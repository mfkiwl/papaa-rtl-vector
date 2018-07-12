module vector_mult
  # (parameter N=4,
               DW=2 )
    (input clk,
     input rst,
     output reg [(2*DW + $clog2(N))-1:0] result,
     input [DW -1:0] vect_a,
     input [DW -1:0] vect_b,
     input [$clog2(N):0] count
     );

//MAC
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    result   <= 0;
  end else begin
    if (count <= 1) result <= vect_a*vect_b;
    else            result <= result + vect_a*vect_b;
  end
end

endmodule