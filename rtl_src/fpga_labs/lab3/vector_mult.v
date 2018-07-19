module vector_mult
  # (parameter N=4,
               DW=2 )
    (input clk,
     input rst,
     output reg [(2*DW + $clog2(N))-1:0] result,
     input [DW -1:0] vect_a,
     input [DW -1:0] vect_b,
     input init
     );

//MAC
always@(posedge clk)
begin
  if (rst) begin
    result   <= 0;
  end else begin
    if (init) result <= vect_a*vect_b;
    else      result <= result + vect_a*vect_b;
  end
end

endmodule