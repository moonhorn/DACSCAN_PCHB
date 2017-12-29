# global variables
set PATH ../0-result/modNetlist/STF/s1238_PCHB_mod_stf.v
set DESIGN s1238_PCHB
set LIBRARY_SIMPLE ../library_delay_expand6/dims_lib_model_delay_stf.v
set LIBRARY_MODEL ../library_delay_expand6/pchb_lib_model_expand.v
set FAULT ../0-result/modFaultlist/STF/s1238_PCHB_mod_stf.fl
set DT ../0-result/tmax/DT/STF/s1238_PCHB_stf.dt
set PT ../0-result/tmax/PT/STF/s1238_PCHB_stf.pt
set UD ../0-result/tmax/UD/STF/s1238_PCHB_stf.ud
set AU ../0-result/tmax/AU/STF/s1238_PCHB_stf.au
set ND ../0-result/tmax/ND/STF/s1238_PCHB_stf.nd
set Ndt "1"
#set cpuNum "8"

read_netlist $PATH
read_netlist $LIBRARY_SIMPLE
read_netlist $LIBRARY_MODEL
read_netlist ../original_library/NangateOpenCellLibrary.v
run_build_model $DESIGN
#report_violations -all
run_drc
read_faults $FAULT
set_atpg -abort_limit 100 -merge high
#set_atpg -num_processes ${cpuNum}
run_atpg -auto
set_faults -fault_coverage
report_summaries
report_fault -class dt > $DT
report_fault -class pt > $PT 
report_fault -class ud > $UD
report_fault -class au > $AU
report_fault -class nd > $ND
exit
