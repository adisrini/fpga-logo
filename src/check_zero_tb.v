`timescale 1 ns / 100 ps
module check_zero_tb();
	reg [26:0] in;
	wire out;
	
	is_zero27bits iz(in, out);
	
	initial
	begin
	$monitor("%d %b", in, out);
	in = 27'b0;
	#500
	$stop;
	end
	always
	#20 in = in + 1;
	
endmodule