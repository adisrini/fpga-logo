`timescale 1 ns/ 100 ps
module signExt15_tb();


	reg [16:0] in;
	wire [31:0] out;
	
	signExt15 se(out, in);

	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of in %b and out %b ", in, out);
		in = 17'd350;
		#1500
		$stop;
	end
	always
		#20 in[16] = ~in[16];
endmodule