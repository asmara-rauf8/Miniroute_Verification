vlib work
vlog +define+UVM_NO_DPI +incdir+/home/comira/intelFPGA/20.1/modelsim_ase/verilog_src/uvm-1.2/src/ /home/comira/intelFPGA/20.1/modelsim_ase/verilog_src/uvm-1.2/src/uvm.sv +incdir+. -f file_list.f  ../MiniRoute/design/top.svp
vsim -voptargs=+acc+top. +UVM_TESTNAME=sanity_test tb_top -sv_seed random
do wave.do
run -all

