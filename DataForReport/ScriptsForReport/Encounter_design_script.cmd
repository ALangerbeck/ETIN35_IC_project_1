# SPECIFY PATHS TO LEF,LIBS AND INITIAL FILES

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set ::TimeLib::tsgMarkCellLatchConstructFlag 1
set _timing_library_enable_mt_flow 0
set conf_ioOri R0
set conf_row_height 2.600000
set dcgHonorSignalNetNDR 1
set defHierChar /
set delaycal_input_transition_delay 0.1ps
set distributed_client_message_echo 1
set fpIsMaxIoHeight 0
set fp_core_height 348.600000
set fp_core_to_bottom 20.000000
set fp_core_to_left 20.000000
set fp_core_to_right 20.000000
set fp_core_to_top 20.000000
set fp_core_width 320.000000
set gpsPrivate::dpgNewAddBufsDBUpdate 1
set gpsPrivate::lsgEnableNewDbApiInRestruct 1
set init_gnd_net GND
set init_io_file ../MiscPnRFiles/TOP_TOP_FINAL.IO
set init_lef_file {Lefs/cmos065_7m4x0y2z_AP_Worst.lef Lefs/CLOCK65LPHVT_soc.lef Lefs/CORE65LPHVT_soc.lef Lefs/IO65LP_SF_BASIC_50A_ST_7M4X0Y2Z_soc.lef Lefs/IO65LPHVT_SF_1V8_50A_7M4X0Y2Z_soc.lef Lefs/PADS_Jun2013.lef Lefs/PRHS65_soc.lef Lefs/SPHD110420_soc.lef}
set init_mmmc_file TOP_TOP_LPHV.view
set init_oa_search_lib {}
set init_pwr_net VDD
set init_top_cell TOP_TOP
set init_verilog ../Synthesis_V2/OUTPUTS/TOP_TOP.v
set lsgOCPGainMult 1.000000
set pegDefaultResScaleFactor 1.000000
set pegDetailResScaleFactor 1.000000
set spgDecolorGeom 1
set timing_library_float_precision_tol 0.000010
set timing_library_load_pin_cap_indices {}
set tso_post_client_restore_command {update_timing ; write_eco_opt_db ;}
set init_io_file ../MiscPnRFiles/TOP_TOP_FINAL.io
init_design

# SET GLOBAL NETS FOR VDD AND GND
globalNetConnect VDD -type pgpin -pin vdd -inst *
globalNetConnect VDD -type tiehi -inst *
globalNetConnect GND -type tielo -inst *
globalNetConnect GND -type pgpin -pin gnd -inst *
globalNetConnect GND -type pgpin -pin GNDC -inst *
globalNetConnect VDD -type pgpin -pin VDDC -inst *


# REZISE FLORRPLAN
fit
setIoFlowFlag 0
floorPlan -site CORE -s 305.0 300.0 20.0 20.0 20.0 20.0
uiSetTool select
getIoFlowFlag
fit

# MOVE RAM INTO PLACE
setObjFPlanBox Instance TOP/inst_RAM_ctrl/RAM/DUT_ST_SPHDL_160x32_mem2011 95.551 354.428 400.351 395.428


# ADD HALO AROUND MEMORY WHERE CELLS CANT BE PLACED
selectInst TOP/inst_RAM_ctrl/RAM/DUT_ST_SPHDL_160x32_mem2011
addHaloToBlock {10 10 10 10} -allBlock

# REMOVE CORE ROWS UNDER MEMORY
deselectAll
selectInst TOP/inst_RAM_ctrl/RAM/DUT_ST_SPHDL_160x32_mem2011
cutRow -selected

# ADD RING CONNECTORS FOR GND AVND VDD
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer AP -type core_rings -jog_distance 2.5 -threshold 2.5 -nets {GND VDD} -follow core -stacked_via_bottom_layer M1 -layer {bottom M3 top M3 right M4 left M4} -width 2 -spacing 2 -offset 2
deselectAll

# RINGS UNDER MEMORY
selectInst TOP/inst_RAM_ctrl/RAM/DUT_ST_SPHDL_160x32_mem2011
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer AP -around cluster -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {GND VDD} -follow core -stacked_via_bottom_layer M1 -layer {bottom M3 top M3 right M4 left M4} -width 2 -spacing 2 -offset 2 -skip_side {left top right}

# CREATE VERTIAL AND HORIZONTAL STRIPES
set sprCreateIeStripeNets {}
set sprCreateIeStripeLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeSpacing 2.0
set sprCreateIeStripeThreshold 1.0
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M5 -max_same_layer_jog_length 6 -padcore_ring_bottom_layer_limit M3 -set_to_set_distance 100 -skip_via_on_pin Standardcell -stacked_via_top_layer AP -padcore_ring_top_layer_limit M5 -spacing 2 -merge_stripes_value 2.5 -layer M4 -block_ring_bottom_layer_limit M3 -width 3 -nets {GND VDD} -stacked_via_bottom_layer M1
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M4 -max_same_layer_jog_length 6 -padcore_ring_bottom_layer_limit M2 -set_to_set_distance 100 -skip_via_on_pin Standardcell -stacked_via_top_layer AP -padcore_ring_top_layer_limit M4 -spacing 2 -merge_stripes_value 2.5 -direction horizontal -layer M3 -block_ring_bottom_layer_limit M2 -width 3 -nets {GND VDD} -stacked_via_bottom_layer M1

# CREATE WELLTAP
addWellTap -cell HS65_LH_FILLERSNPWPFP3 -cellInterval 25 -prefix WELLTAP

# CREATE PLACEMENT BLOCKAGE AND PLACE STANDARD CELLS
setPlaceMode -prerouteAsObs {1 2 3 4 5 6 7 8}
setPlaceMode -fp false
placeDesign

# SPECIFY BUFFERS FOR CLOCK
createClockTreeSpec -bufferList {CLOCKTREE HS65_LH_CNBFX10 HS65_LH_CNBFX103 HS65_LH_CNBFX124 HS65_LH_CNBFX14 HS65_LH_CNBFX17 HS65_LH_CNBFX21 HS65_LH_CNBFX24 HS65_LH_CNBFX27 HS65_LH_CNBFX31 HS65_LH_CNBFX34 HS65_LH_CNBFX38 HS65_LH_CNBFX38_0 HS65_LH_CNBFX38_1 HS65_LH_CNBFX38_10 HS65_LH_CNBFX38_11 HS65_LH_CNBFX38_12 HS65_LH_CNBFX38_13 HS65_LH_CNBFX38_14 HS65_LH_CNBFX38_15 HS65_LH_CNBFX38_16 HS65_LH_CNBFX38_17 HS65_LH_CNBFX38_18 HS65_LH_CNBFX38_19 HS65_LH_CNBFX38_2 HS65_LH_CNBFX38_20 HS65_LH_CNBFX38_21 HS65_LH_CNBFX38_22 HS65_LH_CNBFX38_23 HS65_LH_CNBFX38_3 HS65_LH_CNBFX38_4 HS65_LH_CNBFX38_5 HS65_LH_CNBFX38_6 HS65_LH_CNBFX38_7 HS65_LH_CNBFX38_8 HS65_LH_CNBFX38_9 HS65_LH_CNBFX41 HS65_LH_CNBFX45 HS65_LH_CNBFX48 HS65_LH_CNBFX52 HS65_LH_CNBFX55 HS65_LH_CNBFX58 HS65_LH_CNBFX62 HS65_LH_CNBFX82 HS65_LH_CNIVX10 HS65_LH_CNIVX103 HS65_LH_CNIVX124 HS65_LH_CNIVX14 HS65_LH_CNIVX17 HS65_LH_CNIVX21 HS65_LH_CNIVX24 HS65_LH_CNIVX27 HS65_LH_CNIVX3 HS65_LH_CNIVX31 HS65_LH_CNIVX34 HS65_LH_CNIVX38 HS65_LH_CNIVX41 HS65_LH_CNIVX45 HS65_LH_CNIVX48 HS65_LH_CNIVX52 HS65_LH_CNIVX55 HS65_LH_CNIVX58 HS65_LH_CNIVX62 HS65_LH_CNIVX7 HS65_LH_CNIVX82} -file Clock.ctstch

# CREATE CLOCK TREE REMOVE TRIAL ROUTES
setCTSMode -engine ck
clockDesign -specFile Clock.ctstch -outDir clock_report -fixedInstBeforeCTS
deleteTrialRoute

# CREATE SUFFICIENT SPACING FOR BETWEEN PADS
deselectAll
selectInst PcornerUL
selectInst PGND1
selectInst {InPads[4].InPad}
selectInst {InPads[5].InPad}
selectInst {InPads[6].InPad}
selectInst {InPads[7].InPad}
selectInst PGND2
spaceObject -fixSide left -space 6
deselectAll
selectInst PcornerUR
selectInst {OutPads[4].OutPad}
selectInst {OutPads[3].OutPad}
selectInst {OutPads[2].OutPad}
selectInst {OutPads[1].OutPad}
selectInst {OutPads[0].OutPad}
spaceObject -fixSide top -space 15
deselectAll
selectInst PcornerLR
selectInst PVDD2
selectInst valid_input_pad
selectInst read_ram_pad
selectInst ready_pad
selectInst rst_pad
selectInst PVDD1
spaceObject -fixSide right -space 6
deselectAll
selectInst PcornerLL
selectInst {InPads[0].InPad}
selectInst {InPads[1].InPad}
selectInst {InPads[2].InPad}
selectInst {InPads[3].InPad}
selectInst clk_pad
spaceObject -fixSide bottom -space 15

# ADD IO FILLERS
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLER -side n
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLER -side e
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLER -side s
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLER -side w
deselectAll

# SPECIAL ROUTING FOR GND AND VDD
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { M1 AP } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { M1 AP } -nets { GND VDD } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { M1 AP }

# ROUTING FOR THE REST
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail

# COMMAND ENABLING US TO ANAYLSE TIMING
setAnalysisMode -analysisType onChipVariation

# TIMING OPTIMIZATION
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute -hold

setOptMode -fixCap false -fixTran false -fixFanoutLoad true
optDesign -postRoute -hold

setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute -hold

#setOptMode -fixCap false -fixTran false -fixFanoutLoad true
#optDesign -postRoute -hold

# ADD FILLER CELLS
getFillerMode -quiet
addFiller -cell HS65_LS_FILLERPFP4 HS65_LL_FILLERPFP4 HS65_LH_FILLERPFP4 HS65_LH_FILLERPFP3 HS65_LS_FILLERPFP3 HS65_LL_FILLERPFP3 HS65_LS_FILLERPFP2 HS65_LL_FILLERPFP2 HS65_LH_FILLERPFP2 HS65_LH_FILLERPFP1 HS65_LL_FILLERPFP1 HS65_LS_FILLERPFP1 -prefix FILLER -markFixed


all_hold_analysis_views 
all_setup_analysis_views 

# WRITE STANDARD DELAY FILE
write_sdf -version2.1 -interconn nooutport TOP_TOP.sdf


