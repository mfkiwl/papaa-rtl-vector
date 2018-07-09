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

module vector_mult_tb ();

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
wire [$clog2(`MEM_DEPTH)-1:0] rd_addr, wr_addr;
wire rd_en;
wire [`DATA_WIDTH-1:0] mem_data;
// data memory
memory
           # (.n(`NUM_ELEMS)
               ,.dw(`DATA_WIDTH)
		       ,.depth(`MEM_DEPTH))
    rom_inst (  .clk(tb_clk)
	           ,.addr(rd_addr)
			   ,.enable(~tb_rst) //rst is active low
			   ,.rd_en(rd_en)
		       ,.data_out(mem_data));

vector_mult #(
         .DW(`DATA_WIDTH)
        ,.N(`NUM_ELEMS)
        ) dut (
         .clk(tb_clk)
        ,.rst(tb_rst)
        ,.result(outp)
        ,.vect_a(mem_data)
        ,.vect_b(mem_data)
		,.mem_rd_en(rd_en)
		,.rd_addr(rd_addr)
		,.mem_wr_en()
		,.wr_addr()
        );
		
	
initial begin
  tb_rst <= 1'b1;
  #12
  tb_rst <= 1'b0;
end

// display inputs and output on each clock cycle
always @(posedge tb_clk) begin
    $display(" => outp = ", outp);
end

endmodule