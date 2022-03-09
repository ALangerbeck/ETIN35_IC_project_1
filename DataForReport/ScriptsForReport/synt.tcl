set ROOT "/h/d8/j/al5878la-s/ICP1"

set SYNT_SCRIPT    "${ROOT}/Synthesis_V2/Synt_Script"
set SYNT_OUT       "${ROOT}/Synthesis_V2/OUTPUTS"
set SYNT_REPORT    "${ROOT}/Synthesis_V2/REPORTS"

puts "\n\n\n DESIGN FILES \n\n\n"
source $SYNT_SCRIPT/design_setup.tcl

puts "\n\n\n ANALYZE HDL DESIGN \n\n\n"
read_hdl -vhdl ${DESIGN_FILES}

puts "\n\n\n ELABORATE \n\n\n"
elaborate ${DESIGN}

check_design
report timing -lint

puts "\n\n\n TIMING CONSTRAINTS \n\n\n"
source $SYNT_SCRIPT/create_clock.tcl

puts "\n\n\n SYN_GENERIC \n\n\n"
syn_generic

puts "\n\n\n SYN_MAP \n\n\n"
syn_map

puts "\n\n\n SYN_OPT \n\n\n"
syn_opt

puts "\n\n\n DONE_WITH_SYN_OPT \n\n\n"


write_reports -outdir $SYNT_REPORT -tag rep1
report_summary -outdir $SYNT_REPORT

puts "\n\n\n EXPORT DESIGN \n\n\n"
write_hdl    > ${SYNT_OUT}/${DESIGN}.v
write_sdc    > ${SYNT_OUT}/${DESIGN}.sdc
write_sdf   -version 2.1  > ${SYNT_OUT}/${DESIGN}.sdf

puts "\n\n\n REPORTING \n\n\n"
report qor      > $SYNT_REPORT/qor_${DESIGN}.rpt
report area     > $SYNT_REPORT/area_${DESIGN}.rpt
report datapath > $SYNT_REPORT/datapath_${DESIGN}.rpt
report messages > $SYNT_REPORT/messages_${DESIGN}.rpt
report gates    > $SYNT_REPORT/gates_${DESIGN}.rpt
report timing   > $SYNT_REPORT/timing_${DESIGN}.rpt
