`timescale 1ps/1ps
`define DATA_WIDTH 8
`define NUM_ELEMS 4
`define MEM_DEPTH  32
`define AW $clog2(`MEM_DEPTH)

module vector_mult_tb ();

localparam TB_TIMEOUT    = 20*(`NUM_ELEMS+5);
localparam TB_CLK_PERIOD = 20;

initial  #(TB_TIMEOUT) $stop();

// clock
reg tb_clk = 1'b0;
reg tb_rst;
reg start;

always #(TB_CLK_PERIOD/2) tb_clk = ~tb_clk;

// DUT
vv_wrapper #(
         .DW(`DATA_WIDTH)
        ,.N(`NUM_ELEMS)
        ,.BRAM_DEPTH(`MEM_DEPTH)
        ) dut (
         .clk(tb_clk)
        ,.rst(tb_rst)
        ,.start(start)
		,.rom_vec_a_wr_addr(0)
		,.rom_vec_a_wr_data(0)
		,.rom_vec_a_we(0)
		,.rom_vec_b_wr_addr(0)
		,.rom_vec_b_wr_data(0)
		,.rom_vec_b_we(0)
		,.ram_rd_addr(0)
		,.ram_rd_data()
        );


initial begin
  tb_rst <= 1'b1;
  #12
  tb_rst <= 1'b0;
end

initial begin
  start <= 1'b1;
  #TB_TIMEOUT
  start <= 1'b0;
end

endmodule
