#========================================================
# Vivado constraint file for mpsoc_kvs_platform
# Based on Vivado 2016.4
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 17/08/2017
#========================================================

# PCIe RP #0 GT reference clock
create_clock -period 10.000 -name pcie_rc_ref_clk_0 -waveform {0.000 5.000} [get_ports pcie_rc_gt_ref_clk_0_clk_p]

set_property PACKAGE_PIN AA10 [get_ports {pcie_rc_gt_ref_clk_0_clk_p[0]}]

# PCIe RP #1 GT reference clock
create_clock -period 10.000 -name pcie_rc_ref_clk_1 -waveform {0.000 5.000} [get_ports pcie_rc_gt_ref_clk_1_clk_p]

set_property PACKAGE_PIN W10 [get_ports {pcie_rc_gt_ref_clk_1_clk_p[0]}]

# PCIe RC GT physical location
set_property LOC GTHE4_CHANNEL_X0Y16 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[4].*gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST}]
set_property LOC GTHE4_CHANNEL_X0Y17 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[4].*gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
set_property LOC GTHE4_CHANNEL_X0Y20 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[5].*gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST}]
set_property LOC GTHE4_CHANNEL_X0Y21 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[5].*gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]

# PCIe RP #0 perstn physical location
set_property PACKAGE_PIN B6 [get_ports pcie_rc_perstn_0]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rc_perstn_0]

# PCIe RP #1 perstn physical location
set_property PACKAGE_PIN C5 [get_ports pcie_rc_perstn_1]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rc_perstn_1]

# PCIe RP #0 link up LED
set_property PACKAGE_PIN A9 [get_ports pcie_rc_user_link_up_0]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_rc_user_link_up_0]

# PCIe RP #1 link up LED
set_property PACKAGE_PIN A10 [get_ports pcie_rc_user_link_up_1]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_rc_user_link_up_1]

# Timing exceptions
set_clock_groups -name async_pl_clk0_pcie_0 -asynchronous \
		-group [get_clocks clk_pl_0] \
		-group [get_clocks -include_generated_clocks pcie_rc_ref_clk_0]

set_clock_groups -name async_pl_clk0_pcie_1 -asynchronous \
		-group [get_clocks clk_pl_0] \
		-group [get_clocks -include_generated_clocks pcie_rc_ref_clk_1]
		
set_property PACKAGE_PIN E11 [get_ports {c0_init_calib_complete}]
set_property IOSTANDARD LVCMOS33 [get_ports {c0_init_calib_complete}]

#DDR mig 
set_property PACKAGE_PIN AK24 [get_ports {ddr4_rtl_dq[15]}]
set_property PACKAGE_PIN AJ24 [get_ports {ddr4_rtl_dq[14]}]
set_property PACKAGE_PIN AL23 [get_ports {ddr4_rtl_dq[13]}]
set_property PACKAGE_PIN AK23 [get_ports {ddr4_rtl_dq[12]}]
set_property PACKAGE_PIN AN24 [get_ports {ddr4_rtl_dq[11]}]
set_property PACKAGE_PIN AM24 [get_ports {ddr4_rtl_dq[10]}]
set_property PACKAGE_PIN AP25 [get_ports {ddr4_rtl_dq[9]}]
set_property PACKAGE_PIN AP24 [get_ports {ddr4_rtl_dq[8]}]
set_property PACKAGE_PIN BB28 [get_ports {ddr4_rtl_dq[7]}]
set_property PACKAGE_PIN BA28 [get_ports {ddr4_rtl_dq[6]}]
set_property PACKAGE_PIN AY28 [get_ports {ddr4_rtl_dq[5]}]
set_property PACKAGE_PIN AY27 [get_ports {ddr4_rtl_dq[4]}]
set_property PACKAGE_PIN BA25 [get_ports {ddr4_rtl_dq[3]}]
set_property PACKAGE_PIN AY25 [get_ports {ddr4_rtl_dq[2]}]
set_property PACKAGE_PIN BB25 [get_ports {ddr4_rtl_dq[1]}]
set_property PACKAGE_PIN BB24 [get_ports {ddr4_rtl_dq[0]}]
set_property PACKAGE_PIN AT26 [get_ports {ddr4_rtl_dq[31]}]
set_property PACKAGE_PIN AT25 [get_ports {ddr4_rtl_dq[30]}]
set_property PACKAGE_PIN AU26 [get_ports {ddr4_rtl_dq[29]}]
set_property PACKAGE_PIN AU25 [get_ports {ddr4_rtl_dq[28]}]
set_property PACKAGE_PIN AW27 [get_ports {ddr4_rtl_dq[27]}]
set_property PACKAGE_PIN AV27 [get_ports {ddr4_rtl_dq[26]}]
set_property PACKAGE_PIN AW26 [get_ports {ddr4_rtl_dq[25]}]
set_property PACKAGE_PIN AV26 [get_ports {ddr4_rtl_dq[24]}]
set_property PACKAGE_PIN AK22 [get_ports {ddr4_rtl_dq[23]}]
set_property PACKAGE_PIN AJ22 [get_ports {ddr4_rtl_dq[22]}]
set_property PACKAGE_PIN AJ20 [get_ports {ddr4_rtl_dq[21]}]
set_property PACKAGE_PIN AJ21 [get_ports {ddr4_rtl_dq[20]}]
set_property PACKAGE_PIN AL21 [get_ports {ddr4_rtl_dq[19]}]
set_property PACKAGE_PIN AL22 [get_ports {ddr4_rtl_dq[18]}]
set_property PACKAGE_PIN AM20 [get_ports {ddr4_rtl_dq[17]}]
set_property PACKAGE_PIN AM21 [get_ports {ddr4_rtl_dq[16]}]
set_property PACKAGE_PIN AL20 [get_ports {ddr4_rtl_cs_n[0]}]
set_property PACKAGE_PIN AR22 [get_ports {ddr4_rtl_adr[16]}]
set_property PACKAGE_PIN AR19 [get_ports {ddr4_rtl_bg[0]}]
set_property PACKAGE_PIN AP20 [get_ports {ddr4_rtl_adr[7]}]
set_property PACKAGE_PIN AP21 [get_ports {ddr4_rtl_adr[5]}]
set_property PACKAGE_PIN AN21 [get_ports {ddr4_rtl_adr[4]}]
set_property PACKAGE_PIN AP22 [get_ports {ddr4_rtl_odt[0]}]
set_property PACKAGE_PIN AU19 [get_ports {ddr4_rtl_cke[1]}]
set_property PACKAGE_PIN AT21 [get_ports {ddr4_rtl_adr[3]}]
set_property PACKAGE_PIN AT22 [get_ports {ddr4_rtl_adr[13]}]
set_property PACKAGE_PIN AV19 [get_ports {ddr4_rtl_bg[1]}]
set_property PACKAGE_PIN AY18 [get_ports {ddr4_rtl_adr[11]}]
set_property PACKAGE_PIN AY19 [get_ports {ddr4_rtl_adr[2]}]
set_property PACKAGE_PIN AW19 [get_ports {ddr4_rtl_adr[1]}]
set_property PACKAGE_PIN AW20 [get_ports {ddr4_rtl_adr[9]}]
set_property PACKAGE_PIN AW22 [get_ports {ddr4_rtl_odt[1]}]
set_property PACKAGE_PIN AV22 [get_ports {ddr4_rtl_adr[15]}]
set_property PACKAGE_PIN AV23 [get_ports {ddr4_rtl_cs_n[1]}]
set_property PACKAGE_PIN AW21 [get_ports {ddr4_rtl_adr[10]}]
set_property PACKAGE_PIN BB18 [get_ports {ddr4_rtl_cke[0]}]
set_property PACKAGE_PIN BA18 [get_ports {ddr4_rtl_adr[6]}]
set_property PACKAGE_PIN BB19 [get_ports {ddr4_rtl_adr[12]}]
set_property PACKAGE_PIN BB20 [get_ports {ddr4_rtl_adr[8]}]
set_property PACKAGE_PIN BA20 [get_ports {ddr4_rtl_adr[0]}]
set_property PACKAGE_PIN AY20 [get_ports {ddr4_rtl_ba[1]}]
set_property PACKAGE_PIN BA21 [get_ports {ddr4_rtl_ba[0]}]
set_property PACKAGE_PIN BA22 [get_ports {ddr4_rtl_adr[14]}]
set_property PACKAGE_PIN AY23 [get_ports {ddr4_rtl_ck_t[1]}]
set_property PACKAGE_PIN BA23 [get_ports {ddr4_rtl_ck_t[0]}]
set_property PACKAGE_PIN AU16 [get_ports {ddr4_rtl_dq[55]}]
set_property PACKAGE_PIN AT16 [get_ports {ddr4_rtl_dq[54]}]
set_property PACKAGE_PIN AT17 [get_ports {ddr4_rtl_dq[53]}]
set_property PACKAGE_PIN AR17 [get_ports {ddr4_rtl_dq[52]}]
set_property PACKAGE_PIN AV18 [get_ports {ddr4_rtl_dq[51]}]
set_property PACKAGE_PIN AU18 [get_ports {ddr4_rtl_dq[50]}]
set_property PACKAGE_PIN AU15 [get_ports {ddr4_rtl_dq[49]}]
set_property PACKAGE_PIN AT15 [get_ports {ddr4_rtl_dq[48]}]
set_property PACKAGE_PIN AP16 [get_ports {ddr4_rtl_dq[63]}]
set_property PACKAGE_PIN AN16 [get_ports {ddr4_rtl_dq[62]}]
set_property PACKAGE_PIN AM16 [get_ports {ddr4_rtl_dq[61]}]
set_property PACKAGE_PIN AL16 [get_ports {ddr4_rtl_dq[60]}]
set_property PACKAGE_PIN AN17 [get_ports {ddr4_rtl_dq[59]}]
set_property PACKAGE_PIN AN18 [get_ports {ddr4_rtl_dq[58]}]
set_property PACKAGE_PIN AM18 [get_ports {ddr4_rtl_dq[57]}]
set_property PACKAGE_PIN AL18 [get_ports {ddr4_rtl_dq[56]}]
set_property PACKAGE_PIN BB13 [get_ports {ddr4_rtl_dq[39]}]
set_property PACKAGE_PIN BA13 [get_ports {ddr4_rtl_dq[38]}]
set_property PACKAGE_PIN AY14 [get_ports {ddr4_rtl_dq[37]}]
set_property PACKAGE_PIN AY15 [get_ports {ddr4_rtl_dq[36]}]
set_property PACKAGE_PIN AW16 [get_ports {ddr4_rtl_dq[35]}]
set_property PACKAGE_PIN AW17 [get_ports {ddr4_rtl_dq[34]}]
set_property PACKAGE_PIN BB16 [get_ports {ddr4_rtl_dq[33]}]
set_property PACKAGE_PIN BA16 [get_ports {ddr4_rtl_dq[32]}]
set_property PACKAGE_PIN AV14 [get_ports {ddr4_rtl_dq[47]}]
set_property PACKAGE_PIN AU14 [get_ports {ddr4_rtl_dq[46]}]
set_property PACKAGE_PIN AW14 [get_ports {ddr4_rtl_dq[45]}]
set_property PACKAGE_PIN AW15 [get_ports {ddr4_rtl_dq[44]}]
set_property PACKAGE_PIN BB10 [get_ports {ddr4_rtl_dq[43]}]
set_property PACKAGE_PIN BA10 [get_ports {ddr4_rtl_dq[42]}]
set_property PACKAGE_PIN BB11 [get_ports {ddr4_rtl_dq[41]}]
set_property PACKAGE_PIN BA11 [get_ports {ddr4_rtl_dq[40]}]
set_property PACKAGE_PIN AM23 [get_ports {ddr4_rtl_dqs_t[1]}]
set_property PACKAGE_PIN BA26 [get_ports {ddr4_rtl_dqs_t[0]}]
set_property PACKAGE_PIN AU28 [get_ports {ddr4_rtl_dqs_t[3]}]
set_property PACKAGE_PIN AK20 [get_ports {ddr4_rtl_dqs_t[2]}]
set_property PACKAGE_PIN AR18 [get_ports {ddr4_rtl_dqs_t[6]}]
set_property PACKAGE_PIN AJ17 [get_ports {ddr4_rtl_dqs_t[7]}]
set_property PACKAGE_PIN BA15 [get_ports {ddr4_rtl_dqs_t[4]}]
set_property PACKAGE_PIN AU13 [get_ports {ddr4_rtl_dqs_t[5]}]
set_property PACKAGE_PIN AY12 [get_ports {ddr4_rtl_dm_n[5]}]
set_property PACKAGE_PIN AY17 [get_ports {ddr4_rtl_dm_n[4]}]
set_property PACKAGE_PIN AJ18 [get_ports {ddr4_rtl_dm_n[7]}]
set_property PACKAGE_PIN AV17 [get_ports {ddr4_rtl_dm_n[6]}]
set_property PACKAGE_PIN AU24 [get_ports {ddr4_rtl_dm_n[3]}]
set_property PACKAGE_PIN AW24 [get_ports {ddr4_rtl_dm_n[0]}]
set_property PACKAGE_PIN AR23 [get_ports {ddr4_rtl_dm_n[1]}]
set_property PACKAGE_PIN AM19 [get_ports {ddr4_rtl_dm_n[2]}]
set_property PACKAGE_PIN AU20 [get_ports ddr4_rtl_act_n]
set_property PACKAGE_PIN AR20 [get_ports ddr4_rtl_reset_n]
set_property PACKAGE_PIN AU21 [get_ports C0_SYS_CLK_clk_p]
set_property ODT RTT_NONE [get_ports C0_SYS_CLK_clk_p]

