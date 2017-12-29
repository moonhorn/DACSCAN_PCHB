# global variables
set PATH ../0-result/modNetlist/STF/s386_PCHB_mod_stf.v
set DESIGN s386_PCHB
set LIBRARY_SIMPLE ../library_delay_expand6/dims_lib_model_delay_stf.v
set LIBRARY_MODEL ../library_delay_expand6/pchb_lib_model_expand.v
set FAULT ../0-result/modFaultlist/STF/s386_PCHB_mod_stf.fl
set DT ../0-result/tmax/DT/STF/s386_PCHB_stf.dt
set PT ../0-result/tmax/PT/STF/s386_PCHB_stf.pt
set UD ../0-result/tmax/UD/STF/s386_PCHB_stf.ud
set AU ../0-result/tmax/AU/STF/s386_PCHB_stf.au
set ND ../0-result/tmax/ND/STF/s386_PCHB_stf.nd
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
analyze_faults -stuck 0 U_I109/inst_model7/buffer/Z >  i7analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model8/buffer/Z >  i8analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model11/buffer/Z > i11analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model12/buffer/Z > i12analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model13/buffer/Z > i13analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model14/buffer/Z > i14analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model15/buffer/Z > i15analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model16/buffer/Z > i16analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model17/buffer/Z > i17analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model18/buffer/Z > i18analyze_report.txt
analyze_faults -stuck 0 U_I109/inst_model19/buffer/Z > i19analyze_report.txt
exit
