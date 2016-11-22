`timescale 1 ns/ 100 ps
module processorCont_tb();

	reg [31:0] opcode;
	reg clock, reset;

	wire [31:0] data_writeReg;

	processorCont pc(opcode, clock, reset,data_writeReg);
	
	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of opcode %b, clock %b, reset %b, and data_writeReg %b, rdst %b, memToReg %b, reg_we %b \n, mem_we %b, alu_imm %b, br %b, jump %b, not_jal %b, ALU_imB %b", opcode, clock,reset, pc.data_writeReg,pc.rdst, pc.memToReg, pc.reg_we, pc.mem_we, pc.alu_imm, pc.br, pc.jump, pc.not_jal,pc.aluImmB);
		opcode = 32'h2ffffe00;
		reset = 1;
		clock = 0;
		#20
		reset = 0;
		#1000
		$stop;
	end
	always
		#10 clock = ~clock;
	always
		#40 opcode[29] = ~opcode[29];
	always
		#40 opcode[27] = ~opcode[27];
endmodule