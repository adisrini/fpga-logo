`timescale 1 ns / 100 ps
module instruction_splitter_tb();
	reg [31:0] data_instruction;
	wire [4:0] data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop;
	wire [16:0] data_immediate;
	wire [26:0] data_target;
	
	instruction_splitter is(data_instruction, data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop, data_immediate, data_target);
	
	initial
	begin
		$monitor("%b %b %b %b %b %b %b %b %b", data_instruction, data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop, data_immediate, data_target);
		
		data_instruction = 32'b01101001010100100101001010101001;
		#100
		$stop;
	end
	
	always
		#10
		data_instruction = data_instruction + 32'b00000000000000000000000000101100;
		
endmodule
