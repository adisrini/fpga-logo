`timescale 1 ns / 100 ps
module shift8bitena_tb();
	reg [31:0] data_input;
	reg ctrl_shiftdirection, ena;
	wire [31:0] data_output;
	
	shift8bitena sh8(data_input, ctrl_shiftdirection, ena, data_output);
	
	initial
	begin
		$monitor("%b %b %b", data_input, ena, data_output);
		data_input = 32'b000011010110000110100110;
		ctrl_shiftdirection = 1'b0;
		ena = 1'b0;
		#300
		$stop;
	end
	
	always
		#10 ena = ~ena;


endmodule
