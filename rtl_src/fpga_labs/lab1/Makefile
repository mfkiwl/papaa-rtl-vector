clean:
	rm -Rf *.log *.jou

vv-sim:
	rm -Rf obj_dir
	verilator -Wno-WIDTH -Wno-MULTIDRIVEN -Wno-COMBDLY -Wno-REALCVT -Wno-INITIALDLY -Wno-PINMISSING -Wno-STMTDLY -Wno-UNOPTFLAT -Wno-CASEX -cc ram_mem.sv rom_mem.sv vector_mult.v vv_fsm.v vv_wrapper.v --exe vv_wrapper_tb.c --top-module vv_wrapper
	make -C obj_dir -j -f Vvv_wrapper.mk Vvv_wrapper
	./obj_dir/Vvv_wrapper
