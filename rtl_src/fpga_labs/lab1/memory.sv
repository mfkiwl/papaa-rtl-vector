module memory
     # (parameter n=4,                                //number of elements in a vector
                  dw=2,
		    	  depth=16)
		(input clk, input [$clog2(depth)-1:0] addr, input enable,
		 input rd_en, output logic [dw-1:0] data_out=0);

    reg[dw-1:0] data [0:depth-1];
    initial $readmemh("data_file.x", data);

	always @(posedge clk)
	begin
		data_out <= data[addr];
	end

endmodule
