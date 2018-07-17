module mm_fsm
  # (parameter N=4,                                //number of elements in a vector
               DW=2,
               BRAM_DEPTH=32)                               //size of each element
    (input clk,
     input rst,
     output wire mem_wr_en,
     output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr,
     output reg [$clog2(BRAM_DEPTH)-1:0] wr_addr,
     output reg [$clog2(N):0] wr_count,
     input start,
     output reg [$clog2(N):0] count
     );

wire mem_rd_en;
reg [$clog2(N):0] wr_count_reg;


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


  // memory write enable
  assign mem_wr_en = wr_count_reg != 0 ? 1'b1 : 1'b0;

  // write counter
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      wr_count <= 'b0;
    end else begin
      if (wr_count == N) wr_count <= 'b0;
      else if (wr_count == 0 && count != N) wr_count <= 'b0;
      else            wr_count <= wr_count + 1'b1;
    end
  end

  //wr count reg
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      wr_count_reg <= 'b0;
    end else begin
      wr_count_reg <= wr_count;
    end
  end

  //write address
  always@(posedge clk or posedge rst)
  begin
    if (rst) begin
      wr_addr   <= 0;
    end else begin
      if (wr_count_reg != 0) wr_addr   <= wr_addr + 1'b1;
    end
  end

endmodule
