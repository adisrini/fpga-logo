`timescale 1 ns / 100 ps
module flush_logic_tb();
	reg [4:0] opcode;
	reg isNotEqual, isLessThan;
	wire flush;
	
	flush_logic fl(opcode, isNotEqual, isLessThan, flush);
	
	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of opcode %b, isNotEqual %b, isLessThan %b, flush %b", opcode, isNotEqual, isLessThan, flush); 
		opcode= 5'b00000;
		isNotEqual = 1'b0;
		isLessThan = 1'b0;
		#3000
		$stop;
	end
	always
		#20 opcode[0] = ~opcode[0];
	always
		#40 opcode[1] = ~opcode[1];
	always
		#80 opcode[2] = ~opcode[2];
	always
		#160 opcode[3] = ~opcode[3];
	always
		#320 opcode[4] = ~opcode[4];
	always
		#640 isNotEqual = ~isNotEqual;
	always
		#1280 isLessThan = ~isLessThan;

endmodule
