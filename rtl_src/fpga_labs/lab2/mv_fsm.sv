module mv_fsm
  # (parameter N=4,                                //number of elements in a vector
               DW=2)
    (input clk,
     input rst,
     output logic mem_wr_en,
     output logic [$clog2(N)-1:0] rd_addr,
     output logic [$clog2(N)-1:0] wr_addr,
     input start,
     output logic init,
	 output logic shift_en
     );

logic [$clog2(N):0] wr_count_reg;
logic [$clog2(N):0] wr_count;

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

  // memory write enable
  assign mem_wr_en = (wr_count_reg != 0 && wr_count_reg != 4'd1) ? 1'b1 : 1'b0;

  // write counter
  always@(posedge clk) begin
    if (rst) begin
      wr_count <= 'b0;
    end else begin
      if (wr_count == N) wr_count <= 'b0;
      else if (wr_count == 0 && rd_addr != N) wr_count <= 'b0;
      else            wr_count <= wr_count + 1'b1;
    end
  end

  //wr count reg
  always@(posedge clk) begin
    if (rst) begin
      wr_count_reg <= 'b0;
    end else begin
      wr_count_reg <= wr_count;
    end
  end
  
  //shift enable
  always@(posedge clk) begin
    if (rst) begin
      shift_en <= 'b0;
    end else begin
	  if (wr_count == 1) shift_en <= 'b1;
	  else if (wr_count == N) shift_en <= 'b0;
    end
  end

  //write address
  always@(posedge clk)
  begin
    if (rst) begin
      wr_addr   <= 0;
    end else begin
      if (wr_count_reg != 0) wr_addr   <= wr_addr + 1'b1;
    end
  end

endmodule
