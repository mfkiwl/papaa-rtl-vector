////////////////////// DESCRIPTION ////////////////////////////
// This is a verilog testbench to test "vector_mult.v" module
// which is instantiated inside "lab1_test.v" module.
//
// NOTE: The "vector_mult.v" is a combinational design and we
// are feeding the input to this module sequentially on every
// clock cycle using the "lab1_test.v" module.
//
// Author       : Tushar Garg
// Organization : University of Waterloo, 20703677
///////////////////////////////////////////////////////////////

`timescale 1ps/1ps
`define DATA_WIDTH 4
`define NUM_ELEMS  4
`define MEM_DEPTH  32
`define AW $clog2(`MEM_DEPTH)

module mv_mult_tb ();

// The test bench runs for 50 clock-cycles with the current settings
// modify TB_TIMEOUT to run longer
localparam TB_TIMEOUT    = 1000;
localparam TB_CLK_PERIOD = 20;

initial  #(TB_TIMEOUT) $stop();

// clock
reg tb_clk = 1'b0;
reg tb_rst;

always #(TB_CLK_PERIOD/2) tb_clk = ~tb_clk;

// DUT
wire [(2*`DATA_WIDTH + $clog2(`NUM_ELEMS)) - 1  : 0] outp;
wire [$clog2(`MEM_DEPTH)-1:0] rd_addr;
wire [$clog2(`MEM_DEPTH)-1:0] wr_addr [0:`NUM_ELEMS-1];
wire rd_en;
wire [`DATA_WIDTH-1:0] vect_a;
wire [`DATA_WIDTH-1:0] mat_b [0:`NUM_ELEMS-1];

// vect memory
memory
           # (  .DW(`DATA_WIDTH)
               ,.AW(`AW))
    rom_inst (  .clk(tb_clk)
               ,.rd_addr(rd_addr)
               ,.wr_addr()
               ,.we()
               ,.wr_data()
               ,.rd_data(vect_a));

genvar i;
generate
for (i=0; i<`NUM_ELEMS; i=i+1) begin : gen_mem
memory
           # (  .DW(`DATA_WIDTH)
               ,.AW(`AW))
    rom_inst (  .clk(tb_clk)
               ,.rd_addr(rd_addr)
               ,.wr_addr()
               ,.we()
               ,.wr_data()
               ,.rd_data(mat_b[i]));
end
endgenerate

matrix_vect #(
         .DW(`DATA_WIDTH)
        ,.N(`NUM_ELEMS)
        ) dut (
         .clk(tb_clk)
        ,.rst(tb_rst)
        ,.result()
        ,.vect_a(vect_a)
        ,.mat_b(mat_b)
        ,.mem_rd_en(rd_en)
        ,.vect_valid(1'b1)
        ,.rd_addr(rd_addr)
        ,.mem_wr_en()
        ,.wr_addr()
        );


initial begin
  tb_rst <= 1'b1;
  #12
  tb_rst <= 1'b0;
end


endmodule