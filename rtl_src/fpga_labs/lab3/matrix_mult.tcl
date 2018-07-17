read_verilog ram_mem.sv;
read_verilog rom_mem.sv;
read_verilog vector_mult.v;
read_verilog mat_vect_mult.sv;
read_verilog mm_fsm.sv;
read_verilog mm_wrapper.sv;
read_xdc main.xdc;
synth_design -mode out_of_context -part xc7vx485tffg1761-2 -generic N=10 -generic DW=8 -generic BRAM_DEPTH=16 -top mm_wrapper;
opt_design; place_design; route_design; report_utilization; report_timing;
exit

