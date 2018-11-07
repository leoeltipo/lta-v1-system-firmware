
################################################################
# This is a generated script based on design: ublaze_subsystem
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ublaze_subsystem_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# adc_bits, vec2bit_5, gpio_leds_bits, packer_header_vec2bit, sequencer_bits, spi_ldo_mux, vec2bit_2, vec2bit_4, vec2bit_6

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a200tfbg484-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name ublaze_subsystem

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
fnal.gov:user:serial_io:1.0\
xilinx.com:ip:axi_intc:4.1\
fnal.gov:user:cds_noncausal:1.0\
xilinx.com:ip:util_ds_buf:2.1\
fnal.gov:user:eth_resync:1.0\
xilinx.com:ip:fit_timer:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:10.0\
fnal.gov:user:packer:1.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.0\
xilinx.com:ip:proc_sys_reset:5.0\
fnal.gov:user:sequencer:1.0\
fnal.gov:user:smart_buffer:1.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
adc_bits\
vec2bit_5\
gpio_leds_bits\
packer_header_vec2bit\
sequencer_bits\
spi_ldo_mux\
vec2bit_2\
vec2bit_4\
vec2bit_6\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: ublaze_mem
proc create_hier_cell_ublaze_mem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ublaze_mem() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]
  set_property -dict [ list \
   CONFIG.C_LMB_NUM_SLAVES {1} \
 ] $ilmb_v10

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_1_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_1_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_1_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

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


  # Create interface ports

  # Create ports
  set ADCA_2LANES [ create_bd_port -dir O -from 0 -to 0 ADCA_2LANES ]
  set ADCA_CNV_N [ create_bd_port -dir O -from 0 -to 0 ADCA_CNV_N ]
  set ADCA_CNV_P [ create_bd_port -dir O -from 0 -to 0 ADCA_CNV_P ]
  set ADCA_DATA_N [ create_bd_port -dir I -from 1 -to 0 ADCA_DATA_N ]
  set ADCA_DATA_P [ create_bd_port -dir I -from 1 -to 0 ADCA_DATA_P ]
  set ADCA_PD_N [ create_bd_port -dir O -from 0 -to 0 ADCA_PD_N ]
  set ADCA_TESTPAT [ create_bd_port -dir O -from 0 -to 0 ADCA_TESTPAT ]
  set ADCB_2LANES [ create_bd_port -dir O -from 0 -to 0 ADCB_2LANES ]
  set ADCB_CNV_N [ create_bd_port -dir O -from 0 -to 0 ADCB_CNV_N ]
  set ADCB_CNV_P [ create_bd_port -dir O -from 0 -to 0 ADCB_CNV_P ]
  set ADCB_DATA_N [ create_bd_port -dir I -from 1 -to 0 ADCB_DATA_N ]
  set ADCB_DATA_P [ create_bd_port -dir I -from 1 -to 0 ADCB_DATA_P ]
  set ADCB_PD_N [ create_bd_port -dir O -from 0 -to 0 ADCB_PD_N ]
  set ADCB_TESTPAT [ create_bd_port -dir O -from 0 -to 0 ADCB_TESTPAT ]
  set ADCC_2LANES [ create_bd_port -dir O -from 0 -to 0 ADCC_2LANES ]
  set ADCC_CNV_N [ create_bd_port -dir O -from 0 -to 0 ADCC_CNV_N ]
  set ADCC_CNV_P [ create_bd_port -dir O -from 0 -to 0 ADCC_CNV_P ]
  set ADCC_DATA_N [ create_bd_port -dir I -from 1 -to 0 ADCC_DATA_N ]
  set ADCC_DATA_P [ create_bd_port -dir I -from 1 -to 0 ADCC_DATA_P ]
  set ADCC_PD_N [ create_bd_port -dir O -from 0 -to 0 ADCC_PD_N ]
  set ADCC_TESTPAT [ create_bd_port -dir O -from 0 -to 0 ADCC_TESTPAT ]
  set ADCD_2LANES [ create_bd_port -dir O -from 0 -to 0 ADCD_2LANES ]
  set ADCD_CNV_N [ create_bd_port -dir O -from 0 -to 0 ADCD_CNV_N ]
  set ADCD_CNV_P [ create_bd_port -dir O -from 0 -to 0 ADCD_CNV_P ]
  set ADCD_DATA_N [ create_bd_port -dir I -from 1 -to 0 ADCD_DATA_N ]
  set ADCD_DATA_P [ create_bd_port -dir I -from 1 -to 0 ADCD_DATA_P ]
  set ADCD_PD_N [ create_bd_port -dir O -from 0 -to 0 ADCD_PD_N ]
  set ADCD_TESTPAT [ create_bd_port -dir O -from 0 -to 0 ADCD_TESTPAT ]
  set ADC_CLKA_N [ create_bd_port -dir O -from 0 -to 0 ADC_CLKA_N ]
  set ADC_CLKA_P [ create_bd_port -dir O -from 0 -to 0 ADC_CLKA_P ]
  set ADC_CLKB_N [ create_bd_port -dir O -from 0 -to 0 ADC_CLKB_N ]
  set ADC_CLKB_P [ create_bd_port -dir O -from 0 -to 0 ADC_CLKB_P ]
  set ADC_CLKC_N [ create_bd_port -dir O -from 0 -to 0 ADC_CLKC_N ]
  set ADC_CLKC_P [ create_bd_port -dir O -from 0 -to 0 ADC_CLKC_P ]
  set ADC_CLKD_N [ create_bd_port -dir O -from 0 -to 0 ADC_CLKD_N ]
  set ADC_CLKD_P [ create_bd_port -dir O -from 0 -to 0 ADC_CLKD_P ]
  set ANA_0 [ create_bd_port -dir O ANA_0 ]
  set ANA_1 [ create_bd_port -dir O ANA_1 ]
  set ANA_2 [ create_bd_port -dir O ANA_2 ]
  set ANA_3 [ create_bd_port -dir O ANA_3 ]
  set ANA_4 [ create_bd_port -dir O ANA_4 ]
  set ANA_5 [ create_bd_port -dir O ANA_5 ]
  set ANA_6 [ create_bd_port -dir O ANA_6 ]
  set ANA_7 [ create_bd_port -dir O ANA_7 ]
  set ANA_8 [ create_bd_port -dir O ANA_8 ]
  set ANA_9 [ create_bd_port -dir O ANA_9 ]
  set ANA_10 [ create_bd_port -dir O ANA_10 ]
  set ANA_11 [ create_bd_port -dir O ANA_11 ]
  set ANA_12 [ create_bd_port -dir O ANA_12 ]
  set ANA_13 [ create_bd_port -dir O ANA_13 ]
  set ANA_14 [ create_bd_port -dir O ANA_14 ]
  set ANA_15 [ create_bd_port -dir O ANA_15 ]
  set ANA_16 [ create_bd_port -dir O ANA_16 ]
  set CCD_VDD_DIGPOT_SDO [ create_bd_port -dir I CCD_VDD_DIGPOT_SDO ]
  set CCD_VDD_DIGPOT_SYNC_N [ create_bd_port -dir O CCD_VDD_DIGPOT_SYNC_N ]
  set CCD_VDD_EN [ create_bd_port -dir O CCD_VDD_EN ]
  set CCD_VDRAIN_DIGPOT_SDO [ create_bd_port -dir I CCD_VDRAIN_DIGPOT_SDO ]
  set CCD_VDRAIN_DIGPOT_SYNC_N [ create_bd_port -dir O CCD_VDRAIN_DIGPOT_SYNC_N ]
  set CCD_VR_DIGPOT_SDO [ create_bd_port -dir I CCD_VR_DIGPOT_SDO ]
  set CCD_VR_DIGPOT_SYNC_N [ create_bd_port -dir O CCD_VR_DIGPOT_SYNC_N ]
  set CCD_VR_EN [ create_bd_port -dir O CCD_VR_EN ]
  set CCD_VSUB_DIGPOT_SDO [ create_bd_port -dir I CCD_VSUB_DIGPOT_SDO ]
  set CCD_VSUB_DIGPOT_SYNC_N [ create_bd_port -dir O CCD_VSUB_DIGPOT_SYNC_N ]
  set CCD_VSUB_EN [ create_bd_port -dir O CCD_VSUB_EN ]
  set CDD_VDRAIN_EN [ create_bd_port -dir O CDD_VDRAIN_EN ]
  set DAC_CLR_N [ create_bd_port -dir O DAC_CLR_N ]
  set DAC_LDAC_N [ create_bd_port -dir O DAC_LDAC_N ]
  set DAC_RESET_N [ create_bd_port -dir O DAC_RESET_N ]
  set DAC_SCLK [ create_bd_port -dir O DAC_SCLK ]
  set DAC_SDI [ create_bd_port -dir O DAC_SDI ]
  set DAC_SDO [ create_bd_port -dir I DAC_SDO ]
  set DAC_SW_EN [ create_bd_port -dir O DAC_SW_EN ]
  set DAC_SYNC_N [ create_bd_port -dir O -from 0 -to 0 DAC_SYNC_N ]
  set DIGPOT_DIN [ create_bd_port -dir O DIGPOT_DIN ]
  set DIGPOT_RST_N [ create_bd_port -dir O DIGPOT_RST_N ]
  set DIGPOT_SCLK [ create_bd_port -dir O DIGPOT_SCLK ]
  set ENET_GTXCLK [ create_bd_port -dir O ENET_GTXCLK ]
  set ENET_RX0 [ create_bd_port -dir I ENET_RX0 ]
  set ENET_RX1 [ create_bd_port -dir I ENET_RX1 ]
  set ENET_RX2 [ create_bd_port -dir I ENET_RX2 ]
  set ENET_RX3 [ create_bd_port -dir I ENET_RX3 ]
  set ENET_RX4 [ create_bd_port -dir I ENET_RX4 ]
  set ENET_RX5 [ create_bd_port -dir I ENET_RX5 ]
  set ENET_RX6 [ create_bd_port -dir I ENET_RX6 ]
  set ENET_RX7 [ create_bd_port -dir I ENET_RX7 ]
  set ENET_RXCLK [ create_bd_port -dir I ENET_RXCLK ]
  set ENET_RXDV [ create_bd_port -dir I ENET_RXDV ]
  set ENET_TX0 [ create_bd_port -dir O ENET_TX0 ]
  set ENET_TX1 [ create_bd_port -dir O ENET_TX1 ]
  set ENET_TX2 [ create_bd_port -dir O ENET_TX2 ]
  set ENET_TX3 [ create_bd_port -dir O ENET_TX3 ]
  set ENET_TX4 [ create_bd_port -dir O ENET_TX4 ]
  set ENET_TX5 [ create_bd_port -dir O ENET_TX5 ]
  set ENET_TX6 [ create_bd_port -dir O ENET_TX6 ]
  set ENET_TX7 [ create_bd_port -dir O ENET_TX7 ]
  set ENET_TXEN [ create_bd_port -dir O ENET_TXEN ]
  set ENET_TXER [ create_bd_port -dir O ENET_TXER ]
  set LED0 [ create_bd_port -dir O LED0 ]
  set LED1 [ create_bd_port -dir O LED1 ]
  set LED2 [ create_bd_port -dir O LED2 ]
  set LED3 [ create_bd_port -dir O LED3 ]
  set LED4 [ create_bd_port -dir O LED4 ]
  set LED5 [ create_bd_port -dir O LED5 ]
  set SPARE_SW4 [ create_bd_port -dir I -type rst SPARE_SW4 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $SPARE_SW4
  set TEL_CS_N [ create_bd_port -dir O -from 0 -to 0 TEL_CS_N ]
  set TEL_DIN [ create_bd_port -dir O TEL_DIN ]
  set TEL_DOUT [ create_bd_port -dir I TEL_DOUT ]
  set TEL_MUXA0 [ create_bd_port -dir O TEL_MUXA0 ]
  set TEL_MUXA1 [ create_bd_port -dir O TEL_MUXA1 ]
  set TEL_MUXA2 [ create_bd_port -dir O TEL_MUXA2 ]
  set TEL_MUXEN0 [ create_bd_port -dir O TEL_MUXEN0 ]
  set TEL_MUXEN1 [ create_bd_port -dir O TEL_MUXEN1 ]
  set TEL_MUXEN2 [ create_bd_port -dir O TEL_MUXEN2 ]
  set TEL_SCLK [ create_bd_port -dir O TEL_SCLK ]
  set TGL_DG [ create_bd_port -dir O TGL_DG ]
  set TGL_H1A [ create_bd_port -dir O TGL_H1A ]
  set TGL_H1B [ create_bd_port -dir O TGL_H1B ]
  set TGL_H2A [ create_bd_port -dir O TGL_H2A ]
  set TGL_H2B [ create_bd_port -dir O TGL_H2B ]
  set TGL_H3A [ create_bd_port -dir O TGL_H3A ]
  set TGL_H3B [ create_bd_port -dir O TGL_H3B ]
  set TGL_OGA [ create_bd_port -dir O TGL_OGA ]
  set TGL_OGB [ create_bd_port -dir O TGL_OGB ]
  set TGL_RGA [ create_bd_port -dir O TGL_RGA ]
  set TGL_RGB [ create_bd_port -dir O TGL_RGB ]
  set TGL_SWA [ create_bd_port -dir O TGL_SWA ]
  set TGL_SWB [ create_bd_port -dir O TGL_SWB ]
  set TGL_TG [ create_bd_port -dir O TGL_TG ]
  set TGL_V1C [ create_bd_port -dir O TGL_V1C ]
  set TGL_V2C [ create_bd_port -dir O TGL_V2C ]
  set TGL_V3C [ create_bd_port -dir O TGL_V3C ]
  set USB_UART_RX [ create_bd_port -dir O USB_UART_RX ]
  set USB_UART_TX [ create_bd_port -dir I USB_UART_TX ]
  set USER_CLK [ create_bd_port -dir I -type clk USER_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $USER_CLK
  set VOLT_SW_CLK [ create_bd_port -dir O VOLT_SW_CLK ]
  set VOLT_SW_CLR [ create_bd_port -dir O VOLT_SW_CLR ]
  set VOLT_SW_DIN [ create_bd_port -dir O VOLT_SW_DIN ]
  set VOLT_SW_DOUT [ create_bd_port -dir I VOLT_SW_DOUT ]
  set VOLT_SW_LE_N [ create_bd_port -dir O VOLT_SW_LE_N ]

  # Create instance: adc_a, and set properties
  set adc_a [ create_bd_cell -type ip -vlnv fnal.gov:user:serial_io:1.0 adc_a ]

  # Create instance: adc_b, and set properties
  set adc_b [ create_bd_cell -type ip -vlnv fnal.gov:user:serial_io:1.0 adc_b ]

  # Create instance: adc_bits_0, and set properties
  set block_name adc_bits
  set block_cell_name adc_bits_0
  if { [catch {set adc_bits_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $adc_bits_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: adc_c, and set properties
  set adc_c [ create_bd_cell -type ip -vlnv fnal.gov:user:serial_io:1.0 adc_c ]

  # Create instance: adc_d, and set properties
  set adc_d [ create_bd_cell -type ip -vlnv fnal.gov:user:serial_io:1.0 adc_d ]

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

  # Create instance: axi_periph, and set properties
  set axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {21} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_periph

  # Create instance: cds_core_a, and set properties
  set cds_core_a [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_a ]

  # Create instance: cds_core_b, and set properties
  set cds_core_b [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_b ]

  # Create instance: cds_core_c, and set properties
  set cds_core_c [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_c ]

  # Create instance: cds_core_d, and set properties
  set cds_core_d [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_d ]

  # Create instance: clk_buf, and set properties
  set clk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 clk_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $clk_buf

  # Create instance: eth, and set properties
  set eth [ create_bd_cell -type ip -vlnv fnal.gov:user:eth_resync:1.0 eth ]

  # Create instance: fit_timer_0, and set properties
  set fit_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer_0 ]
  set_property -dict [ list \
   CONFIG.C_NO_CLOCKS {100000} \
 ] $fit_timer_0

  # Create instance: gpio_adc, and set properties
  set gpio_adc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_adc ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {16} \
 ] $gpio_adc

  # Create instance: gpio_bits, and set properties
  set block_name vec2bit_5
  set block_cell_name gpio_bits
  if { [catch {set gpio_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_dac, and set properties
  set gpio_dac [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_dac ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $gpio_dac

  # Create instance: gpio_eth, and set properties
  set gpio_eth [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_eth ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
 ] $gpio_eth

  # Create instance: gpio_ldo, and set properties
  set gpio_ldo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_ldo ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {5} \
 ] $gpio_ldo

  # Create instance: gpio_leds_bits_0, and set properties
  set block_name gpio_leds_bits
  set block_cell_name gpio_leds_bits_0
  if { [catch {set gpio_leds_bits_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_leds_bits_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_telemetry, and set properties
  set gpio_telemetry [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_telemetry ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $gpio_telemetry

  # Create instance: gpio_volt_sw, and set properties
  set gpio_volt_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_volt_sw ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {2} \
 ] $gpio_volt_sw

  # Create instance: leds_gpio, and set properties
  set leds_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 leds_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $leds_gpio

  # Create instance: master_clock, and set properties
  set master_clock [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 master_clock ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {100.0} \
   CONFIG.CLKIN2_JITTER_PS {100.0} \
   CONFIG.CLKOUT1_JITTER {151.366} \
   CONFIG.CLKOUT1_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_JITTER {168.019} \
   CONFIG.CLKOUT2_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {60} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {132.221} \
   CONFIG.CLKOUT3_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {6} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIM_IN_FREQ {100} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.RESET_PORT {reset} \
   CONFIG.RESET_TYPE {ACTIVE_HIGH} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_INCLK_SWITCHOVER {false} \
 ] $master_clock

  # Create instance: mdm, and set properties
  set mdm [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm ]
  set_property -dict [ list \
   CONFIG.C_MB_DBG_PORTS {1} \
 ] $mdm

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ICACHE_BASEADDR {0x0000000000000000} \
   CONFIG.C_ICACHE_HIGHADDR {0x000000003FFFFFFF} \
   CONFIG.C_I_LMB {1} \
 ] $microblaze_0

  # Create instance: packer, and set properties
  set packer [ create_bd_cell -type ip -vlnv fnal.gov:user:packer:1.0 packer ]

  # Create instance: packer_header_vec2bit_0, and set properties
  set block_name packer_header_vec2bit
  set block_cell_name packer_header_vec2bit_0
  if { [catch {set packer_header_vec2bit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $packer_header_vec2bit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ram_eth, and set properties
  set ram_eth [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 ram_eth ]
  set_property -dict [ list \
   CONFIG.Byte_Size {8} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Read_Width_A {32} \
   CONFIG.Read_Width_B {32} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {true} \
   CONFIG.Use_RSTA_Pin {true} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.Write_Width_A {32} \
   CONFIG.Write_Width_B {32} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $ram_eth

  # Create instance: ram_eth_ctrl, and set properties
  set ram_eth_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 ram_eth_ctrl ]
  set_property -dict [ list \
   CONFIG.C_SELECT_XPM {0} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $ram_eth_ctrl

  # Create instance: reset_ctrl, and set properties
  set reset_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_ctrl ]

  # Create instance: sequencer, and set properties
  set sequencer [ create_bd_cell -type ip -vlnv fnal.gov:user:sequencer:1.0 sequencer ]

  # Create instance: sequencer_bits, and set properties
  set block_name sequencer_bits
  set block_cell_name sequencer_bits
  if { [catch {set sequencer_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sequencer_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: smart_buffer, and set properties
  set smart_buffer [ create_bd_cell -type ip -vlnv fnal.gov:user:smart_buffer:1.0 smart_buffer ]

  # Create instance: spi_dac, and set properties
  set spi_dac [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_dac ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
   CONFIG.Master_mode {1} \
 ] $spi_dac

  # Create instance: spi_ldo, and set properties
  set spi_ldo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_ldo ]
  set_property -dict [ list \
   CONFIG.C_NUM_SS_BITS {4} \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
   CONFIG.Master_mode {1} \
 ] $spi_ldo

  # Create instance: spi_ldo_mux, and set properties
  set block_name spi_ldo_mux
  set block_cell_name spi_ldo_mux
  if { [catch {set spi_ldo_mux [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $spi_ldo_mux eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: spi_telemetry, and set properties
  set spi_telemetry [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_telemetry ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
   CONFIG.Master_mode {1} \
 ] $spi_telemetry

  # Create instance: spi_volt_sw, and set properties
  set spi_volt_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_volt_sw ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
   CONFIG.Master_mode {1} \
 ] $spi_volt_sw

  # Create instance: uart, and set properties
  set uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 uart ]

  # Create instance: ublaze_mem
  create_hier_cell_ublaze_mem [current_bd_instance .] ublaze_mem

  # Create instance: vec2bit_2_0, and set properties
  set block_name vec2bit_2
  set block_cell_name vec2bit_2_0
  if { [catch {set vec2bit_2_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $vec2bit_2_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: vec2bit_4_0, and set properties
  set block_name vec2bit_4
  set block_cell_name vec2bit_4_0
  if { [catch {set vec2bit_4_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $vec2bit_4_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: vec2bit_6_0, and set properties
  set block_name vec2bit_6
  set block_cell_name vec2bit_6_0
  if { [catch {set vec2bit_6_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $vec2bit_6_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins ram_eth/BRAM_PORTA] [get_bd_intf_pins ram_eth_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net axi_periph_M03_AXI [get_bd_intf_pins axi_periph/M03_AXI] [get_bd_intf_pins gpio_ldo/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M09_AXI [get_bd_intf_pins axi_periph/M09_AXI] [get_bd_intf_pins sequencer/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M11_AXI [get_bd_intf_pins axi_periph/M11_AXI] [get_bd_intf_pins cds_core_a/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M12_AXI [get_bd_intf_pins axi_periph/M12_AXI] [get_bd_intf_pins gpio_adc/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M13_AXI [get_bd_intf_pins axi_periph/M13_AXI] [get_bd_intf_pins cds_core_b/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M14_AXI [get_bd_intf_pins axi_periph/M14_AXI] [get_bd_intf_pins cds_core_c/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M15_AXI [get_bd_intf_pins axi_periph/M15_AXI] [get_bd_intf_pins cds_core_d/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M16_AXI [get_bd_intf_pins axi_periph/M16_AXI] [get_bd_intf_pins packer/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M17_AXI [get_bd_intf_pins axi_periph/M17_AXI] [get_bd_intf_pins leds_gpio/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M18_AXI [get_bd_intf_pins axi_periph/M18_AXI] [get_bd_intf_pins smart_buffer/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M19_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins axi_periph/M19_AXI]
  connect_bd_intf_net -intf_net axi_periph_M20_AXI [get_bd_intf_pins axi_periph/M20_AXI] [get_bd_intf_pins gpio_eth/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins ublaze_mem/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins ublaze_mem/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_periph/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins axi_periph/M00_AXI] [get_bd_intf_pins spi_dac/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins axi_periph/M01_AXI] [get_bd_intf_pins gpio_dac/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins axi_periph/M02_AXI] [get_bd_intf_pins spi_ldo/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins axi_periph/M04_AXI] [get_bd_intf_pins spi_telemetry/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins axi_periph/M05_AXI] [get_bd_intf_pins gpio_telemetry/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins axi_periph/M06_AXI] [get_bd_intf_pins spi_volt_sw/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins axi_periph/M07_AXI] [get_bd_intf_pins gpio_volt_sw/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins axi_periph/M08_AXI] [get_bd_intf_pins uart/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins axi_periph/M10_AXI] [get_bd_intf_pins ram_eth_ctrl/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]

  # Create port connections
  connect_bd_net -net ADCA_DATA_N_1 [get_bd_ports ADCA_DATA_N] [get_bd_pins adc_a/din_n]
  connect_bd_net -net ADCA_DATA_P_1 [get_bd_ports ADCA_DATA_P] [get_bd_pins adc_a/din_p]
  connect_bd_net -net ADCB_DATA_N_1 [get_bd_ports ADCB_DATA_N] [get_bd_pins adc_b/din_n]
  connect_bd_net -net ADCB_DATA_P_1 [get_bd_ports ADCB_DATA_P] [get_bd_pins adc_b/din_p]
  connect_bd_net -net ADCC_DATA_N_1 [get_bd_ports ADCC_DATA_N] [get_bd_pins adc_c/din_n]
  connect_bd_net -net ADCC_DATA_P_1 [get_bd_ports ADCC_DATA_P] [get_bd_pins adc_c/din_p]
  connect_bd_net -net ADCD_DATA_N_1 [get_bd_ports ADCD_DATA_N] [get_bd_pins adc_d/din_n]
  connect_bd_net -net ADCD_DATA_P_1 [get_bd_ports ADCD_DATA_P] [get_bd_pins adc_d/din_p]
  connect_bd_net -net CCD_VDD_DIGPOT_SDO_1 [get_bd_ports CCD_VDD_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo1_in]
  connect_bd_net -net CCD_VDRAIN_DIGPOT_SDO_1 [get_bd_ports CCD_VDRAIN_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo0_in]
  connect_bd_net -net CCD_VR_DIGPOT_SDO_1 [get_bd_ports CCD_VR_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo2_in]
  connect_bd_net -net CCD_VSUB_DIGPOT_SDO_1 [get_bd_ports CCD_VSUB_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo3_in]
  connect_bd_net -net DAC_SDO_1 [get_bd_ports DAC_SDO] [get_bd_pins spi_dac/io1_i]
  connect_bd_net -net ENET_RX0_1 [get_bd_ports ENET_RX0] [get_bd_pins eth/ENET_RX0]
  connect_bd_net -net ENET_RX1_1 [get_bd_ports ENET_RX1] [get_bd_pins eth/ENET_RX1]
  connect_bd_net -net ENET_RX2_1 [get_bd_ports ENET_RX2] [get_bd_pins eth/ENET_RX2]
  connect_bd_net -net ENET_RX3_1 [get_bd_ports ENET_RX3] [get_bd_pins eth/ENET_RX3]
  connect_bd_net -net ENET_RX4_1 [get_bd_ports ENET_RX4] [get_bd_pins eth/ENET_RX4]
  connect_bd_net -net ENET_RX5_1 [get_bd_ports ENET_RX5] [get_bd_pins eth/ENET_RX5]
  connect_bd_net -net ENET_RX6_1 [get_bd_ports ENET_RX6] [get_bd_pins eth/ENET_RX6]
  connect_bd_net -net ENET_RX7_1 [get_bd_ports ENET_RX7] [get_bd_pins eth/ENET_RX7]
  connect_bd_net -net ENET_RXCLK_1 [get_bd_ports ENET_RXCLK] [get_bd_pins eth/ENET_RXCLK]
  connect_bd_net -net ENET_RXDV_1 [get_bd_ports ENET_RXDV] [get_bd_pins eth/ENET_RXDV]
  connect_bd_net -net Net [get_bd_pins adc_b/dout_strobe] [get_bd_pins cds_core_b/din_ready] [get_bd_pins packer/rready_b] [get_bd_pins smart_buffer/ready_in_b]
  connect_bd_net -net Net1 [get_bd_pins adc_b/dout] [get_bd_pins cds_core_b/din] [get_bd_pins packer/rdata_b] [get_bd_pins smart_buffer/data_in_b]
  connect_bd_net -net SPARE_SW4_1 [get_bd_ports SPARE_SW4] [get_bd_pins adc_a/reset] [get_bd_pins adc_b/reset] [get_bd_pins adc_c/reset] [get_bd_pins adc_d/reset] [get_bd_pins eth/rst] [get_bd_pins master_clock/reset] [get_bd_pins ram_eth/rstb] [get_bd_pins reset_ctrl/ext_reset_in]
  connect_bd_net -net TEL_DOUT_1 [get_bd_ports TEL_DOUT] [get_bd_pins spi_telemetry/io1_i]
  connect_bd_net -net USB_UART_TX_1 [get_bd_ports USB_UART_TX] [get_bd_pins uart/rx]
  connect_bd_net -net USER_CLK_1 [get_bd_ports USER_CLK] [get_bd_pins clk_buf/BUFG_I]
  connect_bd_net -net VOLT_SW_DOUT_1 [get_bd_ports VOLT_SW_DOUT] [get_bd_pins spi_volt_sw/io1_i]
  connect_bd_net -net adc_a_dout [get_bd_pins adc_a/dout] [get_bd_pins cds_core_a/din] [get_bd_pins packer/rdata_a] [get_bd_pins smart_buffer/data_in_a]
  connect_bd_net -net adc_a_dout_strobe [get_bd_pins adc_a/dout_strobe] [get_bd_pins cds_core_a/din_ready] [get_bd_pins packer/rready_a] [get_bd_pins smart_buffer/ready_in_a]
  connect_bd_net -net adc_bits_0_out0 [get_bd_pins adc_a/acquire] [get_bd_pins adc_bits_0/out0]
  connect_bd_net -net adc_bits_0_out1 [get_bd_ports ADCA_TESTPAT] [get_bd_pins adc_a/en_tst_ptrn] [get_bd_pins adc_bits_0/out1]
  connect_bd_net -net adc_bits_0_out2 [get_bd_pins adc_a/send_bitslip] [get_bd_pins adc_bits_0/out2]
  connect_bd_net -net adc_bits_0_out3 [get_bd_ports ADCA_PD_N] [get_bd_pins adc_bits_0/out3]
  connect_bd_net -net adc_bits_0_out4 [get_bd_pins adc_b/acquire] [get_bd_pins adc_bits_0/out4]
  connect_bd_net -net adc_bits_0_out5 [get_bd_ports ADCB_TESTPAT] [get_bd_pins adc_b/en_tst_ptrn] [get_bd_pins adc_bits_0/out5]
  connect_bd_net -net adc_bits_0_out6 [get_bd_pins adc_b/send_bitslip] [get_bd_pins adc_bits_0/out6]
  connect_bd_net -net adc_bits_0_out7 [get_bd_ports ADCB_PD_N] [get_bd_pins adc_bits_0/out7]
  connect_bd_net -net adc_bits_0_out8 [get_bd_pins adc_bits_0/out8] [get_bd_pins adc_c/acquire]
  connect_bd_net -net adc_bits_0_out9 [get_bd_ports ADCC_TESTPAT] [get_bd_pins adc_bits_0/out9] [get_bd_pins adc_c/en_tst_ptrn]
  connect_bd_net -net adc_bits_0_out10 [get_bd_pins adc_bits_0/out10] [get_bd_pins adc_c/send_bitslip]
  connect_bd_net -net adc_bits_0_out11 [get_bd_ports ADCC_PD_N] [get_bd_pins adc_bits_0/out11]
  connect_bd_net -net adc_bits_0_out12 [get_bd_pins adc_bits_0/out12] [get_bd_pins adc_d/acquire]
  connect_bd_net -net adc_bits_0_out13 [get_bd_ports ADCD_TESTPAT] [get_bd_pins adc_bits_0/out13] [get_bd_pins adc_d/en_tst_ptrn]
  connect_bd_net -net adc_bits_0_out14 [get_bd_pins adc_bits_0/out14] [get_bd_pins adc_d/send_bitslip]
  connect_bd_net -net adc_bits_0_out15 [get_bd_ports ADCD_PD_N] [get_bd_pins adc_bits_0/out15]
  connect_bd_net -net adc_c_dout [get_bd_pins adc_c/dout] [get_bd_pins cds_core_c/din] [get_bd_pins packer/rdata_c] [get_bd_pins smart_buffer/data_in_c]
  connect_bd_net -net adc_c_dout_strobe [get_bd_pins adc_c/dout_strobe] [get_bd_pins cds_core_c/din_ready] [get_bd_pins packer/rready_c] [get_bd_pins smart_buffer/ready_in_c]
  connect_bd_net -net adc_d_dout [get_bd_pins adc_d/dout] [get_bd_pins cds_core_d/din] [get_bd_pins packer/rdata_d] [get_bd_pins smart_buffer/data_in_d]
  connect_bd_net -net adc_d_dout_strobe [get_bd_pins adc_d/dout_strobe] [get_bd_pins cds_core_d/din_ready] [get_bd_pins packer/rready_d] [get_bd_pins smart_buffer/ready_in_d]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins eth/user_addr] [get_bd_pins gpio_eth/gpio_io_o]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_ports USB_UART_RX] [get_bd_pins uart/tx]
  connect_bd_net -net axis_clock_converter_0_s_axis_tready [get_bd_pins packer/dack] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins eth/data_in] [get_bd_pins ram_eth/doutb]
  connect_bd_net -net cds_core_a_dout [get_bd_pins cds_core_a/dout] [get_bd_pins packer/pdata_a]
  connect_bd_net -net cds_core_a_dout_ready [get_bd_pins cds_core_a/dout_ready] [get_bd_pins packer/pready_a]
  connect_bd_net -net cds_core_b_dout [get_bd_pins cds_core_b/dout] [get_bd_pins packer/pdata_b]
  connect_bd_net -net cds_core_b_dout_ready [get_bd_pins cds_core_b/dout_ready] [get_bd_pins packer/pready_b]
  connect_bd_net -net cds_core_c_dout [get_bd_pins cds_core_c/dout] [get_bd_pins packer/pdata_c]
  connect_bd_net -net cds_core_c_dout_ready [get_bd_pins cds_core_c/dout_ready] [get_bd_pins packer/pready_c]
  connect_bd_net -net cds_core_d_dout [get_bd_pins cds_core_d/dout] [get_bd_pins packer/pdata_d]
  connect_bd_net -net cds_core_d_dout_ready [get_bd_pins cds_core_d/dout_ready] [get_bd_pins packer/pready_d]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins master_clock/locked] [get_bd_pins reset_ctrl/dcm_locked]
  connect_bd_net -net eth_ENET_GTXCLK [get_bd_ports ENET_GTXCLK] [get_bd_pins eth/ENET_GTXCLK]
  connect_bd_net -net eth_ENET_TX0 [get_bd_ports ENET_TX0] [get_bd_pins eth/ENET_TX0]
  connect_bd_net -net eth_ENET_TX1 [get_bd_ports ENET_TX1] [get_bd_pins eth/ENET_TX1]
  connect_bd_net -net eth_ENET_TX2 [get_bd_ports ENET_TX2] [get_bd_pins eth/ENET_TX2]
  connect_bd_net -net eth_ENET_TX3 [get_bd_ports ENET_TX3] [get_bd_pins eth/ENET_TX3]
  connect_bd_net -net eth_ENET_TX4 [get_bd_ports ENET_TX4] [get_bd_pins eth/ENET_TX4]
  connect_bd_net -net eth_ENET_TX5 [get_bd_ports ENET_TX5] [get_bd_pins eth/ENET_TX5]
  connect_bd_net -net eth_ENET_TX6 [get_bd_ports ENET_TX6] [get_bd_pins eth/ENET_TX6]
  connect_bd_net -net eth_ENET_TX7 [get_bd_ports ENET_TX7] [get_bd_pins eth/ENET_TX7]
  connect_bd_net -net eth_ENET_TXEN [get_bd_ports ENET_TXEN] [get_bd_pins eth/ENET_TXEN]
  connect_bd_net -net eth_ENET_TXER [get_bd_ports ENET_TXER] [get_bd_pins eth/ENET_TXER]
  connect_bd_net -net eth_addr [get_bd_pins eth/addr] [get_bd_pins ram_eth/addrb]
  connect_bd_net -net eth_clk_125_out [get_bd_pins eth/clk_125_out] [get_bd_pins ram_eth/clkb]
  connect_bd_net -net eth_data_out [get_bd_pins eth/data_out] [get_bd_pins ram_eth/dinb]
  connect_bd_net -net eth_wren [get_bd_pins eth/wren] [get_bd_pins ram_eth/web]
  connect_bd_net -net fit_timer_0_Interrupt [get_bd_pins axi_intc_0/intr] [get_bd_pins fit_timer_0/Interrupt]
  connect_bd_net -net gpio_adc_gpio_io_o [get_bd_pins adc_bits_0/vec_in] [get_bd_pins gpio_adc/gpio_io_o]
  connect_bd_net -net gpio_bits_out0 [get_bd_ports CDD_VDRAIN_EN] [get_bd_pins gpio_bits/out0]
  connect_bd_net -net gpio_bits_out1 [get_bd_ports CCD_VDD_EN] [get_bd_pins gpio_bits/out1]
  connect_bd_net -net gpio_bits_out2 [get_bd_ports CCD_VR_EN] [get_bd_pins gpio_bits/out2]
  connect_bd_net -net gpio_bits_out3 [get_bd_ports CCD_VSUB_EN] [get_bd_pins gpio_bits/out3]
  connect_bd_net -net gpio_bits_out4 [get_bd_ports DIGPOT_RST_N] [get_bd_pins gpio_bits/out4]
  connect_bd_net -net gpio_dac_gpio_io_o [get_bd_pins gpio_dac/gpio_io_o] [get_bd_pins vec2bit_4_0/vec_in]
  connect_bd_net -net gpio_leds_bits_0_out0 [get_bd_ports LED0] [get_bd_pins gpio_leds_bits_0/out0]
  connect_bd_net -net gpio_leds_bits_0_out1 [get_bd_ports LED1] [get_bd_pins gpio_leds_bits_0/out1]
  connect_bd_net -net gpio_leds_bits_0_out2 [get_bd_ports LED2] [get_bd_pins gpio_leds_bits_0/out2]
  connect_bd_net -net gpio_leds_bits_0_out3 [get_bd_ports LED3] [get_bd_pins gpio_leds_bits_0/out3]
  connect_bd_net -net gpio_leds_bits_0_out4 [get_bd_ports LED4] [get_bd_pins gpio_leds_bits_0/out4]
  connect_bd_net -net gpio_leds_bits_0_out5 [get_bd_ports LED5] [get_bd_pins gpio_leds_bits_0/out5]
  connect_bd_net -net gpio_telemetry_gpio_io_o [get_bd_pins gpio_telemetry/gpio_io_o] [get_bd_pins vec2bit_6_0/vec_in]
  connect_bd_net -net gpio_volt_sw_gpio_io_o [get_bd_pins gpio_volt_sw/gpio_io_o] [get_bd_pins vec2bit_2_0/vec_in]
  connect_bd_net -net leds_gpio_gpio_io_o [get_bd_pins gpio_leds_bits_0/vec_in] [get_bd_pins leds_gpio/gpio_io_o]
  connect_bd_net -net master_clock_clk_out2 [get_bd_pins master_clock/clk_out2] [get_bd_pins spi_dac/ext_spi_clk] [get_bd_pins spi_ldo/ext_spi_clk] [get_bd_pins spi_telemetry/ext_spi_clk] [get_bd_pins spi_volt_sw/ext_spi_clk]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm/Debug_SYS_Rst] [get_bd_pins reset_ctrl/mb_debug_sys_rst]
  connect_bd_net -net microblaze_1_Clk [get_bd_pins adc_a/clk_100] [get_bd_pins adc_b/clk_100] [get_bd_pins adc_c/clk_100] [get_bd_pins adc_d/clk_100] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_periph/ACLK] [get_bd_pins axi_periph/M00_ACLK] [get_bd_pins axi_periph/M01_ACLK] [get_bd_pins axi_periph/M02_ACLK] [get_bd_pins axi_periph/M03_ACLK] [get_bd_pins axi_periph/M04_ACLK] [get_bd_pins axi_periph/M05_ACLK] [get_bd_pins axi_periph/M06_ACLK] [get_bd_pins axi_periph/M07_ACLK] [get_bd_pins axi_periph/M08_ACLK] [get_bd_pins axi_periph/M09_ACLK] [get_bd_pins axi_periph/M10_ACLK] [get_bd_pins axi_periph/M11_ACLK] [get_bd_pins axi_periph/M12_ACLK] [get_bd_pins axi_periph/M13_ACLK] [get_bd_pins axi_periph/M14_ACLK] [get_bd_pins axi_periph/M15_ACLK] [get_bd_pins axi_periph/M16_ACLK] [get_bd_pins axi_periph/M17_ACLK] [get_bd_pins axi_periph/M18_ACLK] [get_bd_pins axi_periph/M19_ACLK] [get_bd_pins axi_periph/M20_ACLK] [get_bd_pins axi_periph/S00_ACLK] [get_bd_pins cds_core_a/s00_axi_aclk] [get_bd_pins cds_core_b/s00_axi_aclk] [get_bd_pins cds_core_c/s00_axi_aclk] [get_bd_pins cds_core_d/s00_axi_aclk] [get_bd_pins fit_timer_0/Clk] [get_bd_pins gpio_adc/s_axi_aclk] [get_bd_pins gpio_dac/s_axi_aclk] [get_bd_pins gpio_eth/s_axi_aclk] [get_bd_pins gpio_ldo/s_axi_aclk] [get_bd_pins gpio_telemetry/s_axi_aclk] [get_bd_pins gpio_volt_sw/s_axi_aclk] [get_bd_pins leds_gpio/s_axi_aclk] [get_bd_pins master_clock/clk_out1] [get_bd_pins microblaze_0/Clk] [get_bd_pins packer/s00_axi_aclk] [get_bd_pins ram_eth_ctrl/s_axi_aclk] [get_bd_pins reset_ctrl/slowest_sync_clk] [get_bd_pins sequencer/s00_axi_aclk] [get_bd_pins smart_buffer/s00_axi_aclk] [get_bd_pins spi_dac/s_axi_aclk] [get_bd_pins spi_ldo/s_axi_aclk] [get_bd_pins spi_telemetry/s_axi_aclk] [get_bd_pins spi_volt_sw/s_axi_aclk] [get_bd_pins uart/s_axi_aclk] [get_bd_pins ublaze_mem/LMB_Clk]
  connect_bd_net -net packer_0_dout [get_bd_pins eth/b_data] [get_bd_pins packer/dout]
  connect_bd_net -net packer_0_dready [get_bd_pins eth/b_we] [get_bd_pins packer/dready]
  connect_bd_net -net packer_header_vec2bit_0_dout [get_bd_pins packer/header] [get_bd_pins packer_header_vec2bit_0/dout] [get_bd_pins smart_buffer/header]
  connect_bd_net -net reset_ctrl_peripheral_reset [get_bd_pins fit_timer_0/Rst] [get_bd_pins reset_ctrl/peripheral_reset]
  connect_bd_net -net rst_Clk_100M_bus_struct_reset [get_bd_pins reset_ctrl/bus_struct_reset] [get_bd_pins ublaze_mem/SYS_Rst]
  connect_bd_net -net rst_Clk_100M_interconnect_aresetn [get_bd_pins axi_periph/ARESETN] [get_bd_pins reset_ctrl/interconnect_aresetn]
  connect_bd_net -net rst_Clk_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins reset_ctrl/mb_reset]
  connect_bd_net -net rst_Clk_100M_peripheral_aresetn [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_periph/M00_ARESETN] [get_bd_pins axi_periph/M01_ARESETN] [get_bd_pins axi_periph/M02_ARESETN] [get_bd_pins axi_periph/M03_ARESETN] [get_bd_pins axi_periph/M04_ARESETN] [get_bd_pins axi_periph/M05_ARESETN] [get_bd_pins axi_periph/M06_ARESETN] [get_bd_pins axi_periph/M07_ARESETN] [get_bd_pins axi_periph/M08_ARESETN] [get_bd_pins axi_periph/M09_ARESETN] [get_bd_pins axi_periph/M10_ARESETN] [get_bd_pins axi_periph/M11_ARESETN] [get_bd_pins axi_periph/M12_ARESETN] [get_bd_pins axi_periph/M13_ARESETN] [get_bd_pins axi_periph/M14_ARESETN] [get_bd_pins axi_periph/M15_ARESETN] [get_bd_pins axi_periph/M16_ARESETN] [get_bd_pins axi_periph/M17_ARESETN] [get_bd_pins axi_periph/M18_ARESETN] [get_bd_pins axi_periph/M19_ARESETN] [get_bd_pins axi_periph/M20_ARESETN] [get_bd_pins axi_periph/S00_ARESETN] [get_bd_pins cds_core_a/s00_axi_aresetn] [get_bd_pins cds_core_b/s00_axi_aresetn] [get_bd_pins cds_core_c/s00_axi_aresetn] [get_bd_pins cds_core_d/s00_axi_aresetn] [get_bd_pins gpio_adc/s_axi_aresetn] [get_bd_pins gpio_dac/s_axi_aresetn] [get_bd_pins gpio_eth/s_axi_aresetn] [get_bd_pins gpio_ldo/s_axi_aresetn] [get_bd_pins gpio_telemetry/s_axi_aresetn] [get_bd_pins gpio_volt_sw/s_axi_aresetn] [get_bd_pins leds_gpio/s_axi_aresetn] [get_bd_pins packer/s00_axi_aresetn] [get_bd_pins ram_eth_ctrl/s_axi_aresetn] [get_bd_pins reset_ctrl/peripheral_aresetn] [get_bd_pins sequencer/s00_axi_aresetn] [get_bd_pins smart_buffer/s00_axi_aresetn] [get_bd_pins spi_dac/s_axi_aresetn] [get_bd_pins spi_ldo/s_axi_aresetn] [get_bd_pins spi_telemetry/s_axi_aresetn] [get_bd_pins spi_volt_sw/s_axi_aresetn] [get_bd_pins uart/s_axi_aresetn]
  connect_bd_net -net sequencer_0_seq_port_out [get_bd_pins sequencer/seq_port_out] [get_bd_pins sequencer_bits/vec_in]
  connect_bd_net -net sequencer_bits_0_out0 [get_bd_ports ANA_0] [get_bd_ports TGL_H1A] [get_bd_pins sequencer_bits/out0]
  connect_bd_net -net sequencer_bits_0_out1 [get_bd_ports ANA_1] [get_bd_ports TGL_H2A] [get_bd_pins sequencer_bits/out1]
  connect_bd_net -net sequencer_bits_0_out2 [get_bd_ports ANA_2] [get_bd_ports TGL_H3A] [get_bd_pins sequencer_bits/out2]
  connect_bd_net -net sequencer_bits_0_out3 [get_bd_ports ANA_3] [get_bd_ports TGL_SWA] [get_bd_pins sequencer_bits/out3]
  connect_bd_net -net sequencer_bits_0_out4 [get_bd_ports ANA_4] [get_bd_ports TGL_RGA] [get_bd_pins sequencer_bits/out4]
  connect_bd_net -net sequencer_bits_0_out5 [get_bd_ports ANA_5] [get_bd_ports TGL_OGA] [get_bd_pins sequencer_bits/out5]
  connect_bd_net -net sequencer_bits_0_out6 [get_bd_ports ANA_6] [get_bd_ports TGL_V1C] [get_bd_pins sequencer_bits/out6]
  connect_bd_net -net sequencer_bits_0_out7 [get_bd_ports ANA_7] [get_bd_ports TGL_V2C] [get_bd_pins sequencer_bits/out7]
  connect_bd_net -net sequencer_bits_0_out8 [get_bd_ports ANA_8] [get_bd_ports TGL_V3C] [get_bd_pins sequencer_bits/out8]
  connect_bd_net -net sequencer_bits_0_out9 [get_bd_ports ANA_9] [get_bd_ports TGL_TG] [get_bd_pins sequencer_bits/out9]
  connect_bd_net -net sequencer_bits_0_out10 [get_bd_ports ANA_10] [get_bd_ports TGL_H1B] [get_bd_pins sequencer_bits/out10]
  connect_bd_net -net sequencer_bits_0_out11 [get_bd_ports ANA_11] [get_bd_ports TGL_H2B] [get_bd_pins sequencer_bits/out11]
  connect_bd_net -net sequencer_bits_0_out12 [get_bd_ports ANA_12] [get_bd_ports TGL_H3B] [get_bd_pins sequencer_bits/out12]
  connect_bd_net -net sequencer_bits_0_out13 [get_bd_ports ANA_13] [get_bd_ports TGL_SWB] [get_bd_pins sequencer_bits/out13]
  connect_bd_net -net sequencer_bits_0_out14 [get_bd_ports ANA_14] [get_bd_ports TGL_RGB] [get_bd_pins sequencer_bits/out14]
  connect_bd_net -net sequencer_bits_0_out15 [get_bd_ports ANA_15] [get_bd_ports TGL_OGB] [get_bd_pins sequencer_bits/out15]
  connect_bd_net -net sequencer_bits_0_out16 [get_bd_ports ANA_16] [get_bd_ports TGL_DG] [get_bd_pins sequencer_bits/out16]
  connect_bd_net -net sequencer_bits_out21 [get_bd_pins sequencer_bits/out21] [get_bd_pins smart_buffer/capture_en_cha]
  connect_bd_net -net sequencer_bits_out22 [get_bd_pins sequencer_bits/out22] [get_bd_pins smart_buffer/capture_en_chb]
  connect_bd_net -net sequencer_bits_out23 [get_bd_pins sequencer_bits/out23] [get_bd_pins smart_buffer/capture_en_chc]
  connect_bd_net -net sequencer_bits_out24 [get_bd_pins sequencer_bits/out24] [get_bd_pins smart_buffer/capture_en_chd]
  connect_bd_net -net sequencer_bits_out25 [get_bd_pins cds_core_a/p] [get_bd_pins cds_core_b/p] [get_bd_pins cds_core_c/p] [get_bd_pins cds_core_d/p] [get_bd_pins packer_header_vec2bit_0/in_0] [get_bd_pins sequencer_bits/out25]
  connect_bd_net -net sequencer_bits_out26 [get_bd_pins cds_core_a/s] [get_bd_pins cds_core_b/s] [get_bd_pins cds_core_c/s] [get_bd_pins cds_core_d/s] [get_bd_pins packer_header_vec2bit_0/in_1] [get_bd_pins sequencer_bits/out26]
  connect_bd_net -net serial_io_0_adc_clk_n [get_bd_ports ADC_CLKA_N] [get_bd_pins adc_a/adc_clk_n]
  connect_bd_net -net serial_io_0_adc_clk_n1 [get_bd_ports ADC_CLKB_N] [get_bd_pins adc_b/adc_clk_n]
  connect_bd_net -net serial_io_0_adc_clk_n2 [get_bd_ports ADC_CLKC_N] [get_bd_pins adc_c/adc_clk_n]
  connect_bd_net -net serial_io_0_adc_clk_n3 [get_bd_ports ADC_CLKD_N] [get_bd_pins adc_d/adc_clk_n]
  connect_bd_net -net serial_io_0_adc_clk_p [get_bd_ports ADC_CLKA_P] [get_bd_pins adc_a/adc_clk_p]
  connect_bd_net -net serial_io_0_adc_clk_p1 [get_bd_ports ADC_CLKB_P] [get_bd_pins adc_b/adc_clk_p]
  connect_bd_net -net serial_io_0_adc_clk_p2 [get_bd_ports ADC_CLKC_P] [get_bd_pins adc_c/adc_clk_p]
  connect_bd_net -net serial_io_0_adc_clk_p3 [get_bd_ports ADC_CLKD_P] [get_bd_pins adc_d/adc_clk_p]
  connect_bd_net -net serial_io_0_adc_cnvrt_n [get_bd_ports ADCA_CNV_N] [get_bd_pins adc_a/adc_cnvrt_n]
  connect_bd_net -net serial_io_0_adc_cnvrt_n1 [get_bd_ports ADCB_CNV_N] [get_bd_pins adc_b/adc_cnvrt_n]
  connect_bd_net -net serial_io_0_adc_cnvrt_n2 [get_bd_ports ADCC_CNV_N] [get_bd_pins adc_c/adc_cnvrt_n]
  connect_bd_net -net serial_io_0_adc_cnvrt_n3 [get_bd_ports ADCD_CNV_N] [get_bd_pins adc_d/adc_cnvrt_n]
  connect_bd_net -net serial_io_0_adc_cnvrt_p [get_bd_ports ADCA_CNV_P] [get_bd_pins adc_a/adc_cnvrt_p]
  connect_bd_net -net serial_io_0_adc_cnvrt_p1 [get_bd_ports ADCB_CNV_P] [get_bd_pins adc_b/adc_cnvrt_p]
  connect_bd_net -net serial_io_0_adc_cnvrt_p2 [get_bd_ports ADCC_CNV_P] [get_bd_pins adc_c/adc_cnvrt_p]
  connect_bd_net -net serial_io_0_adc_cnvrt_p3 [get_bd_ports ADCD_CNV_P] [get_bd_pins adc_d/adc_cnvrt_p]
  connect_bd_net -net smart_buffer_0_data_out [get_bd_pins packer/rdata_smart_bufffer] [get_bd_pins smart_buffer/data_out]
  connect_bd_net -net smart_buffer_0_ready_out [get_bd_pins packer/rready_smart_buffer] [get_bd_pins smart_buffer/ready_out]
  connect_bd_net -net spi_dac_io0_o [get_bd_ports DAC_SDI] [get_bd_pins spi_dac/io0_o]
  connect_bd_net -net spi_dac_sck_o [get_bd_ports DAC_SCLK] [get_bd_pins spi_dac/sck_o]
  connect_bd_net -net spi_dac_ss_o [get_bd_ports DAC_SYNC_N] [get_bd_pins spi_dac/ss_o]
  connect_bd_net -net spi_ldo_block_gpio_io_o [get_bd_pins gpio_bits/vec_in] [get_bd_pins gpio_ldo/gpio_io_o]
  connect_bd_net -net spi_ldo_io0_o [get_bd_ports DIGPOT_DIN] [get_bd_pins spi_ldo/io0_o]
  connect_bd_net -net spi_ldo_mux_0_sdo_out [get_bd_pins spi_ldo/io1_i] [get_bd_pins spi_ldo_mux/sdo_out]
  connect_bd_net -net spi_ldo_mux_0_ss0_out [get_bd_ports CCD_VDRAIN_DIGPOT_SYNC_N] [get_bd_pins spi_ldo_mux/ss0_out]
  connect_bd_net -net spi_ldo_mux_0_ss1_out [get_bd_ports CCD_VDD_DIGPOT_SYNC_N] [get_bd_pins spi_ldo_mux/ss1_out]
  connect_bd_net -net spi_ldo_mux_0_ss2_out [get_bd_ports CCD_VR_DIGPOT_SYNC_N] [get_bd_pins spi_ldo_mux/ss2_out]
  connect_bd_net -net spi_ldo_mux_0_ss3_out [get_bd_ports CCD_VSUB_DIGPOT_SYNC_N] [get_bd_pins spi_ldo_mux/ss3_out]
  connect_bd_net -net spi_ldo_sck_o [get_bd_ports DIGPOT_SCLK] [get_bd_pins spi_ldo/sck_o]
  connect_bd_net -net spi_ldo_ss_o [get_bd_pins spi_ldo/ss_o] [get_bd_pins spi_ldo_mux/ss_in]
  connect_bd_net -net spi_telemetry_io0_o [get_bd_ports TEL_DIN] [get_bd_pins spi_telemetry/io0_o]
  connect_bd_net -net spi_telemetry_sck_o [get_bd_ports TEL_SCLK] [get_bd_pins spi_telemetry/sck_o]
  connect_bd_net -net spi_telemetry_ss_o [get_bd_ports TEL_CS_N] [get_bd_pins spi_telemetry/ss_o]
  connect_bd_net -net spi_volt_sw_io0_o [get_bd_ports VOLT_SW_DIN] [get_bd_pins spi_volt_sw/io0_o]
  connect_bd_net -net spi_volt_sw_sck_o [get_bd_ports VOLT_SW_CLK] [get_bd_pins spi_volt_sw/sck_o]
  connect_bd_net -net util_ds_buf_0_BUFG_O [get_bd_pins clk_buf/BUFG_O] [get_bd_pins master_clock/clk_in1]
  connect_bd_net -net vec2bit_2_0_out0 [get_bd_ports VOLT_SW_CLR] [get_bd_pins vec2bit_2_0/out0]
  connect_bd_net -net vec2bit_2_0_out1 [get_bd_ports VOLT_SW_LE_N] [get_bd_pins vec2bit_2_0/out1]
  connect_bd_net -net vec2bit_4_0_out0 [get_bd_ports DAC_LDAC_N] [get_bd_pins vec2bit_4_0/out0]
  connect_bd_net -net vec2bit_4_0_out1 [get_bd_ports DAC_CLR_N] [get_bd_pins vec2bit_4_0/out1]
  connect_bd_net -net vec2bit_4_0_out2 [get_bd_ports DAC_RESET_N] [get_bd_pins vec2bit_4_0/out2]
  connect_bd_net -net vec2bit_4_0_out3 [get_bd_ports DAC_SW_EN] [get_bd_pins vec2bit_4_0/out3]
  connect_bd_net -net vec2bit_6_0_out0 [get_bd_ports TEL_MUXEN0] [get_bd_pins vec2bit_6_0/out0]
  connect_bd_net -net vec2bit_6_0_out1 [get_bd_ports TEL_MUXEN1] [get_bd_pins vec2bit_6_0/out1]
  connect_bd_net -net vec2bit_6_0_out2 [get_bd_ports TEL_MUXEN2] [get_bd_pins vec2bit_6_0/out2]
  connect_bd_net -net vec2bit_6_0_out3 [get_bd_ports TEL_MUXA0] [get_bd_pins vec2bit_6_0/out3]
  connect_bd_net -net vec2bit_6_0_out4 [get_bd_ports TEL_MUXA1] [get_bd_pins vec2bit_6_0/out4]
  connect_bd_net -net vec2bit_6_0_out5 [get_bd_ports TEL_MUXA2] [get_bd_pins vec2bit_6_0/out5]
  connect_bd_net -net vio_1_probe_out0 [get_bd_ports ADCA_2LANES] [get_bd_ports ADCB_2LANES] [get_bd_ports ADCC_2LANES] [get_bd_ports ADCD_2LANES] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins ram_eth/enb] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x40060000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_eth/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs uart/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A40000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_a/s00_axi/reg0] SEG_cds_core_a_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A50000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_b/s00_axi/reg0] SEG_cds_core_b_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_c/s00_axi/reg0] SEG_cds_core_c_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_d/s00_axi/reg0] SEG_cds_core_d_reg0
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ublaze_mem/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0x40040000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_adc/S_AXI/Reg] SEG_gpio_adc_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_dac/S_AXI/Reg] SEG_gpio_dac_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_ldo/S_AXI/Reg] SEG_gpio_ldo_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40020000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_telemetry/S_AXI/Reg] SEG_gpio_telemetry_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40030000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_volt_sw/S_AXI/Reg] SEG_gpio_volt_sw_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ublaze_mem/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x40050000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs leds_gpio/S_AXI/Reg] SEG_leds_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A80000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs packer/s00_axi/reg0] SEG_packer_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ram_eth_ctrl/S_AXI/Mem0] SEG_ram_eth_ctrl_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A90000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs sequencer/s00_axi/reg0] SEG_sequencer_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44AA0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs smart_buffer/s00_axi/reg0] SEG_smart_buffer_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_dac/AXI_LITE/Reg] SEG_spi_dac_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_ldo/AXI_LITE/Reg] SEG_spi_ldo_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A20000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_telemetry/AXI_LITE/Reg] SEG_spi_telemetry_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A30000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_volt_sw/AXI_LITE/Reg] SEG_spi_volt_sw_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


