


#define _CRT_SECURE_NO_WARNINGS 1

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <malloc.h>

#ifdef _WIN32
#undef UNICODE
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0501
#endif
#include <winsock2.h>
#include <ws2tcpip.h>
#include <iphlpapi.h>

#if defined(_MSC_VER)
typedef unsigned __int8 uint8_t;
#else
#include <inttypes.h>
#endif

#pragma comment(lib, "Ws2_32.lib")

#define snprintf _snprintf
#else
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/tcp.h>
#include <netdb.h>
#include <unistd.h>
#include <string.h>

#include <sys/time.h>
#endif

#include "xvcserver.h"

#define MAX_PACKET_LEN 10000

#define tostr2(X) #X
#define tostr(X) tostr2(X)

#ifndef XVC_VERSION
#define XVC_VERSION 10
#endif

static unsigned max_packet_len = MAX_PACKET_LEN;

struct XvcClient {
    unsigned buf_len;
    unsigned buf_max;
    uint8_t * buf;
    int fd;
    XvcServerHandlers *handlers;
    int locked;
    int enable_locking;
    int enable_status;
    char pending_error[1024];
};

static XvcClient xvc_client;

static unsigned char *reply_buf = NULL;
static unsigned reply_max = 0;
static unsigned reply_len;

static void reply_buf_size(unsigned bytes) {
    if (reply_max < bytes) {
        if (reply_max == 0) reply_max = 1;
        while (reply_max < bytes) reply_max *= 2;
        reply_buf = (unsigned char *)realloc(reply_buf, reply_max);
    }
}


#ifndef _WIN32
static int closesocket(int sock)
{
    return close(sock);
}
#endif

static int open_server(const char * host, const char * port) {
    int err = 0;
    int sock = -1;
    struct addrinfo hints;
    struct addrinfo * reslist = NULL;
    struct addrinfo * res = NULL;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = PF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;
    if (*host == '\0') host = NULL;
    err = getaddrinfo(host, port, &hints, &reslist);
    if (err) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(err));
        errno = EINVAL;
        return -1;
    }

    for (res = reslist; res != NULL; res = res->ai_next) {
        const int i = 1;
        sock = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
        if (sock < 0) continue;

        err = 0;
        if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (char *)&i, sizeof(i)) < 0) err = 1;
        if (!err && bind(sock, res->ai_addr, res->ai_addrlen)) err = 1;
        if (!err && listen(sock, 4)) err = 1;
        if (!err) break;

        closesocket(sock);
        sock = -1;
    }
    freeaddrinfo(reslist);
    return sock;
}

static unsigned get_uint_le(void * buf, int len) {
    unsigned char * p = (unsigned char *)buf;
    unsigned value = 0;

    while (len-- > 0) {
        value = (value << 8) | p[len];
    }
    return value;
}

static void set_uint_le(void * buf, int len, unsigned value) {
    unsigned char * p = (unsigned char *)buf;

    while (len-- > 0) {
        *p++ = (unsigned char)value;
        value >>= 8;
    }
}


static int send_packet(XvcClient * c, const void * buf, unsigned len) {
    int rval = send(c->fd, buf, len, 0);
    return rval;
}

static void consume_packet(XvcClient * c, unsigned len) {
    assert(len <= c->buf_len);
    c->buf_len -= len;
    memmove(c->buf, c->buf + len, c->buf_len);
}

#ifdef LOG_PACKET
static void dumphex(
    void *buf, size_t len)
{
    unsigned char *p = (unsigned char *)buf;
    size_t i;

    if (len == 0)
        return;
    for (i = 0; i < len; i++) {
        int c = p[i];
        if (c >= 32 && c <= 127) {
            printf("%c", c);
        } else if (c == 0) {
            printf("\\0");
        } else {
            printf("\\x%02x", c);
        }
    }
}
#endif

static void read_packet(XvcClient * c) {
    unsigned char * cbuf;
    unsigned char * cend;
    unsigned fill;

    reply_buf_size(max_packet_len);

	
read_more:
#ifdef LOG_PACKET
    printf("read_packet ");
    dumphex(c->buf, c->buf_len);
    printf("\n");
#endif
    cbuf = c->buf;
    cend = cbuf + c->buf_len;
    fill = 0;
    reply_len = 0; 
    for (;;) {
        unsigned char * p = cbuf;  //每次循环都会进行该赋值语句
        unsigned char * e = p + 30 < cend ? p + 30 : cend;
        unsigned len;

        while (p < e && *p != ':') {
            p++;
        }
        if (p >= e) { 

            if (p - cbuf >= 30) {
                fprintf(stderr, "protocol error: received %.30s\n", cbuf);
                goto error;
            }
            fill = 1;
            break;
        }
        p++; 
        len = p - cbuf;


        if (len == 8 && memcmp(cbuf, "getinfo:", len) == 0) {

            snprintf((char *)reply_buf + reply_len, 100, "xvcServer_v%u.%u:%u\n",
                     XVC_VERSION / 10, XVC_VERSION % 10, c->buf_max);  //xvcServer_v1.0:10000
            reply_len += strlen((char *)reply_buf + reply_len);
			
            goto reply;
        }


        if (len == 6 && memcmp(cbuf, "shift:", len) == 0) {

            unsigned bits;
            unsigned bytes;

            if (cend < p + 4) {
                fill = 1;
                break;
            }
            bits = get_uint_le(p, 4);
            bytes = (bits + 7) / 8;
            if (cend < p + 4 + bytes * 2) {
                assert(p + 4 + bytes * 2 - cbuf <= c->buf_max);
                fill = 1;
                break;
            }
            p += 4;


            if (!c->pending_error[0]) {

				c->handlers->shift_tms_tdi(bits, p, p + bytes, reply_buf + reply_len);
				
            }
	
            if (c->pending_error[0]) {
                printf("Problem\n");
                memset(reply_buf + reply_len, 0, bytes);
            }
            reply_len += bytes;
            p += bytes * 2;


            goto reply_with_optional_status;
        }

		
		
		
        if (len == 7 && memcmp(cbuf, "settck:", len) == 0) {

            unsigned long nsperiod;
            unsigned long resnsperiod;

            if (cend < p + 4) {
                fill = 1;
                break;
            }
            nsperiod = get_uint_le(p, 4); 
            p += 4;
            if (!c->pending_error[0])
                c->handlers->set_tck(nsperiod, &resnsperiod);
            if (c->pending_error[0])
                resnsperiod = nsperiod;

            set_uint_le(reply_buf + reply_len, 4, resnsperiod);
            reply_len += 4;
            goto reply_with_optional_status;
        }

        fprintf(stderr, "protocol error: received %.*s\n", (int)len, cbuf);
        goto error;

    reply_with_optional_status:
        if (!c->enable_status) goto reply;

    reply:
        cbuf = p;
    }

	
    if (c->buf < cbuf) {

#ifdef LOG_PACKET
        printf("send_packet ");
        dumphex(reply_buf, reply_len);
        printf("\n");
#endif
        if (send_packet(c, reply_buf, reply_len) < 0) goto error;
		
        consume_packet(c, cbuf - c->buf);
        
        if (c->buf_len && !fill) goto read_more;
    }

    {
        unsigned len = recv(c->fd, c->buf + c->buf_len, c->buf_max - c->buf_len, 0);

        if (len > 0) {
            c->buf_len += len;
            goto read_more;
        }
        if (len < 0) goto error;
    }
    return;

error:
    fprintf(stderr, "XVC connection terminated: error %d\n", errno);
}

int xvcserver_start(
    const char * port,
    XvcServerHandlers * handlers)
{
    XvcClient * c = &xvc_client;
    int sock;
    int fd;
    const char * host = "";
    sock = open_server(host, port);
    if (sock < 0) {
        perror("failed to create socket");
        return 1;
    }
    printf("******** XVC server has ready, Port Number is 2542 *******\n");
    while ((fd = accept(sock, NULL, NULL)) >= 0) {
        int opt = 1;

        if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (char *)&opt, sizeof(opt)) < 0)
            fprintf(stderr, "setsockopt TCP_NODELAY failed\n");


        memset(c, 0, sizeof *c);
        c->fd = fd;
        c->handlers = handlers;
        c->buf_max = max_packet_len;
        c->buf = (uint8_t *)malloc(c->buf_max);
		printf("\n");
        printf("**************** XVC connection success! *****************\n");
        read_packet(c);
		printf("\n");
        printf("***************** XVC connection exit! *******************\n");
		
        closesocket(fd);
        free(c->buf);
    }

    closesocket(sock);
    return 0;
}
