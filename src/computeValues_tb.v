`timescale 1 ns/ 100 ps
module computeValues_tb();
		reg [31:0] instr;
		wire [4:0] rd, rs, rt, shamt, alu_op,opcode;
		wire [26:0] target;
		wire [1:0] zeroes_R;
		wire [16:0] immediate;
		wire [21:0] zeroes_J;
		
	computeValues cv(opcode, rd, rs, rt, shamt, alu_op, zeroes_R, immediate, target, zeroes_J, instr);
	
	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of instr %b, opcode %b, rd %b, rs %b, rt %b, shamt %b, alu_op %b, zeroes_R %b, immediate %b, target %b, zeroes_J %b",instr,opcode, rd, rs, rt, shamt, alu_op, zeroes_R, immediate, target, zeroes_J);
		instr = 32'h0000beef;
		#2500
		$stop;
	end
	
	always
		#10 instr[27] = ~instr[27];
	always
		#20 instr[28] = ~instr[28];
	always
		#40 instr[29] = ~instr[29];
	always
		#80 instr[30] = ~instr[30];
	always
		#160 instr[31] = ~instr[31];
endmodule