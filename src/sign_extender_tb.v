`timescale 1 ns / 100 ps
module sign_extender_tb();
	reg [16:0] data_input;
	wire [31:0] data_output;
	
	sign_extender sx(data_input, data_output);
	
	initial
	begin
		$monitor("%b %b", data_input, data_output);
		data_input = 17'b00000000000000000;
		#25
		data_input = 17'b00100110110100100;
		#25
		data_input = 17'b10100110110100100;
		#25
		$stop;
	end

endmodule
