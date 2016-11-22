module processor(clock, reset, /*ps2_key_pressed, ps2_out, lcd_write, lcd_data,*/ debug_data_in, debug_address);

	input 			clock, reset/*, ps2_key_pressed*/;
	//input 	[7:0]	ps2_out;
	
	//output 			lcd_write;
	//output 	[31:0] 	lcd_data;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
	output 	[31:0] 	debug_data_in;
	output	[11:0]	debug_address;
	
	
	// your processor here
	//
	
	// SPLITTING INSTRUCTION
	wire [31:0] instruction;
	wire [4:0] data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop;
	wire [16:0] data_immediate;
	wire [26:0] data_target;
	instruction_splitter is(instruction, data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop, data_immediate, data_target);
	
	// CONTROLS
	wire [4:0] ctrl_ALUop;
	wire ctrl_JR, ctrl_JAL, ctrl_DMWE, ctrl_RWd, ctrl_READ1, ctrl_READ2, ctrl_BNE, ctrl_BLT, ctrl_J, ctrl_ALUin, ctrl_RegW, ctrl_SWE;
	
	control ctrl(instruction, ctrl_ALUop, ctrl_JR, ctrl_JAL, ctrl_DMWE, ctrl_RWd, ctrl_READ1, ctrl_READ2, ctrl_BNE, ctrl_BLT, ctrl_J, ctrl_ALUin, ctrl_RegW, ctrl_SWE);
	
	// AUXILLIARY
	wire [31:0] extended_immediate;
	wire [26:0] status_in, status_out;
	sign_extender sx(data_immediate, extended_immediate);
	register27 rg_sts(clock, ctrl_SWE, reset, status_in, status_out); 
	
	// Program Counter
	wire [31:0] data_PC, data_NEXT_PC, data_PC_PLUS_ONE, data_JUMP_PC, data_BRANCH_PC;
	register pc(clock, 1'b1, reset, data_NEXT_PC, data_PC);
	
	// PC = PC + 1
	wire ignore0, ignore1, ignore2;
	wire [31:0] ignore3, ignore4;
	cla add1(data_PC, 32'b1, 1'b0, data_PC_PLUS_ONE, ignore0, ignore1, ignore2, ignore3, ignore4);
	
	// Jump and Branch addresses
	wire ignore5, ignore6, ignore7;
	wire [31:0] ignore8, ignore9;
	jump_addresser ja(data_target, data_PC, data_JUMP_PC);
	cla branch_addresser(extended_immediate, data_PC_PLUS_ONE, 1'b0, data_BRANCH_PC, ignore5, ignore6, ignore7, ignore8, ignore9);
	
	// ALU
	wire [31:0] data_readRegA, data_readRegB;
	wire [31:0] alu_operandA, alu_operandB, alu_result;
	wire isNotEqual, isLessThan, overflow;
	assign_alu_operands asgn0(data_readRegA, data_readRegB, extended_immediate, ctrl_ALUin, alu_operandA, alu_operandB);
	
	as577_alu alu(alu_operandA, alu_operandB, ctrl_ALUop, data_shamt, alu_result, isNotEqual, isLessThan, overflow);
	
	// ASSIGN STATUS
	assign_status asgn_sts(data_instruction, overflow, status_in);
	
	// FIND NEXT PC
	next_PC nx(data_PC_PLUS_ONE, data_BRANCH_PC, data_JUMP_PC, ctrl_BNE, ctrl_BLT, isNotEqual, isLessThan, data_readRegA, ctrl_JR, ctrl_J, ctrl_JAL, data_NEXT_PC);
	
	// REGISTER WRITE DATA
	wire [31:0] data_writeReg;
	wire [31:0] data_dmem_out;
	assign_reg_write asgn1(alu_result, data_dmem_out, data_PC_PLUS_ONE, ctrl_RWd, ctrl_JAL, data_writeReg);
	
	// REGISTER FILE
	wire [4:0] ctrl_WRITE_REG, ctrl_READ_REG1, ctrl_READ_REG2;
	assign_registers asgn2(data_rd, data_rs, data_rt, ctrl_READ1, ctrl_READ2, ctrl_JAL, ctrl_WRITE_REG, ctrl_READ_REG1, ctrl_READ_REG2);
	
	// TEMP
	wire [1023:0] allData;
	
	regfile_as577 rgfile(clock, ctrl_RegW, reset, ctrl_WRITE_REG, ctrl_READ_REG1, ctrl_READ_REG2, data_writeReg, data_readRegA, data_readRegB, allData);
	
	wire signed [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
	
	assign reg0 = allData[31:0];
	assign reg1 = allData[63:32];
	assign reg2 = allData[95:64];
	assign reg3 = allData[127:96];
	assign reg4 = allData[159:128];
	assign reg5 = allData[191:160];
	assign reg6 = allData[223:192];
	assign reg7 = allData[255:224];
	assign reg8 = allData[287:256];
	assign reg9 = allData[319:288];
	assign reg10 = allData[351:320];
	assign reg11 = allData[383:352];
	assign reg12 = allData[415:384];
	assign reg13 = allData[447:416];
	assign reg14 = allData[479:448];
	assign reg15 = allData[511:480];
	assign reg16 = allData[543:512];
	assign reg17 = allData[575:544];
	assign reg18 = allData[607:576];
	assign reg19 = allData[639:608];
	assign reg20 = allData[671:640];
	assign reg21 = allData[703:672];
	assign reg22 = allData[735:704];
	assign reg23 = allData[767:736];
	assign reg24 = allData[799:768];
	assign reg25 = allData[831:800];
	assign reg26 = allData[863:832];
	assign reg27 = allData[895:864];
	assign reg28 = allData[927:896];
	assign reg29 = allData[959:928];
	assign reg30 = allData[991:960];
	assign reg31 = allData[1023:992];

	
	//////////////////////////////////////
	////// THIS IS REQUIRED FOR GRADING
	// CHANGE THIS TO ASSIGN YOUR DMEM WRITE ADDRESS ALSO TO debug_addr
	assign debug_data_in = data_readRegA;
	// CHANGE THIS TO ASSIGN YOUR DMEM DATA INPUT (TO BE WRITTEN) ALSO TO debug_data
	assign debug_address = alu_result[11:0];
	////////////////////////////////////////////////////////////
	
		
	// You'll need to change where the dmem and imem read and write...
	dmem mydmem(.address		(debug_address),
					.clock		(clock),
					.data			(debug_data_in),
					.wren			(ctrl_DMWE),
					.q				(data_dmem_out)
	);
	
	imem myimem(.address 	(data_NEXT_PC[11:0]),
					.clken		(1'b1),
					.clock		(clock),
					.q				(instruction)
	);
	
endmodule

module assign_status(data_instruction, data_overflow, data_status);
	input [31:0] data_instruction;
	input data_overflow;
	output [26:0] data_status;
	
	wire i_add, i_sub, i_mul, i_div, i_setx;
	
	assign i_add = ~data_instruction[2] & ~data_instruction[3] & ~data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_sub = data_instruction[2] & ~data_instruction[3] & ~data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_mul = ~data_instruction[2] & data_instruction[3] & data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_div = data_instruction[2] & data_instruction[3] & data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_setx = data_instruction[27] & ~data_instruction[28] & data_instruction[29] & ~data_instruction[30] & data_instruction[31];
	
	wire [26:0] inter0;
	
	assign inter0 = ((i_add | i_sub | i_mul | i_div) & data_overflow) ? 27'b1 : 27'b0;
	
	assign data_status = (i_setx) ? data_instruction[26:0] : inter0;
endmodule

// DETERMINES THE NEXT PC VALUE
module next_PC(data_PC_PLUS_ONE, data_BRANCH_PC, data_JUMP_PC, ctrl_BNE, ctrl_BLT, isNotEqual, isLessThan, data_readRegA, ctrl_JR, ctrl_J, ctrl_JAL, data_NEXT_PC);
	input [31:0] data_PC_PLUS_ONE, data_BRANCH_PC, data_JUMP_PC, data_readRegA;
	input ctrl_BNE, ctrl_BLT, isNotEqual, isLessThan, ctrl_JR, ctrl_J, ctrl_JAL;
	output [31:0] data_NEXT_PC;
	
	wire ctrl_BRANCH, ctrl_JUMP;
	assign ctrl_BRANCH = (ctrl_BNE & isNotEqual) | (ctrl_BLT & isLessThan);
	assign ctrl_JUMP = ctrl_JR | ctrl_J | ctrl_JAL;
	
	wire [31:0] inter0, inter1;
	assign inter0 = (ctrl_BRANCH) ? data_BRANCH_PC : data_PC_PLUS_ONE;
	assign inter1 = (ctrl_JUMP) ? data_JUMP_PC : inter0;
	assign data_NEXT_PC = (ctrl_JR) ? data_readRegA : inter1;
endmodule

// ASSIGNS REGISTER VALUE TO WRITE BASED ON CONTROLS
module assign_reg_write(alu_result, data_dmem_out, data_PC_PLUS_ONE, ctrl_RWd, ctrl_JAL, data_writeReg);
	input [31:0] alu_result, data_dmem_out, data_PC_PLUS_ONE;
	input ctrl_RWd, ctrl_JAL;
	output [31:0] data_writeReg;
	
	wire [31:0] intermediate;
	assign intermediate = (ctrl_RWd) ? data_dmem_out : alu_result;
	assign data_writeReg = (ctrl_JAL) ? data_PC_PLUS_ONE : intermediate;
endmodule

// ASSIGNS ALU OPERANDS BASED ON CONTROLS
module assign_alu_operands(data_readRegA, data_readRegB, extended_immediate, ctrl_ALUin, alu_operandA, alu_operandB);
	input [31:0] data_readRegA, data_readRegB, extended_immediate;
	input ctrl_ALUin;
	output [31:0] alu_operandA, alu_operandB;
	
	assign alu_operandA = data_readRegA;
	assign alu_operandB = (ctrl_ALUin) ? extended_immediate : data_readRegB;
endmodule

// ASSIGNS THE REGISTERS TO READ/WRITE BASED ON CONTROLS
module assign_registers(data_rd, data_rs, data_rt, ctrl_READ1, ctrl_READ2, ctrl_JAL, ctrl_WRITE_REG, ctrl_READ_REG1, ctrl_READ_REG2);
	input [4:0] data_rd, data_rs, data_rt;
	input ctrl_READ1, ctrl_READ2, ctrl_JAL;
	output [4:0] ctrl_WRITE_REG, ctrl_READ_REG1, ctrl_READ_REG2;
	
	assign ctrl_READ_REG1 = (ctrl_READ1) ? data_rd : data_rs;
	assign ctrl_READ_REG2 = (ctrl_READ2) ? data_rs : data_rt;
	assign ctrl_WRITE_REG = (ctrl_JAL) ? 5'b11111 : data_rd;
endmodule

// CONTROL
// TAKES OPCODE AND DETERMINES WHAT THE CONTROL SIGNALS SHOULD BE
module control(data_instruction, ctrl_ALUop, ctrl_JR, ctrl_JAL, ctrl_DMWE, ctrl_RWd, ctrl_READ1, ctrl_READ2, ctrl_BNE, ctrl_BLT, ctrl_J, ctrl_ALUin, ctrl_RegW, ctrl_SWE);
	input [31:0] data_instruction;
	output [4:0] ctrl_ALUop;
	output ctrl_JR, ctrl_JAL, ctrl_DMWE, ctrl_RWd, ctrl_READ1, ctrl_READ2, ctrl_BNE, ctrl_BLT, ctrl_J, ctrl_ALUin, ctrl_RegW, ctrl_SWE;
	
	wire i_arith, i_addi, i_sw, i_lw, i_j, i_bne, i_jal, i_jr, i_blt, i_bex, i_setx;
	
	opcode_decode dec(data_instruction[27 +: 5], i_arith, i_addi, i_sw, i_lw, i_j, i_bne, i_jal, i_jr, i_blt, i_bex, i_setx);
	
	// ALU operation assignment
	encode_ALUop enc(data_instruction, ctrl_ALUop);
	
	wire i_add, i_sub, i_mul, i_div;
	
	assign i_add = ~data_instruction[2] & ~data_instruction[3] & ~data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_sub = data_instruction[2] & ~data_instruction[3] & ~data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_mul = ~data_instruction[2] & data_instruction[3] & data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	assign i_div = data_instruction[2] & data_instruction[3] & data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
	
	// Trivial assignments
	assign ctrl_JR = i_jr;
	assign ctrl_JAL = i_jal;
	assign ctrl_J = i_j;
	assign ctrl_BNE = i_bne;
	assign ctrl_BLT = i_blt;
	assign ctrl_DMWE = i_sw;
	assign ctrl_RWd = i_lw;
	assign ctrl_SWE = i_addi | i_setx | (i_arith & (i_add | i_sub | i_mul | i_div));
	
	// Complex assignments
	assign ctrl_ALUin = i_addi | i_sw | i_lw;
	assign ctrl_RegW = i_arith | i_addi | i_lw | i_jal;
	assign ctrl_READ1 = i_sw | i_bne | i_blt | i_jr;// if high, choose $rd, else $rs
	assign ctrl_READ2 = i_sw | i_bne | i_blt;			// if high, choose $rs, else $rt
	
	// READ1:
	//		$rd: sw, bne, blt, jr
	//		$rs: everywhere else
	//
	// READ2:
	//		$rs: sw, bne, blt
	//		$rt: everywhere else
	
endmodule

// TAKES IN OPCODE AND OUTPUTS 1-HOT WIRE FOR ACTIVE INSTRUCTION
module opcode_decode(opcode, i_arith, i_addi, i_sw, i_lw, i_j, i_bne, i_jal, i_jr, i_blt, i_bex, i_setx);
	input [4:0] opcode;
	output i_arith, i_addi, i_sw, i_lw, i_j, i_bne, i_jal, i_jr, i_blt, i_bex, i_setx;
	
	// i_arith governs all ALU operations (add, sub, and, or, sll, sra, mul, div, and custom_r)
	assign i_arith = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	

	assign i_addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];
	
	assign i_sw = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & opcode[0];
	
	assign i_lw = ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	
	assign i_j = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];
	
	assign i_bne = ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0];
	
	assign i_jal = ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & opcode[0];

	assign i_jr = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & ~opcode[0];
	
	assign i_blt = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0];
	
	assign i_bex = opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0];
	
	assign i_setx = opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];
	
endmodule

// TAKES IN OPCODE AND OUTPUTS CORRECT ALU OPCODE (verified)
// NOTE: if opcode doesn't have a particular ALU op, it'll be 00000
module encode_ALUop(data_instruction, ctrl_ALUop);
	input [31:0] data_instruction;
	output [4:0] ctrl_ALUop;
	
	// Extract the opcode from instruction
	wire [4:0] opcode;
	assign opcode = data_instruction[27 +:	5];
	
	// Assign the options for ALU opcode
	wire [4:0] option_ALUop, option_SUB, option_ADD;
	assign option_ALUop = data_instruction[2 +: 5];
	assign option_SUB = 5'b00001;
	assign option_ADD = 5'b00000;
	
	// Determine select bits
	wire s0, s1;
	assign s1 = (opcode[0] & opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4]) | (opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4]) | (~opcode[0] & ~opcode[1] & ~opcode[2] & opcode[3] & ~opcode[4]) | (~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4]);
	assign s0 = (~opcode[0] & opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4]) | (~opcode[0] & opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4]) | (~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4]);
	
	// Select option based on select bits
	mux4_5bit mx(5'b00000, option_SUB, option_ADD, option_ALUop, s0, s1, ctrl_ALUop);
	
endmodule

// PADS THE JUMP ADDRESS FROM 27-BITS TO 32-BITS (verified)
module jump_addresser(data_jump_address, data_PC_address, data_output_address);
	input [26:0] data_jump_address;
	input [31:0] data_PC_address;
	output [31:0] data_output_address;
	
	assign data_output_address[0 +: 27] = data_jump_address;
	assign data_output_address[27 +: 5] = data_PC_address[27 +: 5];
endmodule

// SIGN EXTENDS 17-BIT INPUT TO 32-BIT OUTPUT (verified)
module sign_extender(data_input, data_output);
	input [16:0] data_input;
	output [31:0] data_output;
	
	wire msb = data_input[16];
	
	assign data_output[0 +: 17] = data_input[0 +: 17];

	genvar i;
	generate
		for(i = 17; i < 32; i = i + 1) begin: fillLoop
			assign data_output[i] = msb;
		end
	endgenerate
	
endmodule

// SPLITS 32-BIT INSTRUCTION INTO DIFFERENT CHUNKS (verified)
module instruction_splitter(data_instruction, data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop, data_immediate, data_target);
	input [31:0] data_instruction;
	output [4:0] data_opcode, data_rd, data_rs, data_rt, data_shamt, data_ALUop;
	output [16:0] data_immediate;
	output [26:0] data_target;
	
	assign data_opcode = data_instruction[27 +: 5];
	assign data_rd = data_instruction[22 +: 5];
	assign data_rs = data_instruction[17 +: 5];
	assign data_rt = data_instruction[12 +: 5];
	assign data_shamt = data_instruction[7 +: 5];
	assign data_ALUop = data_instruction[2 +: 5];
	assign data_immediate = data_instruction[0 +: 17];
	assign data_target = data_instruction[0 +: 27];
endmodule



// DON'T GO DOWN THERE UNLESS YOU NEED TO CHANGE HOW REGFILE/ALU/MULTDIV WORK
//
//
//
//	SRSLY KEEP OUT
//
//
//
//




//
// Arithmetic Logic Unit (ALU)
//
module as577_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
	input [31:0] data_operandA, data_operandB;
	input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	output [31:0] data_result;
	output isNotEqual, isLessThan, overflow;
	
	wire [31:0] wire_chooseOp;
	decoder d1(ctrl_ALUopcode, 1'b1, wire_chooseOp);
	
	wire [31:0] data_adder, data_and, data_or, data_shift;
	
	// load added/subbed bits into wire
	cla c0(data_operandA, data_operandB, ctrl_ALUopcode[0], data_adder, isNotEqual, isLessThan, overflow, data_and, data_or);
	
	// load shifted bits into wire
	shiftXbits sxb(data_operandA, ctrl_ALUopcode[0], ctrl_shiftamt, data_shift);
	
	// channeling output of decoder through tristates into data output
	tristate ts0(data_adder, wire_chooseOp[0], data_result);
	tristate ts1(data_adder, wire_chooseOp[1], data_result);
	tristate ts2(data_and, wire_chooseOp[2], data_result);
	tristate ts3(data_or, wire_chooseOp[3], data_result);
	tristate ts4(data_shift, wire_chooseOp[4], data_result);
	tristate ts5(data_shift, wire_chooseOp[5], data_result);
		
endmodule

// TRISTATE BUFFER (verified)
module tristate(in, oe, out);
	input oe;
	input [31:0] in;
	output [31:0] out;
	
	// propagate if enabled else impede
	assign out = oe ? in : 32'bz;
endmodule


// 5-TO-32 DECODER (verified)
module decoder(s, we, out);
	input we;
	input [4:0] s;
	output [31:0] out;
	
	assign out[0] = (we) ? (~s[4] & ~s[3] & ~s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[1] = (we) ? (~s[4] & ~s[3] & ~s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[2] = (we) ? (~s[4] & ~s[3] & ~s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[3] = (we) ? (~s[4] & ~s[3] & ~s[2] & s[1] & s[0]) : 1'b0;
	assign out[4] = (we) ? (~s[4] & ~s[3] & s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[5] = (we) ? (~s[4] & ~s[3] & s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[6] = (we) ? (~s[4] & ~s[3] & s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[7] = (we) ? (~s[4] & ~s[3] & s[2] & s[1] & s[0]) : 1'b0;
	assign out[8] = (we) ? (~s[4] & s[3] & ~s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[9] = (we) ? (~s[4] & s[3] & ~s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[10] = (we) ? (~s[4] & s[3] & ~s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[11] = (we) ? (~s[4] & s[3] & ~s[2] & s[1] & s[0]) : 1'b0;
	assign out[12] = (we) ? (~s[4] & s[3] & s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[13] = (we) ? (~s[4] & s[3] & s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[14] = (we) ? (~s[4] & s[3] & s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[15] = (we) ? (~s[4] & s[3] & s[2] & s[1] & s[0]) : 1'b0;
	assign out[16] = (we) ? (s[4] & ~s[3] & ~s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[17] = (we) ? (s[4] & ~s[3] & ~s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[18] = (we) ? (s[4] & ~s[3] & ~s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[19] = (we) ? (s[4] & ~s[3] & ~s[2] & s[1] & s[0]) : 1'b0;
	assign out[20] = (we) ? (s[4] & ~s[3] & s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[21] = (we) ? (s[4] & ~s[3] & s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[22] = (we) ? (s[4] & ~s[3] & s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[23] = (we) ? (s[4] & ~s[3] & s[2] & s[1] & s[0]) : 1'b0;
	assign out[24] = (we) ? (s[4] & s[3] & ~s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[25] = (we) ? (s[4] & s[3] & ~s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[26] = (we) ? (s[4] & s[3] & ~s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[27] = (we) ? (s[4] & s[3] & ~s[2] & s[1] & s[0]) : 1'b0;
	assign out[28] = (we) ? (s[4] & s[3] & s[2] & ~s[1] & ~s[0]) : 1'b0;
	assign out[29] = (we) ? (s[4] & s[3] & s[2] & ~s[1] & s[0]) : 1'b0;
	assign out[30] = (we) ? (s[4] & s[3] & s[2] & s[1] & ~s[0]) : 1'b0;
	assign out[31] = (we) ? (s[4] & s[3] & s[2] & s[1] & s[0]) : 1'b0;
endmodule

// 32-BIT CARRY-LOOKAHEAD ADDER (verified)
module cla(data_operandA, data_operandB_RAW, ctrl_addSub, data_sum, isNotEqual, isLessThan, overflow, data_and, data_or);
	input ctrl_addSub;	// 0 for add, 1 for sub. also acts as carry-in
	input [31:0] data_operandA, data_operandB_RAW;
	output isNotEqual, isLessThan, overflow;
	output [31:0] data_sum, data_and, data_or;
	
	wire [31:0] data_operandB;
	
	
	// xor bits of second input
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: xorLoop
			xor xor0(data_operandB[i], ctrl_addSub, data_operandB_RAW[i]);
		end
	endgenerate
		
	// intermediate carry bits
	wire c8, c16, c24;
	
	// block-level propagate and generate bits
	wire P0, P1, P2, P3, G0, G1, G2, G3;
	
	// intermediate bits
	wire P0c0;
	wire P1G0, P1P0c0;
	wire P2G1, P2P1G0, P2P1P0c0;
	wire P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0;
	
	cla8 adder0(data_operandA[0 +: 8], data_operandB[0 +: 8], data_operandB_RAW[0 +: 8], ctrl_addSub, data_sum[0 +: 8], data_and[0 +: 8], data_or[0 +: 8], P0, G0);
	
	and and0(P0c0, P0, ctrl_addSub);
	or or0(c8, G0, P0c0);
	
	cla8 adder1(data_operandA[8 +: 8], data_operandB[8 +: 8], data_operandB_RAW[8 +: 8], c8, data_sum[8 +: 8], data_and[8 +: 8], data_or[8 +: 8], P1, G1);
	
	and and1(P1G0, P1, G0);
	and and2(P1P0c0, P1, P0, ctrl_addSub);
	or or1(c16, G1, P1G0, P1P0c0);
	
	cla8 adder2(data_operandA[16 +: 8], data_operandB[16 +: 8], data_operandB_RAW[16 +: 8], c16, data_sum[16 +: 8], data_and[16 +: 8], data_or[16 +: 8], P2, G2);
		
	and and3(P2G1, P2, G1);
	and and4(P2P1G0, P2, P1, G0);
	and and5(P2P1P0c0, P2, P1, P0, ctrl_addSub);
	or or2(c24, G2, P2G1, P2P1G0, P2P1P0c0);
	
	cla8 adder3(data_operandA[24 +: 8], data_operandB[24 +: 8], data_operandB_RAW[24 +: 8], c24, data_sum[24 +: 8], data_and[24 +: 8], data_or[24 +: 8], P3, G3);
	
	and and6(P3G2, P3, G2);
	and and7(P3P2G1, P3, P2, G1);
	and and8(P3P2P1G0, P3, P2, P1, G0);
	and and9(P3P2P1P0c0, P3, P2, P1, P0, ctrl_addSub);
	or or3(data_carryout, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0);
	
	ovf ovf1(data_operandA[31], data_operandB_RAW[31], data_sum[31], ctrl_addSub, overflow);
	assign isNotEqual = (data_sum[0 +: 32]) ? 1 : 0;
	lt lt1(data_operandA[31], data_operandB_RAW[31], data_sum[31], isLessThan);
	
endmodule

// DETERMINES IF A < B (verified)
module lt(msb_A, msb_B, msb_sum, isLessThan);
	input msb_A, msb_B, msb_sum;
	output isLessThan;
	
	wire msb_An, msb_Bn, msb_sumn;
	
	not not1(msb_An, msb_A);
	not not2(msb_Bn, msb_B);
	
	wire c1, c2, c3;
	
	// same signs, if (a-b) negative then a < b
	and and1(c1, msb_A, msb_B, msb_sum);
	and and2(c2, msb_An, msb_Bn, msb_sum);
	
	// different signs, then if a neg and b pos, a < b
	and and3(c3, msb_A, msb_Bn);
	
	or or1(isLessThan, c1, c2, c3);
endmodule

// check overflow
module ovf(msb_A, msb_B, msb_sum, ctrl_addSub, overflow);
	input msb_A, msb_B, msb_sum, ctrl_addSub;
	output overflow;
	
	wire c1, c2, c3, c4;
	wire ctrl_addSubn, msb_An, msb_Bn, msb_sumn;
	
	not not1(ctrl_addSubn, ctrl_addSub);
	not not2(msb_An, msb_A);
	not not3(msb_Bn, msb_B);
	not not4(msb_sumn, msb_sum);
	
	// addition
	and and1(c1, ctrl_addSubn, msb_An, msb_Bn, msb_sum);	// A, B positive, sum negative
	and and2(c2, ctrl_addSubn, msb_A, msb_B, msb_sumn);	// A, B negative, sum positive
	
	// subtraction
	and and3(c3, ctrl_addSub, msb_A, msb_Bn, msb_sumn);	// A positive, B, sum negative
	and and4(c4, ctrl_addSub, msb_An, msb_B, msb_sum);		// A negative, B, sum positive
	
	or(overflow, c1, c2, c3, c4);
endmodule


// 8-BIT CARRY-LOOKAHEAD ADDER (verified)
module cla8(data_operandA, data_operandB, data_operandB_noEdit, c0, data_sum, data_and, data_or, P0, G0);
	input c0;
	input [7:0] data_operandA, data_operandB, data_operandB_noEdit;
	output P0, G0;
	output [7:0] data_sum, data_and, data_or;
	
	wire g0, g1, g2, g3, g4, g5, g6, g7, p0, p1, p2, p3, p4, p5, p6, p7;
	
	// generate bits
	and and0(g0, data_operandA[0], data_operandB[0]);
	and and1(g1, data_operandA[1], data_operandB[1]);
	and and2(g2, data_operandA[2], data_operandB[2]);
	and and3(g3, data_operandA[3], data_operandB[3]);
	and and4(g4, data_operandA[4], data_operandB[4]);
	and and5(g5, data_operandA[5], data_operandB[5]);
	and and6(g6, data_operandA[6], data_operandB[6]);
	and and7(g7, data_operandA[7], data_operandB[7]);
	
	// assign bitwise AND
	and and45(data_and[0], data_operandA[0], data_operandB_noEdit[0]);
	and and46(data_and[1], data_operandA[1], data_operandB_noEdit[1]);
	and and47(data_and[2], data_operandA[2], data_operandB_noEdit[2]);
	and and48(data_and[3], data_operandA[3], data_operandB_noEdit[3]);
	and and49(data_and[4], data_operandA[4], data_operandB_noEdit[4]);
	and and50(data_and[5], data_operandA[5], data_operandB_noEdit[5]);
	and and51(data_and[6], data_operandA[6], data_operandB_noEdit[6]);
	and and52(data_and[7], data_operandA[7], data_operandB_noEdit[7]);
	
	// propagate bits
	or or0(p0, data_operandA[0], data_operandB[0]);
	or or1(p1, data_operandA[1], data_operandB[1]);
	or or2(p2, data_operandA[2], data_operandB[2]);
	or or3(p3, data_operandA[3], data_operandB[3]);
	or or4(p4, data_operandA[4], data_operandB[4]);
	or or5(p5, data_operandA[5], data_operandB[5]);
	or or6(p6, data_operandA[6], data_operandB[6]);
	or or7(p7, data_operandA[7], data_operandB[7]);
	
	// assign bitwise OR
	or or16(data_or[0], data_operandA[0], data_operandB_noEdit[0]);
	or or17(data_or[1], data_operandA[1], data_operandB_noEdit[1]);
	or or18(data_or[2], data_operandA[2], data_operandB_noEdit[2]);
	or or19(data_or[3], data_operandA[3], data_operandB_noEdit[3]);
	or or20(data_or[4], data_operandA[4], data_operandB_noEdit[4]);
	or or21(data_or[5], data_operandA[5], data_operandB_noEdit[5]);
	or or22(data_or[6], data_operandA[6], data_operandB_noEdit[6]);
	or or23(data_or[7], data_operandA[7], data_operandB_noEdit[7]);
	
	// intermediate wires
	wire c1, c2, c3, c4, c5, c6, c7;
	wire p0c0, p1p0c0, p2p1p0c0, p3p2p1p0c0, p4p3p2p1p0c0, p5p4p3p2p1p0c0, p6p5p4p3p2p1p0c0, p7p6p5p4p3p2p1p0c0;
	wire p1g0, p2p1g0, p3p2p1g0, p4p3p2p1g0, p5p4p3p2p1g0, p6p5p4p3p2p1g0, p7p6p5p4p3p2p1g0;
	wire p2g1, p3p2g1, p4p3p2g1, p5p4p3p2g1, p6p5p4p3p2g1, p7p6p5p4p3p2g1;
	wire p3g2, p4p3g2, p5p4p3g2, p6p5p4p3g2, p7p6p5p4p3g2;
	wire p4g3, p5p4g3, p6p5p4g3, p7p6p5p4g3;
	wire p5g4, p6p5g4, p7p6p5g4;
	wire p6g5, p7p6g5;
	wire p7g6;
	
	// assigning intermediate wires
	and and8(p0c0, p0, c0);
	and and9(p1p0c0, p1, p0, c0);
	and and10(p2p1p0c0, p2, p1, p0, c0);
	and and11(p3p2p1p0c0, p3, p2, p1, p0, c0);
	and and12(p4p3p2p1p0c0, p4, p3, p2, p1, p0, c0);
	and and13(p5p4p3p2p1p0c0, p5, p4, p3, p2, p1, p0, c0);
	and and14(p6p5p4p3p2p1p0c0, p6, p5, p4, p3, p2, p1, p0, c0);
	and and15(p7p6p5p4p3p2p1p0c0, p7, p6, p5, p4, p3, p2, p1, p0, c0);
	and and16(p1g0, p1, g0);
	and and17(p2p1g0, p2, p1, g0);
	and and18(p3p2p1g0, p3, p2, p1, g0);
	and and19(p4p3p2p1g0, p4, p3, p2, p1, g0);
	and and20(p5p4p3p2p1g0, p5, p4, p3, p2, p1, g0);
	and and21(p6p5p4p3p2p1g0, p6, p5, p4, p3, p2, p1, g0);
	and and22(p7p6p5p4p3p2p1g0, p7, p6, p5, p4, p3, p2, p1, g0);
	and and23(p2g1, p2, g1);
	and and24(p3p2g1, p3, p2, g1);
	and and25(p4p3p2g1, p4, p3, p2, g1);
	and and26(p5p4p3p2g1, p5, p4, p3, p2, g1);
	and and27(p6p5p4p3p2g1, p6, p5, p4, p3, p2, g1);
	and and28(p7p6p5p4p3p2g1, p7, p6, p5, p4, p3, p2, g1);
	and and29(p3g2, p3, g2);
	and and30(p4p3g2, p4, p3, g2);
	and and31(p5p4p3g2, p5, p4, p3, g2);
	and and32(p6p5p4p3g2, p6, p5, p4, p3, g2);
	and and33(p7p6p5p4p3g2, p7, p6, p5, p4, p3, g2);
	and and34(p4g3, p4, g3);
	and and35(p5p4g3, p5, p4, g3);
	and and36(p6p5p4g3, p6, p5, p4, g3);
	and and37(p7p6p5p4g3, p7, p6, p5, p4, g3);
	and and38(p5g4, p5, g4);
	and and39(p6p5g4, p6, p5, g4);
	and and40(p7p6p5g4, p7, p6, p5, g4);
	and and41(p6g5, p6, g5);
	and and42(p7p6g5, p7, p6, g5);
	and and43(p7g6, p7, g6);
	
	// assigning carries
	or or8(c1, g0, p0c0);
	or or9(c2, g1, p1g0, p1p0c0);
	or or10(c3, g2, p2g1, p2p1g0, p2p1p0c0);
	or or11(c4, g3, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);
	or or12(c5, g4, p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0);
	or or13(c6, g5, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0);
	or or14(c7, g6, p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0);

	// assigning sums
	xor xor0(data_sum[0], data_operandA[0], data_operandB[0], c0);
	xor xor1(data_sum[1], data_operandA[1], data_operandB[1], c1);
	xor xor2(data_sum[2], data_operandA[2], data_operandB[2], c2);
	xor xor3(data_sum[3], data_operandA[3], data_operandB[3], c3);
	xor xor4(data_sum[4], data_operandA[4], data_operandB[4], c4);
	xor xor5(data_sum[5], data_operandA[5], data_operandB[5], c5);
	xor xor6(data_sum[6], data_operandA[6], data_operandB[6], c6);
	xor xor7(data_sum[7], data_operandA[7], data_operandB[7], c7);
	
	// assigning block-level propagate
	and and44(P0, p7, p6, p5, p4, p3, p2, p1, p0);
	or or15(G0, g7, p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0);
	
endmodule

// 1-BIT SHIFTER (verified)
//
// PARAMS:
//		* 32-BIT INPUT
//    * 1-BIT DIRECTION (0 = left, 1 = right)
module shift1bit(data_input, ctrl_shiftdirection, data_output);
	input [31:0] data_input;
	input ctrl_shiftdirection;
	output [31:0] data_output;
	
	// MSB and LSB special cases
	assign data_output[31] = (ctrl_shiftdirection) ? data_input[31] : data_input[30];
	assign data_output[0] = (ctrl_shiftdirection) ? data_input[1] : 1'b0;
	
	// assign remaining middle bits using loop
	genvar i;
	generate
		for(i = 1; i < 31; i = i + 1) begin: shiftLoop
			assign data_output[i] = (ctrl_shiftdirection) ? data_input[i + 1] : data_input[i - 1];
		end
	endgenerate
	
endmodule

// 2-BIT SHIFTER (verified)
//
// PARAMS:
//		* 32-BIT INPUT
//    * 1-BIT DIRECTION (0 = left, 1 = right)
module shift2bit(data_input, ctrl_shiftdirection, data_output);
	input [31:0] data_input;
	input ctrl_shiftdirection;
	output [31:0] data_output;
	
	wire [31:0] intermediate;
	
	shift1bit s1(data_input, ctrl_shiftdirection, intermediate);
	shift1bit s2(intermediate, ctrl_shiftdirection, data_output);
	
endmodule


// 4-BIT SHIFTER (verified)
//
// PARAMS:
//		* 32-BIT INPUT
//    * 1-BIT DIRECTION (0 = left, 1 = right)
module shift4bit(data_input, ctrl_shiftdirection, data_output);
	input [31:0] data_input;
	input ctrl_shiftdirection;
	output [31:0] data_output;
	
	wire [31:0] intermediate;
	
	shift2bit s2(data_input, ctrl_shiftdirection, intermediate);
	shift2bit s4(intermediate, ctrl_shiftdirection, data_output);
	
endmodule

// 8-BIT SHIFTER (verified)
//
// PARAMS:
//		* 32-BIT INPUT
//    * 1-BIT DIRECTION (0 = left, 1 = right)
module shift8bit(data_input, ctrl_shiftdirection, data_output);
	input [31:0] data_input;
	input ctrl_shiftdirection;
	output [31:0] data_output;
	
	wire [31:0] intermediate;
	
	shift4bit s4(data_input, ctrl_shiftdirection, intermediate);
	shift4bit s8(intermediate, ctrl_shiftdirection, data_output);
	
endmodule

// 16-BIT SHIFTER (verified)
//
// PARAMS:
//		* 32-BIT INPUT
//    * 1-BIT DIRECTION (0 = left, 1 = right)
module shift16bit(data_input, ctrl_shiftdirection, data_output);
	input [31:0] data_input;
	input ctrl_shiftdirection;
	output [31:0] data_output;
	
	wire [31:0] intermediate;
	
	shift8bit s8(data_input, ctrl_shiftdirection, intermediate);
	shift8bit s16(intermediate, ctrl_shiftdirection, data_output);
	
endmodule

// 31-BIT SHIFTER (verified)
//
// PARAMS:
//		* 32-BIT INPUT
//		* 5-BIT SHAMT
//    * 1-BIT DIRECTION (0 = left, 1 = right)
module shiftXbits(data_input, ctrl_shiftdirection, ctrl_shiftamt, data_output);
	input [31:0] data_input;
	input [4:0] ctrl_shiftamt;
	input ctrl_shiftdirection;
	output [31:0] data_output;
	
	wire [31:0] s0, s1, s2, s3, s4, w0, w1, w2, w3;
	
	shift1bit sh1(data_input, ctrl_shiftdirection, s0);
	assign w0 = (ctrl_shiftamt[0]) ? s0 : data_input;
	
	shift2bit sh2(w0, ctrl_shiftdirection, s1);
	assign w1 = (ctrl_shiftamt[1]) ? s1 : w0;
	
	shift4bit sh3(w1, ctrl_shiftdirection, s2);
	assign w2 = (ctrl_shiftamt[2]) ? s2 : w1;
	
	shift8bit sh4(w2, ctrl_shiftdirection, s3);
	assign w3 = (ctrl_shiftamt[3]) ? s3 : w2;
	
	shift16bit sh5(w3, ctrl_shiftdirection, s4);
	assign data_output = (ctrl_shiftamt[4]) ? s4 : w3;
	
endmodule

// 5-BIT 4-TO-1 MUX (verified)
module mux4_5bit(data_in0, data_in1, data_in2, data_in3, data_s0, data_s1, data_output);
	input [4:0] data_in0, data_in1, data_in2, data_in3;
	input data_s0, data_s1;
	output [4:0] data_output;
	
	wire [4:0] inter0, inter1;
	assign inter0 = (data_s0) ? data_in1 : data_in0;
	assign inter1 = (data_s0) ? data_in3 : data_in2;
	
	assign data_output = (data_s1) ? inter1 : inter0;
endmodule


//
// REGISTER FILE
//
module regfile_as577(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB, allData);
	
	// inputs and outputs
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;
	output [1023:0] allData;
	
	wire [31:0] write_chooseReg;
	decoder dc1(ctrl_writeReg, ctrl_writeEnable, write_chooseReg);
	
	wire [31:0] read_chooseRegA;
	decoder dc2(ctrl_readRegA, 1'b1, read_chooseRegA);
	
	wire [31:0] read_chooseRegB;
	decoder dc3(ctrl_readRegB, 1'b1, read_chooseRegB);
	
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: loop1
			wire [31:0] data;		// the register's data
			register rg(.clock(clock),
							.ctrl_writeEnable(write_chooseReg[i]),
							.ctrl_reset(ctrl_reset),
							.data_writeReg(data_writeReg),
							.data_readReg(data));
			tristate tsA(data, read_chooseRegA[i], data_readRegA);
			tristate tsB(data, read_chooseRegB[i], data_readRegB);
			// TESTING: adds to 1024 array
			assign allData[i*32 +: 32] = data;
		end
	endgenerate
	
endmodule

// 32-BIT REGISTER
module register(clock, ctrl_writeEnable, ctrl_reset, data_writeReg, data_readReg);

	// inputs and outputs
	input clock, ctrl_writeEnable, ctrl_reset;
	input [31:0] data_writeReg;
	output [31:0] data_readReg;
	
	assign ctrl_resetn = ~ctrl_reset;
	
	// flip flops
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: loop1
			dffe my_dffe(.d(data_writeReg[i]), .clk(clock), .clrn(ctrl_resetn), .prn(1'b1), .ena(ctrl_writeEnable), .q(data_readReg[i]));
		end
	endgenerate
	
endmodule

// 27-BIT REGISTER
module register27(clock, ctrl_writeEnable, ctrl_reset, data_writeReg, data_readReg);

	// inputs and outputs
	input clock, ctrl_writeEnable, ctrl_reset;
	input [26:0] data_writeReg;
	output [26:0] data_readReg;
	
	assign ctrl_resetn = ~ctrl_reset;
	
	// flip flops
	genvar i;
	generate
		for(i = 0; i < 27; i = i + 1) begin: loop1
			dffe my_dffe(.d(data_writeReg[i]), .clk(clock), .clrn(ctrl_resetn), .prn(1'b1), .ena(ctrl_writeEnable), .q(data_readReg[i]));
		end
	endgenerate
	
endmodule
