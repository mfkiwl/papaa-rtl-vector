module matrix_vect
  # (parameter N=4,                                //number of elements in a vector
               DW=2,
               BRAM_DEPTH=32)                               //size of each element
    (input clk,
     input rst,
     output wire [(2*DW + $clog2(N))-1:0] result,
     input [DW -1:0] vect_a,
     input [DW -1:0] mat_b [0:N-1],
     input vect_valid,
     output wire mem_rd_en,
     output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr,
     output wire mem_wr_en,
     output reg [$clog2(BRAM_DEPTH)-1:0] wr_addr
     );

reg [$clog2(N):0] count;
reg [$clog2(N):0] wr_count;
reg [$clog2(N):0] wr_count_reg;
wire [(2*DW + $clog2(N))-1:0] vv_oup [0:N-1];
wire [(2*DW + $clog2(N))-1:0] mux_op [0:N-2];
wire sel [0:N-2];
reg [(2*DW + $clog2(N))-1:0] mux_op_reg [0:N-1];

genvar i,j;

generate
for (i=0; i<N; i=i+1) begin : gen_vv
vector_mult
      # ( .N(N)
         ,.DW(DW))
vv_inst ( .clk      (clk)
         ,.rst      (rst)
         ,.result   (vv_oup[i])
         ,.vect_a   (vect_a)
         ,.vect_b   (mat_b[i])
         ,.count    (count)
         );
end
endgenerate

//counter
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    count <= 0;
  end else begin
    if (count == N)  count <= 0;
    else if (vect_valid) count <= count + 1;
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

  // memory read enable
  // always@(posedge clk or posedge rst) begin
    // if (rst) begin
      // mem_rd_en <= 'b1;
    // end else begin
      // if (count == N-1) mem_rd_en <= 'b0;
      // else              mem_rd_en <= 'b1;
    // end
  // end
  assign mem_rd_en = (count == N || !vect_valid) ? 1'b0 : 1'b1;


  // memory write enable
  assign mem_wr_en = wr_count_reg != 0 ? 1'b1 : 1'b0;

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

  assign result = mux_op_reg[0];


endmodule