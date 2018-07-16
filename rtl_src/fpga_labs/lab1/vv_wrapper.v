module vv_wrapper
  # (parameter N=3,                                //number of elements in a vector
               DW=8,
               BRAM_DEPTH=32)                               //size of each element
    (input clk,
     input rst,
     input start
     );

wire [$clog2(N):0] count;
wire [$clog2(BRAM_DEPTH)-1:0] rd_addr;
wire [$clog2(BRAM_DEPTH)-1:0] wr_addr;
wire mem_wr_en;
wire [DW -1:0] vect_a;
wire [DW -1:0] vect_b;
wire [(2*DW + $clog2(N))-1:0] result;

//vector "a" memory
rom_mem
           # (  .DW(DW)
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE("../python/vv_test/vec_a.hex"))
    rom_inst1 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr ()
               ,.we      ()
               ,.wr_data ()
               ,.rd_data (vect_a));

//vector "b" memory
rom_mem
           # (  .DW(DW)
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE("../python/vv_test/vec_b.hex"))
    rom_inst2 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr ()
               ,.we      ()
               ,.wr_data ()
               ,.rd_data (vect_b));

//result memory
ram_mem
           # (  .N(N)
		       ,.DW(2*DW + $clog2(N))
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE("../python/vv_test/sim_res.hex"))
    ram_inst3 ( .clk     (clk)
               ,.rd_addr ()
               ,.wr_addr (wr_addr)
               ,.we      (mem_wr_en)
               ,.wr_data (result)
               ,.rd_data ());


//vector multiplier logic
vector_mult
      # ( .N(N)
         ,.DW(DW))
vv_inst ( .clk      (clk)
         ,.rst      (rst)
         ,.result   (result)
         ,.vect_a   (vect_a)
         ,.vect_b   (vect_b)
         ,.count    (count)
         );

//vector multiplier fsm
vv_fsm
         # (.N(N)
            ,.BRAM_DEPTH(BRAM_DEPTH))
vvfsm_inst ( .clk        (clk)
            ,.rst        (rst)
            ,.start      (start)
            ,.rd_addr    (rd_addr)
            ,.mem_wr_en  (mem_wr_en)
            ,.wr_addr    (wr_addr)
            ,.count      (count)
            );


endmodule
