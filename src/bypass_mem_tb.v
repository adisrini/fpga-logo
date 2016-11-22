`timescale 1 ns / 100 ps
module bypass_mem_tb();
	reg [4:0] opcode_WB, opcode_Mem;
	reg [4:0] rd_WB, rd_Mem;

	wire bypass_mem;

	bypass_mem bm(opcode_Mem, opcode_WB, rd_Mem, rd_WB, bypass_mem);

	initial
		begin
		$display($time, "<<Starting the simulation>> ");
		opcode_WB = 5'b00000;
		opcode_Mem = 5'b00000;
		rd_WB = 5'b00000;
		rd_Mem = 5'b00000;
		#1100000
		$stop;
		end
	always
		#20 opcode_WB = opcode_WB + 1;
	always
		#40 opcode_Mem = opcode_Mem + 1;
	always
		#80 rd_Mem = rd_Mem + 1;
	always
		#160 rd_WB = rd_WB + 1;
endmodule
