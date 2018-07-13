`timescale 1ps/1ps
`define DATA_WIDTH 4
`define NUM_ELEMS 4 
`define MEM_DEPTH  32
`define AW $clog2(`MEM_DEPTH)

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
wire [`DATA_WIDTH-1:0] mem_data;
// data memory
memory
           # (  .DW(`DATA_WIDTH)
               ,.AW(`AW))
    rom_inst (  .clk(tb_clk)
               ,.rd_addr(rd_addr)
               ,.wr_addr()
               ,.we()
               ,.wr_data()
               ,.rd_data(mem_data));

vm_wrapper #(
         .DW(`DATA_WIDTH)
        ,.N(`NUM_ELEMS)
        ) dut (
         .clk(tb_clk)
        ,.rst(tb_rst)
        ,.result(outp)
        ,.vect_a(mem_data)
        ,.vect_b(mem_data)
        ,.mem_rd_en()
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

// display inputs and output on each clock cycle
always @(posedge tb_clk) begin
    $display(" => outp = ", outp);
end

endmodule
