module mm_wrapper
  # (parameter N=4,                                //number of elements in a vector
               DW=2,
               BRAM_DEPTH=32)                               //size of each element
    (input clk,
     input rst,
     input start
     );

wire [DW -1:0] mat_a [0:N-1];
wire [DW -1:0] mat_b [0:N-1];
wire [(2*DW + $clog2(N))-1:0] result [0:N-1];
wire [$clog2(BRAM_DEPTH)-1:0] rd_addr;
wire [$clog2(BRAM_DEPTH)-1:0] wr_addr;
wire mem_wr_en;
wire [$clog2(N):0] count;
wire [$clog2(N):0] wr_count;

genvar i,j;
generate
for (i=0; i<N; i=i+1) begin : mat_gen
localparam [7:0] index = "0"+i;
//matrix "a" memory
rom_mem
           # (  .DW(DW)
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE({"../python/mm_test_10/mat_a_r",index,".hex"}))
    rom_inst1 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr ()
               ,.we      ()
               ,.wr_data ()
               ,.rd_data (mat_a[i]));

//matrix "b" memory
rom_mem
           # (  .DW(DW)
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE({"../python/mm_test_10/mat_b_c",index,".hex"}))
    rom_inst2 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr ()
               ,.we      ()
               ,.wr_data ()
               ,.rd_data (mat_b[i]));
			   
//result vector memory
ram_mem
           # (  .N(N)
               ,.DW(2*DW + $clog2(N))
               ,.AW($clog2(BRAM_DEPTH))
               ,.INIT_FILE({"../python/mm_test_10/sim_res_c",index,".hex"}))
    ram_inst3 ( .clk     (clk)
               ,.rd_addr ()
               ,.wr_addr (wr_addr)
               ,.we      (mem_wr_en)
               ,.wr_data (result[i])
               ,.rd_data ());
end
endgenerate

generate
for (j=0; j<N; j=j+1) begin : gen_mv
mat_vect_mult
          # ( .N        (N)
             ,.DW       (DW))
mvmult_inst ( .clk      (clk)
             ,.rst      (rst)
             ,.mat_a    (mat_a)
             ,.vect_b   (mat_b[j])
             ,.count    (count)
             ,.wr_count (wr_count)
             ,.result   (result[j])
             );
end
endgenerate

//matrix vector multiplier fsm
mm_fsm
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