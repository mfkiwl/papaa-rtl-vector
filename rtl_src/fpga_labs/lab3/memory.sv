module memory
  # (parameter AW = 8,
               DW = 32)
    (clk,
     wr_data,
     rd_data,
     wr_addr,
     rd_addr,
     we);

input                       clk;
input [DW-1:0]              wr_data;
output reg [DW-1:0]         rd_data;
input [AW-1:0]              wr_addr;
input [AW-1:0]              rd_addr;
input                       we;

reg [DW-1:0] mem [2**AW-1:0];
initial $readmemh("data_file.x", mem);

always@(posedge clk) begin
  if (we) mem[wr_addr] <= wr_data;
  rd_data <= mem[rd_addr];
end

endmodule

