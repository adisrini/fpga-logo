`timescale 1 ns/ 100 ps
module instControl_tb();

	reg [4:0] opcode;
	
	wire rs_rd1, rt_rs2, memToReg, reg_we, mem_we, alu_imm, br, jump, jal_ctrl, jr_ctrl, bne_blt;
	
	//control bits
	
	instControl ic(opcode, rs_rd1, rt_rs2, memToReg, reg_we, mem_we, alu_imm, br, jump, jal_ctrl, jr_ctrl, bne_blt);
	
	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of opcode %b , rs_rd1 %b, rt_rs2 %b, memToReg %b, reg_we %b, mem_we %b, alu_imm %b, br %b, jump %b, jal_ctrl %b, jr_ctrl %b, bne_blt %b", opcode, rs_rd1, rt_rs2, memToReg, reg_we, mem_we, alu_imm, br, jump, jal_ctrl, jr_ctrl, bne_blt);
		opcode = 5'b00000;
		#1500
		$stop;
	end
	always
		#10 opcode[0] = ~opcode[0];
	always
		#20 opcode[1] = ~opcode[1];
	always
		#40 opcode[2] = ~opcode[2];
	always
		#80 opcode[3] = ~opcode[3];
	always
		#160 opcode[4] = ~opcode[4];
endmodule