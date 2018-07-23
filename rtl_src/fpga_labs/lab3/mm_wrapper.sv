module mm_wrapper
  # (parameter N=4,                                //number of elements in a vector
               DW=2)
    (input clk,
     input rst,
     input start,
     input [DW-1:0] rom_mat_a_data[0:N-1],
     input [DW-1:0] rom_mat_b_data[0:N-1],
     input [$clog2(N)-1:0] rom_mat_a_wr_addr[0:N-1],
     input [$clog2(N)-1:0] rom_mat_b_wr_addr[0:N-1],
     input [0:N-1] rom_mat_a_we,
     input [0:N-1] rom_mat_b_we,
     output logic [(2*DW + $clog2(N))-1:0] ram_data [0:N-1],
     input [$clog2(N)-1:0] ram_rd_addr[0:N-1]
     );

logic [DW -1:0] mat_a [0:N-1];
logic [DW -1:0] mat_b [0:N-1];
logic [(2*DW + $clog2(N))-1:0] result [0:N-1];
logic [$clog2(N)-1:0] rd_addr;
logic [$clog2(N)-1:0] wr_addr;
logic mem_wr_en;
logic init;
logic shift_en;

genvar i,j;
generate
for (i=0; i<N; i=i+1) begin : mat_gen
localparam [7:0] index = "0"+i;
//matrix "a" memory
ram_mem
           # (  .DW(DW)
               ,.AW($clog2(N))
               ,.INIT_FILE({"../python/mm_test/mat_a_r",index,".hex"})
			   ,.mode("read"))
    rom_inst1 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_mat_a_wr_addr[i])
               ,.we      (rom_mat_a_we[i])
               ,.wr_data (rom_mat_a_data[i])
               ,.rd_data (mat_a[i]));

//matrix "b" memory
ram_mem
           # (  .DW(DW)
               ,.AW($clog2(N))
               ,.INIT_FILE({"../python/mm_test/mat_b_c",index,".hex"})
			   ,.mode("read"))
    rom_inst2 ( .clk     (clk)
               ,.rd_addr (rd_addr)
               ,.wr_addr (rom_mat_b_wr_addr[i])
               ,.we      (rom_mat_b_we[i])
               ,.wr_data (rom_mat_b_data[i])
               ,.rd_data (mat_b[i]));
			   
//result vector memory
ram_mem
           # (  .N(N)
               ,.DW(2*DW + $clog2(N))
               ,.AW($clog2(N))
               ,.INIT_FILE({"../python/mm_test/sim_res_c",index,".hex"})
			   ,.mode("write") )
    ram_inst3 ( .clk     (clk)
               ,.rd_addr (ram_rd_addr[i])
               ,.wr_addr (wr_addr)
               ,.we      (mem_wr_en)
               ,.wr_data (result[i])
               ,.rd_data (ram_data[i]));
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
             ,.init     (init)
             ,.shift_en (shift_en)
             ,.result   (result[j])
             );
end
endgenerate

//matrix matrix multiplier fsm
mm_fsm
         # ( .N          (N)
            ,.DW         (DW) )
mmfsm_inst ( .clk        (clk)
            ,.rst        (rst)
            ,.mem_wr_en  (mem_wr_en)
            ,.rd_addr    (rd_addr)
            ,.wr_addr    (wr_addr)
            ,.start      (start)
            ,.init       (init)
            ,.shift_en   (shift_en)
            );

endmodule
