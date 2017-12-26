#global variables
set PATH ../1-modeler/a.v
set DESIGN DEMUX_dims
set LIBRARY_SIMPLE ../library_delay_expand3/dims_lib_model_expand.v
set LIBRARY_EXTEND ../library_delay_expand3/dims_lib_extend_model_expand.v
set LIBRARY_MODEL  ../library_delay_expand3/dims_lib_model_delay_stf.v
set FAULT ../1-modeler/a.fl
set DT ../0-result/ISCAS/tmax/DT/SA1/small_dims_sa1.dt
set PT ../0-result/ISCAS/tmax/PT/SA1/small_dims_sa1.pt
set UD ../0-result/ISCAS/tmax/UD/SA1/small_dims_sa1.ud
set AU ../0-result/ISCAS/tmax/AU/SA1/small_dims_sa1.au
set ND ../0-result/ISCAS/tmax/ND/SA1/small_dims_sa1.nd
set Ndt "1"

read_netlist $PATH
read_netlist $LIBRARY_SIMPLE
read_netlist $LIBRARY_EXTEND
read_netlist $LIBRARY_MODEL
read_netlist ../library_delay_expand2/NangateOpenCellLibrary.v
run_build_model $DESIGN
#report_violations -all
run_drc
read_faults $FAULT
#add_faults -all
set_atpg -abort_limit 100 
run_atpg -auto
#set_patterns -external temp.stil
#run_fault_sim
set_faults -fault_coverage
report_summaries
#report_fault -class dt
#report_fault -class pt > $PT 
#report_fault -class ud > $UD
#report_fault -class au > $AU
#report_fault -class nd > $ND
#exit
