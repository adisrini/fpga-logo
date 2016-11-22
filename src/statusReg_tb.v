`timescale 1 ns/ 100 ps
module statusReg_tb();

	reg [4:0] opcode, alu_code;
	reg [26:0] target;
	reg overflow;
	wire [26:0] statusOut;

	statusReg sr(statusOut, opcode, alu_code, target, overflow);

	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of statusOut %d, opcode %d, alu_code %d, target %d, overflow %d" ,statusOut, opcode, alu_code, target, overflow);
		target = 26'b11110001;
		alu_code = 5'b00000;
		opcode = 5'b00000;
		overflow = 1'b0;
		#8000
		$stop;
	end
		always
			#20 overflow = ~overflow;
		always
			#40 alu_code = alu_code + 1;
		always
			#1280 opcode = opcode + 21;
endmodule
