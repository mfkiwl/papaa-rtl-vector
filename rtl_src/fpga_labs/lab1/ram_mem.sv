`timescale 1ps/1ps

module ram_mem
  # (parameter N = 4,
               AW = 8,
               DW = 32,
               INIT_FILE = "abc.hex")
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
integer f;
localparam FILE_TIMEOUT    = 20*(N+4);

reg [DW-1:0] mem [2**AW-1:0];

initial f = $fopen(INIT_FILE,"w");
always@(posedge clk) begin
  if (we) mem[wr_addr] <= wr_data;
  rd_data <= mem[rd_addr];
end

//write to file
always@(posedge clk) begin
  if (we) begin
    $fwrite (f,"%0h",wr_data);
	$display ("entered this blk");
  end
end

initial #FILE_TIMEOUT $fclose(f);


endmodule

