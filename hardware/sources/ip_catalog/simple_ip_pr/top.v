//////////////////////////////////////////////////////////////////////////////
//  Top-level, static design
//////////////////////////////////////////////////////////////////////////////

`define DATA_WIDTH 32

module top(
  input C0_SYS_CLK_clk_n,
  input C0_SYS_CLK_clk_p,
  output c0_init_calib_complete,
  output ddr4_rtl_act_n,
  output [16:0] ddr4_rtl_adr,
  output [1:0] ddr4_rtl_ba,
  output [1:0] ddr4_rtl_bg,
  output [1:0] ddr4_rtl_ck_c,
  output [1:0] ddr4_rtl_ck_t,
  output [1:0] ddr4_rtl_cke,
  output [1:0] ddr4_rtl_cs_n,
  inout [7:0] ddr4_rtl_dm_n,
  inout [63:0] ddr4_rtl_dq,
  inout [7:0] ddr4_rtl_dqs_c,
  inout [7:0] ddr4_rtl_dqs_t,
  output [1:0] ddr4_rtl_odt,
  output ddr4_rtl_reset_n,

  input [3:0] pcie_exp_rxn_0,
  input [3:0] pcie_exp_rxn_1,
  input [3:0] pcie_exp_rxp_0,
  input [3:0] pcie_exp_rxp_1,
  output [3:0] pcie_exp_txn_0,
  output [3:0] pcie_exp_txn_1,
  output [3:0] pcie_exp_txp_0,
  output [3:0] pcie_exp_txp_1,
  input [0:0] pcie_rc_gt_ref_clk_0_clk_n,
  input [0:0] pcie_rc_gt_ref_clk_0_clk_p,
  input [0:0] pcie_rc_gt_ref_clk_1_clk_n,
  input [0:0] pcie_rc_gt_ref_clk_1_clk_p,
  output [0:0] pcie_rc_perstn_0,
  output [0:0] pcie_rc_perstn_1,
  output pcie_rc_user_link_up_0,
  output pcie_rc_user_link_up_1
); 
  wire [31:0] axi4_ddr0_araddr;
  wire [1:0] axi4_ddr0_arburst;
  wire [3:0] axi4_ddr0_arcache;
  wire [7:0] axi4_ddr0_arlen;
  wire [0:0] axi4_ddr0_arlock;
  wire [2:0] axi4_ddr0_arprot;
  wire [3:0] axi4_ddr0_arqos;
  wire axi4_ddr0_arready;
  wire [3:0] axi4_ddr0_arregion;
  wire [2:0] axi4_ddr0_arsize;
  wire axi4_ddr0_arvalid;
  wire [31:0] axi4_ddr0_awaddr;
  wire [1:0] axi4_ddr0_awburst;
  wire [3:0] axi4_ddr0_awcache;
  wire [7:0] axi4_ddr0_awlen;
  wire [0:0] axi4_ddr0_awlock;
  wire [2:0] axi4_ddr0_awprot;
  wire [3:0] axi4_ddr0_awqos;
  wire axi4_ddr0_awready;
  wire [3:0] axi4_ddr0_awregion;
  wire [2:0] axi4_ddr0_awsize;
  wire axi4_ddr0_awvalid;
  wire axi4_ddr0_bready;
  wire [1:0] axi4_ddr0_bresp;
  wire axi4_ddr0_bvalid;
  wire [31:0] axi4_ddr0_rdata;
  wire axi4_ddr0_rlast;
  wire axi4_ddr0_rready;
  wire [1:0] axi4_ddr0_rresp;
  wire axi4_ddr0_rvalid;
  wire [31:0] axi4_ddr0_wdata;
  wire axi4_ddr0_wlast;
  wire axi4_ddr0_wready;
  wire [3:0] axi4_ddr0_wstrb;
  wire axi4_ddr0_wvalid;

  wire [31:0] axi4_ddr1_araddr;
  wire [1:0] axi4_ddr1_arburst;
  wire [3:0] axi4_ddr1_arcache;
  wire [7:0] axi4_ddr1_arlen;
  wire [0:0] axi4_ddr1_arlock;
  wire [2:0] axi4_ddr1_arprot;
  wire [3:0] axi4_ddr1_arqos;
  wire axi4_ddr1_arready;
  wire [3:0] axi4_ddr1_arregion;
  wire [2:0] axi4_ddr1_arsize;
  wire axi4_ddr1_arvalid;
  wire [31:0] axi4_ddr1_awaddr;
  wire [1:0] axi4_ddr1_awburst;
  wire [3:0] axi4_ddr1_awcache;
  wire [7:0] axi4_ddr1_awlen;
  wire [0:0] axi4_ddr1_awlock;
  wire [2:0] axi4_ddr1_awprot;
  wire [3:0] axi4_ddr1_awqos;
  wire axi4_ddr1_awready;
  wire [3:0] axi4_ddr1_awregion;
  wire [2:0] axi4_ddr1_awsize;
  wire axi4_ddr1_awvalid;
  wire axi4_ddr1_bready;
  wire [1:0] axi4_ddr1_bresp;
  wire axi4_ddr1_bvalid;
  wire [31:0] axi4_ddr1_rdata;
  wire axi4_ddr1_rlast;
  wire axi4_ddr1_rready;
  wire [1:0] axi4_ddr1_rresp;
  wire axi4_ddr1_rvalid;
  wire [31:0] axi4_ddr1_wdata;
  wire axi4_ddr1_wlast;
  wire axi4_ddr1_wready;
  wire [3:0] axi4_ddr1_wstrb;
  wire axi4_ddr1_wvalid;

  wire [31:0] axi4_ddr2_araddr;
  wire [1:0] axi4_ddr2_arburst;
  wire [3:0] axi4_ddr2_arcache;
  wire [7:0] axi4_ddr2_arlen;
  wire [0:0] axi4_ddr2_arlock;
  wire [2:0] axi4_ddr2_arprot;
  wire [3:0] axi4_ddr2_arqos;
  wire axi4_ddr2_arready;
  wire [3:0] axi4_ddr2_arregion;
  wire [2:0] axi4_ddr2_arsize;
  wire axi4_ddr2_arvalid;
  wire [31:0] axi4_ddr2_awaddr;
  wire [1:0] axi4_ddr2_awburst;
  wire [3:0] axi4_ddr2_awcache;
  wire [7:0] axi4_ddr2_awlen;
  wire [0:0] axi4_ddr2_awlock;
  wire [2:0] axi4_ddr2_awprot;
  wire [3:0] axi4_ddr2_awqos;
  wire axi4_ddr2_awready;
  wire [3:0] axi4_ddr2_awregion;
  wire [2:0] axi4_ddr2_awsize;
  wire axi4_ddr2_awvalid;
  wire axi4_ddr2_bready;
  wire [1:0] axi4_ddr2_bresp;
  wire axi4_ddr2_bvalid;
  wire [31:0] axi4_ddr2_rdata;
  wire axi4_ddr2_rlast;
  wire axi4_ddr2_rready;
  wire [1:0] axi4_ddr2_rresp;
  wire axi4_ddr2_rvalid;
  wire [31:0] axi4_ddr2_wdata;
  wire axi4_ddr2_wlast;
  wire axi4_ddr2_wready;
  wire [3:0] axi4_ddr2_wstrb;
  wire axi4_ddr2_wvalid;

  wire [31:0] axi4_ddr3_araddr;
  wire [1:0] axi4_ddr3_arburst;
  wire [3:0] axi4_ddr3_arcache;
  wire [7:0] axi4_ddr3_arlen;
  wire [0:0] axi4_ddr3_arlock;
  wire [2:0] axi4_ddr3_arprot;
  wire [3:0] axi4_ddr3_arqos;
  wire axi4_ddr3_arready;
  wire [3:0] axi4_ddr3_arregion;
  wire [2:0] axi4_ddr3_arsize;
  wire axi4_ddr3_arvalid;
  wire [31:0] axi4_ddr3_awaddr;
  wire [1:0] axi4_ddr3_awburst;
  wire [3:0] axi4_ddr3_awcache;
  wire [7:0] axi4_ddr3_awlen;
  wire [0:0] axi4_ddr3_awlock;
  wire [2:0] axi4_ddr3_awprot;
  wire [3:0] axi4_ddr3_awqos;
  wire axi4_ddr3_awready;
  wire [3:0] axi4_ddr3_awregion;
  wire [2:0] axi4_ddr3_awsize;
  wire axi4_ddr3_awvalid;
  wire axi4_ddr3_bready;
  wire [1:0] axi4_ddr3_bresp;
  wire axi4_ddr3_bvalid;
  wire [31:0] axi4_ddr3_rdata;
  wire axi4_ddr3_rlast;
  wire axi4_ddr3_rready;
  wire [1:0] axi4_ddr3_rresp;
  wire axi4_ddr3_rvalid;
  wire [31:0] axi4_ddr3_wdata;
  wire axi4_ddr3_wlast;
  wire axi4_ddr3_wready;
  wire [3:0] axi4_ddr3_wstrb;
  wire axi4_ddr3_wvalid;

  wire [31:0] cpu_axi_uart0_araddr;
  wire [2:0] cpu_axi_uart0_arprot;
  wire [3:0] cpu_axi_uart0_arqos;
  wire cpu_axi_uart0_arready;
  wire [3:0] cpu_axi_uart0_arregion;
  wire cpu_axi_uart0_arvalid;
  wire [31:0] cpu_axi_uart0_awaddr;
  wire [2:0] cpu_axi_uart0_awprot;
  wire [3:0] cpu_axi_uart0_awqos;
  wire cpu_axi_uart0_awready;
  wire [3:0] cpu_axi_uart0_awregion;
  wire cpu_axi_uart0_awvalid;
  wire cpu_axi_uart0_bready;
  wire [1:0] cpu_axi_uart0_bresp;
  wire cpu_axi_uart0_bvalid;
  wire [31:0] cpu_axi_uart0_rdata;
  wire cpu_axi_uart0_rready;
  wire [1:0] cpu_axi_uart0_rresp;
  wire cpu_axi_uart0_rvalid;
  wire [31:0] cpu_axi_uart0_wdata;
  wire cpu_axi_uart0_wready;
  wire [3:0] cpu_axi_uart0_wstrb;
  wire cpu_axi_uart0_wvalid;

  wire [31:0] cpu_axi_uart1_araddr;
  wire [2:0] cpu_axi_uart1_arprot;
  wire [3:0] cpu_axi_uart1_arqos;
  wire cpu_axi_uart1_arready;
  wire [3:0] cpu_axi_uart1_arregion;
  wire cpu_axi_uart1_arvalid;
  wire [31:0] cpu_axi_uart1_awaddr;
  wire [2:0] cpu_axi_uart1_awprot;
  wire [3:0] cpu_axi_uart1_awqos;
  wire cpu_axi_uart1_awready;
  wire [3:0] cpu_axi_uart1_awregion;
  wire cpu_axi_uart1_awvalid;
  wire cpu_axi_uart1_bready;
  wire [1:0] cpu_axi_uart1_bresp;
  wire cpu_axi_uart1_bvalid;
  wire [31:0] cpu_axi_uart1_rdata;
  wire cpu_axi_uart1_rready;
  wire [1:0] cpu_axi_uart1_rresp;
  wire cpu_axi_uart1_rvalid;
  wire [31:0] cpu_axi_uart1_wdata;
  wire cpu_axi_uart1_wready;
  wire [3:0] cpu_axi_uart1_wstrb;
  wire cpu_axi_uart1_wvalid;

  wire [31:0] cpu_axi_uart2_araddr;
  wire [2:0] cpu_axi_uart2_arprot;
  wire [3:0] cpu_axi_uart2_arqos;
  wire cpu_axi_uart2_arready;
  wire [3:0] cpu_axi_uart2_arregion;
  wire cpu_axi_uart2_arvalid;
  wire [31:0] cpu_axi_uart2_awaddr;
  wire [2:0] cpu_axi_uart2_awprot;
  wire [3:0] cpu_axi_uart2_awqos;
  wire cpu_axi_uart2_awready;
  wire [3:0] cpu_axi_uart2_awregion;
  wire cpu_axi_uart2_awvalid;
  wire cpu_axi_uart2_bready;
  wire [1:0] cpu_axi_uart2_bresp;
  wire cpu_axi_uart2_bvalid;
  wire [31:0] cpu_axi_uart2_rdata;
  wire cpu_axi_uart2_rready;
  wire [1:0] cpu_axi_uart2_rresp;
  wire cpu_axi_uart2_rvalid;
  wire [31:0] cpu_axi_uart2_wdata;
  wire cpu_axi_uart2_wready;
  wire [3:0] cpu_axi_uart2_wstrb;
  wire cpu_axi_uart2_wvalid;

  wire [31:0] cpu_axi_uart3_araddr;
  wire [2:0] cpu_axi_uart3_arprot;
  wire [3:0] cpu_axi_uart3_arqos;
  wire cpu_axi_uart3_arready;
  wire [3:0] cpu_axi_uart3_arregion;
  wire cpu_axi_uart3_arvalid;
  wire [31:0] cpu_axi_uart3_awaddr;
  wire [2:0] cpu_axi_uart3_awprot;
  wire [3:0] cpu_axi_uart3_awqos;
  wire cpu_axi_uart3_awready;
  wire [3:0] cpu_axi_uart3_awregion;
  wire cpu_axi_uart3_awvalid;
  wire cpu_axi_uart3_bready;
  wire [1:0] cpu_axi_uart3_bresp;
  wire cpu_axi_uart3_bvalid;
  wire [31:0] cpu_axi_uart3_rdata;
  wire cpu_axi_uart3_rready;
  wire [1:0] cpu_axi_uart3_rresp;
  wire cpu_axi_uart3_rvalid;
  wire [31:0] cpu_axi_uart3_wdata;
  wire cpu_axi_uart3_wready;
  wire [3:0] cpu_axi_uart3_wstrb;
  wire cpu_axi_uart3_wvalid;

  wire [39:0] mips_cpu_axi_mmio0_araddr;
  wire [2:0] mips_cpu_axi_mmio0_arprot;
  wire [3:0] mips_cpu_axi_mmio0_arqos;
  wire mips_cpu_axi_mmio0_arready;
  wire [3:0] mips_cpu_axi_mmio0_arregion;
  wire mips_cpu_axi_mmio0_arvalid;
  wire [39:0] mips_cpu_axi_mmio0_awaddr;
  wire [2:0] mips_cpu_axi_mmio0_awprot;
  wire [3:0] mips_cpu_axi_mmio0_awqos;
  wire mips_cpu_axi_mmio0_awready;
  wire [3:0] mips_cpu_axi_mmio0_awregion;
  wire mips_cpu_axi_mmio0_awvalid;
  wire mips_cpu_axi_mmio0_bready;
  wire [1:0] mips_cpu_axi_mmio0_bresp;
  wire mips_cpu_axi_mmio0_bvalid;
  wire [31:0] mips_cpu_axi_mmio0_rdata;
  wire mips_cpu_axi_mmio0_rready;
  wire [1:0] mips_cpu_axi_mmio0_rresp;
  wire mips_cpu_axi_mmio0_rvalid;
  wire [31:0] mips_cpu_axi_mmio0_wdata;
  wire mips_cpu_axi_mmio0_wready;
  wire [3:0] mips_cpu_axi_mmio0_wstrb;
  wire mips_cpu_axi_mmio0_wvalid;

  wire [39:0] mips_cpu_axi_mmio1_araddr;
  wire [2:0] mips_cpu_axi_mmio1_arprot;
  wire [3:0] mips_cpu_axi_mmio1_arqos;
  wire mips_cpu_axi_mmio1_arready;
  wire [3:0] mips_cpu_axi_mmio1_arregion;
  wire mips_cpu_axi_mmio1_arvalid;
  wire [39:0] mips_cpu_axi_mmio1_awaddr;
  wire [2:0] mips_cpu_axi_mmio1_awprot;
  wire [3:0] mips_cpu_axi_mmio1_awqos;
  wire mips_cpu_axi_mmio1_awready;
  wire [3:0] mips_cpu_axi_mmio1_awregion;
  wire mips_cpu_axi_mmio1_awvalid;
  wire mips_cpu_axi_mmio1_bready;
  wire [1:0] mips_cpu_axi_mmio1_bresp;
  wire mips_cpu_axi_mmio1_bvalid;
  wire [31:0] mips_cpu_axi_mmio1_rdata;
  wire mips_cpu_axi_mmio1_rready;
  wire [1:0] mips_cpu_axi_mmio1_rresp;
  wire mips_cpu_axi_mmio1_rvalid;
  wire [31:0] mips_cpu_axi_mmio1_wdata;
  wire mips_cpu_axi_mmio1_wready;
  wire [3:0] mips_cpu_axi_mmio1_wstrb;
  wire mips_cpu_axi_mmio1_wvalid;

  wire [39:0] mips_cpu_axi_mmio2_araddr;
  wire [2:0] mips_cpu_axi_mmio2_arprot;
  wire [3:0] mips_cpu_axi_mmio2_arqos;
  wire mips_cpu_axi_mmio2_arready;
  wire [3:0] mips_cpu_axi_mmio2_arregion;
  wire mips_cpu_axi_mmio2_arvalid;
  wire [39:0] mips_cpu_axi_mmio2_awaddr;
  wire [2:0] mips_cpu_axi_mmio2_awprot;
  wire [3:0] mips_cpu_axi_mmio2_awqos;
  wire mips_cpu_axi_mmio2_awready;
  wire [3:0] mips_cpu_axi_mmio2_awregion;
  wire mips_cpu_axi_mmio2_awvalid;
  wire mips_cpu_axi_mmio2_bready;
  wire [1:0] mips_cpu_axi_mmio2_bresp;
  wire mips_cpu_axi_mmio2_bvalid;
  wire [31:0] mips_cpu_axi_mmio2_rdata;
  wire mips_cpu_axi_mmio2_rready;
  wire [1:0] mips_cpu_axi_mmio2_rresp;
  wire mips_cpu_axi_mmio2_rvalid;
  wire [31:0] mips_cpu_axi_mmio2_wdata;
  wire mips_cpu_axi_mmio2_wready;
  wire [3:0] mips_cpu_axi_mmio2_wstrb;
  wire mips_cpu_axi_mmio2_wvalid;

  wire [39:0] mips_cpu_axi_mmio3_araddr;
  wire [2:0] mips_cpu_axi_mmio3_arprot;
  wire [3:0] mips_cpu_axi_mmio3_arqos;
  wire mips_cpu_axi_mmio3_arready;
  wire [3:0] mips_cpu_axi_mmio3_arregion;
  wire mips_cpu_axi_mmio3_arvalid;
  wire [39:0] mips_cpu_axi_mmio3_awaddr;
  wire [2:0] mips_cpu_axi_mmio3_awprot;
  wire [3:0] mips_cpu_axi_mmio3_awqos;
  wire mips_cpu_axi_mmio3_awready;
  wire [3:0] mips_cpu_axi_mmio3_awregion;
  wire mips_cpu_axi_mmio3_awvalid;
  wire mips_cpu_axi_mmio3_bready;
  wire [1:0] mips_cpu_axi_mmio3_bresp;
  wire mips_cpu_axi_mmio3_bvalid;
  wire [31:0] mips_cpu_axi_mmio3_rdata;
  wire mips_cpu_axi_mmio3_rready;
  wire [1:0] mips_cpu_axi_mmio3_rresp;
  wire mips_cpu_axi_mmio3_rvalid;
  wire [31:0] mips_cpu_axi_mmio3_wdata;
  wire mips_cpu_axi_mmio3_wready;
  wire [3:0] mips_cpu_axi_mmio3_wstrb;
  wire mips_cpu_axi_mmio3_wvalid;
  
  wire ps_fclk_clk0;
  wire ps_fclk_clk1;
  wire ps_fclk_clk2;
  wire ps_fclk_clk3;
  wire ps_user_resetn0;
  wire ps_user_resetn1;
  wire ps_user_resetn2;
  wire ps_user_resetn3;

mpsoc_wrapper u_mpsoc_wrapper(

        // mig clk and calib_complete
        .C0_SYS_CLK_clk_n                       (C0_SYS_CLK_clk_n),
        .C0_SYS_CLK_clk_p                       (C0_SYS_CLK_clk_p),
        .c0_init_calib_complete                 (c0_init_calib_complete),
        //ddr interface
        .ddr4_rtl_act_n                         (ddr4_rtl_act_n),
        .ddr4_rtl_adr                           (ddr4_rtl_adr),
        .ddr4_rtl_ba                            (ddr4_rtl_ba),
        .ddr4_rtl_bg                            (ddr4_rtl_bg),
        .ddr4_rtl_ck_c                          (ddr4_rtl_ck_c),
        //.ddr4_rtl_ck_c                          (2'b00),
	.ddr4_rtl_ck_t                          (ddr4_rtl_ck_t),
        .ddr4_rtl_cke                           (ddr4_rtl_cke),
        .ddr4_rtl_cs_n                          (ddr4_rtl_cs_n),
        .ddr4_rtl_dm_n                          (ddr4_rtl_dm_n),
        .ddr4_rtl_dq                            (ddr4_rtl_dq),
        .ddr4_rtl_dqs_c                         (ddr4_rtl_dqs_c),
        //.ddr4_rtl_dqs_c                         (8'b0),
        .ddr4_rtl_dqs_t                         (ddr4_rtl_dqs_t),
        .ddr4_rtl_odt                           (ddr4_rtl_odt),
        .ddr4_rtl_reset_n                       (ddr4_rtl_reset_n),

        // role0 access ddr AXI4 
        .axi4_ddr0_araddr                       (axi4_ddr0_araddr + 34'h000000000),
        .axi4_ddr0_arburst                      (axi4_ddr0_arburst),
        .axi4_ddr0_arcache                      (axi4_ddr0_arcache),
        .axi4_ddr0_arlen                        (axi4_ddr0_arlen),
        .axi4_ddr0_arlock                       (axi4_ddr0_arlock),
        .axi4_ddr0_arprot                       (axi4_ddr0_arprot),
        .axi4_ddr0_arqos                        (axi4_ddr0_arqos),
        .axi4_ddr0_arready                      (axi4_ddr0_arready),
        .axi4_ddr0_arregion                     (axi4_ddr0_arregion),
        .axi4_ddr0_arsize                       (axi4_ddr0_arsize),
        .axi4_ddr0_arvalid                      (axi4_ddr0_arvalid),
        .axi4_ddr0_awaddr                       (axi4_ddr0_awaddr + 34'h000000000),
        .axi4_ddr0_awburst                      (axi4_ddr0_awburst),
        .axi4_ddr0_awcache                      (axi4_ddr0_awcache),
        .axi4_ddr0_awlen                        (axi4_ddr0_awlen),
        .axi4_ddr0_awlock                       (axi4_ddr0_awlock),
        .axi4_ddr0_awprot                       (axi4_ddr0_awprot),
        .axi4_ddr0_awqos                        (axi4_ddr0_awqos),
        .axi4_ddr0_awready                      (axi4_ddr0_awready),
        .axi4_ddr0_awregion                     (axi4_ddr0_awregion),
        .axi4_ddr0_awsize                       (axi4_ddr0_awsize),
        .axi4_ddr0_awvalid                      (axi4_ddr0_awvalid),
        .axi4_ddr0_bready                       (axi4_ddr0_bready),
        .axi4_ddr0_bresp                        (axi4_ddr0_bresp),
        .axi4_ddr0_bvalid                       (axi4_ddr0_bvalid),
        .axi4_ddr0_rdata                        (axi4_ddr0_rdata),
        .axi4_ddr0_rlast                        (axi4_ddr0_rlast),
        .axi4_ddr0_rready                       (axi4_ddr0_rready),
        .axi4_ddr0_rresp                        (axi4_ddr0_rresp),
        .axi4_ddr0_rvalid                       (axi4_ddr0_rvalid),
        .axi4_ddr0_wdata                        (axi4_ddr0_wdata),
        .axi4_ddr0_wlast                        (axi4_ddr0_wlast),
        .axi4_ddr0_wready                       (axi4_ddr0_wready),
        .axi4_ddr0_wstrb                        (axi4_ddr0_wstrb),
        .axi4_ddr0_wvalid                       (axi4_ddr0_wvalid),
        // role1 access ddr AXI4
        .axi4_ddr1_araddr                       (axi4_ddr1_araddr + 34'h100000000),
        .axi4_ddr1_arburst                      (axi4_ddr1_arburst),
        .axi4_ddr1_arcache                      (axi4_ddr1_arcache),
        .axi4_ddr1_arlen                        (axi4_ddr1_arlen),
        .axi4_ddr1_arlock                       (axi4_ddr1_arlock),
        .axi4_ddr1_arprot                       (axi4_ddr1_arprot),
        .axi4_ddr1_arqos                        (axi4_ddr1_arqos),
        .axi4_ddr1_arready                      (axi4_ddr1_arready),
        .axi4_ddr1_arregion                     (axi4_ddr1_arregion),
        .axi4_ddr1_arsize                       (axi4_ddr1_arsize),
        .axi4_ddr1_arvalid                      (axi4_ddr1_arvalid),
        .axi4_ddr1_awaddr                       (axi4_ddr1_awaddr + 34'h100000000),
        .axi4_ddr1_awburst                      (axi4_ddr1_awburst),
        .axi4_ddr1_awcache                      (axi4_ddr1_awcache),
        .axi4_ddr1_awlen                        (axi4_ddr1_awlen),
        .axi4_ddr1_awlock                       (axi4_ddr1_awlock),
        .axi4_ddr1_awprot                       (axi4_ddr1_awprot),
        .axi4_ddr1_awqos                        (axi4_ddr1_awqos),
        .axi4_ddr1_awready                      (axi4_ddr1_awready),
        .axi4_ddr1_awregion                     (axi4_ddr1_awregion),
        .axi4_ddr1_awsize                       (axi4_ddr1_awsize),
        .axi4_ddr1_awvalid                      (axi4_ddr1_awvalid),
        .axi4_ddr1_bready                       (axi4_ddr1_bready),
        .axi4_ddr1_bresp                        (axi4_ddr1_bresp),
        .axi4_ddr1_bvalid                       (axi4_ddr1_bvalid),
        .axi4_ddr1_rdata                        (axi4_ddr1_rdata),
        .axi4_ddr1_rlast                        (axi4_ddr1_rlast),
        .axi4_ddr1_rready                       (axi4_ddr1_rready),
        .axi4_ddr1_rresp                        (axi4_ddr1_rresp),
        .axi4_ddr1_rvalid                       (axi4_ddr1_rvalid),
        .axi4_ddr1_wdata                        (axi4_ddr1_wdata),
        .axi4_ddr1_wlast                        (axi4_ddr1_wlast),
        .axi4_ddr1_wready                       (axi4_ddr1_wready),
        .axi4_ddr1_wstrb                        (axi4_ddr1_wstrb),
        .axi4_ddr1_wvalid                       (axi4_ddr1_wvalid),

        .axi4_ddr2_araddr                       (axi4_ddr2_araddr + 34'h200000000),
        .axi4_ddr2_arburst                      (axi4_ddr2_arburst),
        .axi4_ddr2_arcache                      (axi4_ddr2_arcache),
        .axi4_ddr2_arlen                        (axi4_ddr2_arlen),
        .axi4_ddr2_arlock                       (axi4_ddr2_arlock),
        .axi4_ddr2_arprot                       (axi4_ddr2_arprot),
        .axi4_ddr2_arqos                        (axi4_ddr2_arqos),
        .axi4_ddr2_arready                      (axi4_ddr2_arready),
        .axi4_ddr2_arregion                     (axi4_ddr2_arregion),
        .axi4_ddr2_arsize                       (axi4_ddr2_arsize),
        .axi4_ddr2_arvalid                      (axi4_ddr2_arvalid),
        .axi4_ddr2_awaddr                       (axi4_ddr2_awaddr + 34'h200000000),
        .axi4_ddr2_awburst                      (axi4_ddr2_awburst),
        .axi4_ddr2_awcache                      (axi4_ddr2_awcache),
        .axi4_ddr2_awlen                        (axi4_ddr2_awlen),
        .axi4_ddr2_awlock                       (axi4_ddr2_awlock),
        .axi4_ddr2_awprot                       (axi4_ddr2_awprot),
        .axi4_ddr2_awqos                        (axi4_ddr2_awqos),
        .axi4_ddr2_awready                      (axi4_ddr2_awready),
        .axi4_ddr2_awregion                     (axi4_ddr2_awregion),
        .axi4_ddr2_awsize                       (axi4_ddr2_awsize),
        .axi4_ddr2_awvalid                      (axi4_ddr2_awvalid),
        .axi4_ddr2_bready                       (axi4_ddr2_bready),
        .axi4_ddr2_bresp                        (axi4_ddr2_bresp),
        .axi4_ddr2_bvalid                       (axi4_ddr2_bvalid),
        .axi4_ddr2_rdata                        (axi4_ddr2_rdata),
        .axi4_ddr2_rlast                        (axi4_ddr2_rlast),
        .axi4_ddr2_rready                       (axi4_ddr2_rready),
        .axi4_ddr2_rresp                        (axi4_ddr2_rresp),
        .axi4_ddr2_rvalid                       (axi4_ddr2_rvalid),
        .axi4_ddr2_wdata                        (axi4_ddr2_wdata),
        .axi4_ddr2_wlast                        (axi4_ddr2_wlast),
        .axi4_ddr2_wready                       (axi4_ddr2_wready),
        .axi4_ddr2_wstrb                        (axi4_ddr2_wstrb),
        .axi4_ddr2_wvalid                       (axi4_ddr2_wvalid),

        .axi4_ddr3_araddr                       (axi4_ddr3_araddr + 34'h300000000),
        .axi4_ddr3_arburst                      (axi4_ddr3_arburst),
        .axi4_ddr3_arcache                      (axi4_ddr3_arcache),
        .axi4_ddr3_arlen                        (axi4_ddr3_arlen),
        .axi4_ddr3_arlock                       (axi4_ddr3_arlock),
        .axi4_ddr3_arprot                       (axi4_ddr3_arprot),
        .axi4_ddr3_arqos                        (axi4_ddr3_arqos),
        .axi4_ddr3_arready                      (axi4_ddr3_arready),
        .axi4_ddr3_arregion                     (axi4_ddr3_arregion),
        .axi4_ddr3_arsize                       (axi4_ddr3_arsize),
        .axi4_ddr3_arvalid                      (axi4_ddr3_arvalid),
        .axi4_ddr3_awaddr                       (axi4_ddr3_awaddr + 34'h300000000),
        .axi4_ddr3_awburst                      (axi4_ddr3_awburst),
        .axi4_ddr3_awcache                      (axi4_ddr3_awcache),
        .axi4_ddr3_awlen                        (axi4_ddr3_awlen),
        .axi4_ddr3_awlock                       (axi4_ddr3_awlock),
        .axi4_ddr3_awprot                       (axi4_ddr3_awprot),
        .axi4_ddr3_awqos                        (axi4_ddr3_awqos),
        .axi4_ddr3_awready                      (axi4_ddr3_awready),
        .axi4_ddr3_awregion                     (axi4_ddr3_awregion),
        .axi4_ddr3_awsize                       (axi4_ddr3_awsize),
        .axi4_ddr3_awvalid                      (axi4_ddr3_awvalid),
        .axi4_ddr3_bready                       (axi4_ddr3_bready),
        .axi4_ddr3_bresp                        (axi4_ddr3_bresp),
        .axi4_ddr3_bvalid                       (axi4_ddr3_bvalid),
        .axi4_ddr3_rdata                        (axi4_ddr3_rdata),
        .axi4_ddr3_rlast                        (axi4_ddr3_rlast),
        .axi4_ddr3_rready                       (axi4_ddr3_rready),
        .axi4_ddr3_rresp                        (axi4_ddr3_rresp),
        .axi4_ddr3_rvalid                       (axi4_ddr3_rvalid),
        .axi4_ddr3_wdata                        (axi4_ddr3_wdata),
        .axi4_ddr3_wlast                        (axi4_ddr3_wlast),
        .axi4_ddr3_wready                       (axi4_ddr3_wready),
        .axi4_ddr3_wstrb                        (axi4_ddr3_wstrb),
        .axi4_ddr3_wvalid                       (axi4_ddr3_wvalid),

        .cpu_axi_uart0_araddr                   (cpu_axi_uart0_araddr),
        .cpu_axi_uart0_arprot                   (cpu_axi_uart0_arprot),
        .cpu_axi_uart0_arqos                    (cpu_axi_uart0_arqos),
        .cpu_axi_uart0_arready                  (cpu_axi_uart0_arready),
        .cpu_axi_uart0_arregion                 (cpu_axi_uart0_arregion),
        .cpu_axi_uart0_arvalid                  (cpu_axi_uart0_arvalid),
        .cpu_axi_uart0_awaddr                   (cpu_axi_uart0_awaddr),
        .cpu_axi_uart0_awprot                   (cpu_axi_uart0_awprot),
        .cpu_axi_uart0_awqos                    (cpu_axi_uart0_awqos),
        .cpu_axi_uart0_awready                  (cpu_axi_uart0_awready),
        .cpu_axi_uart0_awregion                 (cpu_axi_uart0_awregion),
        .cpu_axi_uart0_awvalid                  (cpu_axi_uart0_awvalid),
        .cpu_axi_uart0_bready                   (cpu_axi_uart0_bready),
        .cpu_axi_uart0_bresp                    (cpu_axi_uart0_bresp),
        .cpu_axi_uart0_bvalid                   (cpu_axi_uart0_bvalid),
        .cpu_axi_uart0_rdata                    (cpu_axi_uart0_rdata),
        .cpu_axi_uart0_rready                   (cpu_axi_uart0_rready),
        .cpu_axi_uart0_rresp                    (cpu_axi_uart0_rresp),
        .cpu_axi_uart0_rvalid                   (cpu_axi_uart0_rvalid),
        .cpu_axi_uart0_wdata                    (cpu_axi_uart0_wdata),
        .cpu_axi_uart0_wready                   (cpu_axi_uart0_wready),
        .cpu_axi_uart0_wstrb                    (cpu_axi_uart0_wstrb),
        .cpu_axi_uart0_wvalid                   (cpu_axi_uart0_wvalid),

        .cpu_axi_uart1_araddr                   (cpu_axi_uart1_araddr),
        .cpu_axi_uart1_arprot                   (cpu_axi_uart1_arprot),
        .cpu_axi_uart1_arqos                    (cpu_axi_uart1_arqos),
        .cpu_axi_uart1_arready                  (cpu_axi_uart1_arready),
        .cpu_axi_uart1_arregion                 (cpu_axi_uart1_arregion),
        .cpu_axi_uart1_arvalid                  (cpu_axi_uart1_arvalid),
        .cpu_axi_uart1_awaddr                   (cpu_axi_uart1_awaddr),
        .cpu_axi_uart1_awprot                   (cpu_axi_uart1_awprot),
        .cpu_axi_uart1_awqos                    (cpu_axi_uart1_awqos),
        .cpu_axi_uart1_awready                  (cpu_axi_uart1_awready),
        .cpu_axi_uart1_awregion                 (cpu_axi_uart1_awregion),
        .cpu_axi_uart1_awvalid                  (cpu_axi_uart1_awvalid),
        .cpu_axi_uart1_bready                   (cpu_axi_uart1_bready),
        .cpu_axi_uart1_bresp                    (cpu_axi_uart1_bresp),
        .cpu_axi_uart1_bvalid                   (cpu_axi_uart1_bvalid),
        .cpu_axi_uart1_rdata                    (cpu_axi_uart1_rdata),
        .cpu_axi_uart1_rready                   (cpu_axi_uart1_rready),
        .cpu_axi_uart1_rresp                    (cpu_axi_uart1_rresp),
        .cpu_axi_uart1_rvalid                   (cpu_axi_uart1_rvalid),
        .cpu_axi_uart1_wdata                    (cpu_axi_uart1_wdata),
        .cpu_axi_uart1_wready                   (cpu_axi_uart1_wready),
        .cpu_axi_uart1_wstrb                    (cpu_axi_uart1_wstrb),
        .cpu_axi_uart1_wvalid                   (cpu_axi_uart1_wvalid),

        .cpu_axi_uart2_araddr                   (cpu_axi_uart2_araddr),
        .cpu_axi_uart2_arprot                   (cpu_axi_uart2_arprot),
        .cpu_axi_uart2_arqos                    (cpu_axi_uart2_arqos),
        .cpu_axi_uart2_arready                  (cpu_axi_uart2_arready),
        .cpu_axi_uart2_arregion                 (cpu_axi_uart2_arregion),
        .cpu_axi_uart2_arvalid                  (cpu_axi_uart2_arvalid),
        .cpu_axi_uart2_awaddr                   (cpu_axi_uart2_awaddr),
        .cpu_axi_uart2_awprot                   (cpu_axi_uart2_awprot),
        .cpu_axi_uart2_awqos                    (cpu_axi_uart2_awqos),
        .cpu_axi_uart2_awready                  (cpu_axi_uart2_awready),
        .cpu_axi_uart2_awregion                 (cpu_axi_uart2_awregion),
        .cpu_axi_uart2_awvalid                  (cpu_axi_uart2_awvalid),
        .cpu_axi_uart2_bready                   (cpu_axi_uart2_bready),
        .cpu_axi_uart2_bresp                    (cpu_axi_uart2_bresp),
        .cpu_axi_uart2_bvalid                   (cpu_axi_uart2_bvalid),
        .cpu_axi_uart2_rdata                    (cpu_axi_uart2_rdata),
        .cpu_axi_uart2_rready                   (cpu_axi_uart2_rready),
        .cpu_axi_uart2_rresp                    (cpu_axi_uart2_rresp),
        .cpu_axi_uart2_rvalid                   (cpu_axi_uart2_rvalid),
        .cpu_axi_uart2_wdata                    (cpu_axi_uart2_wdata),
        .cpu_axi_uart2_wready                   (cpu_axi_uart2_wready),
        .cpu_axi_uart2_wstrb                    (cpu_axi_uart2_wstrb),
        .cpu_axi_uart2_wvalid                   (cpu_axi_uart2_wvalid),

        .cpu_axi_uart3_araddr                   (cpu_axi_uart3_araddr),
        .cpu_axi_uart3_arprot                   (cpu_axi_uart3_arprot),
        .cpu_axi_uart3_arqos                    (cpu_axi_uart3_arqos),
        .cpu_axi_uart3_arready                  (cpu_axi_uart3_arready),
        .cpu_axi_uart3_arregion                 (cpu_axi_uart3_arregion),
        .cpu_axi_uart3_arvalid                  (cpu_axi_uart3_arvalid),
        .cpu_axi_uart3_awaddr                   (cpu_axi_uart3_awaddr),
        .cpu_axi_uart3_awprot                   (cpu_axi_uart3_awprot),
        .cpu_axi_uart3_awqos                    (cpu_axi_uart3_awqos),
        .cpu_axi_uart3_awready                  (cpu_axi_uart3_awready),
        .cpu_axi_uart3_awregion                 (cpu_axi_uart3_awregion),
        .cpu_axi_uart3_awvalid                  (cpu_axi_uart3_awvalid),
        .cpu_axi_uart3_bready                   (cpu_axi_uart3_bready),
        .cpu_axi_uart3_bresp                    (cpu_axi_uart3_bresp),
        .cpu_axi_uart3_bvalid                   (cpu_axi_uart3_bvalid),
        .cpu_axi_uart3_rdata                    (cpu_axi_uart3_rdata),
        .cpu_axi_uart3_rready                   (cpu_axi_uart3_rready),
        .cpu_axi_uart3_rresp                    (cpu_axi_uart3_rresp),
        .cpu_axi_uart3_rvalid                   (cpu_axi_uart3_rvalid),
        .cpu_axi_uart3_wdata                    (cpu_axi_uart3_wdata),
        .cpu_axi_uart3_wready                   (cpu_axi_uart3_wready),
        .cpu_axi_uart3_wstrb                    (cpu_axi_uart3_wstrb),
        .cpu_axi_uart3_wvalid                   (cpu_axi_uart3_wvalid),

        .mips_cpu_axi_mmio0_araddr              (mips_cpu_axi_mmio0_araddr),
        .mips_cpu_axi_mmio0_arprot              (mips_cpu_axi_mmio0_arprot),
        .mips_cpu_axi_mmio0_arqos               (mips_cpu_axi_mmio0_arqos),
        .mips_cpu_axi_mmio0_arready             (mips_cpu_axi_mmio0_arready),
        .mips_cpu_axi_mmio0_arregion            (mips_cpu_axi_mmio0_arregion),
        .mips_cpu_axi_mmio0_arvalid             (mips_cpu_axi_mmio0_arvalid),
        .mips_cpu_axi_mmio0_awaddr              (mips_cpu_axi_mmio0_awaddr),
        .mips_cpu_axi_mmio0_awprot              (mips_cpu_axi_mmio0_awprot),
        .mips_cpu_axi_mmio0_awqos               (mips_cpu_axi_mmio0_awqos),
        .mips_cpu_axi_mmio0_awready             (mips_cpu_axi_mmio0_awready),
        .mips_cpu_axi_mmio0_awregion            (mips_cpu_axi_mmio0_awregion),
        .mips_cpu_axi_mmio0_awvalid             (mips_cpu_axi_mmio0_awvalid),
        .mips_cpu_axi_mmio0_bready              (mips_cpu_axi_mmio0_bready),
        .mips_cpu_axi_mmio0_bresp               (mips_cpu_axi_mmio0_bresp),
        .mips_cpu_axi_mmio0_bvalid              (mips_cpu_axi_mmio0_bvalid),
        .mips_cpu_axi_mmio0_rdata               (mips_cpu_axi_mmio0_rdata),
        .mips_cpu_axi_mmio0_rready              (mips_cpu_axi_mmio0_rready),
        .mips_cpu_axi_mmio0_rresp               (mips_cpu_axi_mmio0_rresp),
        .mips_cpu_axi_mmio0_rvalid              (mips_cpu_axi_mmio0_rvalid),
        .mips_cpu_axi_mmio0_wdata               (mips_cpu_axi_mmio0_wdata),
        .mips_cpu_axi_mmio0_wready              (mips_cpu_axi_mmio0_wready),
        .mips_cpu_axi_mmio0_wstrb               (mips_cpu_axi_mmio0_wstrb),
        .mips_cpu_axi_mmio0_wvalid              (mips_cpu_axi_mmio0_wvalid),

        .mips_cpu_axi_mmio1_araddr              (mips_cpu_axi_mmio1_araddr),
        .mips_cpu_axi_mmio1_arprot              (mips_cpu_axi_mmio1_arprot),
        .mips_cpu_axi_mmio1_arqos               (mips_cpu_axi_mmio1_arqos),
        .mips_cpu_axi_mmio1_arready             (mips_cpu_axi_mmio1_arready),
        .mips_cpu_axi_mmio1_arregion            (mips_cpu_axi_mmio1_arregion),
        .mips_cpu_axi_mmio1_arvalid             (mips_cpu_axi_mmio1_arvalid),
        .mips_cpu_axi_mmio1_awaddr              (mips_cpu_axi_mmio1_awaddr),
        .mips_cpu_axi_mmio1_awprot              (mips_cpu_axi_mmio1_awprot),
        .mips_cpu_axi_mmio1_awqos               (mips_cpu_axi_mmio1_awqos),
        .mips_cpu_axi_mmio1_awready             (mips_cpu_axi_mmio1_awready),
        .mips_cpu_axi_mmio1_awregion            (mips_cpu_axi_mmio1_awregion),
        .mips_cpu_axi_mmio1_awvalid             (mips_cpu_axi_mmio1_awvalid),
        .mips_cpu_axi_mmio1_bready              (mips_cpu_axi_mmio1_bready),
        .mips_cpu_axi_mmio1_bresp               (mips_cpu_axi_mmio1_bresp),
        .mips_cpu_axi_mmio1_bvalid              (mips_cpu_axi_mmio1_bvalid),
        .mips_cpu_axi_mmio1_rdata               (mips_cpu_axi_mmio1_rdata),
        .mips_cpu_axi_mmio1_rready              (mips_cpu_axi_mmio1_rready),
        .mips_cpu_axi_mmio1_rresp               (mips_cpu_axi_mmio1_rresp),
        .mips_cpu_axi_mmio1_rvalid              (mips_cpu_axi_mmio1_rvalid),
        .mips_cpu_axi_mmio1_wdata               (mips_cpu_axi_mmio1_wdata),
        .mips_cpu_axi_mmio1_wready              (mips_cpu_axi_mmio1_wready),
        .mips_cpu_axi_mmio1_wstrb               (mips_cpu_axi_mmio1_wstrb),
        .mips_cpu_axi_mmio1_wvalid              (mips_cpu_axi_mmio1_wvalid),


        .mips_cpu_axi_mmio2_araddr              (mips_cpu_axi_mmio2_araddr),
        .mips_cpu_axi_mmio2_arprot              (mips_cpu_axi_mmio2_arprot),
        .mips_cpu_axi_mmio2_arqos               (mips_cpu_axi_mmio2_arqos),
        .mips_cpu_axi_mmio2_arready             (mips_cpu_axi_mmio2_arready),
        .mips_cpu_axi_mmio2_arregion            (mips_cpu_axi_mmio2_arregion),
        .mips_cpu_axi_mmio2_arvalid             (mips_cpu_axi_mmio2_arvalid),
        .mips_cpu_axi_mmio2_awaddr              (mips_cpu_axi_mmio2_awaddr),
        .mips_cpu_axi_mmio2_awprot              (mips_cpu_axi_mmio2_awprot),
        .mips_cpu_axi_mmio2_awqos               (mips_cpu_axi_mmio2_awqos),
        .mips_cpu_axi_mmio2_awready             (mips_cpu_axi_mmio2_awready),
        .mips_cpu_axi_mmio2_awregion            (mips_cpu_axi_mmio2_awregion),
        .mips_cpu_axi_mmio2_awvalid             (mips_cpu_axi_mmio2_awvalid),
        .mips_cpu_axi_mmio2_bready              (mips_cpu_axi_mmio2_bready),
        .mips_cpu_axi_mmio2_bresp               (mips_cpu_axi_mmio2_bresp),
        .mips_cpu_axi_mmio2_bvalid              (mips_cpu_axi_mmio2_bvalid),
        .mips_cpu_axi_mmio2_rdata               (mips_cpu_axi_mmio2_rdata),
        .mips_cpu_axi_mmio2_rready              (mips_cpu_axi_mmio2_rready),
        .mips_cpu_axi_mmio2_rresp               (mips_cpu_axi_mmio2_rresp),
        .mips_cpu_axi_mmio2_rvalid              (mips_cpu_axi_mmio2_rvalid),
        .mips_cpu_axi_mmio2_wdata               (mips_cpu_axi_mmio2_wdata),
        .mips_cpu_axi_mmio2_wready              (mips_cpu_axi_mmio2_wready),
        .mips_cpu_axi_mmio2_wstrb               (mips_cpu_axi_mmio2_wstrb),
        .mips_cpu_axi_mmio2_wvalid              (mips_cpu_axi_mmio2_wvalid),

        .mips_cpu_axi_mmio3_araddr              (mips_cpu_axi_mmio3_araddr),
        .mips_cpu_axi_mmio3_arprot              (mips_cpu_axi_mmio3_arprot),
        .mips_cpu_axi_mmio3_arqos               (mips_cpu_axi_mmio3_arqos),
        .mips_cpu_axi_mmio3_arready             (mips_cpu_axi_mmio3_arready),
        .mips_cpu_axi_mmio3_arregion            (mips_cpu_axi_mmio3_arregion),
        .mips_cpu_axi_mmio3_arvalid             (mips_cpu_axi_mmio3_arvalid),
        .mips_cpu_axi_mmio3_awaddr              (mips_cpu_axi_mmio3_awaddr),
        .mips_cpu_axi_mmio3_awprot              (mips_cpu_axi_mmio3_awprot),
        .mips_cpu_axi_mmio3_awqos               (mips_cpu_axi_mmio3_awqos),
        .mips_cpu_axi_mmio3_awready             (mips_cpu_axi_mmio3_awready),
        .mips_cpu_axi_mmio3_awregion            (mips_cpu_axi_mmio3_awregion),
        .mips_cpu_axi_mmio3_awvalid             (mips_cpu_axi_mmio3_awvalid),
        .mips_cpu_axi_mmio3_bready              (mips_cpu_axi_mmio3_bready),
        .mips_cpu_axi_mmio3_bresp               (mips_cpu_axi_mmio3_bresp),
        .mips_cpu_axi_mmio3_bvalid              (mips_cpu_axi_mmio3_bvalid),
        .mips_cpu_axi_mmio3_rdata               (mips_cpu_axi_mmio3_rdata),
        .mips_cpu_axi_mmio3_rready              (mips_cpu_axi_mmio3_rready),
        .mips_cpu_axi_mmio3_rresp               (mips_cpu_axi_mmio3_rresp),
        .mips_cpu_axi_mmio3_rvalid              (mips_cpu_axi_mmio3_rvalid),
        .mips_cpu_axi_mmio3_wdata               (mips_cpu_axi_mmio3_wdata),
        .mips_cpu_axi_mmio3_wready              (mips_cpu_axi_mmio3_wready),
        .mips_cpu_axi_mmio3_wstrb               (mips_cpu_axi_mmio3_wstrb),
        .mips_cpu_axi_mmio3_wvalid              (mips_cpu_axi_mmio3_wvalid),

        //nvme pcie
        .pcie_exp_rxn_0                         (pcie_exp_rxn_0),
        .pcie_exp_rxn_1                         (pcie_exp_rxn_1),
        .pcie_exp_rxp_0                         (pcie_exp_rxp_0),
        .pcie_exp_rxp_1                         (pcie_exp_rxp_1),
        .pcie_exp_txn_0                         (pcie_exp_txn_0),
        .pcie_exp_txn_1                         (pcie_exp_txn_1),
        .pcie_exp_txp_0                         (pcie_exp_txp_0),
        .pcie_exp_txp_1                         (pcie_exp_txp_1),
        .pcie_rc_gt_ref_clk_0_clk_n             (pcie_rc_gt_ref_clk_0_clk_n),
        .pcie_rc_gt_ref_clk_0_clk_p             (pcie_rc_gt_ref_clk_0_clk_p),
        .pcie_rc_gt_ref_clk_1_clk_n             (pcie_rc_gt_ref_clk_1_clk_n),
        .pcie_rc_gt_ref_clk_1_clk_p             (pcie_rc_gt_ref_clk_1_clk_p),
        .pcie_rc_perstn_0                       (pcie_rc_perstn_0),
        .pcie_rc_perstn_1                       (pcie_rc_perstn_1),
        .pcie_rc_user_link_up_0                 (pcie_rc_user_link_up_0),
        .pcie_rc_user_link_up_1                 (pcie_rc_user_link_up_1),
        
        //role clk
        .ps_fclk_clk0                           (ps_fclk_clk0),
        .ps_fclk_clk1                           (ps_fclk_clk1),
        .ps_fclk_clk2                           (ps_fclk_clk2),
        .ps_fclk_clk3                           (ps_fclk_clk3),

        // role reset
        .ps_user_resetn0                        (ps_user_resetn0),
        .ps_user_resetn1                        (ps_user_resetn1),
        .ps_user_resetn2                        (ps_user_resetn2),
        .ps_user_resetn3                        (ps_user_resetn3)
);

   // instantiate module shift
   user inst_user1(
        .clk                                    (ps_fclk_clk0),
        .rst                                    (ps_user_resetn0),
        // access PL memory AXI4 Master interface,32bit address
        // AXI4 AR channel
        .axi4_ddr_araddr                        (axi4_ddr0_araddr),
        .axi4_ddr_arburst                       (axi4_ddr0_arburst),
        .axi4_ddr_arcache                       (axi4_ddr0_arcache),
        .axi4_ddr_arlen                         (axi4_ddr0_arlen),
        .axi4_ddr_arlock                        (axi4_ddr0_arlock),
        .axi4_ddr_arprot                        (axi4_ddr0_arprot),
        .axi4_ddr_arqos                         (axi4_ddr0_arqos),
        .axi4_ddr_arready                       (axi4_ddr0_arready),
        .axi4_ddr_arregion                      (axi4_ddr0_arregion),
        .axi4_ddr_arsize                        (axi4_ddr0_arsize),
        .axi4_ddr_arvalid                       (axi4_ddr0_arvalid),
        // AXI4 AW channel
        .axi4_ddr_awaddr                        (axi4_ddr0_awaddr),
        .axi4_ddr_awburst                       (axi4_ddr0_awburst),
        .axi4_ddr_awcache                       (axi4_ddr0_awcache),
        .axi4_ddr_awlen                         (axi4_ddr0_awlen),
        .axi4_ddr_awlock                        (axi4_ddr0_awlock),
        .axi4_ddr_awprot                        (axi4_ddr0_awprot),
        .axi4_ddr_awqos                         (axi4_ddr0_awqos),
        .axi4_ddr_awready                       (axi4_ddr0_awready),
        .axi4_ddr_awregion                      (axi4_ddr0_awregion),
        .axi4_ddr_awsize                        (axi4_ddr0_awsize),
        .axi4_ddr_awvalid                       (axi4_ddr0_awvalid),
        // AXI4 B channel
        .axi4_ddr_bready                        (axi4_ddr0_bready),
        .axi4_ddr_bresp                         (axi4_ddr0_bresp),
        .axi4_ddr_bvalid                        (axi4_ddr0_bvalid),
        // AXI4 R channel
        .axi4_ddr_rdata                         (axi4_ddr0_rdata),
        .axi4_ddr_rlast                         (axi4_ddr0_rlast),
        .axi4_ddr_rready                        (axi4_ddr0_rready),
        .axi4_ddr_rresp                         (axi4_ddr0_rresp),
        .axi4_ddr_rvalid                        (axi4_ddr0_rvalid),
        // AXI4 W channel
        .axi4_ddr_wdata                         (axi4_ddr0_wdata),
        .axi4_ddr_wlast                         (axi4_ddr0_wlast),
        .axi4_ddr_wready                        (axi4_ddr0_wready),
        .axi4_ddr_wstrb                         (axi4_ddr0_wstrb),
        .axi4_ddr_wvalid                        (axi4_ddr0_wvalid),

        // acess uartlite reg AXI-lite master interface,12bit address
        // AXI-lite AR channel
        .cpu_axi_uart_araddr                    (cpu_axi_uart0_araddr),
        .cpu_axi_uart_arprot                    (cpu_axi_uart0_arprot),
        .cpu_axi_uart_arqos                     (cpu_axi_uart0_arqos),
        .cpu_axi_uart_arready                   (cpu_axi_uart0_arready),
        .cpu_axi_uart_arregion                  (cpu_axi_uart0_arregion),
        .cpu_axi_uart_arvalid                   (cpu_axi_uart0_arvalid),
        // AXI-lite AW channel
        .cpu_axi_uart_awaddr                    (cpu_axi_uart0_awaddr),
        .cpu_axi_uart_awprot                    (cpu_axi_uart0_awprot),
        .cpu_axi_uart_awqos                     (cpu_axi_uart0_awqos),
        .cpu_axi_uart_awready                   (cpu_axi_uart0_awready),
        .cpu_axi_uart_awregion                  (cpu_axi_uart0_awregion),
        .cpu_axi_uart_awvalid                   (cpu_axi_uart0_awvalid),
        // AXI-lite B channel
        .cpu_axi_uart_bready                    (cpu_axi_uart0_bready),
        .cpu_axi_uart_bresp                     (cpu_axi_uart0_bresp),
        .cpu_axi_uart_bvalid                    (cpu_axi_uart0_bvalid),
        // AXI-lite R channel
        .cpu_axi_uart_rdata                     (cpu_axi_uart0_rdata),
        .cpu_axi_uart_rready                    (cpu_axi_uart0_rready),
        .cpu_axi_uart_rresp                     (cpu_axi_uart0_rresp),
        .cpu_axi_uart_rvalid                    (cpu_axi_uart0_rvalid),
        // AXI-lite W channel
        .cpu_axi_uart_wdata                     (cpu_axi_uart0_wdata),
        .cpu_axi_uart_wready                    (cpu_axi_uart0_wready),
        .cpu_axi_uart_wstrb                     (cpu_axi_uart0_wstrb),
        .cpu_axi_uart_wvalid                    (cpu_axi_uart0_wvalid),

        // MMIO reg AXI-lite slave interface,26bit address,64MB
        // AXI-lite AR channel
        .mips_cpu_axi_mmio_araddr               (mips_cpu_axi_mmio0_araddr[25:0]),
        .mips_cpu_axi_mmio_arprot               (mips_cpu_axi_mmio0_arprot),
        .mips_cpu_axi_mmio_arqos                (mips_cpu_axi_mmio0_arqos),
        .mips_cpu_axi_mmio_arready              (mips_cpu_axi_mmio0_arready),
        .mips_cpu_axi_mmio_arregion             (mips_cpu_axi_mmio0_arregion),
        .mips_cpu_axi_mmio_arvalid              (mips_cpu_axi_mmio0_arvalid),
        // AXI-lite AW channel
        .mips_cpu_axi_mmio_awaddr               (mips_cpu_axi_mmio0_awaddr[25:0]),
        .mips_cpu_axi_mmio_awprot               (mips_cpu_axi_mmio0_awprot),
        .mips_cpu_axi_mmio_awqos                (mips_cpu_axi_mmio0_awqos),
        .mips_cpu_axi_mmio_awready              (mips_cpu_axi_mmio0_awready),
        .mips_cpu_axi_mmio_awregion             (mips_cpu_axi_mmio0_awregion),
        .mips_cpu_axi_mmio_awvalid              (mips_cpu_axi_mmio0_awvalid),
        // AXI-lite B channel
        .mips_cpu_axi_mmio_bready               (mips_cpu_axi_mmio0_bready),
        .mips_cpu_axi_mmio_bresp                (mips_cpu_axi_mmio0_bresp),
        .mips_cpu_axi_mmio_bvalid               (mips_cpu_axi_mmio0_bvalid),
        // AXI-lite R channel
        .mips_cpu_axi_mmio_rdata                (mips_cpu_axi_mmio0_rdata),
        .mips_cpu_axi_mmio_rready               (mips_cpu_axi_mmio0_rready),
        .mips_cpu_axi_mmio_rresp                (mips_cpu_axi_mmio0_rresp),
        .mips_cpu_axi_mmio_rvalid               (mips_cpu_axi_mmio0_rvalid),
        // AXI-lite W channel
        .mips_cpu_axi_mmio_wdata                (mips_cpu_axi_mmio0_wdata),
        .mips_cpu_axi_mmio_wready               (mips_cpu_axi_mmio0_wready),
        .mips_cpu_axi_mmio_wstrb                (mips_cpu_axi_mmio0_wstrb),
        .mips_cpu_axi_mmio_wvalid               (mips_cpu_axi_mmio0_wvalid)
   );

   // instantiate module count
   user inst_user2(
        .clk                                    (ps_fclk_clk1),
        .rst                                    (ps_user_resetn1),
        // access PL memory AXI4 Master interface,32bit address
        // AXI4 AR channel
        .axi4_ddr_araddr                        (axi4_ddr1_araddr),
        .axi4_ddr_arburst                       (axi4_ddr1_arburst),
        .axi4_ddr_arcache                       (axi4_ddr1_arcache),
        .axi4_ddr_arlen                         (axi4_ddr1_arlen),
        .axi4_ddr_arlock                        (axi4_ddr1_arlock),
        .axi4_ddr_arprot                        (axi4_ddr1_arprot),
        .axi4_ddr_arqos                         (axi4_ddr1_arqos),
        .axi4_ddr_arready                       (axi4_ddr1_arready),
        .axi4_ddr_arregion                      (axi4_ddr1_arregion),
        .axi4_ddr_arsize                        (axi4_ddr1_arsize),
        .axi4_ddr_arvalid                       (axi4_ddr1_arvalid),
        // AXI4 AW channel
        .axi4_ddr_awaddr                        (axi4_ddr1_awaddr),
        .axi4_ddr_awburst                       (axi4_ddr1_awburst),
        .axi4_ddr_awcache                       (axi4_ddr1_awcache),
        .axi4_ddr_awlen                         (axi4_ddr1_awlen),
        .axi4_ddr_awlock                        (axi4_ddr1_awlock),
        .axi4_ddr_awprot                        (axi4_ddr1_awprot),
        .axi4_ddr_awqos                         (axi4_ddr1_awqos),
        .axi4_ddr_awready                       (axi4_ddr1_awready),
        .axi4_ddr_awregion                      (axi4_ddr1_awregion),
        .axi4_ddr_awsize                        (axi4_ddr1_awsize),
        .axi4_ddr_awvalid                       (axi4_ddr1_awvalid),
        // AXI4 B channel
        .axi4_ddr_bready                        (axi4_ddr1_bready),
        .axi4_ddr_bresp                         (axi4_ddr1_bresp),
        .axi4_ddr_bvalid                        (axi4_ddr1_bvalid),
        // AXI4 R channel
        .axi4_ddr_rdata                         (axi4_ddr1_rdata),
        .axi4_ddr_rlast                         (axi4_ddr1_rlast),
        .axi4_ddr_rready                        (axi4_ddr1_rready),
        .axi4_ddr_rresp                         (axi4_ddr1_rresp),
        .axi4_ddr_rvalid                        (axi4_ddr1_rvalid),
        // AXI4 W channel
        .axi4_ddr_wdata                         (axi4_ddr1_wdata),
        .axi4_ddr_wlast                         (axi4_ddr1_wlast),
        .axi4_ddr_wready                        (axi4_ddr1_wready),
        .axi4_ddr_wstrb                         (axi4_ddr1_wstrb),
        .axi4_ddr_wvalid                        (axi4_ddr1_wvalid),

        // acess uartlite reg AXI-lite master interface,12bit address
        // AXI-lite AR channel
        .cpu_axi_uart_araddr                    (cpu_axi_uart1_araddr),
        .cpu_axi_uart_arprot                    (cpu_axi_uart1_arprot),
        .cpu_axi_uart_arqos                     (cpu_axi_uart1_arqos),
        .cpu_axi_uart_arready                   (cpu_axi_uart1_arready),
        .cpu_axi_uart_arregion                  (cpu_axi_uart1_arregion),
        .cpu_axi_uart_arvalid                   (cpu_axi_uart1_arvalid),
        // AXI-lite AW channel
        .cpu_axi_uart_awaddr                    (cpu_axi_uart1_awaddr),
        .cpu_axi_uart_awprot                    (cpu_axi_uart1_awprot),
        .cpu_axi_uart_awqos                     (cpu_axi_uart1_awqos),
        .cpu_axi_uart_awready                   (cpu_axi_uart1_awready),
        .cpu_axi_uart_awregion                  (cpu_axi_uart1_awregion),
        .cpu_axi_uart_awvalid                   (cpu_axi_uart1_awvalid),
        // AXI-lite B channel
        .cpu_axi_uart_bready                    (cpu_axi_uart1_bready),
        .cpu_axi_uart_bresp                     (cpu_axi_uart1_bresp),
        .cpu_axi_uart_bvalid                    (cpu_axi_uart1_bvalid),
        // AXI-lite R channel
        .cpu_axi_uart_rdata                     (cpu_axi_uart1_rdata),
        .cpu_axi_uart_rready                    (cpu_axi_uart1_rready),
        .cpu_axi_uart_rresp                     (cpu_axi_uart1_rresp),
        .cpu_axi_uart_rvalid                    (cpu_axi_uart1_rvalid),
        // AXI-lite W channel
        .cpu_axi_uart_wdata                     (cpu_axi_uart1_wdata),
        .cpu_axi_uart_wready                    (cpu_axi_uart1_wready),
        .cpu_axi_uart_wstrb                     (cpu_axi_uart1_wstrb),
        .cpu_axi_uart_wvalid                    (cpu_axi_uart1_wvalid),

        // MMIO reg AXI-lite slave interface,26bit address,64MB
        // AXI-lite AR channel
        .mips_cpu_axi_mmio_araddr               (mips_cpu_axi_mmio1_araddr[25:0]),
        .mips_cpu_axi_mmio_arprot               (mips_cpu_axi_mmio1_arprot),
        .mips_cpu_axi_mmio_arqos                (mips_cpu_axi_mmio1_arqos),
        .mips_cpu_axi_mmio_arready              (mips_cpu_axi_mmio1_arready),
        .mips_cpu_axi_mmio_arregion             (mips_cpu_axi_mmio1_arregion),
        .mips_cpu_axi_mmio_arvalid              (mips_cpu_axi_mmio1_arvalid),
        // AXI-lite AW channel
        .mips_cpu_axi_mmio_awaddr               (mips_cpu_axi_mmio1_awaddr[25:0]),
        .mips_cpu_axi_mmio_awprot               (mips_cpu_axi_mmio1_awprot),
        .mips_cpu_axi_mmio_awqos                (mips_cpu_axi_mmio1_awqos),
        .mips_cpu_axi_mmio_awready              (mips_cpu_axi_mmio1_awready),
        .mips_cpu_axi_mmio_awregion             (mips_cpu_axi_mmio1_awregion),
        .mips_cpu_axi_mmio_awvalid              (mips_cpu_axi_mmio1_awvalid),
        // AXI-lite B channel
        .mips_cpu_axi_mmio_bready               (mips_cpu_axi_mmio1_bready),
        .mips_cpu_axi_mmio_bresp                (mips_cpu_axi_mmio1_bresp),
        .mips_cpu_axi_mmio_bvalid               (mips_cpu_axi_mmio1_bvalid),
        // AXI-lite R channel
        .mips_cpu_axi_mmio_rdata                (mips_cpu_axi_mmio1_rdata),
        .mips_cpu_axi_mmio_rready               (mips_cpu_axi_mmio1_rready),
        .mips_cpu_axi_mmio_rresp                (mips_cpu_axi_mmio1_rresp),
        .mips_cpu_axi_mmio_rvalid               (mips_cpu_axi_mmio1_rvalid),
        // AXI-lite W channel
        .mips_cpu_axi_mmio_wdata                (mips_cpu_axi_mmio1_wdata),
        .mips_cpu_axi_mmio_wready               (mips_cpu_axi_mmio1_wready),
        .mips_cpu_axi_mmio_wstrb                (mips_cpu_axi_mmio1_wstrb),
        .mips_cpu_axi_mmio_wvalid               (mips_cpu_axi_mmio1_wvalid)
);

      // instantiate module shift
   user inst_user3(
        .clk                                    (ps_fclk_clk2),
        .rst                                    (ps_user_resetn2),
        // access PL memory AXI4 Master interface,32bit address
        // AXI4 AR channel
        .axi4_ddr_araddr                        (axi4_ddr2_araddr),
        .axi4_ddr_arburst                       (axi4_ddr2_arburst),
        .axi4_ddr_arcache                       (axi4_ddr2_arcache),
        .axi4_ddr_arlen                         (axi4_ddr2_arlen),
        .axi4_ddr_arlock                        (axi4_ddr2_arlock),
        .axi4_ddr_arprot                        (axi4_ddr2_arprot),
        .axi4_ddr_arqos                         (axi4_ddr2_arqos),
        .axi4_ddr_arready                       (axi4_ddr2_arready),
        .axi4_ddr_arregion                      (axi4_ddr2_arregion),
        .axi4_ddr_arsize                        (axi4_ddr2_arsize),
        .axi4_ddr_arvalid                       (axi4_ddr2_arvalid),
        // AXI4 AW channel
        .axi4_ddr_awaddr                        (axi4_ddr2_awaddr),
        .axi4_ddr_awburst                       (axi4_ddr2_awburst),
        .axi4_ddr_awcache                       (axi4_ddr2_awcache),
        .axi4_ddr_awlen                         (axi4_ddr2_awlen),
        .axi4_ddr_awlock                        (axi4_ddr2_awlock),
        .axi4_ddr_awprot                        (axi4_ddr2_awprot),
        .axi4_ddr_awqos                         (axi4_ddr2_awqos),
        .axi4_ddr_awready                       (axi4_ddr2_awready),
        .axi4_ddr_awregion                      (axi4_ddr2_awregion),
        .axi4_ddr_awsize                        (axi4_ddr2_awsize),
        .axi4_ddr_awvalid                       (axi4_ddr2_awvalid),
        // AXI4 B channel
        .axi4_ddr_bready                        (axi4_ddr2_bready),
        .axi4_ddr_bresp                         (axi4_ddr2_bresp),
        .axi4_ddr_bvalid                        (axi4_ddr2_bvalid),
        // AXI4 R channel
        .axi4_ddr_rdata                         (axi4_ddr2_rdata),
        .axi4_ddr_rlast                         (axi4_ddr2_rlast),
        .axi4_ddr_rready                        (axi4_ddr2_rready),
        .axi4_ddr_rresp                         (axi4_ddr2_rresp),
        .axi4_ddr_rvalid                        (axi4_ddr2_rvalid),
        // AXI4 W channel
        .axi4_ddr_wdata                         (axi4_ddr2_wdata),
        .axi4_ddr_wlast                         (axi4_ddr2_wlast),
        .axi4_ddr_wready                        (axi4_ddr2_wready),
        .axi4_ddr_wstrb                         (axi4_ddr2_wstrb),
        .axi4_ddr_wvalid                        (axi4_ddr2_wvalid),

        // acess uartlite reg AXI-lite master interface,12bit address
        // AXI-lite AR channel
        .cpu_axi_uart_araddr                    (cpu_axi_uart2_araddr),
        .cpu_axi_uart_arprot                    (cpu_axi_uart2_arprot),
        .cpu_axi_uart_arqos                     (cpu_axi_uart2_arqos),
        .cpu_axi_uart_arready                   (cpu_axi_uart2_arready),
        .cpu_axi_uart_arregion                  (cpu_axi_uart2_arregion),
        .cpu_axi_uart_arvalid                   (cpu_axi_uart2_arvalid),
        // AXI-lite AW channel
        .cpu_axi_uart_awaddr                    (cpu_axi_uart2_awaddr),
        .cpu_axi_uart_awprot                    (cpu_axi_uart2_awprot),
        .cpu_axi_uart_awqos                     (cpu_axi_uart2_awqos),
        .cpu_axi_uart_awready                   (cpu_axi_uart2_awready),
        .cpu_axi_uart_awregion                  (cpu_axi_uart2_awregion),
        .cpu_axi_uart_awvalid                   (cpu_axi_uart2_awvalid),
        // AXI-lite B channel
        .cpu_axi_uart_bready                    (cpu_axi_uart2_bready),
        .cpu_axi_uart_bresp                     (cpu_axi_uart2_bresp),
        .cpu_axi_uart_bvalid                    (cpu_axi_uart2_bvalid),
        // AXI-lite R channel
        .cpu_axi_uart_rdata                     (cpu_axi_uart2_rdata),
        .cpu_axi_uart_rready                    (cpu_axi_uart2_rready),
        .cpu_axi_uart_rresp                     (cpu_axi_uart2_rresp),
        .cpu_axi_uart_rvalid                    (cpu_axi_uart2_rvalid),
        // AXI-lite W channel
        .cpu_axi_uart_wdata                     (cpu_axi_uart2_wdata),
        .cpu_axi_uart_wready                    (cpu_axi_uart2_wready),
        .cpu_axi_uart_wstrb                     (cpu_axi_uart2_wstrb),
        .cpu_axi_uart_wvalid                    (cpu_axi_uart2_wvalid),

        // MMIO reg AXI-lite slave interface,26bit address,64MB
        // AXI-lite AR channel
        .mips_cpu_axi_mmio_araddr               (mips_cpu_axi_mmio2_araddr[25:0]),
        .mips_cpu_axi_mmio_arprot               (mips_cpu_axi_mmio2_arprot),
        .mips_cpu_axi_mmio_arqos                (mips_cpu_axi_mmio2_arqos),
        .mips_cpu_axi_mmio_arready              (mips_cpu_axi_mmio2_arready),
        .mips_cpu_axi_mmio_arregion             (mips_cpu_axi_mmio2_arregion),
        .mips_cpu_axi_mmio_arvalid              (mips_cpu_axi_mmio2_arvalid),
        // AXI-lite AW channel
        .mips_cpu_axi_mmio_awaddr               (mips_cpu_axi_mmio2_awaddr[25:0]),
        .mips_cpu_axi_mmio_awprot               (mips_cpu_axi_mmio2_awprot),
        .mips_cpu_axi_mmio_awqos                (mips_cpu_axi_mmio2_awqos),
        .mips_cpu_axi_mmio_awready              (mips_cpu_axi_mmio2_awready),
        .mips_cpu_axi_mmio_awregion             (mips_cpu_axi_mmio2_awregion),
        .mips_cpu_axi_mmio_awvalid              (mips_cpu_axi_mmio2_awvalid),
        // AXI-lite B channel
        .mips_cpu_axi_mmio_bready               (mips_cpu_axi_mmio2_bready),
        .mips_cpu_axi_mmio_bresp                (mips_cpu_axi_mmio2_bresp),
        .mips_cpu_axi_mmio_bvalid               (mips_cpu_axi_mmio2_bvalid),
        // AXI-lite R channel
        .mips_cpu_axi_mmio_rdata                (mips_cpu_axi_mmio2_rdata),
        .mips_cpu_axi_mmio_rready               (mips_cpu_axi_mmio2_rready),
        .mips_cpu_axi_mmio_rresp                (mips_cpu_axi_mmio2_rresp),
        .mips_cpu_axi_mmio_rvalid               (mips_cpu_axi_mmio2_rvalid),
        // AXI-lite W channel
        .mips_cpu_axi_mmio_wdata                (mips_cpu_axi_mmio2_wdata),
        .mips_cpu_axi_mmio_wready               (mips_cpu_axi_mmio2_wready),
        .mips_cpu_axi_mmio_wstrb                (mips_cpu_axi_mmio2_wstrb),
        .mips_cpu_axi_mmio_wvalid               (mips_cpu_axi_mmio2_wvalid)
);

   // instantiate module count
   user inst_user4(
        .clk                                    (ps_fclk_clk3),
        .rst                                    (ps_user_resetn3),
        // access PL memory AXI4 Master interface,32bit address
        // AXI4 AR channel
        .axi4_ddr_araddr                        (axi4_ddr3_araddr),
        .axi4_ddr_arburst                       (axi4_ddr3_arburst),
        .axi4_ddr_arcache                       (axi4_ddr3_arcache),
        .axi4_ddr_arlen                         (axi4_ddr3_arlen),
        .axi4_ddr_arlock                        (axi4_ddr3_arlock),
        .axi4_ddr_arprot                        (axi4_ddr3_arprot),
        .axi4_ddr_arqos                         (axi4_ddr3_arqos),
        .axi4_ddr_arready                       (axi4_ddr3_arready),
        .axi4_ddr_arregion                      (axi4_ddr3_arregion),
        .axi4_ddr_arsize                        (axi4_ddr3_arsize),
        .axi4_ddr_arvalid                       (axi4_ddr3_arvalid),
        // AXI4 AW channel
        .axi4_ddr_awaddr                        (axi4_ddr3_awaddr),
        .axi4_ddr_awburst                       (axi4_ddr3_awburst),
        .axi4_ddr_awcache                       (axi4_ddr3_awcache),
        .axi4_ddr_awlen                         (axi4_ddr3_awlen),
        .axi4_ddr_awlock                        (axi4_ddr3_awlock),
        .axi4_ddr_awprot                        (axi4_ddr3_awprot),
        .axi4_ddr_awqos                         (axi4_ddr3_awqos),
        .axi4_ddr_awready                       (axi4_ddr3_awready),
        .axi4_ddr_awregion                      (axi4_ddr3_awregion),
        .axi4_ddr_awsize                        (axi4_ddr3_awsize),
        .axi4_ddr_awvalid                       (axi4_ddr3_awvalid),
        // AXI4 B channel
        .axi4_ddr_bready                        (axi4_ddr3_bready),
        .axi4_ddr_bresp                         (axi4_ddr3_bresp),
        .axi4_ddr_bvalid                        (axi4_ddr3_bvalid),
        // AXI4 R channel
        .axi4_ddr_rdata                         (axi4_ddr3_rdata),
        .axi4_ddr_rlast                         (axi4_ddr3_rlast),
        .axi4_ddr_rready                        (axi4_ddr3_rready),
        .axi4_ddr_rresp                         (axi4_ddr3_rresp),
        .axi4_ddr_rvalid                        (axi4_ddr3_rvalid),
        // AXI4 W channel
        .axi4_ddr_wdata                         (axi4_ddr3_wdata),
        .axi4_ddr_wlast                         (axi4_ddr3_wlast),
        .axi4_ddr_wready                        (axi4_ddr3_wready),
        .axi4_ddr_wstrb                         (axi4_ddr3_wstrb),
        .axi4_ddr_wvalid                        (axi4_ddr3_wvalid),

        // acess uartlite reg AXI-lite master interface,12bit address
        // AXI-lite AR channel
        .cpu_axi_uart_araddr                    (cpu_axi_uart3_araddr),
        .cpu_axi_uart_arprot                    (cpu_axi_uart3_arprot),
        .cpu_axi_uart_arqos                     (cpu_axi_uart3_arqos),
        .cpu_axi_uart_arready                   (cpu_axi_uart3_arready),
        .cpu_axi_uart_arregion                  (cpu_axi_uart3_arregion),
        .cpu_axi_uart_arvalid                   (cpu_axi_uart3_arvalid),
        // AXI-lite AW channel
        .cpu_axi_uart_awaddr                    (cpu_axi_uart3_awaddr),
        .cpu_axi_uart_awprot                    (cpu_axi_uart3_awprot),
        .cpu_axi_uart_awqos                     (cpu_axi_uart3_awqos),
        .cpu_axi_uart_awready                   (cpu_axi_uart3_awready),
        .cpu_axi_uart_awregion                  (cpu_axi_uart3_awregion),
        .cpu_axi_uart_awvalid                   (cpu_axi_uart3_awvalid),
        // AXI-lite B channel
        .cpu_axi_uart_bready                    (cpu_axi_uart3_bready),
        .cpu_axi_uart_bresp                     (cpu_axi_uart3_bresp),
        .cpu_axi_uart_bvalid                    (cpu_axi_uart3_bvalid),
        // AXI-lite R channel
        .cpu_axi_uart_rdata                     (cpu_axi_uart3_rdata),
        .cpu_axi_uart_rready                    (cpu_axi_uart3_rready),
        .cpu_axi_uart_rresp                     (cpu_axi_uart3_rresp),
        .cpu_axi_uart_rvalid                    (cpu_axi_uart3_rvalid),
        // AXI-lite W channel
        .cpu_axi_uart_wdata                     (cpu_axi_uart3_wdata),
        .cpu_axi_uart_wready                    (cpu_axi_uart3_wready),
        .cpu_axi_uart_wstrb                     (cpu_axi_uart3_wstrb),
        .cpu_axi_uart_wvalid                    (cpu_axi_uart3_wvalid),

        // MMIO reg AXI-lite slave interface,26bit address,64MB
        // AXI-lite AR channel
        .mips_cpu_axi_mmio_araddr               (mips_cpu_axi_mmio3_araddr[25:0]),
        .mips_cpu_axi_mmio_arprot               (mips_cpu_axi_mmio3_arprot),
        .mips_cpu_axi_mmio_arqos                (mips_cpu_axi_mmio3_arqos),
        .mips_cpu_axi_mmio_arready              (mips_cpu_axi_mmio3_arready),
        .mips_cpu_axi_mmio_arregion             (mips_cpu_axi_mmio3_arregion),
        .mips_cpu_axi_mmio_arvalid              (mips_cpu_axi_mmio3_arvalid),
        // AXI-lite AW channel
        .mips_cpu_axi_mmio_awaddr               (mips_cpu_axi_mmio3_awaddr[25:0]),
        .mips_cpu_axi_mmio_awprot               (mips_cpu_axi_mmio3_awprot),
        .mips_cpu_axi_mmio_awqos                (mips_cpu_axi_mmio3_awqos),
        .mips_cpu_axi_mmio_awready              (mips_cpu_axi_mmio3_awready),
        .mips_cpu_axi_mmio_awregion             (mips_cpu_axi_mmio3_awregion),
        .mips_cpu_axi_mmio_awvalid              (mips_cpu_axi_mmio3_awvalid),
        // AXI-lite B channel
        .mips_cpu_axi_mmio_bready               (mips_cpu_axi_mmio3_bready),
        .mips_cpu_axi_mmio_bresp                (mips_cpu_axi_mmio3_bresp),
        .mips_cpu_axi_mmio_bvalid               (mips_cpu_axi_mmio3_bvalid),
        // AXI-lite R channel
        .mips_cpu_axi_mmio_rdata                (mips_cpu_axi_mmio3_rdata),
        .mips_cpu_axi_mmio_rready               (mips_cpu_axi_mmio3_rready),
        .mips_cpu_axi_mmio_rresp                (mips_cpu_axi_mmio3_rresp),
        .mips_cpu_axi_mmio_rvalid               (mips_cpu_axi_mmio3_rvalid),
        // AXI-lite W channel
        .mips_cpu_axi_mmio_wdata                (mips_cpu_axi_mmio3_wdata),
        .mips_cpu_axi_mmio_wready               (mips_cpu_axi_mmio3_wready),
        .mips_cpu_axi_mmio_wstrb                (mips_cpu_axi_mmio3_wstrb),
        .mips_cpu_axi_mmio_wvalid               (mips_cpu_axi_mmio3_wvalid)
);
endmodule

// black box definition for module user1
module user(
    input clk,
    input rst,
    // access PL memory AXI4 Master interface,32bit address
    // AXI4 AR channel
    output [31:0] axi4_ddr_araddr,
    output [1:0] axi4_ddr_arburst,
    output [3:0] axi4_ddr_arcache,
    output [7:0] axi4_ddr_arlen,
    output [0:0] axi4_ddr_arlock,
    output [2:0] axi4_ddr_arprot,
    output [3:0] axi4_ddr_arqos,
    input axi4_ddr_arready,
    output [3:0] axi4_ddr_arregion,
    output [2:0] axi4_ddr_arsize,
    output axi4_ddr_arvalid,
    // AXI4 AW channel
    output [31:0] axi4_ddr_awaddr,
    output [1:0] axi4_ddr_awburst,
    output [3:0] axi4_ddr_awcache,
    output [7:0] axi4_ddr_awlen,
    output [0:0] axi4_ddr_awlock,
    output [2:0] axi4_ddr_awprot,
    output [3:0] axi4_ddr_awqos,
    input axi4_ddr_awready,
    output [3:0] axi4_ddr_awregion,
    output [2:0] axi4_ddr_awsize,
    output axi4_ddr_awvalid,
    // AXI4 B channel
    output axi4_ddr_bready,
    input [1:0] axi4_ddr_bresp,
    input axi4_ddr_bvalid,
    // AXI4 R channel
    input [31:0] axi4_ddr_rdata,
    input axi4_ddr_rlast,
    output axi4_ddr_rready,
    input [1:0] axi4_ddr_rresp,
    input axi4_ddr_rvalid,
    // AXI4 W channel
    output [31:0] axi4_ddr_wdata,
    output axi4_ddr_wlast,
    input axi4_ddr_wready,
    output [3:0] axi4_ddr_wstrb,
    output axi4_ddr_wvalid,

    // acess uartlite reg AXI-lite master interface,12bit address
    // AXI-lite AR channel
    output [31:0] cpu_axi_uart_araddr,
    output [2:0] cpu_axi_uart_arprot,
    output [3:0] cpu_axi_uart_arqos,
    input cpu_axi_uart_arready,
    output [3:0] cpu_axi_uart_arregion,
    output cpu_axi_uart_arvalid,
    // AXI-lite AW channel
    output [31:0] cpu_axi_uart_awaddr,
    output [2:0] cpu_axi_uart_awprot,
    output [3:0] cpu_axi_uart_awqos,
    input cpu_axi_uart_awready,
    output [3:0] cpu_axi_uart_awregion,
    output cpu_axi_uart_awvalid,
    // AXI-lite B channel
    output cpu_axi_uart_bready,
    input [1:0] cpu_axi_uart_bresp,
    input cpu_axi_uart_bvalid,
    // AXI-lite R channel
    input [31:0] cpu_axi_uart_rdata,
    output cpu_axi_uart_rready,
    input [1:0] cpu_axi_uart_rresp,
    input cpu_axi_uart_rvalid,
    // AXI-lite W channel
    output [31:0] cpu_axi_uart_wdata,
    input cpu_axi_uart_wready,
    output [3:0] cpu_axi_uart_wstrb,
    output cpu_axi_uart_wvalid,

    // MMIO reg AXI-lite slave interface,26bit address,64MB
    // AXI-lite AR channel
    input [25:0] mips_cpu_axi_mmio_araddr,
    input [2:0] mips_cpu_axi_mmio_arprot,
    input [3:0] mips_cpu_axi_mmio_arqos,
    output mips_cpu_axi_mmio_arready,
    input [3:0] mips_cpu_axi_mmio_arregion,
    input mips_cpu_axi_mmio_arvalid,
    // AXI-lite AW channel
    input [25:0] mips_cpu_axi_mmio_awaddr,
    input [2:0] mips_cpu_axi_mmio_awprot,
    input [3:0] mips_cpu_axi_mmio_awqos,
    output mips_cpu_axi_mmio_awready,
    input [3:0] mips_cpu_axi_mmio_awregion,
    input mips_cpu_axi_mmio_awvalid,
    // AXI-lite B channel
    input mips_cpu_axi_mmio_bready,
    output [1:0] mips_cpu_axi_mmio_bresp,
    output mips_cpu_axi_mmio_bvalid,
    // AXI-lite R channel
    output [31:0] mips_cpu_axi_mmio_rdata,
    input mips_cpu_axi_mmio_rready,
    output [1:0] mips_cpu_axi_mmio_rresp,
    output mips_cpu_axi_mmio_rvalid,
    // AXI-lite W channel
    input [31:0] mips_cpu_axi_mmio_wdata,
    output mips_cpu_axi_mmio_wready,
    input [3:0] mips_cpu_axi_mmio_wstrb,
    input mips_cpu_axi_mmio_wvalid
);
endmodule


