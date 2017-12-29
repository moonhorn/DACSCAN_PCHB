# global variables
set PATH ../1-modeler/inputs/s386.v
set DESIGN s386
set Ndt "1"
#set cpuNum "8"

read_netlist $PATH
read_netlist ../original_library/NangateOpenCellLibrary.v
run_build_model $DESIGN
#report_violations -all
run_drc
set_atpg -abort_limit 100 -merge high
#set_atpg -num_processes ${cpuNum}
run_atpg -auto
set_faults -fault_coverage
report_summaries
exit