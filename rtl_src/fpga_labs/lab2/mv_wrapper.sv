module mv_wrapper
  # (parameter N=10,                                //number of elements in a vector
               DW=8,
               BRAM_DEPTH=16)                               //size of each element
    (input clk,
     input rst,
     input start,
     input [DW-1:0] rom_data,
     input [$clog2(BRAM_DEPTH)-1:0] rom_wr_addr,
     input rom_we,
     output wire [(2*DW + $clog2(N))-1:0] ram_data,
     input [$clog2(BRAM_DEPTH)-1:0] ram_rd_addr
     );

wire [$clog2(BRAM_DEPTH)-1:0] rd_addr;
wire [$clog2(BRAM_DEPTH)-1:0] wr_addr;
wire mem_wr_en;
wire [$clog2(N):0] count;
wire [$clog2(N):0] wr_count;
wire [(2*DW + $clog2(N))-1:0] result;
wire [DW -1:0] mat_a [0:N-1];
wire [DW -1:0] vect_b;
genvar i;

//matrix "a" memory
generate
for (i=0; i<N; i=i+1) begin : mat_a_gen
localparam [7:0] index = "0"+i;
rom_mem
           # (  .DW(DW)
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE({"../python/mv_test/mat_a_r",index,".hex"}))
    rom_inst2 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_wr_addr)
               ,.we      (rom_we)
               ,.wr_data (rom_data)
               ,.rd_data (mat_a[i]));
end
endgenerate

//vector "b" memory
rom_mem
           # (  .DW(DW)
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE("../python/mv_test/vec_b.hex"))
    rom_inst1 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_wr_addr)
               ,.we      (rom_we)
               ,.wr_data (rom_data)
               ,.rd_data (vect_b));

//result vector memory
ram_mem
           # (  .N(N)
               ,.DW(2*DW + $clog2(N))
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE("../python/mv_test/sim_res.hex"))
    ram_inst3 ( .clk     (clk)
               ,.rd_addr (ram_rd_addr)
               ,.wr_addr (wr_addr)
               ,.we      (mem_wr_en)
               ,.wr_data (result)
               ,.rd_data (ram_data));

mat_vect_mult
      # ( .N        (N)
         ,.DW       (DW))
mv_inst ( .clk      (clk)
         ,.rst      (rst)
         ,.mat_a    (mat_a)
         ,.vect_b   (vect_b)
         ,.count    (count)
         ,.wr_count (wr_count)
         ,.result   (result)
         );

//matrix vector multiplier fsm
mv_fsm
         # ( .N          (N)
            ,.DW         (DW)
            ,.BRAM_DEPTH (BRAM_DEPTH))
mvfsm_inst ( .clk        (clk)
            ,.rst        (rst)
            ,.mem_wr_en  (mem_wr_en)
            ,.rd_addr    (rd_addr)
            ,.wr_addr    (wr_addr)
            ,.wr_count   (wr_count)
            ,.start      (start)
            ,.count      (count)
            );

endmodule
