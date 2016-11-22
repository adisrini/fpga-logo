`timescale 1 ns / 100 ps
module jump_addresser_tb();
	reg [26:0] jump_address;
	reg [31:0] PC_address;
	wire [31:0] output_address;
	
	jump_addresser ja(jump_address, PC_address, output_address);
	
	initial
	begin
		$monitor("%b %b %b", jump_address, PC_address, output_address);
		jump_address = 27'b010000000010010010100101001;
		PC_address = 32'b11111000000000000000000000000000;
		#100
		$stop;
	end
		
endmodule
