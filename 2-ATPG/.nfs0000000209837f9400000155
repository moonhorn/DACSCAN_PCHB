# global variables
set PATH search
set DESIGN circuit
set LIBRARY_SIMPLE simple_lib
set LIBRARY_MODEL  model_lib
set FAULT faultlist
set DT output_dt
set PT output_pt
set UD output_ud
set AU output_au
set ND output_nd
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
