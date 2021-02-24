#========================================================
# Vivado BD design auto run script for mpsoc
# Based on Vivado 2019.1
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 09/06/2020
#========================================================

namespace eval mpsoc_bd_val {
	set design_name mpsoc
	set bd_prefix ${mpsoc_bd_val::design_name}_

	set mig_csv fidus_pl_ddr4_sodimm.csv

	set mig_csv_src ${::script_dir}/../sources/ip_catalog/ddr4_mig/${mig_csv}
	set mig_csv_dest ./${::project_name}/${::project_name}.srcs/sources_1/bd/${mpsoc_bd_val::design_name}/ip/${mpsoc_bd_val::bd_prefix}ddr4_mig_0/${mig_csv}
}


# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${mpsoc_bd_val::design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne ${mpsoc_bd_val::design_name} } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <${mpsoc_bd_val::design_name}> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq ${mpsoc_bd_val::design_name} } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <${mpsoc_bd_val::design_name}> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${mpsoc_bd_val::design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <${mpsoc_bd_val::design_name}> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <${mpsoc_bd_val::design_name}> in project, so creating one..."

   create_bd_design ${mpsoc_bd_val::design_name}

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <${mpsoc_bd_val::design_name}> as current_bd_design."
   current_bd_design ${mpsoc_bd_val::design_name}

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"${mpsoc_bd_val::design_name}\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

#=============================================
# Create IP blocks
#=============================================

  # Create instance: Zynq MPSoC
  set zynq_mpsoc [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_mpsoc ]
  apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} $zynq_mpsoc
  set_property -dict [ list CONFIG.PSU__USE__M_AXI_GP0 {1} \
				CONFIG.PSU__USE__M_AXI_GP1 {1}\
				CONFIG.PSU__USE__M_AXI_GP2 {1} \
				CONFIG.PSU__USE__S_AXI_GP2 {1} \
				CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {125} \
				CONFIG.PSU__FPGA_PL1_ENABLE {1} \
				CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {250} \
				CONFIG.PSU__USE__IRQ0 {1} \
				CONFIG.PSU__USE__IRQ1 {1} \
				CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
				CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {1} ] $zynq_mpsoc

  # Create instance: AXI PCIe Root Complex
  set xdma_rp_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_rp_0 ]
  set_property -dict [ list CONFIG.mode_selection {Advanced} \
				CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
        CONFIG.functional_mode {AXI Bridge} \
        CONFIG.dma_reset_source_sel {Phy_Ready} \
				CONFIG.en_gt_selection {true} \
				CONFIG.pl_link_cap_max_link_width {X4} \
				CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
				CONFIG.axi_addr_width {40} \
				CONFIG.pf0_class_code_sub {04} \
				CONFIG.pf0_bar0_enabled {false} \
				CONFIG.axibar2pciebar_0 {0x00000000A0000000} \
				CONFIG.c_s_axi_supports_narrow_burst {false} \
				CONFIG.plltype {QPLL1} \
        CONFIG.msi_rx_pin_en {true} \
				CONFIG.BASEADDR {0x00000000} \
				CONFIG.HIGHADDR {0x007FFFFF} ] $xdma_rp_0

  # Create instance: AXI PCIe Root Complex
  set xdma_rp_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_rp_1 ]
  set_property -dict [ list CONFIG.mode_selection {Advanced} \
				CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
        CONFIG.functional_mode {AXI Bridge} \
        CONFIG.dma_reset_source_sel {Phy_Ready} \
				CONFIG.en_gt_selection {true} \
				CONFIG.pl_link_cap_max_link_width {X4} \
				CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
				CONFIG.axi_addr_width {40} \
				CONFIG.pf0_class_code_sub {04} \
				CONFIG.pf0_bar0_enabled {false} \
				CONFIG.axibar2pciebar_0 {0x00000000A0100000} \
				CONFIG.c_s_axi_supports_narrow_burst {false} \
				CONFIG.plltype {QPLL1} \
        CONFIG.msi_rx_pin_en {true} \
				CONFIG.BASEADDR {0x00000000} \
				CONFIG.HIGHADDR {0x007FFFFF} ] $xdma_rp_1

if {${::board} == "fidus"} {
  set_property -dict [ list CONFIG.select_quad {GTY_Quad_128} ] $xdma_rp_0

  set_property -dict [ list CONFIG.select_quad {GTY_Quad_129} ] $xdma_rp_1

} else {
  set_property -dict [ list CONFIG.pcie_blk_locn {X1Y1} \
				CONFIG.select_quad {GTH_Quad_228} ] $xdma_rp_0

  set_property -dict [ list CONFIG.pcie_blk_locn {X1Y2} \
				CONFIG.select_quad {GTH_Quad_229} ] $xdma_rp_1
}

  # Create instance: Concat
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list CONFIG.NUM_PORTS {1} CONFIG.IN0_WIDTH {23}] $xlconcat_0

  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [list CONFIG.NUM_PORTS {1} CONFIG.IN0_WIDTH {23}] $xlconcat_1

  # Create instance: AXI IC for AXI-Lite slave instance of PCIe RC
  set axi_ic_pcie_rc_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rc_dma ]
  set_property -dict [ list CONFIG.NUM_MI {1} \
				CONFIG.NUM_SI {2} \
        CONFIG.STRATEGY {2} ] $axi_ic_pcie_rc_dma

  set axi_ic_pcie_rc_bar [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rc_bar ]
  set_property -dict [ list CONFIG.NUM_MI {2} \
				CONFIG.NUM_SI {1} ] $axi_ic_pcie_rc_bar

  set axi_ic_mmio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_mmio ]
  set_property -dict [ list CONFIG.NUM_MI {15} \
				CONFIG.NUM_SI {1} ] $axi_ic_mmio

  # Create instance: IBUFDS_GTE for PCIe RP #0 reference clock
  set pcie_rc_ref_clk_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 pcie_rc_ref_clk_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $pcie_rc_ref_clk_buf_0

  # Create instance: IBUFDS_GTE for PCIe RP #1 reference clock
  set pcie_rc_ref_clk_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 pcie_rc_ref_clk_buf_1 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $pcie_rc_ref_clk_buf_1

  # Create instance: system reset for pl_clock0 and PCIe RC 
  create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pl_clk_sys_reset

  # Create instance: dcm_locked_gen 
  set dcm_locked_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 dcm_locked_gen ]
  set_property -dict [list CONFIG.C_SIZE {1}] $dcm_locked_gen

#=============================================
# Clock ports
#=============================================

  # gt differential reference clock for pcie rp #0
  set pcie_rc_gt_ref_clk_0 [ create_bd_intf_port -mode slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_rc_gt_ref_clk_0 ]
  set_property -dict [ list config.freq_hz {100000000} ] $pcie_rc_gt_ref_clk_0

  # gt differential reference clock for pcie rp #1
  set pcie_rc_gt_ref_clk_1 [ create_bd_intf_port -mode slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_rc_gt_ref_clk_1 ]
  set_property -dict [ list config.freq_hz {100000000} ] $pcie_rc_gt_ref_clk_1

#=============================================
# Reset ports
#=============================================

  # PCIe RC perst
  create_bd_port -dir O -type rst pcie_rc_perstn_0
  create_bd_port -dir O -type rst pcie_rc_perstn_1

#=============================================
# GT ports
#=============================================

  # PCIe Slot
  create_bd_port -dir I -from 3 -to 0 pcie_exp_rxn_0
  create_bd_port -dir I -from 3 -to 0 pcie_exp_rxp_0
  create_bd_port -dir O -from 3 -to 0 pcie_exp_txn_0
  create_bd_port -dir O -from 3 -to 0 pcie_exp_txp_0

  create_bd_port -dir I -from 3 -to 0 pcie_exp_rxn_1
  create_bd_port -dir I -from 3 -to 0 pcie_exp_rxp_1
  create_bd_port -dir O -from 3 -to 0 pcie_exp_txn_1
  create_bd_port -dir O -from 3 -to 0 pcie_exp_txp_1

#=============================================
# MISC ports
#=============================================

  create_bd_port -dir O pcie_rc_user_link_up_0
  create_bd_port -dir O pcie_rc_user_link_up_1

#=============================================
# System clock connection
#=============================================

  # PCIe RP #0 reference clock
  connect_bd_intf_net -intf_net pcie_rc_gt_ref_clk_0 \
      [get_bd_intf_pins pcie_rc_gt_ref_clk_0] \
      [get_bd_intf_pins pcie_rc_ref_clk_buf_0/CLK_IN_D]

  connect_bd_net -net pcie_rc_ref_clk_0 \
      [get_bd_pins pcie_rc_ref_clk_buf_0/IBUF_DS_ODIV2] \
      [get_bd_pins xdma_rp_0/sys_clk]

  connect_bd_net -net pcie_rc_sys_clk_0 \
      [get_bd_pins pcie_rc_ref_clk_buf_0/IBUF_OUT] \
      [get_bd_pins xdma_rp_0/sys_clk_gt]

  # PCIe RP #1 reference clock
  connect_bd_intf_net -intf_net pcie_rc_gt_ref_clk_1 \
      [get_bd_intf_pins pcie_rc_gt_ref_clk_1] \
      [get_bd_intf_pins pcie_rc_ref_clk_buf_1/CLK_IN_D]

  connect_bd_net -net pcie_rc_ref_clk_1 \
      [get_bd_pins pcie_rc_ref_clk_buf_1/IBUF_DS_ODIV2] \
      [get_bd_pins xdma_rp_1/sys_clk]

  connect_bd_net -net pcie_rc_sys_clk_1 \
      [get_bd_pins pcie_rc_ref_clk_buf_1/IBUF_OUT] \
      [get_bd_pins xdma_rp_1/sys_clk_gt]

  # PCIe RP #0 AXI clock
  connect_bd_net -net pcie_axi_clk [get_bd_pins xdma_rp_0/axi_aclk] \
				[get_bd_pins axi_ic_pcie_rc_dma/S00_ACLK] \
				[get_bd_pins axi_ic_pcie_rc_bar/M00_ACLK] \
				[get_bd_pins axi_ic_mmio/M00_ACLK]

  # PCIe RP #1 AXI clock
  connect_bd_net -net pcie_axi_clk1 [get_bd_pins xdma_rp_1/axi_aclk] \
				[get_bd_pins axi_ic_pcie_rc_dma/S01_ACLK] \
				[get_bd_pins axi_ic_pcie_rc_bar/M01_ACLK] \
				[get_bd_pins axi_ic_mmio/M01_ACLK]

  # MPSoC pl_clk1 for PCIe RC S_AXI and M_AXI related interfaces
  connect_bd_net -net pl_clk1_out [get_bd_pins zynq_mpsoc/pl_clk1] \
				[get_bd_pins axi_ic_pcie_rc_dma/ACLK] \
				[get_bd_pins axi_ic_pcie_rc_dma/M00_ACLK] \
				[get_bd_pins axi_ic_pcie_rc_bar/ACLK] \
				[get_bd_pins axi_ic_pcie_rc_bar/S00_ACLK] \
				[get_bd_pins zynq_mpsoc/maxihpm0_fpd_aclk] \
				[get_bd_pins zynq_mpsoc/saxihp0_fpd_aclk]

 
#=============================================
# System reset connection
#=============================================

  # System reset for AXI PCIe RC bridge
  connect_bd_net -net pl_resetn0 [get_bd_pins zynq_mpsoc/pl_resetn0] \
				[get_bd_pins xdma_rp_0/sys_rst_n] \
				[get_bd_pins xdma_rp_1/sys_rst_n] \
				[get_bd_pins pl_clk_sys_reset/ext_reset_in]

  # Reset for AXI interface of PCIe RP #0
  connect_bd_net -net pcie_rp_0_axi_aresetn [get_bd_pins xdma_rp_0/axi_aresetn] \
				[get_bd_pins axi_ic_pcie_rc_dma/S00_ARESETN] \
				[get_bd_pins axi_ic_pcie_rc_bar/M00_ARESETN] 

  connect_bd_net -net pcie_rp_0_axi_ctl_aresetn [get_bd_pins xdma_rp_0/axi_ctl_aresetn] \
				[get_bd_pins axi_ic_mmio/M00_ARESETN] \
				[get_bd_pins dcm_locked_gen/Op1]

  # Reset for AXI interface of PCIe RP #1
  connect_bd_net -net pcie_rp_1_axi_aresetn [get_bd_pins xdma_rp_1/axi_aresetn] \
				[get_bd_pins axi_ic_pcie_rc_dma/S01_ARESETN] \
				[get_bd_pins axi_ic_pcie_rc_bar/M01_ARESETN] 

  connect_bd_net -net pcie_rp_1_axi_ctl_aresetn [get_bd_pins xdma_rp_1/axi_ctl_aresetn] \
				[get_bd_pins axi_ic_mmio/M01_ARESETN] \
				[get_bd_pins dcm_locked_gen/Op2]

  # Reset for AXI MMIO IC
  connect_bd_net [get_bd_pins dcm_locked_gen/Res] \
        [get_bd_pins pl_clk_sys_reset/dcm_locked]

  
#=============================================
# AXI interface connection
#=============================================

  # MPSoC HPM0_FPD 
  connect_bd_intf_net -intf_net HPM0_FPD [get_bd_intf_pins zynq_mpsoc/M_AXI_HPM0_FPD] \
				[get_bd_intf_pins axi_ic_pcie_rc_bar/S00_AXI]

  connect_bd_intf_net -intf_net PCIE_RP_0_BAR [get_bd_intf_pins xdma_rp_0/S_AXI_B] \
				[get_bd_intf_pins axi_ic_pcie_rc_bar/M00_AXI]

  connect_bd_intf_net -intf_net PCIE_RP_1_BAR [get_bd_intf_pins xdma_rp_1/S_AXI_B] \
				[get_bd_intf_pins axi_ic_pcie_rc_bar/M01_AXI]

  # MPSoC HPM0_LPD
  connect_bd_intf_net -intf_net HPM0_LPD [get_bd_intf_pins zynq_mpsoc/M_AXI_HPM0_LPD] \
				[get_bd_intf_pins axi_ic_mmio/S00_AXI]

  connect_bd_intf_net -intf_net PCIE_RP_0_MMIO [get_bd_intf_pins xdma_rp_0/S_AXI_LITE] \
				[get_bd_intf_pins axi_ic_mmio/M00_AXI]

  connect_bd_intf_net -intf_net PCIE_RP_1_MMIO [get_bd_intf_pins xdma_rp_1/S_AXI_LITE] \
				[get_bd_intf_pins axi_ic_mmio/M01_AXI]

  connect_bd_net [get_bd_pins axi_ic_mmio/M01_AXI_araddr] [get_bd_pins xlconcat_0/In0]
  connect_bd_net [get_bd_pins axi_ic_mmio/M01_AXI_awaddr] [get_bd_pins xlconcat_1/In0]

  connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins xdma_rp_1/s_axil_araddr]
  connect_bd_net [get_bd_pins xlconcat_1/dout] [get_bd_pins xdma_rp_1/s_axil_awaddr]

  # MPSoC HP0_FPD
  connect_bd_intf_net -intf_net HP0_FPD [get_bd_intf_pins zynq_mpsoc/S_AXI_HP0_FPD] \
				[get_bd_intf_pins axi_ic_pcie_rc_dma/M00_AXI]

  connect_bd_intf_net -intf_net PCIE_RP_0_DMA [get_bd_intf_pins xdma_rp_0/M_AXI_B] \
				[get_bd_intf_pins axi_ic_pcie_rc_dma/S00_AXI]

  connect_bd_intf_net -intf_net PCIE_RP_1_DMA [get_bd_intf_pins xdma_rp_1/M_AXI_B] \
				[get_bd_intf_pins axi_ic_pcie_rc_dma/S01_AXI]

#==============================================
# GT Port connection
#==============================================

  # PCIe #0 slot
  connect_bd_net [get_bd_ports pcie_exp_rxn_0] [get_bd_pins xdma_rp_0/pci_exp_rxn]
  connect_bd_net [get_bd_ports pcie_exp_rxp_0] [get_bd_pins xdma_rp_0/pci_exp_rxp]
  connect_bd_net [get_bd_ports pcie_exp_txn_0] [get_bd_pins xdma_rp_0/pci_exp_txn]
  connect_bd_net [get_bd_ports pcie_exp_txp_0] [get_bd_pins xdma_rp_0/pci_exp_txp]

  # PCIe #1 slot
  connect_bd_net [get_bd_ports pcie_exp_rxn_1] [get_bd_pins xdma_rp_1/pci_exp_rxn]
  connect_bd_net [get_bd_ports pcie_exp_rxp_1] [get_bd_pins xdma_rp_1/pci_exp_rxp]
  connect_bd_net [get_bd_ports pcie_exp_txn_1] [get_bd_pins xdma_rp_1/pci_exp_txn]
  connect_bd_net [get_bd_ports pcie_exp_txp_1] [get_bd_pins xdma_rp_1/pci_exp_txp]

#=============================================
# Interrupt signal connection
#=============================================

  # Create instance: concat_intr, and set properties
  set concat_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_intr ]
  set_property -dict [ list CONFIG.NUM_PORTS {6} ] $concat_intr
	  
  connect_bd_net [get_bd_pins xdma_rp_0/interrupt_out] [get_bd_pins concat_intr/In0]
  connect_bd_net [get_bd_pins xdma_rp_0/interrupt_out_msi_vec0to31] [get_bd_pins concat_intr/In1]
  connect_bd_net [get_bd_pins xdma_rp_0/interrupt_out_msi_vec32to63] [get_bd_pins concat_intr/In2]
  connect_bd_net [get_bd_pins xdma_rp_1/interrupt_out] [get_bd_pins concat_intr/In3]
  connect_bd_net [get_bd_pins xdma_rp_1/interrupt_out_msi_vec0to31] [get_bd_pins concat_intr/In4]
  connect_bd_net [get_bd_pins xdma_rp_1/interrupt_out_msi_vec32to63] [get_bd_pins concat_intr/In5]
  connect_bd_net [get_bd_pins concat_intr/dout] [get_bd_pins zynq_mpsoc/pl_ps_irq0]

#=============================================
# MISC port connection
#=============================================

  connect_bd_net [get_bd_ports pcie_rc_user_link_up_0] [get_bd_pins xdma_rp_0/user_lnk_up]
  connect_bd_net [get_bd_ports pcie_rc_user_link_up_1] [get_bd_pins xdma_rp_1/user_lnk_up]

#=============================================
# Address segments
#=============================================
  
  # AXI PCIe RP #0 M_AXI
  create_bd_addr_seg -range 0x80000000 -offset 0x0 [get_bd_addr_spaces xdma_rp_0/M_AXI_B] [get_bd_addr_segs zynq_mpsoc/SAXIGP2/HP0_DDR_LOW] HP0_DDR_LOW_0
  create_bd_addr_seg -range 0x400000000 -offset 0x800000000 [get_bd_addr_spaces xdma_rp_0/M_AXI_B] [get_bd_addr_segs zynq_mpsoc/SAXIGP2/HP0_DDR_HIGH] HP0_DDR_HIGH_0

  # AXI PCIe RP #1 M_AXI
  create_bd_addr_seg -range 0x80000000 -offset 0x0 [get_bd_addr_spaces xdma_rp_1/M_AXI_B] [get_bd_addr_segs zynq_mpsoc/SAXIGP2/HP0_DDR_LOW] HP0_DDR_LOW_1
  create_bd_addr_seg -range 0x400000000 -offset 0x800000000 [get_bd_addr_spaces xdma_rp_1/M_AXI_B] [get_bd_addr_segs zynq_mpsoc/SAXIGP2/HP0_DDR_HIGH] HP0_DDR_HIGH_1

  # Zynq MPSoC
  create_bd_addr_seg -range 0x800000 -offset 0x80000000 [get_bd_addr_spaces zynq_mpsoc/Data] [get_bd_addr_segs xdma_rp_0/S_AXI_LITE/CTL0] PCIE_RC_CTL_0
  create_bd_addr_seg -range 0x800000 -offset 0x80800000 [get_bd_addr_spaces zynq_mpsoc/Data] [get_bd_addr_segs xdma_rp_1/S_AXI_LITE/CTL0] PCIE_RC_CTL_1

  create_bd_addr_seg -range 0x00100000 -offset 0xA0000000 [get_bd_addr_spaces zynq_mpsoc/Data] [get_bd_addr_segs xdma_rp_0/S_AXI_B/BAR0] PCIE_RC_BAR0_0
  create_bd_addr_seg -range 0x00100000 -offset 0xA0100000 [get_bd_addr_spaces zynq_mpsoc/Data] [get_bd_addr_segs xdma_rp_1/S_AXI_B/BAR0] PCIE_RC_BAR0_1


# ddr mig
  # Create interface ports
  set C0_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK ]
  set c0_init_calib_complete [ create_bd_port -dir O c0_init_calib_complete ]
  set ddr4_rtl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl ]

  # Create instance: axi_ic_ddr4_mig, and set properties
  set axi_ic_ddr4_mig [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ddr4_mig ]
  set_property -dict [ list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {5} \
  ] $axi_ic_ddr4_mig

  # Create instance: xlconstant_0, and set properties
  set xlconstant_mig_sys_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_mig_sys_rst ]
  set_property -dict [ list \
    CONFIG.CONST_VAL {0} \
  ] $xlconstant_mig_sys_rst

  # Create instance: ddr4_0, and set properties
  set ddr4_mig [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_mig ]
  set_property -dict [ list \
      CONFIG.C0.CKE_WIDTH {2} \
      CONFIG.C0.CK_WIDTH {2} \
      CONFIG.C0.CS_WIDTH {2} \
      CONFIG.C0.DDR4_AxiAddressWidth {34} \
      CONFIG.C0.DDR4_AxiDataWidth {64} \
      CONFIG.C0.DDR4_CLKOUT0_DIVIDE {7} \
      CONFIG.C0.DDR4_CasLatency {12} \
      CONFIG.C0.DDR4_CasWriteLatency {11} \
      CONFIG.C0.DDR4_DataMask {DM_NO_DBI} \
      CONFIG.C0.DDR4_DataWidth {64} \
      CONFIG.C0.DDR4_Ecc {false} \
      CONFIG.C0.DDR4_InputClockPeriod {10000} \
      CONFIG.C0.DDR4_MemoryPart {MTA16ATF2G64HZ-2G3} \
      CONFIG.C0.DDR4_MemoryType {SODIMMs} \
      CONFIG.C0.DDR4_Slot {Single} \
      CONFIG.C0.DDR4_TimePeriod {1250} \
      CONFIG.C0.ODT_WIDTH {2} \
  ] $ddr4_mig

  # Create instance: rst_ddr4_0_200M, and set properties
  set rst_ddr4_0_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_200M ]

# pr-shell interface
  #4 pr ddr axi4 interface(AXI4-M)
  set i 0
  while {$i < 4} {
    set axi4_ddr$i [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi4_ddr$i ]
    set_property -dict [ list CONFIG.ADDR_WIDTH {34} \
      CONFIG.PROTOCOL {AXI4} \
    ] [get_bd_intf_ports axi4_ddr$i]
    incr i 1
  }

  #4 pr uartlite axilite interface(AXILite-M)
  set i 0
  while {$i < 4} {
    set cpu_axi_uart$i [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cpu_axi_uart$i ]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4LITE} \
    ] [get_bd_intf_ports cpu_axi_uart${i}]
    incr i 1
  }

  #4 pr AXI4 MMIO interface(AXILite-S)
  set i 0
  while {$i < 4} {
    set mips_cpu_axi_mmio$i [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 mips_cpu_axi_mmio$i ]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4LITE} ] [get_bd_intf_ports mips_cpu_axi_mmio$i]
    incr i 1
  }

  #4 pr reset and clk
  set i 0
  while {$i < 4} {
      set ps_user_resetn$i [ create_bd_port -dir O -type rst ps_user_resetn$i ]
      set ps_fclk_clk$i [ create_bd_port -dir O -type clk ps_fclk_clk$i ]
      set_property -dict [ list \
        CONFIG.ASSOCIATED_BUSIF  mips_cpu_axi_mmio${i}:axi4_ddr${i}:cpu_axi_uart${i}  \
        CONFIG.ASSOCIATED_RESET  ps_user_resetn${i} \
      ] [get_bd_ports ps_fclk_clk$i]
      incr i 1
  }

  # 4 ps axi uartlite and 4 pr axi uartlite
  set i 0
  while {$i < 8} {
      set axi_uartlite_$i [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_$i ]
      set_property -dict [ list CONFIG.C_BAUDRATE {115200} ] [get_bd_cells axi_uartlite_$i]
      incr i 1
  }

# ps uartlite0~3 interrupt
  set concat_intr_uartlite [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_intr_uartlite ]
  set_property -dict [ list CONFIG.NUM_PORTS {4} ] $concat_intr_uartlite

  set i 0
  while {$i < 4} {
  connect_bd_net -net axi_uartlite_${i}_interrupt [get_bd_pins axi_uartlite_${i}/interrupt] \
      [get_bd_pins concat_intr_uartlite/In${i}]
      incr i 1
  }

  # Create instance: debug_bridge_mpsoc, and set properties
  set debug_bridge_mpsoc [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_mpsoc ]
  set_property -dict [ list CONFIG.C_DEBUG_MODE {2} \
    CONFIG.C_TCK_CLOCK_RATIO {2} \
  ] $debug_bridge_mpsoc

  source [get_property REPOSITORY \
      [get_ipdefs  *pr_decoupler:1.0]]/xilinx/pr_decoupler_v1_0/tcl/api.tcl -notrace

  # 4 pr_decoupler
  set i 0
  while {$i < 4} {
      set pr_decoupler_${i} [ create_bd_cell -type ip -vlnv xilinx.com:ip:pr_decoupler:1.0 pr_decoupler_${i} ]
      set_property -dict [ list \
        CONFIG.ALL_PARAMS { HAS_AXI_LITE 1 HAS_SIGNAL_CONTROL 0 HAS_SIGNAL_STATUS 0 \
        INTF {AXI_pr2shell {ID 1 VLNV xilinx.com:interface:aximm_rtl:1.0 SIGNALS {  AWLOCK {PRESENT 0} AWCACHE {PRESENT 0} AWPROT {PRESENT 0} AWREGION {PRESENT 0} AWQOS {PRESENT 0} ARLOCK {PRESENT 0} ARCACHE {PRESENT 0} ARPROT {PRESENT 0} ARREGION {PRESENT 0} ARQOS {PRESENT 0}}} resetn {ID 0 VLNV xilinx.com:signal:reset_rtl:1.0 MODE slave } AXI_shell2pr {ID 2 VLNV xilinx.com:interface:aximm_rtl:1.0 MODE slave PROTOCOL axi4lite SIGNALS { AWPROT {PRESENT 0} ARPROT {PRESENT 0 } AWREGION {PRESENT 0} AWQOS {PRESENT 0} ARREGION {PRESENT 0} ARQOS {PRESENT 0} }} ps_fclk {ID 3 VLNV xilinx.com:signal:clock_rtl:1.0 MODE slave} axilite_pr2shell {ID 4 VLNV xilinx.com:interface:aximm_rtl:1.0 PROTOCOL axi4lite SIGNALS { AWPROT {PRESENT 0} ARPROT {PRESENT 0 } AWREGION {PRESENT 0} AWQOS {PRESENT 0} ARREGION {PRESENT 0} ARQOS {PRESENT 0} }}}} \
        CONFIG.GUI_HAS_AXI_LITE {true} \
        CONFIG.GUI_HAS_SIGNAL_CONTROL {false} \
        CONFIG.GUI_HAS_SIGNAL_STATUS {false} \
      ] [ get_bd_cells pr_decoupler_${i} ]
      incr i 1
  }

  # uartlite intr connect
  connect_bd_net -net concat_intr_uartlite_dout [get_bd_pins concat_intr_uartlite/dout] \
      [get_bd_pins zynq_mpsoc/pl_ps_irq1]

  # ddr4 mig sys_rst set 0
  connect_bd_net -net xlconstant_mig_sys_rst_dout [get_bd_pins ddr4_mig/sys_rst] \
      [get_bd_pins xlconstant_mig_sys_rst/dout]
  # ddr mig c0_sys_clk
  connect_bd_intf_net -intf_net C0_SYS_CLK_1 [get_bd_intf_ports C0_SYS_CLK] \
      [get_bd_intf_pins ddr4_mig/C0_SYS_CLK]
  # ddr mig C0_DDR4
  connect_bd_intf_net -intf_net ddr4_mig_C0_DDR4 [get_bd_intf_ports ddr4_rtl] \
      [get_bd_intf_pins ddr4_mig/C0_DDR4]
  connect_bd_net -net ddr4_0_c0_init_calib_complete [get_bd_ports c0_init_calib_complete] \
       [get_bd_pins ddr4_mig/c0_init_calib_complete]
  connect_bd_net -net ddr4_mig_axi_reset [get_bd_pins ddr4_mig/c0_ddr4_aresetn] \
      [get_bd_pins rst_ddr4_0_200M/peripheral_aresetn]\
      [get_bd_pins axi_ic_ddr4_mig/S04_ARESETN] \
      [get_bd_pins axi_ic_ddr4_mig/M00_ARESETN] 
  connect_bd_net -net ddr4_mig_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_mig/c0_ddr4_ui_clk_sync_rst] \
      [get_bd_pins rst_ddr4_0_200M/ext_reset_in]

  #decoupler axi reg
  set i 0
  while {$i < 4} {
       set j [expr $i + 2]
      connect_bd_intf_net -intf_net axi_ic_mmio_M0${j}_AXI [get_bd_intf_pins axi_ic_mmio/M0${j}_AXI] \
          [get_bd_intf_pins pr_decoupler_${i}/s_axi_reg]
      incr i 1
  }
  
  #uartlite axi reg
  connect_bd_intf_net -intf_net axi_ic_mmio_M06_AXI [get_bd_intf_pins axi_ic_mmio/M06_AXI] \
      [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_mmio_M07_AXI [get_bd_intf_pins axi_ic_mmio/M07_AXI] \
      [get_bd_intf_pins axi_uartlite_1/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_mmio_M08_AXI [get_bd_intf_pins axi_ic_mmio/M08_AXI] \
      [get_bd_intf_pins axi_uartlite_2/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_mmio_M09_AXI [get_bd_intf_pins axi_ic_mmio/M09_AXI] \
      [get_bd_intf_pins axi_uartlite_3/S_AXI]

  # pr decouple to cpu axi mmio
  # uart decouple to shell axi reg
  # cpu_axi uart to decouple
  # pr axi4 ddr and decouple connect
  # pr axi mmio
  # ddr mig ic
  set i 0
  while {$i < 4} {
      set j [expr $i + 4]
      connect_bd_intf_net -intf_net pr_decoupler_${i}_rp_AXI_shell2pr [get_bd_intf_ports mips_cpu_axi_mmio${i}] \
          [get_bd_intf_pins pr_decoupler_${i}/rp_AXI_shell2pr]

      connect_bd_intf_net -intf_net pr_decoupler_${i}_s_axilite_pr2shell [get_bd_intf_pins axi_uartlite_${j}/S_AXI] \
          [get_bd_intf_pins pr_decoupler_${i}/s_axilite_pr2shell]
      
      connect_bd_intf_net -intf_net cpu_axi_uart${i}_1 [get_bd_intf_ports cpu_axi_uart${i}] \
          [get_bd_intf_pins pr_decoupler_${i}/rp_axilite_pr2shell]
      
      connect_bd_intf_net -intf_net axi4_ddr${i}_1 [get_bd_intf_ports axi4_ddr${i}] \
          [get_bd_intf_pins pr_decoupler_${i}/rp_AXI_pr2shell]

      connect_bd_intf_net -intf_net axi_ic_mmio_M1${i}_AXI [get_bd_intf_pins axi_ic_mmio/M1${i}_AXI] \
          [get_bd_intf_pins pr_decoupler_${i}/s_AXI_shell2pr]
      
      connect_bd_intf_net -intf_net S0${i}_AXI_1 [get_bd_intf_pins axi_ic_ddr4_mig/S0${i}_AXI] \
          [get_bd_intf_pins pr_decoupler_${i}/s_AXI_pr2shell]

      incr i 1
  }

  #debug core axi reg
  connect_bd_intf_net -intf_net axi_ic_mmio_M14_AXI [get_bd_intf_pins axi_ic_mmio/M14_AXI] \
      [get_bd_intf_pins debug_bridge_mpsoc/S_AXI]

  connect_bd_intf_net -intf_net S04_AXI_1 [get_bd_intf_pins axi_ic_ddr4_mig/S04_AXI] \
      [get_bd_intf_pins zynq_mpsoc/M_AXI_HPM1_FPD]
  connect_bd_intf_net -intf_net axi_ic_ddr4_mig_M00_AXI [get_bd_intf_pins axi_ic_ddr4_mig/M00_AXI] \
      [get_bd_intf_pins ddr4_mig/C0_DDR4_S_AXI]

  # uart rx to tx,tx to rx
  set i 0
  while {$i < 4} {
      set j [expr $i + 4]
      connect_bd_net -net axi_uartlite_${i}_tx [get_bd_pins axi_uartlite_${i}/tx] \
          [get_bd_pins axi_uartlite_${j}/rx]
      connect_bd_net -net axi_uartlite_${j}_tx [get_bd_pins axi_uartlite_${i}/rx] \
          [get_bd_pins axi_uartlite_${j}/tx]
      incr i 1
  }

  set i 0
  while {$i < 4} {
      connect_bd_net -net pr_decoupler_${i}_rp_ps_fclk_CLK [get_bd_ports ps_fclk_clk${i}] \
          [get_bd_pins pr_decoupler_${i}/rp_ps_fclk_CLK]
      connect_bd_net -net pr_decoupler_${i}_rp_resetn_RST [get_bd_ports ps_user_resetn${i}] \
          [get_bd_pins pr_decoupler_${i}/rp_resetn_RST]
      incr i 1
  }

  # MMIO AXI IC clock
  connect_bd_net -net zynq_mpsoc_pl_clk0    [get_bd_pins zynq_mpsoc/pl_clk0] \
      [get_bd_pins axi_ic_ddr4_mig/ACLK] \
      [get_bd_pins axi_ic_ddr4_mig/S00_ACLK] \
      [get_bd_pins axi_ic_ddr4_mig/S01_ACLK] \
      [get_bd_pins axi_ic_ddr4_mig/S02_ACLK] \
      [get_bd_pins axi_ic_ddr4_mig/S03_ACLK] \
      [get_bd_pins axi_ic_mmio/ACLK] \
      [get_bd_pins axi_ic_mmio/M02_ACLK] \
      [get_bd_pins axi_ic_mmio/M03_ACLK] \
      [get_bd_pins axi_ic_mmio/M04_ACLK] \
      [get_bd_pins axi_ic_mmio/M05_ACLK] \
      [get_bd_pins axi_ic_mmio/M06_ACLK] \
      [get_bd_pins axi_ic_mmio/M07_ACLK] \
      [get_bd_pins axi_ic_mmio/M08_ACLK] \
      [get_bd_pins axi_ic_mmio/M09_ACLK] \
      [get_bd_pins axi_ic_mmio/M10_ACLK] \
      [get_bd_pins axi_ic_mmio/M11_ACLK] \
      [get_bd_pins axi_ic_mmio/M12_ACLK] \
      [get_bd_pins axi_ic_mmio/M13_ACLK] \
      [get_bd_pins axi_ic_mmio/M14_ACLK] \
      [get_bd_pins axi_ic_mmio/S00_ACLK] \
      [get_bd_pins axi_uartlite_0/s_axi_aclk] \
      [get_bd_pins axi_uartlite_1/s_axi_aclk] \
      [get_bd_pins axi_uartlite_2/s_axi_aclk] \
      [get_bd_pins axi_uartlite_3/s_axi_aclk] \
      [get_bd_pins axi_uartlite_4/s_axi_aclk] \
      [get_bd_pins axi_uartlite_5/s_axi_aclk] \
      [get_bd_pins axi_uartlite_6/s_axi_aclk] \
      [get_bd_pins axi_uartlite_7/s_axi_aclk] \
      [get_bd_pins debug_bridge_mpsoc/s_axi_aclk] \
      [get_bd_pins pl_clk_sys_reset/slowest_sync_clk] \
      [get_bd_pins pr_decoupler_0/aclk] \
      [get_bd_pins pr_decoupler_0/s_ps_fclk_CLK] \
      [get_bd_pins pr_decoupler_1/aclk] \
      [get_bd_pins pr_decoupler_1/s_ps_fclk_CLK] \
      [get_bd_pins pr_decoupler_2/aclk] \
      [get_bd_pins pr_decoupler_2/s_ps_fclk_CLK] \
      [get_bd_pins pr_decoupler_3/aclk] \
      [get_bd_pins pr_decoupler_3/s_ps_fclk_CLK] \
      [get_bd_pins zynq_mpsoc/maxihpm0_lpd_aclk] 

  connect_bd_net -net Net [get_bd_pins axi_ic_ddr4_mig/M00_ACLK] \
      [get_bd_pins axi_ic_ddr4_mig/S04_ACLK] \
      [get_bd_pins ddr4_mig/c0_ddr4_ui_clk] \
      [get_bd_pins rst_ddr4_0_200M/slowest_sync_clk] \
      [get_bd_pins zynq_mpsoc/maxihpm1_fpd_aclk]

  connect_bd_net -net axi_dma_ic_reset [get_bd_pins pl_clk_sys_reset/interconnect_aresetn] \
				[get_bd_pins axi_ic_pcie_rc_dma/ARESETN] \
				[get_bd_pins axi_ic_mmio/ARESETN] \
				[get_bd_pins axi_ic_pcie_rc_bar/ARESETN] \

  connect_bd_net -net axi_mmio_ic_reset_n [get_bd_ports pcie_rc_perstn_0] \
	[get_bd_ports pcie_rc_perstn_1] \
	[get_bd_pins axi_ic_pcie_rc_bar/S00_ARESETN] \
	[get_bd_pins axi_ic_pcie_rc_dma/M00_ARESETN] \
	[get_bd_pins axi_ic_ddr4_mig/ARESETN] \
	[get_bd_pins axi_ic_ddr4_mig/S00_ARESETN] \
	[get_bd_pins axi_ic_ddr4_mig/S01_ARESETN] \
	[get_bd_pins axi_ic_ddr4_mig/S02_ARESETN] \
	[get_bd_pins axi_ic_ddr4_mig/S03_ARESETN] \
	[get_bd_pins axi_ic_mmio/M02_ARESETN] \
	[get_bd_pins axi_ic_mmio/M03_ARESETN] \
	[get_bd_pins axi_ic_mmio/M04_ARESETN] \
	[get_bd_pins axi_ic_mmio/M05_ARESETN] \
	[get_bd_pins axi_ic_mmio/M06_ARESETN] \
	[get_bd_pins axi_ic_mmio/M07_ARESETN] \
	[get_bd_pins axi_ic_mmio/M08_ARESETN] \
	[get_bd_pins axi_ic_mmio/M09_ARESETN] \
	[get_bd_pins axi_ic_mmio/M10_ARESETN] \
	[get_bd_pins axi_ic_mmio/M11_ARESETN] \
	[get_bd_pins axi_ic_mmio/M12_ARESETN] \
	[get_bd_pins axi_ic_mmio/M13_ARESETN] \
	[get_bd_pins axi_ic_mmio/M14_ARESETN] \
	[get_bd_pins axi_ic_mmio/S00_ARESETN] \
	[get_bd_pins axi_uartlite_0/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_1/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_2/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_3/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_4/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_5/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_6/s_axi_aresetn] \
	[get_bd_pins axi_uartlite_7/s_axi_aresetn] \
	[get_bd_pins debug_bridge_mpsoc/s_axi_aresetn] \
	[get_bd_pins pl_clk_sys_reset/peripheral_aresetn] \
	[get_bd_pins pr_decoupler_0/s_axi_reg_aresetn] \
	[get_bd_pins pr_decoupler_0/s_resetn_RST] \
	[get_bd_pins pr_decoupler_1/s_axi_reg_aresetn] \
	[get_bd_pins pr_decoupler_1/s_resetn_RST] \
	[get_bd_pins pr_decoupler_2/s_axi_reg_aresetn] \
	[get_bd_pins pr_decoupler_2/s_resetn_RST] \
	[get_bd_pins pr_decoupler_3/s_axi_reg_aresetn] \
	[get_bd_pins pr_decoupler_3/s_resetn_RST]


#=============================================
# Address segments
#=============================================
  #set uartlite 0~3 address seg
  set i 0
  set addr_base 0x81040000
  while {$i < 4} {
      set addr [expr $addr_base + 0x1000]
      create_bd_addr_seg -range 0x00001000 -offset $addr_base [get_bd_addr_spaces zynq_mpsoc/Data] \
          [get_bd_addr_segs axi_uartlite_${i}/S_AXI/Reg] SEG_axi_uartlite_${i}_Reg
      incr i 1
      set addr_base $addr
  }

  #set uartlite 4~7 address seg
  set i 0
  set addr_base 0x80000000
  while {$i < 4} {
      set addr [expr $addr_base + 0x1000]
      set j [expr $i + 4]
      create_bd_addr_seg -range 0x00001000 -offset $addr_base [get_bd_addr_spaces cpu_axi_uart${i}] \
          [get_bd_addr_segs axi_uartlite_${j}/S_AXI/Reg] SEG_axi_uartlite_${j}_Reg
      incr i 1
      set addr_base $addr
  }
  
  #ddr 16GB
  create_bd_addr_seg -range 0x000400000000 -offset 0x004800000000 [get_bd_addr_spaces zynq_mpsoc/Data] \
      [get_bd_addr_segs ddr4_mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_mig_C0_DDR4_ADDRESS_BLOCK

  #cpu mmio 16MB*4
  set i 0
  set addr_base 0x90000000
  while {$i < 4} {
      set addr [expr $addr_base + 0x04000000]
      create_bd_addr_seg -range 0x04000000 -offset $addr_base [get_bd_addr_spaces zynq_mpsoc/Data] \
          [get_bd_addr_segs mips_cpu_axi_mmio${i}/Reg] SEG_mips_cpu_axi_mmio${i}_Reg
      incr i 1
      set addr_base $addr
  }

  #pr decouple 64 KB*4
  set i 0
  set addr_base 0x81000000
  while {$i < 4} {
      set addr [expr $addr_base + 0x00010000]
      create_bd_addr_seg -range 0x00010000 -offset $addr_base [get_bd_addr_spaces zynq_mpsoc/Data] \
          [get_bd_addr_segs pr_decoupler_${i}/s_axi_reg/Reg] SEG_pr_decoupler_${i}_Reg
      incr i 1
      set addr_base $addr
  }

  # debug core
  create_bd_addr_seg -range 0x00010000 -offset 0x81090000 [get_bd_addr_spaces zynq_mpsoc/Data] \
      [get_bd_addr_segs debug_bridge_mpsoc/S_AXI/Reg0] SEG_debug_bridge_mpsoc_Reg0

  #pr ddr 0~16GB
  set i 0
  set addr_base 0x00000000
  while {$i < 4} {
      set addr [expr $addr_base + 0x0]
      create_bd_addr_seg -range 0x000400000000 -offset $addr_base [get_bd_addr_spaces axi4_ddr${i}] \
      [get_bd_addr_segs ddr4_mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_mig_C0_DDR4_ADDRESS_BLOCK
      incr i 1
      set addr_base $addr
  }

#=============================================
# Finish BD creation 
#=============================================

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

