module mat_vect_mult
  # (parameter N=3,                                //number of elements in a vector
               DW=8)                               //size of each element
    (input clk,
     input rst,
     input [DW -1:0] mat_a [0:N-1],
     input [DW -1:0] vect_b,
     input [$clog2(N):0] count,
     input [$clog2(N):0] wr_count,
     output wire [(2*DW + $clog2(N))-1:0] result
     );

genvar i,j;
wire [(2*DW + $clog2(N))-1:0] vv_oup [0:N-1];
wire [(2*DW + $clog2(N))-1:0] mux_op [0:N-2];
wire sel [0:N-2];
reg [(2*DW + $clog2(N))-1:0] mux_op_reg [0:N-1];

//matrix vector multiplier logic
generate
for (i=0; i<N; i=i+1) begin : gen_vv
vector_mult
      # ( .N(N)
         ,.DW(DW))
vv_inst ( .clk      (clk)
         ,.rst      (rst)
         ,.result   (vv_oup[i])
         ,.vect_a   (mat_a[i])
         ,.vect_b   (vect_b)
         ,.count    (count)
         );
end
endgenerate

  //mux reg generate
  generate
  for (j=0; j<N-1; j=j+1) begin : gen_mux
    assign mux_op[j] = sel[j] ? mux_op_reg[j+1] : vv_oup[j];
    assign sel[j] = (wr_count != 0) && (wr_count != 1);
    always@(posedge clk)
      mux_op_reg[j] <= mux_op[j];
  end
  endgenerate

  always@(posedge clk)
    mux_op_reg[N-1] <= vv_oup[N-1];

    assign result = mux_op_reg[0];


endmodule
