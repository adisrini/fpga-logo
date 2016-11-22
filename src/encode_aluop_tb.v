`timescale 1 ns/ 100 ps
module encode_aluop_tb();
	reg [31:0] instruction;
	wire [4:0] alu_op;
		
	encode_ALUop enc(instruction, alu_op); 
	
	initial
	begin
		$monitor("%b %b",instruction, alu_op);
		instruction = 32'h0000beef;
		#2500
		$stop;
	end
	
	always
		#10 instruction[27] = ~instruction[27];
	always
		#20 instruction[28] = ~instruction[28];
	always
		#40 instruction[29] = ~instruction[29];
	always
		#80 instruction[30] = ~instruction[30];
	always
		#160 instruction[31] = ~instruction[31];
		
endmodule
