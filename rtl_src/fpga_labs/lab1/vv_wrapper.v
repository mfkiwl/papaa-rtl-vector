module vv_wrapper
  # (parameter N=3,                                //number of elements in a vector
               DW=8)                               //size of each element
    (input clk,
     input rst,
     input start,
	 input [$clog2(N)-1:0] rom_vec_a_wr_addr,
	 input [$clog2(N)-1:0] rom_vec_b_wr_addr,
	 input [$clog2(N)-1:0] ram_rd_addr,
	 input [DW -1:0] rom_vec_a_wr_data,
	 input [DW -1:0] rom_vec_b_wr_data,
	 input rom_vec_a_we,
	 input rom_vec_b_we,
	 output wire [(2*DW + $clog2(N))-1:0] ram_rd_data
     );

wire init;
wire [$clog2(N)-1:0] rd_addr;
wire [$clog2(N)-1:0] wr_addr;
wire mem_wr_en;
wire [DW -1:0] vect_a;
wire [DW -1:0] vect_b;
wire [(2*DW + $clog2(N))-1:0] result;

//vector "a" memory
ram_mem
           # (  .DW(DW)
               ,.AW($clog2(N))
               ,.INIT_FILE("../python/vv_test/vec_a.hex")
			   ,.mode("read"))
    rom_inst1 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_vec_a_wr_addr)
               ,.we      (rom_vec_a_we)
               ,.wr_data (rom_vec_a_wr_data)
               ,.rd_data (vect_a));

//vector "b" memory
ram_mem
           # (  .DW(DW)
               ,.AW($clog2(N))
               ,.INIT_FILE("../python/vv_test/vec_b.hex")
			   ,.mode("read"))
    rom_inst2 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_vec_b_wr_addr)
               ,.we      (rom_vec_b_we)
               ,.wr_data (rom_vec_b_wr_data)
               ,.rd_data (vect_b));

//result memory
ram_mem
           # (  .N(N)
		       ,.DW(2*DW + $clog2(N))
               ,.AW($clog2(N))
               ,.INIT_FILE("../python/vv_test/sim_res.hex")
			   ,.mode("write"))
    ram_inst3 ( .clk     (clk)
               ,.rd_addr (ram_rd_addr)
               ,.wr_addr (wr_addr)
               ,.we      (mem_wr_en)
               ,.wr_data (result)
               ,.rd_data (ram_rd_data));


//vector multiplier logic
vector_mult
      # ( .N(N)
         ,.DW(DW))
vv_inst ( .clk      (clk)
         ,.rst      (rst)
         ,.result   (result)
         ,.vect_a   (vect_a)
         ,.vect_b   (vect_b)
         ,.init     (init)
         );

//vector multiplier fsm
vv_fsm
         # (.N(N))
vvfsm_inst ( .clk        (clk)
            ,.rst        (rst)
            ,.start      (start)
            ,.rd_addr    (rd_addr)
            ,.mem_wr_en  (mem_wr_en)
            ,.wr_addr    (wr_addr)
            ,.init       (init)
            );


endmodule
