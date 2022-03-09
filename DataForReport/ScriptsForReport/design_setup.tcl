# Set the top_entity_name you want to do synthesis on
set DESIGN TOP_TOP

set RTL "${ROOT}/VHD_files"

set_attribute script_search_path $SYNT_SCRIPT /

set_attribute init_hdl_search_path $RTL /

set_attribute hdl_error_on_latch true

set_attribute init_lib_search_path { \
/usr/local-eit/cad2/cmpstm/stm065v536/CORE65LPHVT_5.1/libs \
/usr/local-eit/cad2/cmpstm/stm065v536/CLOCK65LPHVT_3.1/libs \
/usr/local-eit/cad2/cmpstm/mem2011/SPHD110420-48158@1.0/libs \
/usr/local-eit/cad2/cmpstm/dicp18/LU_PADS_65nm \
} /

set_attribute library { \
CLOCK65LPHVT_wc_1.10V_125C.lib \
CORE65LPHVT_wc_1.10V_125C.lib \
SPHD110420_wc_1.10V_125C.lib \
Pads_Oct2012.lib} /

# put all your design files here
set DESIGN_FILES "${RTL}/TOP_TOP.vhd ${RTL}/TOP_matmult.vhd  ${RTL}/Controller.vhd  ${RTL}/fake_ROM.vhd  ${RTL}/RAM_ctrl.vhd  ${RTL}/Multiplier_Unit.vhd ${RTL}/shift_reg.vhd  ${RTL}/reg.vhd ${RTL}/SRAM_SP_WRAPPER.vhd"

set SYN_EFF high
set MAP_EFF high
set OPT_EFF high


set_attribute syn_generic_effort ${SYN_EFF}
set_attribute syn_map_effort ${MAP_EFF}
set_attribute syn_opt_effort ${OPT_EFF}
set_attribute information_level 5
