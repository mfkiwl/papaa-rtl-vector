`timescale 1ps/1ps
`define DATA_WIDTH 8
`define NUM_ELEMS  10
`define MEM_DEPTH  16
`define AW $clog2(`MEM_DEPTH)

module mm_mult_tb ();

// The test bench runs for 50 clock-cycles with the current settings
// modify TB_TIMEOUT to run longer
localparam TB_TIMEOUT    = 20*(2*`NUM_ELEMS+3);
localparam TB_CLK_PERIOD = 20;

initial  #(TB_TIMEOUT) $stop();

// clock
reg tb_clk = 1'b0;
reg tb_rst;
reg start;

always #(TB_CLK_PERIOD/2) tb_clk = ~tb_clk;

// DUT
mm_wrapper #(
         .DW(`DATA_WIDTH)
        ,.N(`NUM_ELEMS)
        ,.BRAM_DEPTH(`MEM_DEPTH)
        ) dut (
         .clk(tb_clk)
        ,.rst(tb_rst)
        ,.start(start)
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