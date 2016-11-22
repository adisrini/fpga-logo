`timescale 1 ns/ 100 ps
module stall_logic_tb();

	reg [4:0] opcodeA, opcodeB, alu_opcodeA, alu_opcodeB, a_write, b_read1, b_read2;
	reg is_not_noop;
	wire stallLW;
	
	stall_logic sl(is_not_noop, opcodeA, opcodeB, alu_opcodeA, alu_opcodeB, a_write, b_read2, b_read1, stallLW);
	
	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of  opcode_A %b, opcode_B %b, alu_codeA %b, alu_codeB %b, a_write %b, b_read1 %b, b_read2 %b, stallLW %b", opcodeA, opcodeB, alu_opcodeA, alu_opcodeB, a_write, b_read1, b_read2, stallLW);
		opcodeA = 5'b00000;
		opcodeB = 5'b00000;
		alu_opcodeA = 5'b00000;
		alu_opcodeB = 5'b00000;
		a_write = 5'b00000;
		b_read1 = 5'b00000;
		b_read2 = 5'b11111;
		is_not_noop = 1'b1;
		#164480
		$stop;
	end
		always
			#20 opcodeA[0] = ~opcodeA[0];
		always
			#40 opcodeA[1] = ~opcodeA[1];
		always
			#80 opcodeA[2] = ~opcodeA[2];
		always
			#160 opcodeB[0] = ~opcodeB[0];
		always
			#320 opcodeB[1] = ~opcodeB[1];
		always
			#640 opcodeB[2] = ~opcodeB[2];
		always
			#1280 alu_opcodeA[0] = ~alu_opcodeA[0];
		always
			#2560 alu_opcodeA[1] = ~alu_opcodeA[1];
		always
			#5120 alu_opcodeA[2] = ~alu_opcodeA[2];
		always
			#10240 alu_opcodeB[0] = ~alu_opcodeB[0];
		always
			#20480 alu_opcodeB[1] = ~alu_opcodeB[1];
		always
			#40960 alu_opcodeB[2] = ~alu_opcodeB[2];
		always
			#81920 b_read1 = ~b_read1;
		always
			#81920 b_read2 = ~b_read2;
endmodule
