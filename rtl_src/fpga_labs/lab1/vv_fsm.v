module vv_fsm
  # (parameter N=4,
               BRAM_DEPTH = 32)
    (input clk,
     input rst,
     input start,
     output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr,
     output reg mem_wr_en,
     output reg [$clog2(BRAM_DEPTH)-1:0] wr_addr,
     output reg init
     );


//init
always@(posedge clk)
begin
  if (rst) begin
    init <= 0;
  end else begin
    if (start && rd_addr == 0) init <= 1;
	else init <= 0;
  end
end

//read address
always@(posedge clk)
begin
  if (rst) begin
    rd_addr   <= 0;
  end else begin
    if (start && rd_addr < N) rd_addr   <= rd_addr + 1'b1;
	else if (rd_addr == N) rd_addr <= 0;
  end
end

// write enable
always@(posedge clk) begin
  if (rst) begin
    mem_wr_en <= 'b0;
  end else begin
    if (rd_addr == N) mem_wr_en <= 'b1;
    else              mem_wr_en <= 'b0;
  end
end

//write address
always@(posedge clk)
begin
  if (rst) begin
    wr_addr   <= 0;
  end else begin
    if (mem_wr_en) wr_addr   <= wr_addr + 1'b1;
  end
end


endmodule
