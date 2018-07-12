module matrix_matrix
  # (parameter N=4,                                //number of elements in a vector
               DW=2,
               BRAM_DEPTH=32)                               //size of each element
    (input clk,
     input rst,
     output wire [(2*DW + $clog2(N))-1:0] result [0:N-1],
     input [DW -1:0] mat_a [0:N-1],
     input [DW -1:0] mat_b [0:N-1] [0:N-1],
     input [0:N-1] vect_valid,
     output wire mem_rd_en [0:N-1],
     output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr[0:N-1],
     output wire mem_wr_en[0:N-1],
     output reg [$clog2(BRAM_DEPTH)-1:0] wr_addr [0:N-1]
     );


genvar i;

generate
for (i=0; i<N; i=i+1) begin : gen_mv
matrix_vect
         # ( .N          (N)
            ,.DW         (DW)
            ,.BRAM_DEPTH (BRAM_DEPTH))
  mv_inst  ( .clk        (clk)
            ,.rst        (rst)
            ,.result     (result[i])
            ,.vect_a     (mat_a[i])
            ,.mat_b      (mat_b[i])
            ,.vect_valid (vect_valid[i])
            ,.mem_rd_en  (mem_rd_en[i])
            ,.rd_addr    (rd_addr[i])
            ,.mem_wr_en  (mem_wr_en[i])
            ,.wr_addr    (wr_addr[i])
     );
end
endgenerate

endmodule