module vv_fsm
  # (parameter N=4,
               BRAM_DEPTH = 32)
    (input clk,
     input rst,
     input start,
     output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr,
     output reg mem_wr_en,
     output reg [$clog2(BRAM_DEPTH)-1:0] wr_addr,
     output reg [$clog2(N):0] count
     );

wire mem_rd_en;

//counter
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    count <= 0;
  end else begin
    if (count == N)  count <= 0;
    else if (start) count <= count + 1;
  end
end

//read address
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    rd_addr   <= 0;
  end else begin
    if (mem_rd_en) rd_addr   <= rd_addr + 1'b1;
  end
end

 assign mem_rd_en = (count == N || !start) ? 1'b0 : 1'b1;

// write enable
always@(posedge clk or posedge rst) begin
  if (rst) begin
    mem_wr_en <= 'b0;
  end else begin
    if (count == N) mem_wr_en <= 'b1;
    else            mem_wr_en <= 'b0;
  end
end

//write address
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    wr_addr   <= 0;
  end else begin
    if (mem_wr_en) wr_addr   <= wr_addr + 1'b1;
  end
end


endmodule
