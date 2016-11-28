module processor(clock, reset, /*ps2_key_pressed, ps2_out, lcd_write, lcd_data,*/ debug_data_in, debug_address);

    input           clock, reset/*, ps2_key_pressed*/;
    //input     [7:0]   ps2_out;

    //output            lcd_write;
    //output    [31:0]  lcd_data;

    // GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
    output  [31:0]  debug_data_in;
    output  [11:0]  debug_address;
	 wire [7:0] debug_vga_in;
	 wire [19:0] debug_vga_address;
	 

    // your processor here
    //


    // IF_ID STAGE

    // PC
    wire [31:0] instruction_if_id_in, data_JB, data_NEXT_PC, data_PC_PLUS_ONE_if_id_in, data_PC;
	 wire ctrl_stall, ctrl_flush;
    wire [31:0] intermediate_next_PC;
    assign intermediate_next_PC = (ctrl_stall) ? data_PC : data_PC_PLUS_ONE_if_id_in;
    assign data_NEXT_PC = (ctrl_flush) ? data_JB : intermediate_next_PC;
    register pc(clock, 1'b1, reset, data_NEXT_PC, data_PC);

    // PC = PC + 1
    wire ignore0, ignore1, ignore2;
    wire [31:0] ignore3, ignore4;
    cla add1(data_PC, 32'b1, 1'b0, data_PC_PLUS_ONE_if_id_in, ignore0, ignore1, ignore2, ignore3, ignore4);

    imem myimem(.address    (data_PC[11:0]),
                    .clken      (1'b1),
                    .clock      (~clock),
                    .q              (instruction_if_id_in)
    );

    wire [31:0] instruction_if_id_out, data_PC_PLUS_ONE_if_id_out;
    wire [31:0] choose_instruction_if_id_in, intermediate_choose;
    assign intermediate_choose = (ctrl_stall) ? instruction_if_id_out : instruction_if_id_in;
    assign choose_instruction_if_id_in = (ctrl_flush) ? 32'b0 : intermediate_choose;
    stage_IF_ID if_id(clock, reset, 1'b1, choose_instruction_if_id_in, data_PC_PLUS_ONE_if_id_in, instruction_if_id_out, data_PC_PLUS_ONE_if_id_out);

            // SPLITTING INSTRUCTION
            wire [4:0] data_ID_opcode, data_ID_rd, data_ID_rs, data_ID_rt, data_ID_shamt, data_ID_ALUop;
            wire [16:0] data_ID_immediate;
            wire [26:0] data_ID_target;

            instruction_splitter split_id(instruction_if_id_out, data_ID_opcode, data_ID_rd, data_ID_rs, data_ID_rt, data_ID_shamt, data_ID_ALUop, data_ID_immediate, data_ID_target);

            // CONTROLS
            wire [4:0] ctrl_ID_ALUop;
            wire ctrl_ID_JR, ctrl_ID_JAL, ctrl_ID_DMWE,ctrl_ID_VGAE, ctrl_ID_RWd, ctrl_ID_READ1, ctrl_ID_READ2, ctrl_ID_BNE, ctrl_ID_BLT, ctrl_ID_BEQ, ctrl_ID_J, ctrl_ID_ALUin, ctrl_ID_RegW, ctrl_ID_SWE, ctrl_WB_RegW, ctrl_WB_RWd;
            control ctrl_id(instruction_if_id_out, ctrl_ID_ALUop, ctrl_ID_JR, ctrl_ID_JAL, ctrl_ID_DMWE, ctrl_ID_VGAE, ctrl_ID_RWd, ctrl_ID_READ1, ctrl_ID_READ2, ctrl_ID_BNE, ctrl_ID_BLT, ctrl_ID_BEQ, ctrl_ID_J, ctrl_ID_ALUin, ctrl_ID_RegW, ctrl_ID_SWE);
				
				wire is_sw_ID;
				assign is_sw_ID = ~instruction_if_id_out[31] & ~instruction_if_id_out[30] & instruction_if_id_out[29] & instruction_if_id_out[28] & instruction_if_id_out[27];

				wire is_svga_ID;
				assign is_svga_ID = ~instruction_if_id_out[31] & instruction_if_id_out[30] & instruction_if_id_out[29] & instruction_if_id_out[28] & instruction_if_id_out[27];
				
            // AUXILLIARY
            wire [31:0] extended_ID_immediate;
            sign_extender sx_id(data_ID_immediate, extended_ID_immediate);

            // REGISTER FILE
            wire [4:0] ctrl_ID_WRITE_REG, ctrl_ID_READ_REG1_temp, ctrl_ID_READ_REG2_temp;
            wire [31:0] data_readRegA_id_ex_in, data_readRegB_id_ex_in;
            assign_registers asgn2(data_ID_rd, data_ID_rs, data_ID_rt, ctrl_ID_READ1, ctrl_ID_READ2, ctrl_ID_JAL, ctrl_ID_READ_REG1_temp, ctrl_ID_READ_REG2_temp);
				
				wire [4:0] ctrl_ID_READ_REG1, ctrl_ID_READ_REG2;
				assign ctrl_ID_READ_REG1 = (is_sw_ID | is_svga_ID) ? ctrl_ID_READ_REG2_temp : ctrl_ID_READ_REG1_temp;
				assign ctrl_ID_READ_REG2 = (is_sw_ID | is_svga_ID) ? ctrl_ID_READ_REG1_temp : ctrl_ID_READ_REG2_temp;

            // REGISTER WRITE DATA
            wire [31:0] data_writeReg;
				
				wire signed [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
				wire [1023:0] allData;

            regfile_as577 rgfile(~clock, ctrl_WB_RegW, reset, ctrl_ID_WRITE_REG, ctrl_ID_READ_REG1, ctrl_ID_READ_REG2, data_writeReg, data_readRegA_id_ex_in, data_readRegB_id_ex_in, allData);
				
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
				
				

    // ID_EX STAGE
    wire [31:0] instruction_id_ex_out, data_PC_PLUS_ONE_id_ex_out, data_readRegA_id_ex_out, data_readRegB_id_ex_out;
    wire [31:0] choose_instruction_if_id_out;
    assign choose_instruction_if_id_out = (ctrl_stall | ctrl_flush) ? 32'b0 : instruction_if_id_out;
    stage_ID_EX id_ex(clock, reset, 1'b1, data_PC_PLUS_ONE_if_id_out, data_readRegA_id_ex_in, data_readRegB_id_ex_in, choose_instruction_if_id_out, data_PC_PLUS_ONE_id_ex_out, data_readRegA_id_ex_out, data_readRegB_id_ex_out, instruction_id_ex_out);

            // SPLITTING INSTRUCTION
            wire [4:0] data_EX_opcode, data_EX_rd, data_EX_rs, data_EX_rt, data_EX_shamt, data_EX_ALUop;
            wire [16:0] data_EX_immediate;
            wire [26:0] data_EX_target;

            instruction_splitter split_ex(instruction_id_ex_out, data_EX_opcode, data_EX_rd, data_EX_rs, data_EX_rt, data_EX_shamt, data_EX_ALUop, data_EX_immediate, data_EX_target);

            // CONTROLS
            wire [4:0] ctrl_EX_ALUop;
            wire ctrl_EX_JR, ctrl_EX_JAL, ctrl_EX_DMWE, ctrl_EX_VGAE, ctrl_EX_RWd, ctrl_EX_READ1, ctrl_EX_READ2, ctrl_EX_BNE, ctrl_EX_BLT, ctrl_EX_BEQ, ctrl_EX_J, ctrl_EX_ALUin, ctrl_EX_RegW, ctrl_EX_SWE, ctrl_EX_BEX;
            control ctrl_ex(instruction_id_ex_out, ctrl_EX_ALUop, ctrl_EX_JR, ctrl_EX_JAL, ctrl_EX_DMWE, ctrl_EX_VGAE, ctrl_EX_RWd, ctrl_EX_READ1, ctrl_EX_READ2, ctrl_EX_BNE, ctrl_EX_BLT, ctrl_EX_BEQ, ctrl_EX_J, ctrl_EX_ALUin, ctrl_EX_RegW, ctrl_EX_SWE);
				
				wire is_sw_EX;
				assign is_sw_EX = ~instruction_id_ex_out[31] & ~instruction_id_ex_out[30] & instruction_id_ex_out[29] & instruction_id_ex_out[28] & instruction_id_ex_out[27];

				wire is_svga_EX;
				assign is_svga_EX = ~instruction_id_ex_out[31] & instruction_id_ex_out[30] & instruction_id_ex_out[29] & instruction_id_ex_out[28] & instruction_id_ex_out[27];
				
				assign ctrl_EX_BEX = data_EX_opcode[4] & ~data_EX_opcode[3] & data_EX_opcode[2] & data_EX_opcode[1] & ~data_EX_opcode[0];
				
				// BYPASS EXECUTE STAGE
				wire [4:0] ctrl_rr1_EX, ctrl_rr2_EX, ctrl_rr1_EX_temp, ctrl_rr2_EX_temp, ctrl_wr_MEM, ctrl_wr_WB;
				wire [1:0] forwardA, forwardB;
				wire ctrl_MEM_RegW;
				wire is_mem_zero, is_wb_zero;
				wire [31:0] instruction_ex_mem_out, instruction_mem_wb_out;
				assign is_mem_zero = ~(|instruction_ex_mem_out);
				assign is_wb_zero = ~(|instruction_mem_wb_out);
				assign ctrl_rr1_EX_temp = (ctrl_EX_READ1) ? data_EX_rd : data_EX_rs;
				assign ctrl_rr2_EX_temp = (ctrl_EX_READ2) ? data_EX_rs : data_EX_rt;
				
				assign ctrl_rr1_EX = (is_sw_EX | is_svga_EX) ? ctrl_rr2_EX_temp : ctrl_rr1_EX_temp;
				
				assign ctrl_rr2_EX = (is_sw_EX | is_svga_EX) ? ctrl_rr1_EX_temp : ctrl_rr2_EX_temp;
				
				bypass_ex bx(is_mem_zero, is_wb_zero, ctrl_rr1_EX, ctrl_rr2_EX, ctrl_wr_MEM, ctrl_wr_WB, ctrl_MEM_RegW, ctrl_WB_RegW, forwardA, forwardB);

            // AUXILLIARY
            wire [31:0] extended_EX_immediate;
            sign_extender sx_ex(data_EX_immediate, extended_EX_immediate);

            wire [31:0] data_JUMP_PC, data_BRANCH_PC;

            // JUMP AND BRANCH ADDRESSING
            wire ignore5, ignore6, ignore7;
            wire [31:0] ignore8, ignore9;
            jump_addresser ja(data_EX_target, 32'b0, data_JUMP_PC);
            cla branch_addresser(extended_EX_immediate, data_PC_PLUS_ONE_id_ex_out, 1'b0, data_BRANCH_PC, ignore5, ignore6, ignore7, ignore8, ignore9);

            // ALU
            wire [31:0] alu_operandA, alu_operandB, alu_EX_result, data_readRegA_bypassed, data_readRegB_bypassed, alu_MEM_result;
            wire isNotEqual, isLessThan, overflow;
				
				mux4_32bit mx_bypassA(data_readRegA_id_ex_out, data_writeReg, alu_MEM_result, data_readRegA_id_ex_out, forwardA[0], forwardA[1], data_readRegA_bypassed);
				mux4_32bit mx_bypassB(data_readRegB_id_ex_out, data_writeReg, alu_MEM_result, data_readRegB_id_ex_out, forwardB[0], forwardB[1], data_readRegB_bypassed);
				
            assign_alu_operands asgn0(data_readRegA_bypassed, data_readRegB_bypassed, extended_EX_immediate, ctrl_EX_ALUin, alu_operandA, alu_operandB);

            as577_alu alu(alu_operandA, alu_operandB, ctrl_EX_ALUop, data_EX_shamt, alu_EX_result, isNotEqual, isLessThan, overflow);

				// MULT/DIV
				wire [31:0] multdiv_result;
				wire ctrl_MULT, ctrl_DIV, data_exception, data_inputRDY, data_resultRDY;
				wire is_add, is_sub, is_addi;
				assign ctrl_MULT = ~data_EX_opcode[0] & ~data_EX_opcode[1] & ~data_EX_opcode[2] & ~data_EX_opcode[3] & ~data_EX_opcode[4] & ~data_EX_ALUop[0] & data_EX_ALUop[1] & data_EX_ALUop[2] & ~data_EX_ALUop[3] & ~data_EX_ALUop[4];
				assign ctrl_DIV = ~data_EX_opcode[0] & ~data_EX_opcode[1] & ~data_EX_opcode[2] & ~data_EX_opcode[3] & ~data_EX_opcode[4] & data_EX_ALUop[0] & data_EX_ALUop[1] & data_EX_ALUop[2] & ~data_EX_ALUop[3] & ~data_EX_ALUop[4];
				assign is_add = ~data_EX_opcode[0] & ~data_EX_opcode[1] & ~data_EX_opcode[2] & ~data_EX_opcode[3] & ~data_EX_opcode[4] & ~data_EX_ALUop[0] & ~data_EX_ALUop[1] & ~data_EX_ALUop[2] & ~data_EX_ALUop[3] & ~data_EX_ALUop[4];
				assign is_sub = ~data_EX_opcode[0] & ~data_EX_opcode[1] & ~data_EX_opcode[2] & ~data_EX_opcode[3] & ~data_EX_opcode[4] & data_EX_ALUop[0] & ~data_EX_ALUop[1] & ~data_EX_ALUop[2] & ~data_EX_ALUop[3] & ~data_EX_ALUop[4];
				assign is_addi = data_EX_opcode[0] & ~data_EX_opcode[1] & data_EX_opcode[2] & ~data_EX_opcode[3] & ~data_EX_opcode[4];
				multdiv_as577 multdiv(alu_operandA, alu_operandB, ctrl_MULT, ctrl_DIV, clock, multdiv_result, data_exception, data_inputRDY, data_resultRDY);
				
            // STATUS
            wire [26:0] status_in, status_out;
				wire overwrite, status_ovf;
				assign status_ovf = (overflow & (is_add | is_sub | is_addi)) | (data_exception & data_resultRDY);
            assign_status asgn_sts(instruction_id_ex_out[31:27], instruction_id_ex_out[6:2], status_ovf, data_EX_target, status_in, overwrite);

				wire status_write;
				assign status_write = ctrl_EX_SWE & overwrite;
				
            register27 rg_sts(clock, status_write, reset, status_in, status_out);
				
            wire is_not_noop;
            is_not_zero inz(is_not_noop, instruction_if_id_out);

            stall_logic sl(is_not_noop, instruction_id_ex_out[31:27], instruction_if_id_out[31:27], instruction_id_ex_out[6:2], instruction_if_id_out[6:2], data_EX_rd, ctrl_ID_READ_REG2, ctrl_ID_READ_REG1, ctrl_stall);
            flush_logic fl(instruction_id_ex_out[31:27], isNotEqual, isLessThan, ctrl_flush);

            // FIND NEXT PC
            jb_PC jb(data_PC_PLUS_ONE_id_ex_out, data_BRANCH_PC, data_JUMP_PC, ctrl_EX_BNE, ctrl_EX_BLT, ctrl_EX_BEQ, isNotEqual, isLessThan, data_readRegA_bypassed, ctrl_EX_JR, ctrl_EX_J, ctrl_EX_JAL, ctrl_EX_BEX, status_out, data_JB);
		

// EX_MEM STAGE
wire [31:0] data_PC_PLUS_ONE_ex_mem_out, data_readRegB_ex_mem_out;
stage_EX_MEM ex_mem(clock, reset, 1'b1, data_PC_PLUS_ONE_id_ex_out, data_readRegB_bypassed, instruction_id_ex_out, alu_EX_result, data_PC_PLUS_ONE_ex_mem_out, data_readRegB_ex_mem_out, instruction_ex_mem_out, alu_MEM_result);

            // SPLITTING INSTRUCTION
            wire [4:0] data_MEM_opcode, data_MEM_rd, data_MEM_rs, data_MEM_rt, data_MEM_shamt, data_MEM_ALUop;
            wire [16:0] data_MEM_immediate;
            wire [26:0] data_MEM_target;

            instruction_splitter split_mem(instruction_ex_mem_out, data_MEM_opcode, data_MEM_rd, data_MEM_rs, data_MEM_rt, data_MEM_shamt, data_MEM_ALUop, data_MEM_immediate, data_MEM_target);

            // CONTROLS
            wire [4:0] ctrl_MEM_ALUop;
            wire ctrl_MEM_JR, ctrl_MEM_JAL, ctrl_MEM_DMWE, ctrl_MEM_VGAE, ctrl_MEM_RWd, ctrl_MEM_READ1, ctrl_MEM_READ2, ctrl_MEM_BNE, ctrl_MEM_BLT, ctrl_MEM_BEQ, ctrl_MEM_J, ctrl_MEM_ALUin, ctrl_MEM_SWE;
            control ctrl_mem(instruction_ex_mem_out, ctrl_MEM_ALUop, ctrl_MEM_JR, ctrl_MEM_JAL, ctrl_MEM_DMWE, ctrl_MEM_VGAE, ctrl_MEM_RWd, ctrl_MEM_READ1, ctrl_MEM_READ2, ctrl_MEM_BNE, ctrl_MEM_BLT, ctrl_MEM_BEQ, ctrl_MEM_J, ctrl_MEM_ALUin, ctrl_MEM_RegW, ctrl_MEM_SWE);
				
				wire [31:0] dmem_data_in_bypassed;
				wire bypass;
				wire [4:0] data_WB_opcode, data_WB_rd;
				bypass_mem bm(is_wb_zero, data_MEM_opcode, ctrl_WB_RegW, data_MEM_rd, data_WB_rd, bypass);
				
				assign dmem_data_in_bypassed = (bypass) ? data_writeReg : data_readRegB_ex_mem_out;

            //////////////////////////////////////
            ////// THIS IS REQUIRED FOR GRADING
            // CHANGE THIS TO ASSIGN YOUR DMEM WRITE ADDRESS ALSO TO debug_addr
            assign debug_data_in = dmem_data_in_bypassed;
				
				assign debug_vga_in = dmem_data_in_bypassed[7:0];
				
            // CHANGE THIS TO ASSIGN YOUR DMEM DATA INPUT (TO BE WRITTEN) ALSO TO debug_data
            assign debug_address = (data_resultRDY) ? multdiv_result[11:0] : alu_MEM_result[11:0];
            ////////////////////////////////////////////////////////////

				assign debug_vga_address = (data_resultRDY) ? multdiv_result[19:0] : alu_MEM_result[19:0];
				
            wire [31:0] data_dmem_out_ex_mem_out;

				wire [7:0] data_vgamem_out_ex_mem_out;
				
            // You'll need to change where the dmem and imem read and write...
            dmem mydmem(.address            (debug_address),
                            .clock          (~clock),
                            .data           (debug_data_in),
                            .wren           (ctrl_MEM_DMWE),
                            .q              (data_dmem_out_ex_mem_out)
            );
				
				vgamem myvgamem(.address        (debug_vga_address),
                            .clock          (~clock),
                            .data           (debug_vga_in),
                            .wren           (ctrl_MEM_VGAE),
                            .q              (data_vgamem_out_ex_mem_out)
            );
				
				assign ctrl_wr_MEM = (ctrl_MEM_JAL) ? 5'b11111 : data_MEM_rd;

// MEM_WB STAGE
wire [31:0] data_PC_PLUS_ONE_mem_wb_out, alu_WB_result, data_dmem_out_mem_wb_out;
wire [7:0] data_vgamem_out_mem_wb_out;
stage_MEM_WB mem_wb(clock, reset, 1'b1, data_PC_PLUS_ONE_ex_mem_out, instruction_ex_mem_out, alu_MEM_result, data_dmem_out_ex_mem_out, data_vgamem_out_ex_mem_out, data_PC_PLUS_ONE_mem_wb_out, instruction_mem_wb_out, alu_WB_result, data_dmem_out_mem_wb_out, data_vgamem_out_mem_wb_out);

            // SPLITTING INSTRUCTION
            wire [4:0] data_WB_rs, data_WB_rt, data_WB_shamt, data_WB_ALUop;
            wire [16:0] data_WB_immediate;
            wire [26:0] data_WB_target;

            instruction_splitter split_wb(instruction_mem_wb_out, data_WB_opcode, data_WB_rd, data_WB_rs, data_WB_rt, data_WB_shamt, data_WB_ALUop, data_WB_immediate, data_WB_target);

            // CONTROLS
            wire [4:0] ctrl_WB_ALUop;
            wire ctrl_WB_JR, ctrl_WB_JAL, ctrl_WB_DMWE, ctrl_WB_VGAE, ctrl_WB_READ1, ctrl_WB_READ2, ctrl_WB_BNE, ctrl_WB_BLT, ctrl_WB_BEQ, ctrl_WB_J, ctrl_WB_ALUin, ctrl_WB_SWE;
            control ctrl_wb(instruction_mem_wb_out, ctrl_WB_ALUop, ctrl_WB_JR, ctrl_WB_JAL, ctrl_WB_DMWE,ctrl_WB_VGAE, ctrl_WB_RWd, ctrl_WB_READ1, ctrl_WB_READ2, ctrl_WB_BNE, ctrl_WB_BLT, ctrl_WB_BEQ, ctrl_WB_J, ctrl_WB_ALUin, ctrl_WB_RegW, ctrl_WB_SWE);
				
				wire is_MULT_WB, is_DIV_WB, reg_num_enable;
				wire [4:0] multdiv_reg;
				
				assign is_MULT_WB = ~data_WB_opcode[0] & ~data_WB_opcode[1] & ~data_WB_opcode[2] & ~data_WB_opcode[3] & ~data_WB_opcode[4] & ~data_WB_ALUop[0] & data_WB_ALUop[1] & data_WB_ALUop[2] & ~data_WB_ALUop[3] & ~data_WB_ALUop[4];
				assign is_DIV_WB = ~data_WB_opcode[0] & ~data_WB_opcode[1] & ~data_WB_opcode[2] & ~data_WB_opcode[3] & ~data_WB_opcode[4] & data_WB_ALUop[0] & data_WB_ALUop[1] & data_WB_ALUop[2] & ~data_WB_ALUop[3] & ~data_WB_ALUop[4];
				
				assign reg_num_enable = is_MULT_WB | is_DIV_WB;
				
				register5 reg_num(clock, reg_num_enable, reset, data_WB_rd, multdiv_reg);
				
				wire [31:0] data_writeBack;
				assign data_writeReg = (data_resultRDY) ? multdiv_result : data_writeBack;

            // REGISTER WRITES
            assign_reg_write asgn1(alu_WB_result, data_dmem_out_mem_wb_out, data_PC_PLUS_ONE_mem_wb_out, ctrl_WB_RWd, ctrl_WB_JAL, data_writeBack);
				
				assign ctrl_ID_WRITE_REG = (ctrl_WB_JAL) ? 5'b11111 : (data_resultRDY) ? multdiv_reg : data_WB_rd;
				assign ctrl_wr_WB = ctrl_ID_WRITE_REG;

endmodule

// ASSIGNS BYPASS FOR THE WB/MEM -> EX STAGES
module bypass_ex(is_mem_zero, is_wb_zero, rr1_ex, rr2_ex, wr_mem, wr_wb, regW_mem, regW_wb, forwardA, forwardB);
	input [4:0] rr1_ex, rr2_ex, wr_mem, wr_wb;
	input regW_mem, regW_wb;
	input is_mem_zero, is_wb_zero;
	output [1:0] forwardA, forwardB;
	
	wire caseA2, caseB2, caseA1, caseB1;
	
	wire wr_mem_equals_rr1_ex;
	equals_4bit eq0(wr_mem, rr1_ex, wr_mem_equals_rr1_ex);
	assign caseA2 = regW_mem & wr_mem_equals_rr1_ex;
	
	wire wr_mem_equals_rr2_ex;
	equals_4bit eq1(wr_mem, rr2_ex, wr_mem_equals_rr2_ex);
	assign caseB2 = regW_mem & wr_mem_equals_rr2_ex;
	
	wire wr_wb_equals_rr1_ex;
	equals_4bit eq2(wr_wb, rr1_ex, wr_wb_equals_rr1_ex);
	assign caseA1 = regW_wb & wr_wb_equals_rr1_ex & (~wr_mem_equals_rr1_ex | ~regW_mem);
	
	wire wr_wb_equals_rr2_ex;
	equals_4bit eq3(wr_wb, rr2_ex, wr_wb_equals_rr2_ex);
	assign caseB1 = regW_wb & wr_wb_equals_rr2_ex & (~wr_mem_equals_rr2_ex | ~regW_mem);
	
	assign forwardA[1] = caseA2 & ~is_mem_zero;
	assign forwardB[1] = caseB2 & ~is_mem_zero;
	
	assign forwardA[0] = caseA1 & ~is_wb_zero;
	assign forwardB[0] = caseB1 & ~is_wb_zero;

endmodule

// ASSIGNS BYPASS FOR THE WB -> MEM STAGE
module bypass_mem(is_wb_zero, opcode_mem, regW_wb, mem_rd, wb_rd, bypass);
	input [4:0] opcode_mem, mem_rd, wb_rd;
	input regW_wb, is_wb_zero;
	output bypass;

	wire mem_is_sw, mem_is_svga, same_rd;
	
	assign mem_is_sw = (~opcode_mem[4] & ~opcode_mem[3] & opcode_mem[2] & opcode_mem[1] & opcode_mem[0]);
	
	assign mem_is_svga = (~opcode_mem[4] & opcode_mem[3] & opcode_mem[2] & opcode_mem[1] & opcode_mem[0]);
	
	equals_4bit eq(mem_rd, wb_rd, same_rd);
	
	assign bypass = regW_wb & (mem_is_sw | mem_is_svga) & same_rd & ~is_wb_zero;
endmodule

// FLUSH LOGIC
module flush_logic(opcode_EX, isNotEqual, isLessThan, ctrl_flush);
    input [4:0] opcode_EX;
    input isNotEqual, isLessThan;
    output ctrl_flush;
    
    wire bne_success, blt_success, beq_success, jump_general, bex;
    
    assign bne_success = ~opcode_EX[4] & ~opcode_EX[3] & ~opcode_EX[2] & opcode_EX[1] & ~opcode_EX[0] & isNotEqual;
    assign blt_success = ~opcode_EX[4] & ~opcode_EX[3] & opcode_EX[2] & opcode_EX[1] & ~opcode_EX[0] & isLessThan;
	 assign beq_success = opcode_EX[4] & opcode_EX[3] & opcode_EX[2] & ~opcode_EX[1] & opcode_EX[0] & ~isNotEqual;
    assign jump_general = (~opcode_EX[4] & ~opcode_EX[3] & ~opcode_EX[2] & ~opcode_EX[1] & opcode_EX[0]) | (~opcode_EX[4] & ~opcode_EX[3] & ~opcode_EX[2] & opcode_EX[1] & opcode_EX[0]) | (~opcode_EX[4] & ~opcode_EX[3] & opcode_EX[2] & ~opcode_EX[1] & ~opcode_EX[0]);
	 assign bex = opcode_EX[4] & ~opcode_EX[3] & opcode_EX[2] & opcode_EX[1] & ~opcode_EX[0];
    
    assign ctrl_flush = bne_success | blt_success | beq_success | jump_general | bex;
endmodule

// DETERMINES WHETHER 32 BIT IS NOT ZERO
module is_not_zero(is_not_zero, in);
    input [31:0] in;
    output is_not_zero;
    
    wire intermediate;
    assign is_not_zero = in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7] | in[8] | in[9] | in[10] | in[11] | in[12] | in[13] | in[14] | in[15] | in[16] | in[17] | in[18] | in[19] | in[20] | in[21] | in[22] | in[23] | in[24] | in[25] | in[26] | in[27] | in[28] | in[29] | in[30] | in[31];   
endmodule

// DETERMINES WHETHER STALL SHOULD OCCUR
module stall_logic(is_not_noop, opcode_DX, opcode_ID, alu_opcode_DX, alu_opcode_ID, rd_DX, rr2_ID, rr1_ID, ctrl_stall);
    input [4:0] opcode_DX, opcode_ID, alu_opcode_DX, alu_opcode_ID, rd_DX, rr2_ID, rr1_ID;
    input is_not_noop;
    output ctrl_stall;
    
    wire arith, addi, bne, blt, beq, lw, sw, svga, j, jal, jr, bex, setx, add, sub, mul, div;
    
    opcode_decode dc(opcode_ID, arith, addi, sw, lw, svga, j, bne, jal, jr, blt, beq, bex, setx);
    
    assign add = arith & (~alu_opcode_ID[4] & ~alu_opcode_ID[3] & ~alu_opcode_ID[2] & ~alu_opcode_ID[1] & ~alu_opcode_ID[0]);
    assign sub = arith & (~alu_opcode_ID[4] & ~alu_opcode_ID[3] & ~alu_opcode_ID[2] & ~alu_opcode_ID[1] & alu_opcode_ID[0]);
    assign mul = arith & (~alu_opcode_ID[4] & ~alu_opcode_ID[3] & alu_opcode_ID[2] & alu_opcode_ID[1] & ~alu_opcode_ID[0]);
    assign div = arith & (~alu_opcode_ID[4] & ~alu_opcode_ID[3] & alu_opcode_ID[2] & alu_opcode_ID[1] & alu_opcode_ID[0]);
	 assign andi = arith & (~alu_opcode_ID[4] & ~alu_opcode_ID[3] & ~alu_opcode_ID[2] & alu_opcode_ID[1] & ~alu_opcode_ID[0]);
	 assign ori = arith & (~alu_opcode_ID[4] & ~alu_opcode_ID[3] & ~alu_opcode_ID[2] & alu_opcode_ID[1] & alu_opcode_ID[0]);
    
    wire mul_EX, div_EX;
    assign mul_EX = (~opcode_DX[4] & ~opcode_DX[3] & ~opcode_DX[2] & ~opcode_DX[1] & ~opcode_DX[0]) & (~alu_opcode_DX[4] & ~alu_opcode_DX[3] & alu_opcode_DX[2] & alu_opcode_DX[1] & ~alu_opcode_DX[0]);
    assign div_EX = (~opcode_DX[4] & ~opcode_DX[3] & ~opcode_DX[2] & ~opcode_DX[1] & ~opcode_DX[0]) & (~alu_opcode_DX[4] & ~alu_opcode_DX[3] & alu_opcode_DX[2] & alu_opcode_DX[1] & alu_opcode_DX[0]);

    wire is_lw, rd_DX_equals_rr2_ID, rd_DX_equals_rr1_ID;
    
    assign is_lw = ~opcode_DX[4] & opcode_DX[3] & ~opcode_DX[2] & ~opcode_DX[1] & ~opcode_DX[0];
    equals_4bit eq0(rd_DX, rr2_ID, rd_DX_equals_rr2_ID);
    equals_4bit eq1(rd_DX, rr1_ID, rd_DX_equals_rr1_ID);
    
    wire case1, case2;
    assign case1 = is_lw & is_not_noop & rd_DX_equals_rr1_ID & (arith | addi | bne | blt | beq | lw | jr | sw | svga);
    assign case2 = is_lw & is_not_noop & rd_DX_equals_rr2_ID & (add | sub | mul | div | bne | blt |beq | andi | ori);
    
    assign ctrl_stall = case1 | case2 | mul_EX | div_EX;
endmodule

// DETERMINES WHETHER 4-BIT WIRES ARE EQUAL
module equals_4bit(data_A, data_B, equals);
    input [4:0] data_A, data_B;
    output equals;
    
    wire eq0, eq1, eq2, eq3, eq4;
    
    assign eq0 = data_A[0] ^ data_B[0];
    assign eq1 = data_A[1] ^ data_B[1];
    assign eq2 = data_A[2] ^ data_B[2];
    assign eq3 = data_A[3] ^ data_B[3];
    assign eq4 = data_A[4] ^ data_B[4];
    
    assign equals = ~(eq0 | eq1 | eq2 | eq3 | eq4);
endmodule

// LATCH BETWEEN FETCH AND DECODE STAGE
module stage_IF_ID(clock, reset, wren, instruction_if_id_in, data_PC_PLUS_ONE_if_id_in, instruction_if_id_out, data_PC_PLUS_ONE_if_id_out);
    input clock, reset, wren;
    input [31:0] instruction_if_id_in, data_PC_PLUS_ONE_if_id_in;
    output [31:0] instruction_if_id_out, data_PC_PLUS_ONE_if_id_out;

    register rg1(clock, wren, reset, instruction_if_id_in, instruction_if_id_out);
    register rg2(clock, wren, reset, data_PC_PLUS_ONE_if_id_in, data_PC_PLUS_ONE_if_id_out);
endmodule

// LATCH BETWEEN DECODE AND EXECUTE STAGE
module stage_ID_EX(clock, reset, wren, data_PC_PLUS_ONE_if_id_out, data_readRegA_id_ex_in, data_readRegB_id_ex_in, instruction_if_id_out, data_PC_PLUS_ONE_id_ex_out, data_readRegA_id_ex_out, data_readRegB_id_ex_out, instruction_id_ex_out);
    input clock, reset, wren;
    input [31:0] instruction_if_id_out, data_PC_PLUS_ONE_if_id_out, data_readRegA_id_ex_in, data_readRegB_id_ex_in;
    output [31:0] instruction_id_ex_out, data_PC_PLUS_ONE_id_ex_out, data_readRegA_id_ex_out, data_readRegB_id_ex_out;

    register rg1(clock, wren, reset, instruction_if_id_out, instruction_id_ex_out);
    register rg2(clock, wren, reset, data_PC_PLUS_ONE_if_id_out, data_PC_PLUS_ONE_id_ex_out);
    register rg3(clock, wren, reset, data_readRegA_id_ex_in, data_readRegA_id_ex_out);
    register rg4(clock, wren, reset, data_readRegB_id_ex_in, data_readRegB_id_ex_out);
endmodule

// LATCH BETWEEN EXECUTE AND MEMORY STAGE
module stage_EX_MEM(clock, reset, wren, data_PC_PLUS_ONE_id_ex_out, data_readRegA_id_ex_out, instruction_id_ex_out, alu_EX_result, data_PC_PLUS_ONE_ex_mem_out, data_readRegA_ex_mem_out, instruction_ex_mem_out, alu_MEM_result);
    input clock, reset, wren;
    input [31:0] data_PC_PLUS_ONE_id_ex_out, data_readRegA_id_ex_out, instruction_id_ex_out, alu_EX_result;
    output [31:0] data_PC_PLUS_ONE_ex_mem_out, data_readRegA_ex_mem_out, instruction_ex_mem_out, alu_MEM_result;

    register rg1(clock, wren, reset, data_PC_PLUS_ONE_id_ex_out, data_PC_PLUS_ONE_ex_mem_out);
    register rg2(clock, wren, reset, data_readRegA_id_ex_out, data_readRegA_ex_mem_out);
    register rg3(clock, wren, reset, instruction_id_ex_out, instruction_ex_mem_out);
    register rg4(clock, wren, reset, alu_EX_result, alu_MEM_result);
endmodule

// LATCH BETWEEN MEMORY AND WRITE-BACK STAGE
module stage_MEM_WB(clock, reset, wren, data_PC_PLUS_ONE_ex_mem_out, instruction_ex_mem_out, alu_MEM_result, data_dmem_out_ex_mem_out, data_vga_out_ex_mem_out, data_PC_PLUS_ONE_mem_wb_out, instruction_mem_wb_out, alu_WB_result, data_dmem_out_mem_wb_out, data_vga_out_mem_wb_out);
    input clock, reset, wren;
    input [31:0] data_PC_PLUS_ONE_ex_mem_out, instruction_ex_mem_out, alu_MEM_result, data_dmem_out_ex_mem_out;
	 input [7:0] data_vga_out_ex_mem_out;
    output [31:0] data_PC_PLUS_ONE_mem_wb_out, instruction_mem_wb_out, alu_WB_result, data_dmem_out_mem_wb_out;
	 output [7:0] data_vga_out_mem_wb_out;

    register rg1(clock, wren, reset, data_PC_PLUS_ONE_ex_mem_out, data_PC_PLUS_ONE_mem_wb_out);
    register rg2(clock, wren, reset, instruction_ex_mem_out, instruction_mem_wb_out);
    register rg3(clock, wren, reset, alu_MEM_result, alu_WB_result);
    register rg4(clock, wren, reset, data_dmem_out_ex_mem_out, data_dmem_out_mem_wb_out);
    register8 rg5(clock, wren, reset, data_vga_out_ex_mem_out, data_vga_out_mem_wb_out);
endmodule

// ASSIGNS THE STATUS BASED ON INSTRUCTION AND OVERFLOW
module assign_status(data_opcode, alu_opcode, data_overflow, data_target, data_status, overwrite);
    input [4:0] data_opcode, alu_opcode;
	 input [26:0] data_target;
    input data_overflow;
    output [26:0] data_status;
	 output overwrite;

    wire i_arith, i_add, i_addi, i_sub, i_mul, i_div, i_setx;
	 
	 assign i_arith = ~data_opcode[0] & ~data_opcode[1] & ~data_opcode[2] & ~data_opcode[3] & ~data_opcode[4];
    assign i_add = i_arith & ~alu_opcode[0] & ~alu_opcode[1] & ~alu_opcode[2] & ~alu_opcode[3] & ~alu_opcode[4];
    assign i_sub = i_arith & alu_opcode[0] & ~alu_opcode[1] & ~alu_opcode[2] & ~alu_opcode[3] & ~alu_opcode[4];
    assign i_mul = i_arith & ~alu_opcode[0] & alu_opcode[1] & alu_opcode[2] & ~alu_opcode[3] & ~alu_opcode[4];
    assign i_div = i_arith & alu_opcode[0] & alu_opcode[1] & alu_opcode[2] & ~alu_opcode[3] & ~alu_opcode[4];
    assign i_setx = data_opcode[0] & ~data_opcode[1] & data_opcode[2] & ~data_opcode[3] & data_opcode[4];
	 assign i_addi = data_opcode[0] & ~data_opcode[1] & data_opcode[2] & ~data_opcode[3] & ~data_opcode[4];

    wire [26:0] inter0;

    assign inter0 = ((i_add | i_addi | i_sub | i_mul | i_div) & data_overflow) ? 27'b1 : 27'b0;

    assign data_status = (i_setx) ? data_target : inter0;
	 assign overwrite = i_setx | ((i_add | i_addi | i_sub | i_mul | i_div) & data_overflow);
endmodule

// DETERMINES THE NEXT PC VALUE
module jb_PC(data_PC_PLUS_ONE, data_BRANCH_PC, data_JUMP_PC, ctrl_BNE, ctrl_BLT, ctrl_BEQ, isNotEqual, isLessThan, data_readRegA, ctrl_JR, ctrl_J, ctrl_JAL, ctrl_BEX, data_status, data_NEXT_PC);
    input [31:0] data_PC_PLUS_ONE, data_BRANCH_PC, data_JUMP_PC, data_readRegA;
	 input [26:0] data_status;
    input ctrl_BNE, ctrl_BLT, ctrl_BEQ, isNotEqual, isLessThan, ctrl_JR, ctrl_J, ctrl_JAL, ctrl_BEX;
    output [31:0] data_NEXT_PC;

	 wire is_status_zero;
	 is_zero27bits iz(data_status, is_status_zero);
	 
    wire ctrl_BRANCH, ctrl_JUMP;
    assign ctrl_BRANCH = (ctrl_BNE & isNotEqual) | (ctrl_BLT & isLessThan) | (ctrl_BEQ & ~isNotEqual);
    assign ctrl_JUMP = ctrl_JR | ctrl_J | ctrl_JAL | (ctrl_BEX & ~is_status_zero);

    wire [31:0] inter0, inter1;
    assign inter0 = (ctrl_BRANCH) ? data_BRANCH_PC : data_PC_PLUS_ONE;
    assign inter1 = (ctrl_JUMP) ? data_JUMP_PC : inter0;
    assign data_NEXT_PC = (ctrl_JR) ? data_readRegA : inter1;
endmodule

// CHECKS IF 27 BIT NUMBER IS 0
module is_zero27bits(in, out);
	input [26:0] in;
	output out;
	wire [26:0] temp;
	
	assign temp[0] = in[0];
	genvar i;
	generate
	for(i = 1; i < 27; i = i + 1) begin: loop
		or(temp[i], in[i], temp[i - 1]);
	end
	endgenerate
	
	assign out = ~temp[26];
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
module assign_registers(data_rd, data_rs, data_rt, ctrl_READ1, ctrl_READ2, ctrl_JAL, ctrl_READ_REG1, ctrl_READ_REG2);
    input [4:0] data_rd, data_rs, data_rt;
    input ctrl_READ1, ctrl_READ2, ctrl_JAL;
    output [4:0] ctrl_READ_REG1, ctrl_READ_REG2;

    assign ctrl_READ_REG1 = (ctrl_READ1) ? data_rd : data_rs;
    assign ctrl_READ_REG2 = (ctrl_READ2) ? data_rs : data_rt;
endmodule

// CONTROL
// TAKES OPCODE AND DETERMINES WHAT THE CONTROL SIGNALS SHOULD BE
module control(data_instruction, ctrl_ALUop, ctrl_JR, ctrl_JAL, ctrl_DMWE, ctrl_VGAE, ctrl_RWd, ctrl_READ1, ctrl_READ2, ctrl_BNE, ctrl_BLT, ctrl_BEQ, ctrl_J, ctrl_ALUin, ctrl_RegW, ctrl_SWE);
    input [31:0] data_instruction;
    output [4:0] ctrl_ALUop;
    output ctrl_JR, ctrl_JAL, ctrl_DMWE, ctrl_VGAE, ctrl_RWd, ctrl_READ1, ctrl_READ2, ctrl_BNE, ctrl_BLT, ctrl_BEQ, ctrl_J, ctrl_ALUin, ctrl_RegW, ctrl_SWE;

    wire i_arith, i_addi, i_sw, i_lw, i_svga, i_j, i_bne, i_beq, i_jal, i_jr, i_blt, i_bex, i_setx;

    opcode_decode dec(data_instruction[27 +: 5], i_arith, i_addi, i_sw, i_lw, i_svga, i_j, i_bne, i_jal, i_jr, i_blt, i_beq, i_bex, i_setx);

    // ALU operation assignment
    encode_ALUop enc(data_instruction, ctrl_ALUop);

    wire i_add, i_sub, i_mul, i_div;

    assign i_add = i_arith & ~data_instruction[2] & ~data_instruction[3] & ~data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
    assign i_sub = i_arith & data_instruction[2] & ~data_instruction[3] & ~data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
    assign i_mul = i_arith & ~data_instruction[2] & data_instruction[3] & data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];
    assign i_div = i_arith & data_instruction[2] & data_instruction[3] & data_instruction[4] & ~data_instruction[5] & ~data_instruction[6];

    // Trivial assignments
    assign ctrl_JR = i_jr;
    assign ctrl_JAL = i_jal;
    assign ctrl_J = i_j;
    assign ctrl_BNE = i_bne;
    assign ctrl_BLT = i_blt;
	 assign ctrl_BEQ = i_beq;
    assign ctrl_DMWE = i_sw;
	 assign ctrl_VGAE = i_svga;
    assign ctrl_RWd = i_lw;
    assign ctrl_SWE = i_addi | i_setx | (i_arith & (i_add | i_sub | i_mul | i_div));

    // Complex assignments
    assign ctrl_ALUin = i_addi | i_sw | i_svga | i_lw;
    assign ctrl_RegW = (i_arith & ~i_mul & ~i_div) | i_addi | i_lw | i_jal;
    assign ctrl_READ1 = i_sw | i_svga |i_bne | i_blt | i_beq | i_jr;// if high, choose $rd, else $rs
    assign ctrl_READ2 = i_sw | i_svga |i_bne | i_blt | i_beq;           // if high, choose $rs, else $rt

    // READ1:
    //      $rd: sw, svga, bne, blt, jr
    //      $rs: everywhere else
    //
    // READ2:
    //      $rs: sw, svga, bne, blt
    //      $rt: everywhere else

endmodule

// TAKES IN OPCODE AND OUTPUTS 1-HOT WIRE FOR ACTIVE INSTRUCTION
module opcode_decode(opcode, i_arith, i_addi, i_sw, i_lw, i_svga, i_j, i_bne, i_jal, i_jr, i_blt, i_beq, i_bex, i_setx);
    input [4:0] opcode;
    output i_arith, i_addi, i_sw, i_lw, i_svga, i_j, i_bne, i_jal, i_jr, i_blt, i_beq, i_bex, i_setx;

    // i_arith governs all ALU operations (add, sub, and, or, sll, sra, mul, div, and custom_r)
    assign i_arith = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];

    assign i_addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];

    assign i_sw = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & opcode[0];

    assign i_lw = ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
	 
	 assign i_svga = ~opcode[4] & opcode[3] & opcode[2] & opcode[1] & opcode[0];

    assign i_j = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];

    assign i_bne = ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0];
	 
	 assign i_beq = opcode[4] & opcode[3] & opcode[2] & ~opcode[1] & opcode[0];

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
    assign opcode = data_instruction[27 +:  5];

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
//  SRSLY KEEP OUT
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

    wire [31:0] data_adder, data_and, data_or, data_shift, zeros;
	 assign zeros = 32'b0;

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
    tristate ts6(zeros, wire_chooseOp[6], data_result);
    tristate ts7(zeros, wire_chooseOp[7], data_result);

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
    input ctrl_addSub;  // 0 for add, 1 for sub. also acts as carry-in
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
    and and1(c1, ctrl_addSubn, msb_An, msb_Bn, msb_sum);    // A, B positive, sum negative
    and and2(c2, ctrl_addSubn, msb_A, msb_B, msb_sumn); // A, B negative, sum positive

    // subtraction
    and and3(c3, ctrl_addSub, msb_A, msb_Bn, msb_sumn); // A positive, B, sum negative
    and and4(c4, ctrl_addSub, msb_An, msb_B, msb_sum);      // A negative, B, sum positive

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
//      * 32-BIT INPUT
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
//      * 32-BIT INPUT
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
//      * 32-BIT INPUT
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
//      * 32-BIT INPUT
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
//      * 32-BIT INPUT
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
//      * 32-BIT INPUT
//      * 5-BIT SHAMT
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


// 32-BIT 4-TO-1 MUX (verified)
module mux4_32bit(data_in0, data_in1, data_in2, data_in3, data_s0, data_s1, data_output);
    input [31:0] data_in0, data_in1, data_in2, data_in3;
    input data_s0, data_s1;
    output [31:0] data_output;

    wire [31:0] inter0, inter1;
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

    wire [31:0] temp_write_choose, write_chooseReg;
    decoder dc1(ctrl_writeReg, ctrl_writeEnable, temp_write_choose);
	 assign write_chooseReg[31:1] = temp_write_choose[31:1];
	 assign write_chooseReg[0] = 1'b0;	// ground register 0

    wire [31:0] read_chooseRegA;
    decoder dc2(ctrl_readRegA, 1'b1, read_chooseRegA);

    wire [31:0] read_chooseRegB;
    decoder dc3(ctrl_readRegB, 1'b1, read_chooseRegB);

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin: loop1
            wire [31:0] data;       // the register's data
            register rg(.clock(clock),
                            .ctrl_writeEnable(write_chooseReg[i]),
                            .ctrl_reset(ctrl_reset),
                            .data_writeReg(data_writeReg),
                            .data_readReg(data));
            tristate tsA(data, read_chooseRegA[i], data_readRegA);
            tristate tsB(data, read_chooseRegB[i], data_readRegB);
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

// 8-BIT REGISTER
module register8(clock, ctrl_writeEnable, ctrl_reset, data_writeReg, data_readReg);

    // inputs and outputs
    input clock, ctrl_writeEnable, ctrl_reset;
    input [7:0] data_writeReg;
    output [7:0] data_readReg;

    assign ctrl_resetn = ~ctrl_reset;

    // flip flops
    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin: loop1
            dffe my_dffe(.d(data_writeReg[i]), .clk(clock), .clrn(ctrl_resetn), .prn(1'b1), .ena(ctrl_writeEnable), .q(data_readReg[i]));
        end
    endgenerate

endmodule


// 5-BIT REGISTER
module register5(clock, ctrl_writeEnable, ctrl_reset, data_writeReg, data_readReg);

    // inputs and outputs
    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] data_writeReg;
    output [4:0] data_readReg;

    assign ctrl_resetn = ~ctrl_reset;

    // flip flops
    genvar i;
    generate
        for(i = 0; i < 5; i = i + 1) begin: loop1
            dffe my_dffe(.d(data_writeReg[i]), .clk(clock), .clrn(ctrl_resetn), .prn(1'b1), .ena(ctrl_writeEnable), .q(data_readReg[i]));
        end
    endgenerate

endmodule

///////////////////////////////////////////////////////
////////////////////// MUL DIV ////////////////////////
///////////////////////////////////////////////////////

// latch inputs
module multdiv_as577(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_inputRDY, data_resultRDY);
	input [31:0] data_operandA;
	input [31:0] data_operandB;
	input ctrl_MULT, ctrl_DIV, clock;
	output [31:0] data_result;
	output data_exception, data_inputRDY, data_resultRDY;
		
	// assert input ready
	assign data_inputRDY = 1'b1;
	
	// count
	wire [5:0] count;
	wire ctrl;
	assign ctrl = ctrl_MULT | ctrl_DIV;
	up_counter counter(count, 1'b1, clock, ctrl);
	
	
	// latching controls
	wire latch_ctrl_mult, latch_ctrl_div;
	dffeveri dffe1(latch_ctrl_mult, ctrl_MULT, clock, ctrl, 1'b1, 1'b1);
	dffeveri dffe2(latch_ctrl_div, ctrl_DIV, clock, ctrl, 1'b1, 1'b1);
	
	// wires to write to for mult/div
	wire [31:0] result_mult, result_div;
	wire ready_mult, ready_div, exception_mult, exception_div;
			
	// latching operands
	wire [31:0] mult_A, mult_B, div_A, div_B;
	register32 rg2(clock, ctrl_MULT, data_operandA, mult_A);
	register32 rg3(clock, ctrl_MULT, data_operandB, mult_B);
	register32 rg4(clock, ctrl_DIV, data_operandA, div_A);
	register32 rg5(clock, ctrl_DIV, data_operandB, div_B);
	
	// multiply
	booth_mult bm(mult_A, mult_B, count, latch_ctrl_mult, clock, result_mult, ready_mult, exception_mult);
	
	// flip inputs for division if negative
	wire [31:0] dividend, divisor, negate_A, negate_B, result_div_preflip;
	negate n1(div_A, negate_A);
	negate n2(div_B, negate_B);
	
	assign dividend = (div_A[31]) ? negate_A : div_A;
	assign divisor = (div_B[31]) ? negate_B : div_B;
	
	div d(dividend, divisor, ~count, latch_ctrl_div, clock, result_div_preflip, ready_div, exception_div);
	
	// flip output if one input is negative
	wire flip;
	xor xor1(flip, div_A[31], div_B[31]);
	
	wire [31:0] flipped_result;
	negate n3(result_div_preflip, flipped_result);
	
	assign result_div = (flip) ? flipped_result : result_div_preflip;
	
	// indicate if result is ready
	wire temp_ready;
	assign temp_ready = ready_div | ready_mult;
	
	dffeveri dffe(data_resultRDY, temp_ready, clock, 1'b1, 1'b1, 1'b1);
	
	// set result appropriately
	wire [31:0] res1, res2;
	assign res1 = (latch_ctrl_div) ? result_div : 32'bz;
	assign res2 = (latch_ctrl_mult) ? result_mult : res1;
	register32 rg1(clock, temp_ready, res2, data_result);
	
	// set exception appropriately
	wire xc1, xc2;
	assign xc1 = (latch_ctrl_div) ? exception_div : 1'bz;
	assign xc2 = (latch_ctrl_mult) ? exception_mult : xc1;
	dffeveri dffe3(data_exception, xc2, clock, temp_ready, 1'b1, 1'b1);
	
endmodule

// Division
// TODO: flip signs and re-flip output
module div(data_operandA, data_operandB, count, latch, clock, data_result, data_ready, data_exception);
	input [31:0] data_operandA, data_operandB;
	input [5:0] count;
	input clock, latch;
	output [31:0] data_result;
	output data_ready, data_exception;
	
	// intermediates and initial values
	wire [31:0] intermediate_RQB, intermediate_quot, init_RQB, init_quot;
	
	// assigning initial values
	assign init_RQB = data_operandA;
	assign init_quot = 32'b0;
	
	// write to registers
	wire [31:0] quot_write, RQB_write;
	wire select;
	isCount31bit6 ic31(count, select);
	mux32 mx1(intermediate_quot, init_quot, select, quot_write);
	mux32 mx2(intermediate_RQB, init_RQB, select, RQB_write);

	wire [31:0] quot_read, RQB_read;
	register32 rg1(clock, 1'b1, quot_write, quot_read);
	register32 rg2(clock, 1'b1, RQB_write, RQB_read);
	
	// division cycle
	division_cycle dc(count, data_operandA, data_operandB, quot_read, RQB_read, intermediate_quot, intermediate_RQB);
	
	wire ready;
	isCountZerobit6 icz(count, ready);
	
	assign data_result = (ready) ? intermediate_quot : 32'bz;
	assign data_ready = latch & ready;
	
	checkDivisionException cde(data_operandB, data_exception);
	
endmodule

// negates data
module negate(data_input, data_output);
	input [31:0] data_input;
	output [31:0] data_output;
	
	cla_mul sub(32'b0, data_input, 1'b1, data_output); 
endmodule

// Determines if division throws exception (if divisor is zero)
module checkDivisionException(divisor, data_exception);
	input [31:0] divisor;
	output data_exception;
	
	assign data_exception = ~(|divisor);
endmodule

// Single division cycle
module division_cycle(count, dividend, divisor, quotient_in, RQB_in, quotient_out, RQB_out);
	input [31:0] dividend, divisor, quotient_in, RQB_in;
	input [5:0] count;
	output [31:0] quotient_out, RQB_out;
	
	wire [31:0] shifted_RQB;
	shiftXbits sh1(RQB_in, 1'b1, count[0 +: 5], shifted_RQB);
	
	wire [31:0] difference1;	// RQB - divisor
	cla_mul sub1(shifted_RQB, divisor, 1'b1, difference1);
	
	wire set_bitn;
	// RQB < divisor -> set_bitn = 1
	lt lt1(shifted_RQB[31], divisor[31], difference1[31], set_bitn);
	
	// shift quotient left by 1 and set bit at bottom
	wire [31:0] quotient_shift;
	shift1bit sh2(quotient_in, 1'b0, quotient_shift);
	
	assign quotient_out[1 +: 31] = quotient_shift[1 +: 31];
	assign quotient_out[0] = ~set_bitn;
	
	// shift the divisor left by count
	wire [31:0] shifted_divisor;
	shiftXbits sh3(divisor, 1'b0, count[0 +: 5], shifted_divisor);
	
	// subtract divisor from RQB
	wire [31:0] difference2;
	cla_mul sub2(RQB_in, shifted_divisor, 1'b1, difference2);
	
	// if set bit, subtract divisor from RQB else do nothing
	assign RQB_out = (~set_bitn) ? difference2 : RQB_in;
	
endmodule

// booth's multiplier
module booth_mult(data_operandA, data_operandB, count, latch, clock, product, data_ready, data_exception);
	// multiplicand (data_operandA), multiplier(data_operandB)
	input [31:0] data_operandA, data_operandB;
	input [5:0] count;
	input clock, latch;
	output [31:0] product;
	output data_ready, data_exception;
	
	// intermediate and initInput
	wire [64:0] intermediate;
	wire [64:0] initInput_pre, initInput;
	
	assign initInput_pre[1 +: 32] = data_operandB;
	assign initInput_pre[0] = 1'b0;
	assign initInput_pre[33 +: 32] = 32'b0;
	boothCycle bc1(data_operandA, initInput_pre, initInput);
		
	// 65-bit mux control input
	wire [64:0] regWrite;
	wire select;
	isCountZerobit6 icz(count, select);
	mux65 mx(intermediate, initInput, select, regWrite);
	
	// 65 DFFEs register
	wire [64:0] regRead;
	register65 rg(clock, regWrite, regRead);
		
	// output of register goes into booth cycle
	// output of booth cycle goes into mux 0th channel
	boothCycle bc2(data_operandA, regRead, intermediate);
		
	// output ready
	wire ready;
	isCount31bit6 ic31(count, ready);
	
	// exception
	checkMultException cme(intermediate, data_operandA, data_operandB, data_exception);
		
	assign product = (ready) ? intermediate[1 +: 32] : 32'bz;
	assign data_ready = latch & ready;
	
endmodule

// determines if multiplication has caused an exception
module checkMultException(intermediate, data_operandA, data_operandB, exception);
	input [64:0] intermediate;
	input [31:0] data_operandA, data_operandB;
	output exception;
	
	wire case1, case2, case3, case4, case6, case7, signError;
	
	// operands diff signs and result positive
	assign case1 = ~intermediate[32] & ~data_operandA[31] & data_operandB[31];
	assign case2 = ~intermediate[32] & data_operandA[31] & ~data_operandB[31];
	
	// operands same sign and result negative
	assign case3 = intermediate[32] & ~data_operandA[31] & ~data_operandB[31];
	assign case4 = intermediate[32] & data_operandA[31] & data_operandB[31];
	
	// data_operands is zero
	assign case6 = ~(|data_operandA);
	assign case7 = ~(|data_operandB);
	
	assign signError = (case1 | case2 | case3 | case4) & ~(case6 | case7);
	
	// upper bits error
	wire upperBitsError, case5, except;
	assign case5 = |intermediate[33 +: 32];
	assign except = &intermediate[33 +: 32];
	
	assign upperBitsError = case5 & ~except;
	
	assign exception = upperBitsError | signError;
endmodule

module isCountZerobit6(count, out);
	input [5:0] count;
	output out;
	
	wire w_or;
	or or1(w_or, count[0], count[1], count[2], count[3], count[4]);
	
	not not1(out, w_or);
endmodule

module isCount31bit6(count, out);
	input [5:0] count;
	output out;

	and and1(out, count[0], count[1], count[2], count[3], count[4]);
	
endmodule

// 2-way mux for 65-bit inputs
module mux65(data_A, data_B, select, out);
	input [64:0] data_A, data_B;
	input select;
	output [64:0] out;
	
	assign out = (select) ? data_B : data_A;
endmodule

module mux32(data_A, data_B, select, out);
	input [31:0] data_A, data_B;
	input select;
	output [31:0] out;
	
	assign out = (select) ? data_B : data_A;
endmodule

// takes in multiplicand and mixed intermediate and performs add/sub and shift based on two LSBs
module boothCycle(data_operandA, intermediate, data_result);
	input [31:0] data_operandA;
	input [64:0] intermediate;
	output [64:0] data_result;
	
	// determine if we do something (01, 10) or not (00, 11)
	wire doSomething;
	xor xor1(doSomething, intermediate[0], intermediate[1]);
	
	// copy least significant 33 bits
	wire [64:0] sum;
	assign sum[0 +: 33] = intermediate[0 +: 33];
	
	// sum/diff to most significant 32 bits
	cla_mul addSub(intermediate[33 +: 32], data_operandA, intermediate[1], sum[33 +: 32]);
	
	// choose sum if we perform action else choose original
	wire [64:0] afterAction;
	assign afterAction = (doSomething) ? sum : intermediate;
	
	shift1bit65 sh(afterAction, 1'b1, data_result);
endmodule

// 32-bit CLA (comprised of 4 8-bit CLAs)
module cla_mul(data_operandA, data_operandB_RAW, ctrl_addSub, data_sum);
	input ctrl_addSub;	// 0 for add, 1 for sub. also acts as carry-in
	input [31:0] data_operandA, data_operandB_RAW;
	output [31:0] data_sum;
	
	wire [31:0] data_operandB;
	wire data_carryout;
	
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
	
	cla8simple adder0(data_operandA[0 +: 8], data_operandB[0 +: 8], data_operandB_RAW[0 +: 8], ctrl_addSub, data_sum[0 +: 8], P0, G0);
	
	and and0(P0c0, P0, ctrl_addSub);
	or or0(c8, G0, P0c0);
	
	cla8simple adder1(data_operandA[8 +: 8], data_operandB[8 +: 8], data_operandB_RAW[8 +: 8], c8, data_sum[8 +: 8], P1, G1);
	
	and and1(P1G0, P1, G0);
	and and2(P1P0c0, P1, P0, ctrl_addSub);
	or or1(c16, G1, P1G0, P1P0c0);
	
	cla8simple adder2(data_operandA[16 +: 8], data_operandB[16 +: 8], data_operandB_RAW[16 +: 8], c16, data_sum[16 +: 8], P2, G2);
		
	and and3(P2G1, P2, G1);
	and and4(P2P1G0, P2, P1, G0);
	and and5(P2P1P0c0, P2, P1, P0, ctrl_addSub);
	or or2(c24, G2, P2G1, P2P1G0, P2P1P0c0);
	
	cla8simple adder3(data_operandA[24 +: 8], data_operandB[24 +: 8], data_operandB_RAW[24 +: 8], c24, data_sum[24 +: 8], P3, G3);
	
	and and6(P3G2, P3, G2);
	and and7(P3P2G1, P3, P2, G1);
	and and8(P3P2P1G0, P3, P2, P1, G0);
	and and9(P3P2P1P0c0, P3, P2, P1, P0, ctrl_addSub);
	or or3(data_carryout, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0);
	
endmodule

// 8-bit CLA
module cla8simple(data_operandA, data_operandB, data_operandB_noEdit, c0, data_sum, P0, G0);
	input c0;
	input [7:0] data_operandA, data_operandB, data_operandB_noEdit;
	output P0, G0;
	output [7:0] data_sum;
	
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
	
	// propagate bits
	or or0(p0, data_operandA[0], data_operandB[0]);
	or or1(p1, data_operandA[1], data_operandB[1]);
	or or2(p2, data_operandA[2], data_operandB[2]);
	or or3(p3, data_operandA[3], data_operandB[3]);
	or or4(p4, data_operandA[4], data_operandB[4]);
	or or5(p5, data_operandA[5], data_operandB[5]);
	or or6(p6, data_operandA[6], data_operandB[6]);
	or or7(p7, data_operandA[7], data_operandB[7]);
	
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

// FSM counter (0 -> 31)
module up_counter(out,enable,clk,reset);
	output [5:0] out;
	input enable, clk, reset;
	reg [5:0] out;
	initial
	begin
		out = 6'd54;
	end
	always @(posedge clk)
	if (reset) begin
	  out <= 6'b000000;
	end else if (enable) begin
		//out <= out + 1;
		case(out)
			6'd0: out <= 6'd1;
			6'd1: out <= 6'd2;
			6'd2: out <= 6'd3;
			6'd3: out <= 6'd4;
			6'd4: out <= 6'd5;
			6'd5: out <= 6'd6;
			6'd6: out <= 6'd7;
			6'd7: out <= 6'd8;
			6'd8: out <= 6'd9;
			6'd9: out <= 6'd10;
			6'd10: out <= 6'd11;
			6'd11: out <= 6'd12;
			6'd12: out <= 6'd13;
			6'd13: out <= 6'd14;
			6'd14: out <= 6'd15;
			6'd15: out <= 6'd16;
			6'd16: out <= 6'd17;
			6'd17: out <= 6'd18;
			6'd18: out <= 6'd19;
			6'd19: out <= 6'd20;
			6'd20: out <= 6'd21;
			6'd21: out <= 6'd22;
			6'd22: out <= 6'd23;
			6'd23: out <= 6'd24;
			6'd24: out <= 6'd25;
			6'd25: out <= 6'd26;
			6'd26: out <= 6'd27;
			6'd27: out <= 6'd28;
			6'd28: out <= 6'd29;
			6'd29: out <= 6'd30;
			6'd30: out <= 6'd31;
			6'd31: out <= 6'd54;
		endcase
	end
endmodule

// 65-bit register
module register65(clock, data_writeReg, data_readReg);

	// inputs and outputs
	input clock;
	input [64:0] data_writeReg;
	output [64:0] data_readReg;
	
	// flip flops
	genvar i;
	generate
		for(i = 0; i < 65; i = i + 1) begin: loop1
			dffeveri my_dffe(data_readReg[i], data_writeReg[i], clock, 1'b1, 1'b1, 1'b1);
		end
	endgenerate
	
endmodule

// 32-bit register
module register32(clock, ena, data_writeReg, data_readReg);

	// inputs and outputs
	input clock, ena;
	input [31:0] data_writeReg;
	output [31:0] data_readReg;
	
	// flip flops
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: loop1
			dffeveri my_dffe(data_readReg[i], data_writeReg[i], clock, ena, 1'b1, 1'b1);
		end
	endgenerate
	
endmodule

// D-Flip-Flop
module dffeveri(q, d, clk, ena, rsn, prn);
	input d, clk, ena, rsn, prn;
	output q;
	reg q;

	
	always @(posedge clk or negedge rsn or negedge prn) begin
		
		if(~prn)
			begin
			if(rsn)
				q = 1'b1;
			else
				q = 1'bx;
			end
			
		else if(~rsn)
			q = 1'b0;
			
		else if(ena)
			q = d;
	end
endmodule

// 1-bit shifter
module shift1bit65(data_input, ctrl_shiftdirection, data_output);
	input [64:0] data_input;
	input ctrl_shiftdirection;
	output [64:0] data_output;
	
	// MSB and LSB special cases
	assign data_output[64] = (ctrl_shiftdirection) ? data_input[64] : data_input[63];
	assign data_output[0] = (ctrl_shiftdirection) ? data_input[1] : 1'b0;
	
	// assign remaining middle bits using loop
	genvar i;
	generate
		for(i = 1; i < 64; i = i + 1) begin: shiftLoop
			assign data_output[i] = (ctrl_shiftdirection) ? data_input[i + 1] : data_input[i - 1];
		end
	endgenerate
	
endmodule
