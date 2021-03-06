module mv_wrapper
  # (parameter N=2,                                //number of elements in a vector
               DW=8)
               
    (input clk,
     input rst,
     input start,
     input [DW-1:0] rom_mat_data [0:N-1],
     input [$clog2(N)-1:0] rom_mat_wr_addr [0:N-1],
     input [0:N-1] rom_mat_we,
     input [DW-1:0] rom_vec_data,
     input [$clog2(N)-1:0] rom_vec_wr_addr,
     input rom_vec_we,
     output logic [(2*DW + $clog2(N))-1:0] ram_data,
     input [$clog2(N)-1:0] ram_rd_addr
     );

logic [$clog2(N)-1:0] rd_addr;
logic [$clog2(N)-1:0] wr_addr;
logic mem_wr_en;
logic init;
logic shift_en;
logic [(2*DW + $clog2(N))-1:0] result;
logic [DW -1:0] mat_a [0:N-1];
logic [DW -1:0] vect_b;
genvar i;

//matrix "a" memory
generate
for (i=0; i<N; i=i+1) begin : mat_a_gen
localparam [7:0] index = "0"+i;
ram_mem
           # (  .DW(DW)
               ,.AW($clog2(N))
               ,.INIT_FILE({"../python/mv_test/mat_a_r",index,".hex"})
			   ,.mode("read"))
    rom_inst2 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_mat_wr_addr[i])
               ,.we      (rom_mat_we[i])
               ,.wr_data (rom_mat_data[i])
               ,.rd_data (mat_a[i]));
end
endgenerate

//vector "b" memory
ram_mem
           # (  .DW(DW)
               ,.AW($clog2(N))
               ,.INIT_FILE("../python/mv_test/vec_b.hex")
			   ,.mode("read"))
    rom_inst1 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_vec_wr_addr)
               ,.we      (rom_vec_we)
               ,.wr_data (rom_vec_data)
               ,.rd_data (vect_b));

//result vector memory
ram_mem
           # (  .N(N)
               ,.DW(2*DW + $clog2(N))
               ,.AW($clog2(N))
               ,.INIT_FILE("../python/mv_test/sim_res.hex")
			   ,.mode("write"))
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
         ,.init     (init)
         ,.shift_en (shift_en)
         ,.result   (result)
         );

//matrix vector multiplier fsm
mv_fsm
         # ( .N          (N)
            ,.DW         (DW))
mvfsm_inst ( .clk        (clk)
            ,.rst        (rst)
            ,.mem_wr_en  (mem_wr_en)
            ,.rd_addr    (rd_addr)
            ,.wr_addr    (wr_addr)
            ,.start      (start)
            ,.init       (init)
            ,.shift_en   (shift_en)
            );

endmodule
