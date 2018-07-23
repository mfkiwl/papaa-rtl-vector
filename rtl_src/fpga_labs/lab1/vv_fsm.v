module vv_fsm
  # (parameter N=4,
               BRAM_DEPTH = 32)
    (input clk,
     input rst,
     input start,
     output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr,
     output reg mem_wr_en,
     output reg init
     );


// insert code here

endmodule
