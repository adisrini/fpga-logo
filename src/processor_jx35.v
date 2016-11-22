module processor_jx35(clock, reset, /*ps2_key_pressed, ps2_out, lcd_write, lcd_data,*/ debug_data_in, debug_address);

	
////////////////////////////////////////////Round 0 - INITIALIZE CLOCK/RESET  //////////////////////////////////////////////////////

input 	clock, reset/*, ps2_key_pressed*/;
	//input 	[7:0]	ps2_out;
	
	//output 			lcd_write;
	//output 	[31:0] 	lcd_data;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
output 	[31:0] 	debug_data_in;
output	[11:0]	debug_address;
		
	//just for now!!
////all wires here

//ROUND 1

//wire [31:0] nextInstructionLocation;
wire readyToBegin;
wire [31:0] pcReadOut,normalInst_loc, currInst_loc, currInst_32bit,nextPC_afterStall,nextPC;
wire [31:0] next_inst_IF_ID_in, instr_IF_ID_in;

//////////////////////////////////////////CONTROL BITS///////////////////////////////////////////////////////////
wire [4:0] rd_IF, rs_IF, rt_IF, shamt_IF, alu_op_IF,opcode_IF;
wire [26:0] target_IF;
wire [16:0] immediate_IF;
wire  rs_rd1_IF, rt_rs2_IF, memToReg_IF, reg_we_IF, mem_we_IF, alu_imm_ctrl_IF;
wire br_IF, jump_IF,jal_ctrl_IF,jr_ctrl_IF, bne_blt_IF,STALL_IF,changePC_IF;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//ROUND 1-2

wire [31:0] next_inst_IF_ID_out, instr_IF_ID_out;

wire [31:0] stallResult_IF_ID;


//ROUND 2
wire [31:0] data_readRegA_ID_EX_in, data_readRegB_ID_EX_in, imm_se_ID_EX_in;
wire [4:0] read_reg1, read_reg2,read_reg1_temp, read_reg2_temp;
wire allZeros;

//////////////////////////////////////////CONTROL BITS///////////////////////////////////////////////////////////
wire [4:0] rd_ID, rs_ID, rt_ID, shamt_ID, alu_op_ID,opcode_ID;
wire [26:0] target_ID;
wire [16:0] immediate_ID;
wire  rs_rd1_ID, rt_rs2_ID, memToReg_ID, reg_we_ID, mem_we_ID, alu_imm_ctrl_ID;
wire br_ID, jump_ID,jal_ctrl_ID,jr_ctrl_ID, bne_blt_ID,STALL_ID, changePC_ID;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//ROUND 3

wire data_exception_multdiv, data_inputRDY, data_resultRDY;
wire [26:0] status_reg_in, status_reg_out;
wire enableStatus,bex_ex, not_AllZeros_27bit,isBEX;
wire bne_or_blt, br_mux_ctrl;
wire [31:0] data_regA_bypassed, data_regB_bypassed;
wire [31:0] pc_immedInst, jumpInst, be_or_NextInst, jump_or_NextInst, jrVal_or_NextInst;
wire [31:0] aluImmB;
wire isLessThan, isNotEqual, overflow;
wire [31:0] alu_result_EX_MEM_in, data_result_mult_div;
wire [4:0] read_reg1_BP, read_reg2_BP;
wire notEquals0_MEM,notEquals0_WB;
wire [1:0] forwardA, forwardB;

//////////////////////////////////////////CONTROL BITS///////////////////////////////////////////////////////////
wire [4:0] rd_EX, rs_EX, rt_EX, shamt_EX, alu_op_EX,opcode_EX;
wire [26:0] target_EX;
wire [16:0] immediate_EX;
wire  rs_rd1_EX, rt_rs2_EX, memToReg_EX, reg_we_EX, mem_we_EX, alu_imm_ctrl_EX;
wire br_EX, jump_EX,jal_ctrl_EX,jr_ctrl_EX, bne_blt_EX,STALL_EX, changePC_EX;

wire arith_EX, ctrl_div_EX,ctrl_mult_EX,ctrl_mult_div_EX;
////////////////////////////////////

//ROUND 3-4

//INPUT WIRES//////
wire [31:0] instr_EX_MEM_in, next_inst_EX_MEM_in;
wire [31:0] data_readRegB_EX_MEM_in;


//OUTPUT WIRES//////
wire [31:0] instr_EX_MEM_out, next_inst_EX_MEM_out;
wire [31:0] data_readRegB_EX_MEM_out;
wire [31:0] alu_result_EX_MEM_out;

//ROUND 4

wire [31:0] dataMem_output_MEM_WB_in;
wire [31:0] bypass_data_WB;
wire [4:0] write_reg_mem;
wire bypass_mem;

//////////////////////////////////////////CONTROL BITS///////////////////////////////////////////////////////////
wire [4:0] rd_MEM, rs_MEM, rt_MEM, shamt_MEM, alu_op_MEM,opcode_MEM;
wire [26:0] target_MEM;
wire [16:0] immediate_MEM;
wire  rs_rd1_MEM, rt_rs2_MEM, memToReg_MEM, reg_we_MEM, mem_we_MEM, alu_imm_ctrl_MEM;
wire br_MEM, jump_MEM,jal_ctrl_MEM,jr_ctrl_MEM, bne_blt_MEM, STALL_MEM,changePC_MEM;
wire sw_MEM;
////////////////////////////////////////////////////////////////////////////////////////////////////////////


//ROUND 4-5

//INPUT WIRES//////
wire [31:0] alu_result_MEM_WB_in;
wire [31:0] instr_MEM_WB_in, next_inst_MEM_WB_in;
assign next_inst_MEM_WB_in = next_inst_EX_MEM_out;
assign instr_MEM_WB_in = instr_EX_MEM_out;
assign alu_result_MEM_WB_in = alu_result_EX_MEM_out;


///OUTPUT WIRES///
wire [31:0] instr_MEM_WB_out, next_inst_MEM_WB_out, alu_result_MEM_WB_out, dataMem_output_MEM_WB_out;


//ROUND 5
wire [31:0] data_writeReg;
wire [4:0] write_reg_WB, rd_WB_case_multdiv,write_reg_no_multdiv_WB;
wire [31:0] alu_or_mem,jal_inst,data_no_multdiv_WB;

//////////////////////////////////////////CONTROL BITS///////////////////////////////////////////////////////////
wire [4:0] rd_WB, rs_WB, rt_WB, shamt_WB, alu_op_WB,opcode_WB;
wire [26:0] target_WB;
wire [16:0] immediate_WB;
wire  rs_rd1_WB, rt_rs2_WB, WBToReg_WB, reg_we_WB, WB_we_WB, alu_imm_ctrl_WB;
wire br_WB, jump_WB,jal_ctrl_WB,jr_ctrl_WB, bne_blt_WB,STALL_WB,changePC_WB;
wire ctrl_mult_div_WB, arith_WB, ctrl_mult_WB, ctrl_div_WB;
////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////Round 1 - IF //////////////////////////////////////////////////////////////////


//	imem myimem(	.address 	(pcReadOut[11:0]),   // shouldn't this be pcReadOut???
//					.clken		(1'b1),
//					.clock		(clock),
//					.q			(instr_IF_ID_in) // I think IMEM becomes the instr but not 100% sure.
//	); 	
//	//readout goes into an adder.
	
	
//	start startfsm(readyToBegin,1'b1,clock,reset);
	
//	multiplexer(nextInstructionLocation, 32'b0, nextPC, readyToBegin);
	
	imem myimem(	.address 	(pcReadOut[11:0]),   // shouldn't this be pcReadOut???
					.clken		(1'b1),
					.clock		(~clock),
					.q			(currInst_32bit) // I think IMEM becomes the instr but not 100% sure.
	); 	
	//readout goes into an adder.
	
	adder32bit_8 firstadder(normalInst_loc, pcReadOut, 32'b1, 1'b0); //adding in this case!
	
	multiplexer nextPC1(nextPC_afterStall, normalInst_loc, pcReadOut, stallLW);
	multiplexer nextPC2(nextPC, nextPC_afterStall, jrVal_or_NextInst, flushJB);
	
	singleReg pc(pcReadOut, nextPC, clock, reset, 1'b1);
	
//	multiplexer mstall(next_inst_IF_ID_in, normalInst_loc, pcReadOut, stallLW); //not sure if STALL_IF or STALL_ID
	
	assign next_inst_IF_ID_in = nextPC;
	
	
//	multiplexer definiteInstr(currInst_loc, normalInst_loc, jrVal_or_NextInst,STALL_EX);
	// view for inputs- adder32bit_8(sum, dataA, dataB, subtractBit);
	
//	multiplexer mstallcurr(instr_in,currInst_32bit, 32'b0, stallLW); //not sure if STALL_IF or STALL_ID
//	multiplexer mstallcurr(instr_in,currInst_32bit, 32'b0, stallLW); //not sure if STALL_IF or STALL_ID
	
	
///////////////////////Round 1 -> Round 2 Signals (IF/ID)//////////////////////////////////////////////////////


multiplexer mstallF_fff(stallResult_IF_ID,currInst_32bit,instr_IF_ID_out, stallLW); //not sure if STALL_IF or STALL_ID

multiplexer mFlushF(instr_IF_ID_in, stallResult_IF_ID, 32'b0, flushJB); // flush here;
	
IF_ID_Register i1(instr_IF_ID_out, next_inst_IF_ID_out, instr_IF_ID_in, next_inst_IF_ID_in, clock, reset);


///////////////////////////////////////Round 2 Signals (ID) /////////////////////////////////////////////


//multiplexer idInst(instr_ID, instr_IF_ID_out, stallLW);


//CONTROL SIGNALS - ID STAGE
/////////////////////////////////////////////////////////////////////////////////////////////////////////
computeValues cv2(opcode_ID, rd_ID, rs_ID, rt_ID, shamt_ID, alu_op_ID, immediate_ID, target_ID, instr_IF_ID_out);
instControl icd2(opcode_ID, alu_op_ID, rs_rd1_ID, rt_rs2_ID, memToReg_ID, reg_we_ID, 
mem_we_ID, alu_imm_ctrl_ID, br_ID, jump_ID, jal_ctrl_ID,jr_ctrl_ID, bne_blt_ID);

and a3122(sw_ID,~opcode_ID[4], ~opcode_ID[3],opcode_ID[2],opcode_ID[1],opcode_ID[0]);   
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

	
checkEquality cess(allZeros, instr_IF_ID_out);

	// Rd, rs, rt. read ports
	multiplexer_5bit read_port1(read_reg1_temp, rs_ID, rd_ID, rs_rd1_ID);
	multiplexer_5bit read_port2(read_reg2_temp, rt_ID, rs_ID, rt_rs2_ID);

	multiplexer_5bit r_sw1(read_reg1, read_reg1_temp, read_reg2_temp, sw_ID);
	multiplexer_5bit r_sw2(read_reg2, read_reg2_temp, read_reg1_temp, sw_ID);

	////TEMPORARILY READ ALL REGS!!!!!!
wire signed [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11,
 reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, 
 reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
 
 wire [1023:0] allData;

  
 		regfile_jx35 rex(~clock, reg_we_WB, reset, write_reg_WB, 
read_reg1, read_reg2, data_writeReg, data_readRegA_ID_EX_in, data_readRegB_ID_EX_in, allData);
 
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

signExt15 se(imm_se_ID_EX_in, immediate_ID);

///////////////////////////////////Round 2- > Round 3 Signals (ID- EX) //////////////////////////////////////////////////////

wire [31:0] instr_ID_EX_in, next_inst_ID_EX_in;
wire stallOrFlush;
wire [31:0]  instr_ID_EX_out,next_inst_ID_EX_out;
wire [31:0] data_readRegA_ID_EX_out, data_readRegB_ID_EX_out, imm_se_ID_EX_out;

or stf(stallOrFlush, stallLW, flushJB);

multiplexer mstallD_loop(instr_ID_EX_in,instr_IF_ID_out, 32'b0, stallOrFlush); //not sure if STALL_IF or STALL_ID

//assign instr_ID_EX_in = instr_IF_ID_out;
assign next_inst_ID_EX_in = next_inst_IF_ID_out;


ID_EX_Register ifexr(instr_ID_EX_out, next_inst_ID_EX_out,
data_readRegA_ID_EX_out, data_readRegB_ID_EX_out, imm_se_ID_EX_out, 
data_readRegA_ID_EX_in, data_readRegB_ID_EX_in, imm_se_ID_EX_in, next_inst_ID_EX_in,
instr_ID_EX_in,clock, reset);


////////////////////////////////////////////////Round 3 Signals//////////////////////////////////////////////////////


//CONTROL SIGNALS - EX STAGE
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
computeValues cv3(opcode_EX, rd_EX, rs_EX, rt_EX, shamt_EX, alu_op_EX, immediate_EX, target_EX, instr_ID_EX_out);
instControl ic3(opcode_EX,alu_op_EX, rs_rd1_EX, rt_rs2_EX, memToReg_EX, reg_we_EX, 
mem_we_EX, alu_imm_ctrl_EX, br_EX, jump_EX, jal_ctrl_EX,jr_ctrl_EX, bne_blt_EX);
and a5324(isBEX,opcode_EX[4], ~opcode_EX[3],opcode_EX[2],opcode_EX[1],~opcode_EX[0]);     // 10110

and a53255(arith_EX,~opcode_EX[4], ~opcode_EX[3],~opcode_EX[2],~opcode_EX[1],~opcode_EX[0]);
and a53234(ctrl_mult_EX,~alu_op_EX[4], ~alu_op_EX[3],alu_op_EX[2],alu_op_EX[1],~alu_op_EX[0], arith_EX);
and a532343(ctrl_div_EX,~alu_op_EX[4], ~alu_op_EX[3],alu_op_EX[2],alu_op_EX[1], alu_op_EX[0], arith_EX);
or(ctrl_mult_div_EX,ctrl_mult_EX, ctrl_div_EX);

and a3125(sw_EX,~opcode_EX[4], ~opcode_EX[3],opcode_EX[2],opcode_EX[1],opcode_EX[0]);   


/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

multiplexer4 m4b1(data_regA_bypassed, data_readRegA_ID_EX_out,data_writeReg,alu_result_EX_MEM_out,data_readRegA_ID_EX_out,forwardA);
multiplexer4 m4b2(data_regB_bypassed, data_readRegB_ID_EX_out,data_writeReg,alu_result_EX_MEM_out,data_readRegB_ID_EX_out,forwardB);

multiplexer readB_or_immediate(aluImmB, data_regB_bypassed, imm_se_ID_EX_out, alu_imm_ctrl_EX); 

jx35_alu alu(data_regA_bypassed, aluImmB, alu_op_EX, shamt_EX,  alu_result_EX_MEM_in, isNotEqual, isLessThan, overflow);

multdiv_jx35 mddd(data_regA_bypassed, data_regB_bypassed,ctrl_mult_EX, ctrl_div_EX, clock, data_result_mult_div, data_exception_multdiv, data_inputRDY, data_resultRDY);

//jx35_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow, ctrl_mult_div,clock);

adder32bit_8 addd45(pc_immedInst,next_inst_ID_EX_out, imm_se_ID_EX_out, 1'b0); //1 or 4?
//multiplexer to choose between equalTO and LessThan
multiplexer_1bit bne_or_blt_mux(bne_or_blt,isNotEqual, isLessThan, bne_blt_EX);

//setx and betx are here.
statusReg ssssrrrr(status_reg_in, enableStatus, opcode_EX, alu_op_EX, target_EX, overflow,data_exception_multdiv,data_resultRDY);

singleReg_27bit s27jump(status_reg_out, status_reg_in, clock, reset, enableStatus);

assign jumpInst[26:0] = target_EX;
assign jumpInst[31:27] = next_inst_ID_EX_out[31:27];

checkEquality_27bit ce2789(not_AllZeros_27bit, status_reg_out);

and(bex_ex, not_AllZeros_27bit,isBEX);
or(goToTarget, jump_EX, bex_ex);

and(br_mux_ctrl, br_EX, bne_or_blt);
multiplexer if_mux(be_or_NextInst, next_inst_ID_EX_out, pc_immedInst, br_mux_ctrl);

multiplexer next_or_branch(jump_or_NextInst, be_or_NextInst, jumpInst, goToTarget);
multiplexer jr_mux(jrVal_or_NextInst, jump_or_NextInst, data_readRegA_ID_EX_out , jr_ctrl_EX); //value can be READ from the 31st register

//singleReg pc(pcReadOut, jrVal_or_NextInst, clock, reset, 1'b1);
// view for inputs- singleReg pc(readOut, writeIn, clk, clr, ena)

lw_Stall_Logic isl(stallLW, opcode_EX,opcode_ID, alu_op_EX, alu_op_ID, rd_EX, read_reg1, read_reg2);
flushLogic fff(flushJB, opcode_EX, isNotEqual, isLessThan);

multiplexer_5bit read_port1BP(read_reg1_BP, rs_EX, rd_EX, rs_rd1_EX);
multiplexer_5bit read_port2BP(read_reg2_BP, rt_EX, rs_EX, rt_rs2_EX);

checkEquality ce11223(notEquals0_MEM, instr_EX_MEM_out);
checkEquality c315324(notEquals0_WB, instr_MEM_WB_out);

bypass_EX byp(forwardA, forwardB, reg_we_WB, reg_we_MEM, write_reg_WB, write_reg_mem, read_reg1_BP, read_reg2_BP,notEquals0_MEM,notEquals0_WB);

///////////////////////////////////Round 3 - > Round 4 Signals (EX-MEM)//////////////////////////////////////////


assign next_inst_EX_MEM_in = next_inst_ID_EX_out;
assign instr_EX_MEM_in = instr_ID_EX_out;
assign data_readRegB_EX_MEM_in = data_regB_bypassed;

EX_MEM_Register emr(instr_EX_MEM_out, 
alu_result_EX_MEM_out, data_readRegB_EX_MEM_out, next_inst_EX_MEM_out,
alu_result_EX_MEM_in, data_readRegB_EX_MEM_in, next_inst_EX_MEM_in,
instr_EX_MEM_in, clock, reset);



///////////////////////////////////////////ROUND 4 - MEM//////////////////////////////////////////////////////

//CONTROL SIGNALS - MEM STAGE
/////////////////////////////////////////////////////////////////////////////////////////////////////////
computeValues cv4(opcode_MEM, rd_MEM, rs_MEM, rt_MEM, shamt_MEM, alu_op_MEM, immediate_MEM, target_MEM, instr_EX_MEM_out);
instControl ic4(opcode_MEM,alu_op_MEM, rs_rd1_MEM, rt_rs2_MEM, memToReg_MEM, reg_we_MEM, 
mem_we_MEM, alu_imm_ctrl_MEM, br_MEM, jump_MEM, jal_ctrl_MEM,jr_ctrl_MEM, bne_blt_MEM);
   
and a3121(sw_MEM,~opcode_MEM[4], ~opcode_MEM[3],opcode_MEM[2],opcode_MEM[1],opcode_MEM[0], ~opcode_MEM);     
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

bypass_mem bmmmmmmmmm(bypass_mem, reg_we_WB, opcode_MEM,rd_WB, rd_MEM,notEquals0_WB);
multiplexer mdatabypass(bypass_data_WB, data_readRegB_EX_MEM_out, data_writeReg, bypass_mem);

multiplexer_5bit write_port_mem(write_reg_mem, rd_MEM, 5'b11111, jal_ctrl_MEM);


	// CHANGE THIS TO ASSIGN YOUR DMEM WRITE ADDRESS ALSO TO debug_addr
	assign debug_data_in = bypass_data_WB;
	// CHANGE THIS TO ASSIGN YOUR DMEM DATA INPUT (TO BE WRITTEN) ALSO TO debug_data
	multiplexer_12bit datamemplex(debug_address[11:0], alu_result_EX_MEM_out[11:0], data_result_mult_div[11:0],data_resultRDY);
	////////////////////////////////////////////////////////////
	
		
	// You'll need to change where the dmem and imem read and write...
	dmem mydmem(	.address	(alu_result_EX_MEM_out[11:0]), //(alu_result) , // WHAT GOES HERE?!?!????????????
					.clock		(~clock),
					.data		(bypass_data_WB), // (datareadRegA) //what goes here?!?!
					.wren		(mem_we_MEM),
					.q			(dataMem_output_MEM_WB_in) // change where output q goes...
	);

	
////////////////////////////////////Round 4 – 5 signals (MEM-WB) ///////////////////////////////////////////////////////


MEM_WB_Register mwbr(instr_MEM_WB_out, next_inst_MEM_WB_out, alu_result_MEM_WB_out, dataMem_output_MEM_WB_out,
alu_result_MEM_WB_in, dataMem_output_MEM_WB_in, next_inst_MEM_WB_in, instr_MEM_WB_in, clock, reset);


 
///////////////////////////////////////Round 5 (WB) ////////////////////////////////////////////////////////////////////////////



//CONTROL SIGNALS - WB STAGE
/////////////////////////////////////////////////////////////////////////////////////////////////////////
computeValues cv5(opcode_WB, rd_WB, rs_WB, rt_WB, shamt_WB, alu_op_WB, immediate_WB, target_WB, instr_MEM_WB_out);
instControl ic5(opcode_WB, alu_op_WB, rs_rd1_WB, rt_rs2_WB, memToReg_WB, reg_we_WB, 
mem_we_WB, alu_imm_ctrl_WB, br_WB, jump_WB, jal_ctrl_WB,jr_ctrl_WB, bne_blt_WB);
and b23(arith_WB,~opcode_WB[4], ~opcode_WB[3],~opcode_WB[2],~opcode_WB[1],~opcode_WB[0]);
and b2351(ctrl_mult_WB,~alu_op_WB[4], ~alu_op_WB[3],alu_op_WB[2],alu_op_WB[1],~alu_op_WB[0], arith_WB);
and b51(ctrl_div_WB,~alu_op_WB[4], ~alu_op_WB[3],alu_op_WB[2],alu_op_WB[1], alu_op_WB[0], arith_WB);
or o315(ctrl_mult_div_WB,ctrl_mult_WB, ctrl_div_WB);
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

singleReg_5bit s516(rd_WB_case_multdiv, rd_WB,clock, reset,ctrl_mult_div_WB);	

multiplexer_5bit write_port(write_reg_no_multdiv_WB, rd_WB, 5'b11111, jal_ctrl_WB);
multiplexer_5bit write_port_mult(write_reg_WB, write_reg_no_multdiv_WB,rd_WB_case_multdiv, data_resultRDY);

multiplexer alu_or_memData(alu_or_mem, alu_result_MEM_WB_out, dataMem_output_MEM_WB_out, memToReg_WB);

//adder32bit_8 a898987(jal_inst,next_inst_MEM_WB_out, 32'b1, 1'b0); //1 or 4?
multiplexer jalLoc_or_aluMem(data_no_multdiv_WB, alu_or_mem,next_inst_MEM_WB_out, jal_ctrl_WB);
multiplexer value_or_multdiv(data_writeReg, data_no_multdiv_WB, data_result_mult_div, data_resultRDY);

endmodule

module start(out,enable,clk,reset);
	output out;	 //potentially change								
	input enable, clk, reset;
	reg out;		//potentially change
	initial out = 1'b0;
	
	always @(negedge clk)
	if (reset) begin
	  out <= 1'b0;
	end else if (enable) begin
		//out <= out + 1;
		case(out)
			1'b0: out <= 1'b1;
			1'b1: out <= 1'b1;
		endcase
	end
endmodule 


//REGISTER MODULES!!!!!
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

module IF_ID_Register(instruction_out, nextInstr_out, instruction_in, nextInstr_in, clock, reset);
 
	input [31:0] instruction_in, nextInstr_in;
	output [31:0] instruction_out, nextInstr_out;
	input reset, clock;
	
	singleReg reg1(instruction_out, instruction_in, clock, reset, 1'b1);
	singleReg reg2(nextInstr_out, nextInstr_in, clock, reset, 1'b1);
		
endmodule

module ID_EX_Register(instruction_out, nextInstr_out,
readResultA_out, readResultB_out, immed_se_out,   
readResultA_in, readResultB_in, immed_se_in, nextInstr_in,
instruction_in, clock, reset);
 
 	
	input clock, reset;
 	input [31:0] instruction_in;
	output [31:0] instruction_out;
 
	input [31:0] readResultA_in, readResultB_in, immed_se_in, nextInstr_in;
	output [31:0] readResultA_out, readResultB_out, immed_se_out, nextInstr_out;
	
	singleReg reg1(instruction_out, instruction_in, clock, reset, 1'b1);
	singleReg readResAReg(readResultA_out, readResultA_in , clock, reset, 1'b1);
	singleReg readResBReg(readResultB_out,readResultB_in , clock, reset, 1'b1);
	singleReg immed_seReg(immed_se_out,immed_se_in , clock, reset, 1'b1);
	singleReg instrucLocReg(nextInstr_out, nextInstr_in, clock, reset, 1'b1);
	
endmodule

module EX_MEM_Register(instruction_out,
alu_result_out, readRegA_out, nextInstr_out,
alu_result_in, readRegA_in, nextInstr_in,
instruction_in, clock, reset);
 
	input clock, reset;
	input [31:0] instruction_in;
	output [31:0] instruction_out;
	
	input [31:0] nextInstr_in;
	output [31:0] nextInstr_out;
	
	input [31:0] alu_result_in, readRegA_in;
	output [31:0] alu_result_out, readRegA_out;
 
	singleReg reg1(instruction_out, instruction_in, clock, reset, 1'b1);
	singleReg instrucLocReg(readRegA_out,readRegA_in, clock, reset, 1'b1);
	singleReg aluReg(alu_result_out,alu_result_in, clock, reset, 1'b1);
	singleReg pcReg(nextInstr_out,nextInstr_in, clock, reset, 1'b1);	

endmodule

module MEM_WB_Register(instruction_out, nextInstr_out, alu_result_out, memData_out,
alu_result_in, memData_in, nextInstr_in, instruction_in, clock, reset);
 
	input clock, reset;
	input [31:0] instruction_in;
	output [31:0] instruction_out;
	
	input [31:0] nextInstr_in;
	output [31:0] nextInstr_out;
	
 	input [31:0] alu_result_in, memData_in;
	output [31:0] alu_result_out, memData_out;
	
	singleReg reg1(instruction_out, instruction_in, clock, reset, 1'b1);
	singleReg instrucLocReg(alu_result_out, alu_result_in, clock, reset, 1'b1);
	singleReg memData(memData_out, memData_in, clock, reset, 1'b1);
	singleReg pcReg(nextInstr_out,nextInstr_in, clock, reset, 1'b1);	
	
endmodule


module instControl(opcode, alu_code, rs_rd1, rt_rs2, memToReg, reg_we, mem_we, alu_imm_ctrl, br, jump, jal_ctrl, jr_ctrl, bne_blt);
	input [4:0] opcode;
	input [4:0] alu_code;
	wire alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx;	
	wire mul, div;

	//control bits
	output rs_rd1, rt_rs2, memToReg, reg_we, mem_we, alu_imm_ctrl, br, jump, jal_ctrl, jr_ctrl, bne_blt;
 // for viewing inputs	decoder32(registerOutput, select, writeEnable);
 
 
	// defining the values of alu, addi, sw, lw, .... etc.
	and a1(alu,~opcode[4], ~opcode[3],~opcode[2],~opcode[1],~opcode[0]);  // 00000
	and a2(addi,~opcode[4], ~opcode[3],opcode[2],~opcode[1],opcode[0]); //00101
	and a3(sw,~opcode[4], ~opcode[3],opcode[2],opcode[1],opcode[0]);      // 00111
	and a4(lw,~opcode[4], opcode[3],~opcode[2],~opcode[1],~opcode[0]);    // 01000
	and a5(j,~opcode[4], ~opcode[3],~opcode[2],~opcode[1],opcode[0]);     //00001
	and a6(bne,~opcode[4], ~opcode[3],~opcode[2],opcode[1],~opcode[0]);   // 00010
	and a7(jal,~opcode[4], ~opcode[3],~opcode[2],opcode[1],opcode[0]);    //00011
	and a8(jr,~opcode[4], ~opcode[3],opcode[2],~opcode[1],~opcode[0]);    // 00100
	and a9(blt,~opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);    // 00110
	and a10(bex,opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);     // 10110
	and a11(setx,opcode[4], ~opcode[3],opcode[2],~opcode[1],opcode[0]);    // 10101
	
	and a16(mul, ~alu_code[4], ~alu_code[3],alu_code[2],alu_code[1],~alu_code[0], alu);
	and a17(div, ~alu_code[4], ~alu_code[3],alu_code[2],alu_code[1],alu_code[0], alu);
	
	// defining the values of the ctrl bits
	or(rs_rd1, sw, bne, jr, blt);
	or(rt_rs2, sw, bne,blt);
	assign memToReg = lw;
	
	and(alu_no_multdiv, alu, ~mul, ~div);
	or or2(reg_we, alu_no_multdiv, addi, lw, jal);
	or or3(jump, j,jal,jr);
	assign mem_we = sw;
	or or4(alu_imm_ctrl, addi, lw, sw);
	or or5(br, bne, blt);
	assign jal_ctrl = jal;
	assign jr_ctrl = jr;
	assign bne_blt = blt;
	
endmodule

module statusReg(statusOut, enable, opcode, alu_code, target, overflow_add_sub, overflow_mult_div, ctrl_mult_div_ready);
	
	input [4:0] opcode, alu_code;
	input [26:0] target;
	input overflow_add_sub,ctrl_mult_div_ready,overflow_mult_div;
	output [26:0] statusOut;
	output enable;
	
	wire alu, addi, bex, setx;	
	wire add, sub, mul, div;
	
	wire [26:0] isOne;
	wire possibleOF_ops_mult_div,possibleOF_ops_add_sub,isOne_case1,isOne_case2;
	
	and a1(alu,~opcode[4], ~opcode[3],~opcode[2],~opcode[1],~opcode[0]);  // 00000
	and a2(addi,~opcode[4], ~opcode[3],opcode[2],~opcode[1],opcode[0]); //00101
//	and a3(sw,~opcode[4], ~opcode[3],opcode[2],opcode[1],opcode[0]);      // 00111
//	and a4(lw,~opcode[4], opcode[3],~opcode[2],~opcode[1],~opcode[0]);    // 01000
//	and a5(j,~opcode[4], ~opcode[3],~opcode[2],~opcode[1],opcode[0]);     //00001
//	and a6(bne,~opcode[4], ~opcode[3],~opcode[2],opcode[1],~opcode[0]);   // 00010
//	and a7(jal,~opcode[4], ~opcode[3],~opcode[2],opcode[1],opcode[0]);    //00011
//	and a8(jr,~opcode[4], ~opcode[3],opcode[2],~opcode[1],~opcode[0]);    // 00100
//	and a9(blt,~opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);    // 00110
	and a10(bex,opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);     // 10110
	and a11(setx,opcode[4], ~opcode[3],opcode[2],~opcode[1],opcode[0]);    // 10101
	
	and a12(add, ~alu_code[4], ~alu_code[3],~alu_code[2],~alu_code[1],~alu_code[0], alu);
	and a13(sub, ~alu_code[4], ~alu_code[3],~alu_code[2],~alu_code[1], alu_code[0], alu);
	and a16(mul, ~alu_code[4], ~alu_code[3],alu_code[2],alu_code[1],~alu_code[0], alu);
	and a17(div, ~alu_code[4], ~alu_code[3],alu_code[2],alu_code[1],alu_code[0], alu);
	
	or o1(possibleOF_ops_add_sub, addi, add, sub);
	
	and(isOne_case1, possibleOF_ops_add_sub, overflow_add_sub);
	and(isOne_case2, ctrl_mult_div_ready, overflow_mult_div);

	or(isOne[0],isOne_case1,isOne_case2);
	
	assign isOne[26:1] = 26'b0;
	
	assign enable = isOne[0] || setx; 
	
	multiplexer_27bit m27bit(statusOut, isOne, target, setx);
	
endmodule

module lw_Stall_Logic(stallLW, opcode_A, opcode_B, alu_code_A, alu_code_B, a_write, b_read1, b_read2);

	input [4:0] opcode_A, opcode_B, a_write,b_read1, b_read2, alu_code_A, alu_code_B;
	output stallLW;
	wire case1, case2, correctCom_case1, correctCom_case2, totalCase1, totalCase2,totalCase3, lw_A,mul_A, div_A;
	wire alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx;	
	wire add, sub, and_alu, or_alu, sll, sra, mul, div;
		
	and a1233(lw_A,~opcode_A[4], opcode_A[3],~opcode_A[2],~opcode_A[1],~opcode_A[0]);  // 01000
	and a1234(alu_A,~opcode_A[4], ~opcode_A[3],~opcode_A[2],~opcode_A[1],~opcode_A[0]);  // 01000
	and a1235(mul_A, ~alu_code_A[4], ~alu_code_A[3],alu_code_A[2],alu_code_A[1],~alu_code_A[0], alu_A);
	and a1236(div_A, ~alu_code_A[4], ~alu_code_A[3],alu_code_A[2],alu_code_A[1],alu_code_A[0], alu_A);
	
	
	and a1(alu,~opcode_B[4], ~opcode_B[3],~opcode_B[2],~opcode_B[1],~opcode_B[0]);  // 00000
	and a2(addi,~opcode_B[4], ~opcode_B[3],opcode_B[2],~opcode_B[1],opcode_B[0]); //00101
	and a3(sw,~opcode_B[4], ~opcode_B[3],opcode_B[2],opcode_B[1],opcode_B[0]);      // 00111
	and a4(lw,~opcode_B[4], opcode_B[3],~opcode_B[2],~opcode_B[1],~opcode_B[0]);    // 01000
	and a5(j,~opcode_B[4], ~opcode_B[3],~opcode_B[2],~opcode_B[1],opcode_B[0]);     //00001
	and a6(bne,~opcode_B[4], ~opcode_B[3],~opcode_B[2],opcode_B[1],~opcode_B[0]);   // 00010
	and a7(jal,~opcode_B[4], ~opcode_B[3],~opcode_B[2],opcode_B[1],opcode_B[0]);    //00011
	and a8(jr,~opcode_B[4], ~opcode_B[3],opcode_B[2],~opcode_B[1],~opcode_B[0]);    // 00100
	and a9(blt,~opcode_B[4], ~opcode_B[3],opcode_B[2],opcode_B[1],~opcode_B[0]);    // 00110
	and a10(bex,opcode_B[4], ~opcode_B[3],opcode_B[2],opcode_B[1],~opcode_B[0]);     // 10110
	and a11(setx,opcode_B[4], ~opcode_B[3],opcode_B[2],~opcode_B[1],opcode_B[0]);    // 10101
	
	and a12(add, ~alu_code_B[4], ~alu_code_B[3],~alu_code_B[2],~alu_code_B[1],~alu_code_B[0], alu);
	and a13(sub, ~alu_code_B[4], ~alu_code_B[3],~alu_code_B[2],~alu_code_B[1], alu_code_B[0], alu);
	and a18(and_alu, ~alu_code_B[4], ~alu_code_B[3],~alu_code_B[2],alu_code_B[1],~alu_code_B[0], alu);
	and a19(or_alu, ~alu_code_B[4], ~alu_code_B[3],~alu_code_B[2],alu_code_B[1],alu_code_B[0], alu);
	and a14(sll, ~alu_code_B[4], ~alu_code_B[3],alu_code_B[2],~alu_code_B[1],~alu_code_B[0], alu);	
	and a15(sra, ~alu_code_B[4], ~alu_code_B[3],alu_code_B[2],~alu_code_B[1],alu_code_B[0], alu);
	and a16(mul, ~alu_code_B[4], ~alu_code_B[3],alu_code_B[2],alu_code_B[1],~alu_code_B[0], alu);
	and a17(div, ~alu_code_B[4], ~alu_code_B[3],alu_code_B[2],alu_code_B[1],alu_code_B[0], alu);

	sameRegister_5bit sr1(case1,a_write, b_read1);
	sameRegister_5bit sr2(case2,a_write, b_read2);
		
	or o1(correctCom_case1, sw,lw, alu, addi, bne, blt, jr);
	or o2(correctCom_case2, add, sub , and_alu,or_alu,mul, div, bne, blt);
	
	or or3(totalCase3, mul_A, div_A);
	
	and a50(totalCase1, correctCom_case1, case1, lw_A);
	and a51(totalCase2, correctCom_case2, case2, lw_A);
	
	or final(stallLW,  totalCase1, totalCase2, totalCase3);
	
endmodule


module flushLogic(flush, opcode, isNotEqual, isLessThan);

	input [4:0] opcode;
	input isNotEqual, isLessThan;
	
	output flush;
	wire case1_a, case1_b, case2;
	wire j, bne, jal, jr, blt, bex;
	
	and a5(j,~opcode[4], ~opcode[3],~opcode[2],~opcode[1],opcode[0]);     //00001
	and a6(bne,~opcode[4], ~opcode[3],~opcode[2],opcode[1],~opcode[0]);   // 00010
	and a7(jal,~opcode[4], ~opcode[3],~opcode[2],opcode[1],opcode[0]);    //00011
	and a8(jr,~opcode[4], ~opcode[3],opcode[2],~opcode[1],~opcode[0]);    // 00100
	and a9(blt,~opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);    // 00110
	and a10(bex,opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);     // 10110
	
	and(case1_a, isNotEqual, bne);
	and(case1_b, isLessThan, blt);
	
	or(case2, j, jal, jr, bex);
	
	or(flush, case1_a, case1_b, case2);
	
endmodule

module bypass_EX(forward_A, forward_B, w_en_wb, w_en_mem, write_reg_wb, write_reg_mem, read_reg1, read_reg2, mem_InstNotZero, WB_InstNotZero);
	
	input w_en_wb, w_en_mem;
	input [4:0] write_reg_wb, write_reg_mem, read_reg1, read_reg2;
	
	input mem_InstNotZero, WB_InstNotZero;
	
	output [1:0] forward_A, forward_B;

	wire sameReg_2A, sameReg_2B, sameReg_1A, sameReg_1B;
	
	sameRegister_5bit sr1(sameReg_2A, write_reg_mem, read_reg1);
	sameRegister_5bit sr2(sameReg_2B, write_reg_mem, read_reg2);
	
	sameRegister_5bit sr3(sameReg_1A, write_reg_wb, read_reg1);
	sameRegister_5bit sr4(sameReg_1B, write_reg_wb, read_reg2);
	
	assign forward_A[1] = w_en_mem & sameReg_2A & mem_InstNotZero;
	assign forward_B[1] = w_en_mem & sameReg_2B & mem_InstNotZero;
		
	assign forward_A[0] = w_en_wb & sameReg_1A & (~sameReg_2A ||  ~w_en_mem) & WB_InstNotZero;
	assign forward_B[0] = w_en_wb & sameReg_1B & (~sameReg_2B ||  ~w_en_mem) & WB_InstNotZero;

endmodule
	
module bypass_mem(bypass_mem,reg_write_ctrl, opcode_Mem, rd_WB, rd_Mem, WB_InstNotZero);

	input reg_write_ctrl;
	input [4:0] opcode_Mem;
	input [4:0] rd_WB, rd_Mem;
	input WB_InstNotZero;
	
	wire equalWire, sw_Mem;
	
	output bypass_mem;

	and a3(sw_Mem,~opcode_Mem[4], ~opcode_Mem[3],opcode_Mem[2],opcode_Mem[1],opcode_Mem[0]);      // 00111
	
	sameRegister_5bit srg(equalWire, rd_WB, rd_Mem);
	
	and a28(bypass_mem,reg_write_ctrl, sw_Mem, equalWire, WB_InstNotZero);

endmodule

module computeValues(opcode, rd, rs, rt, shamt, alu_op, immediate, target, instr);
		input [31:0] instr;
		output [4:0] rd, rs, rt, shamt, alu_op,opcode;
		output [26:0] target;
//		output [1:0] zeroes_R;
		output [16:0] immediate;
//		output [21:0] zeroes_J;
		
		wire [4:0] aluOpNormal;
		
		wire [1:0] select;
		
		wire sw, lw, blt, bne, add, sub, aluReg,addi;
		
		assign opcode = instr[31:27];
		
		and a0(aluReg,~opcode[4], ~opcode[3],~opcode[2],~opcode[1],~opcode[0]);
		and a1(sw,~opcode[4], ~opcode[3],opcode[2],opcode[1],opcode[0]);
		and a2(lw,~opcode[4], opcode[3],~opcode[2],~opcode[1],~opcode[0]);
		and a3(addi,~opcode[4], ~opcode[3],opcode[2],~opcode[1],opcode[0]);
		and a4(blt,~opcode[4], ~opcode[3],opcode[2],opcode[1],~opcode[0]);
		and a5(bne,~opcode[4], ~opcode[3],~opcode[2],opcode[1],~opcode[0]);
		
		or o1(add, sw, lw, addi);
		or o2(sub, blt,bne);
		
		or o3(select[0], sub, aluReg);
		or o4(select[1], add, aluReg);
		
		
		//Setting Status here, based on the ALU code ....//
//		and a6(setStatusAdd, ~alu_op[4], ~alu_op[3],~alu_op[2],~alu_op[1],~alu_op[0]);
//		and a7(setStatusSub, ~alu_op[4], ~alu_op[3],~alu_op[2],~alu_op[1],alu_op[0]);
//		and a8(setStatusMult, ~alu_op[4], ~alu_op[3],alu_op[2],alu_op[1],~alu_op[0]);
//		and a9(setStatusDiv, ~alu_op[4], ~alu_op[3],alu_op[2],alu_op[1],alu_op[0]);
		////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////
		
		assign rd = instr[26:22];
		assign rs = instr[21:17];
		assign rt = instr[16:12];
		assign shamt = instr[11:7];
		assign aluOpNormal = instr[6:2];
//		assign zeroes_R = instr[1:0];
		assign immediate = instr[16:0];
		assign target = instr[26:0];
//		assign zeroes_J = instr[21:0];
		multiplexer4_5bit mp(alu_op, 5'b00000 ,5'b00001, 5'b00000, aluOpNormal, select);
		
endmodule

module signExt15(out, in);

	input [16:0] in;
	output [31:0] out;
	genvar i;
	generate
	for (i = 31; i > 16; i = i-1) begin: adderFullLoop
		assign out[i] = in[16];
	end
	endgenerate
	
	assign out[16:0] = in;
endmodule

module basicShiftLeft2(out, in);

	input [26:0] in;
	output [28:0] out;
	genvar i;
	generate
	for (i = 28; i >= 2; i = i-1) begin: adderFullLoop
		assign out[i] = in[i-2];
	end
	endgenerate
	
	assign out[1:0] = 2'b00;
	
endmodule

module multiplexer4_5bit(out,input0, input1, input2, input3, selectBits);
	input [4:0] input0, input1, input2, input3;
	input [1:0] selectBits;
	wire[4:0] w1, w2;
	output [4:0] out;
	multiplexer_5bit m1 (w1, input0,input1, selectBits[0]),
	        m2 (w2, input2, input3, selectBits[0]),
	        m3 (out, w1, w2,selectBits[1]);
endmodule

module multiplexer_27bit(out,input1, input2, selectBit);
	input [26:0] input1, input2;
	input selectBit;
	output [26:0] out;
	genvar i;
	generate
	for (i = 0; i < 27; i = i+1) begin: multiplexerLoop
		assign out[i] = selectBit ? input2[i]:input1[i];
	end
	endgenerate
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	

module multiplexer_12bit(out,input1, input2, selectBit);
	input [11:0] input1, input2;
	input selectBit;
	output [11:0] out;
	genvar i;
	generate
	for (i = 0; i < 12; i = i+1) begin: multiplexerLoop
		assign out[i] = selectBit ? input2[i]:input1[i];
	end
	endgenerate
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	

module multiplexer_5bit(out,input1, input2, selectBit);
	input [4:0] input1, input2;
	input selectBit;
	output [4:0] out;
	genvar i;
	generate
	for (i = 0; i < 5; i = i+1) begin: multiplexerLoop
		assign out[i] = selectBit ? input2[i]:input1[i];
	end
	endgenerate
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	

module multiplexer_1bit(out,input1, input2, selectBit);
	input input1, input2;
	input selectBit;
	output out;
	assign out = selectBit ? input2:input1;
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	


module sameRegister_5bit(same, inputA, inputB);
	input [4:0] inputA, inputB;
	wire[4:0] dataResult;
	wire [4:0] tempOutput;
	

	genvar j;
	generate
	for (j = 0; j < 5; j = j+1) begin: xorloops
		xor xa(dataResult[j], inputA[j],inputB[j]);
	end
	endgenerate
	
	output same;
	
	assign tempOutput[0] = dataResult[0];
	genvar i;
	generate
	for (i = 1; i < 5; i = i+1) begin: adderLoop 
		or(tempOutput[i], dataResult[i], tempOutput[i-1]);
	end
	endgenerate
	
	not(same,tempOutput[4]);

endmodule

module singleReg_27bit(readOut, writeIn, clk, clr, ena);

	input clk, clr, ena;
	input [26:0] writeIn;
	output [26:0] readOut;
	wire clrn;
	assign clrn = ~clr;
	
	genvar i;
	generate
	for (i = 0; i < 27; i = i+1) begin: loop1
		dffe currDFFE(.d(writeIn[i]), .clk(clk), .clrn(clrn), .prn(1'b1), .ena(ena), .q(readOut[i]));
	end
	endgenerate

endmodule

module singleReg_5bit(readOut, writeIn, clk, clr, ena);

	input clk, clr, ena;
	input [4:0] writeIn;
	output [4:0] readOut;
	wire clrn;
	assign clrn = ~clr;
	
	genvar i;
	generate
	for (i = 0; i < 5; i = i+1) begin: loop1
		dffe currDFFE(.d(writeIn[i]), .clk(clk), .clrn(clrn), .prn(1'b1), .ena(ena), .q(readOut[i]));
	end
	endgenerate

endmodule

module checkEquality_27bit(notEquals0, dataResult);
	input [26:0] dataResult;
	
	wire [26:0] tempOutput;
	output notEquals0;
	
	assign tempOutput[0] = dataResult[0];
	genvar i;
	generate
	for (i = 1; i < 27; i = i+1) begin: adderLoop 
		or(tempOutput[i], dataResult[i], tempOutput[i-1]);
	end
	endgenerate
	
	assign notEquals0 = tempOutput[26];
endmodule


//////////////// RECYCLED CODE BELOW!!! ALU.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module jx35_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	wire[31:0] adderResult, andOrResult,shiftResult;
	
	adder32bit_8 theAdder(adderResult, data_operandA, data_operandB, ctrl_ALUopcode[0]);
	andOr32bit andOr(andOrResult, data_operandA, data_operandB,ctrl_ALUopcode[0]);
	shiftOperator so(shiftResult, data_operandA, ctrl_shiftamt,ctrl_ALUopcode[0]);
	multiplexer4 multiplex(data_result, adderResult,andOrResult, shiftResult,32'b0,ctrl_ALUopcode[2:1]);
	
	isLT itl(isLessThan, data_operandA[31], data_operandB[31], data_result[31]);

	overFlowChecker ofc(overflow, data_operandA[31], data_operandB[31], data_result[31], ctrl_ALUopcode[0]);
	checkEquality ce(isNotEqual, data_result);
endmodule
	
module isLT(itl,digitA, digitB, diff);
	input digitA, digitB, diff;
	wire c1,c2,c3,c4,not1b, not1a, notdiff;
	output itl;
	
	not n1a(not1a, digitA);
	not n1b(not1b, digitB);
	not ndiff(notdiff,diff);
	and case1(c1, digitA, digitB, diff);
	and case2(c2, not1a, not1b, diff);
	and case3(c3, digitA, not1b,diff);
	and case4(c4, digitA, not1b,notdiff);
	or(itl, c1,c2,c3,c4);
endmodule

module overFlowChecker(overFlow, digit1A,digit1B,result1,addSub);
	input digit1A, digit1B, result1,addSub;
	wire c1,c2,c3,c4, not1b, not1a, notresult, notaddSub;
	output overFlow;
	
	not n1a(not1a, digit1A);
	not n1b(not1b, digit1B);
	not nresult(notresult, result1);
	not nadd(notaddSub, addSub);
	
	and case1(c1, not1a, not1b, result1, notaddSub);
	and case2(c2, digit1A, digit1B, notresult, notaddSub);
	and case3(c3, digit1A, not1b, notresult, addSub);
	and case4(c4, not1a, digit1B, result1, addSub);
	or(overFlow, c1,c2,c3,c4);
endmodule

module checkEquality(notEquals0, dataResult);
	input [31:0] dataResult;
	
	wire [31:0] tempOutput;
	output notEquals0;
	
	assign tempOutput[0] = dataResult[0];
	genvar i;
	generate
	for (i = 1; i < 32; i = i+1) begin: adderLoop 
		or(tempOutput[i], dataResult[i], tempOutput[i-1]);
	end
	endgenerate
	
	assign notEquals0 = tempOutput[31];
endmodule

module ALU1bit(g, p, dataA, dataB);
	input dataA, dataB;
	output g, p;
	and and1(g,dataA,dataB);
	or or1(p, dataA, dataB);
endmodule


module adder8bit(sum, carryFinal, totalG, totalP, dataA, dataB,carryIn);
	input [7:0] dataA, dataB;
	input carryIn;
	output [7:0] sum;
	output carryFinal;
	wire [8:0] carryOut;
	output totalG, totalP;
	wire[7:0] g, p;
	wire[8:0] toOutG, toOutP;
	assign toOutP[0] = 1;
	assign toOutG[0] = 0;
	assign carryOut[0] = carryIn;
	
	genvar i;
	generate
	for (i = 0; i < 8; i = i+1) begin: adderLoop 
		wire p_c;
		ALU1bit alu(g[i], p[i], dataA[i], dataB[i]);
		and pc(p_c, p[i], carryOut[i]);
		xor xor1(sum[i], dataA[i], dataB[i], carryOut[i]);
		or or1(carryOut[i+1],g[i], p_c);
	end
	endgenerate
	
	genvar j;
	generate
	for (j = 0; j < 8; j = j+1) begin: adderLoop2nd
		wire temp;
		and andP(toOutP[j+1], p[7-j], toOutP[j]);
		and andtemp(temp, g[7-j], toOutP[j]);
		or orG(toOutG[j+1], toOutG[j], temp);
	end
	endgenerate
	
	assign carryFinal = carryOut[8];
	assign totalG= toOutG[8];
	assign totalP= toOutP[8];
	
endmodule


//
module adder32bit_8(sum, dataA, dataB, subtractBit);
	input [31:0] dataA, dataB;
	input subtractBit;
	output [31:0] sum;
	wire [4:0] carryToNext;
	wire [31:0] BnotB;
	assign carryToNext[0] = subtractBit;
	
	genvar ii;
	generate
	for (ii = 0; ii < 32; ii = ii+1) begin: flipLoop
		wire notGate;
		not notdata(notGate,dataB[ii]);
		assign BnotB[ii] = subtractBit ? notGate : dataB[ii];
	end
	endgenerate
	
	genvar i;
	generate
	for (i = 0; i < 4; i = i+1) begin: adderFullLoop
		wire carryOut,totalG, totalP,p_c;
		adder8bit adder8(sum[i*8+7:i*8], carryOut, totalG, totalP, dataA[i*8+7:i*8], BnotB[i*8+7:i*8], carryToNext[i]);
		and pc(p_c, totalP, carryOut);
		or or1(carryToNext[i+1],totalG, p_c);
	end
	endgenerate
endmodule


module andOr32bit(out,dataA, dataB, andOr);
	input [31:0] dataA, dataB;
	input andOr;
	wire [31:0] outAnd, outOr;
	output [31:0] out;
	genvar i;
	generate
	for (i = 0; i < 32; i = i+1) begin: adderLoop
		ALU1bit alu(outAnd[i], outOr[i], dataA[i], dataB[i]);
	end
	endgenerate
	multiplexer mAndOr(out,outAnd,outOr,andOr);
endmodule

module multiplexer(out,input1, input2, selectBit);
	input [31:0] input1, input2;
	input selectBit;
	output [31:0] out;
	genvar i;
	generate
	for (i = 0; i < 32; i = i+1) begin: multiplexerLoop
		assign out[i] = selectBit ? input2[i]:input1[i];
	end
	endgenerate
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	


module multiplexer4(out,input0, input1, input2, input3, selectBits);
	input [31:0] input0, input1, input2, input3;
	input [1:0] selectBits;
	wire[31:0] w1, w2;
	output [31:0] out;
	multiplexer m1 (w1, input0,input1, selectBits[0]),
	        m2 (w2, input2, input3, selectBits[0]),
	        m3 (out, w1, w2,selectBits[1]);
endmodule

module shiftOperator(shiftedOut, dataA, shiftAmount, leftRight);
	input [31:0] dataA;
	input [4:0] shiftAmount;
	input leftRight;
	output [31:0] shiftedOut;
	wire [31:0] left, right;
	
	leftBarrelShifter lbs(left, dataA, shiftAmount);
	rightBarrelShifter rbs(right, dataA, shiftAmount);
	multiplexer mshift(shiftedOut,left,right,leftRight);
endmodule
	

module leftBarrelShifter(shiftedOut, dataA, shiftAmount);
	input [31:0] dataA;
	input [4:0] shiftAmount;
	wire [31:0] s16, sFinal16, s8, sFinal8, s4, sFinal4, s2, sFinal2, s1, sFinal1;
	output [31:0] shiftedOut;

	genvar i;
	generate
	for (i = 0; i < 16; i = i+1) begin: leftShiftLoop16
		assign s16[i+16] = dataA[i];
		assign s16[i] = 1'b0;
	end
	endgenerate
	multiplexer m16(sFinal16, dataA, s16, shiftAmount[4]);
	
	genvar i8;
	generate
	for (i8 = 0; i8 < 24; i8 = i8+1) begin: leftShiftLoop8
		assign s8[i8+8] = sFinal16[i8];
	end
	endgenerate
	
	genvar j8;
	generate
	for (j8 = 0; j8 < 8; j8 = j8+1) begin: leftShiftLoop8_2
		assign s8[j8] = 0;
	end
	endgenerate
	
	multiplexer m8(sFinal8, sFinal16, s8, shiftAmount[3]);
	
	// 4
	genvar i4;
	generate
	for (i4 = 0; i4 < 28; i4 = i4+1) begin: leftShiftLoop4
		assign s4[i4+4] = sFinal8[i4];
	end
	endgenerate
	
	genvar j4;
	generate
	for (j4 = 0; j4 < 4; j4 = j4+1) begin: leftShiftLoop4_2
		assign s4[j4] = 0;
	end
	endgenerate
	
	multiplexer m4(sFinal4, sFinal8, s4, shiftAmount[2]);
	
	//2
	genvar i2;
	generate
	for (i2 = 0; i2 < 30; i2 = i2+1) begin: leftShiftLoop2
		assign s2[i2+2] = sFinal4[i2];
	end
	endgenerate
	
	genvar j2;
	generate
	for (j2 = 0; j2 < 2; j2 = j2+1) begin: leftShiftLoop2_2
		assign s2[j2] = 0;
	end
	endgenerate
	
	multiplexer m2(sFinal2, sFinal4, s2, shiftAmount[1]);
	
	//1
	genvar i1;
	generate
	for (i1 = 0; i1 < 31; i1 = i1+1) begin: leftShiftLoop1
		assign s1[i1+1] = sFinal2[i1];
	end
	endgenerate
	
	genvar j1;
	generate
	for (j1 = 0; j1 < 1; j1 = j1+1) begin: leftShiftLoop1_2
		assign s1[j1] = 0;
	end
	endgenerate
	
	multiplexer m1(sFinal1, sFinal2, s1, shiftAmount[0]);
	
	assign shiftedOut = sFinal1;
endmodule

module rightBarrelShifter(shiftedOut, dataA, shiftAmount);
	input [31:0] dataA;
	input [4:0] shiftAmount;
	wire [31:0] s16, sFinal16, s8, sFinal8, s4, sFinal4, s2, sFinal2, s1, sFinal1;
	output [31:0] shiftedOut;
	
	genvar i;
	generate
	for (i = 16; i < 32; i = i+1) begin: leftShiftLoop16
		assign s16[i-16] = dataA[i];
		assign s16[i] = dataA[31];
	end
	endgenerate
	multiplexer m16(sFinal16, dataA, s16, shiftAmount[4]);
	
	genvar i8;
	generate
	for (i8 = 8; i8 < 32; i8 = i8+1) begin: rightShiftLoop8
		assign s8[i8-8] = sFinal16[i8];
	end
	endgenerate
	
	genvar j8;
	generate
	for (j8 = 24; j8 < 32; j8 = j8+1) begin: rightShiftLoop8_2
		assign s8[j8] = dataA[31];
	end
	endgenerate
	
	multiplexer m8(sFinal8, sFinal16, s8, shiftAmount[3]);
	
	// 4
	genvar i4;
	generate
	for (i4 = 4; i4 < 32; i4 = i4+1) begin: rightShiftLoop4
		assign s4[i4-4] = sFinal8[i4];
	end
	endgenerate
	
	genvar j4;
	generate
	for (j4 = 28; j4 < 32; j4 = j4+1) begin: rightShiftLoop4_2
		assign s4[j4] = dataA[31];
	end
	endgenerate
	
	multiplexer m4(sFinal4, sFinal8, s4, shiftAmount[2]);
	
	//2
	genvar i2;
	generate
	for (i2 = 2; i2 < 32; i2 = i2+1) begin: rightShiftLoop2
		assign s2[i2-2] = sFinal4[i2];
	end
	endgenerate
	
	genvar j2;
	generate
	for (j2 = 30; j2 < 32; j2 = j2+1) begin: rightShiftLoop2_2
		assign s2[j2] = dataA[31];
	end
	endgenerate
	
	multiplexer m2(sFinal2, sFinal4, s2, shiftAmount[1]);
	
	//1
	genvar i1;
	generate
	for (i1 = 1; i1 < 32; i1 = i1+1) begin: rightShiftLoop1
		assign s1[i1-1] = sFinal2[i1];
	end
	endgenerate
	
	genvar j1;
	generate
	for (j1 = 31; j1 < 32; j1 = j1+1) begin: rightShiftLoop1_2
		assign s1[j1] = dataA[31];
	end
	endgenerate
	
	multiplexer m1(sFinal1, sFinal2, s1, shiftAmount[0]);
	
	assign shiftedOut = sFinal1;
endmodule

//////////////// RECYCLED CODE BELOW!!! MULT DIV
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module multdiv_jx35(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_inputRDY, data_resultRDY);
   input [31:0] data_operandA;
   input [31:0] data_operandB;
	
   input ctrl_MULT, ctrl_DIV, clock;             
   output [31:0] data_result; 
   output data_exception, data_inputRDY, data_resultRDY;

	wire [31:0] latchedA, latchedB;
	wire reset;
	wire [5:0] cycleNum;
	
	wire [31:0] data_resultTemp;
	
	or or1(reset,ctrl_MULT, ctrl_DIV);
	
	up_counter uc(cycleNum,1'b1,clock,reset);
	
	wire finalOf, exception0, data_exception_mult, data_exception_div;
	wire [31:0] multResult, divResult;
	wire doneMult, doneDiv, latchOp;
	
	wire data_exceptionTemp, latchReady;
	singleReg sr1(latchedA, data_operandA, clock, 1'b0, reset);
	singleReg sr2(latchedB, data_operandB, clock, 1'b0, reset);
	singleReg sr3(data_result, data_resultTemp, clock, 1'b0, latchReady);
	
	dffe dtemp(.d(data_exceptionTemp), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(latchReady), .q(data_exception));
	
	dffe currDFFE(.d(ctrl_DIV), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(reset), .q(latchOp));
		
	dffe currDFFE151(.d(latchReady), .clk(clock), .clrn(1'b1), .prn(1'b1), .ena(1'b1), .q(data_resultRDY));
	
	fullMult fm(multResult,doneMult, finalOf, cycleNum, latchedA, latchedB, ctrl_MULT, clock);
	
	fullDiv fd(divResult,doneDiv,exception0, cycleNum, latchedA, latchedB, ctrl_DIV, clock);
	
	multiplexer mmd(data_resultTemp, multResult, divResult, latchOp);
	multiplexer1 mmd2(data_exceptionTemp, data_exception_mult, data_exception_div, latchOp);
	
	and a1(data_exception_mult, doneMult, finalOf);
	and a2(data_exception_div, doneDiv, exception0);
	
	or or2(latchReady, doneMult, doneDiv);
	
	
	
	assign data_inputRDY = 1;
	
endmodule


module fullMult(result, done, of, counterIn,data_operandA, data_operandB, reset, clock);
		input reset,clock;
		input [31:0] data_operandA, data_operandB;
		input [5:0] counterIn;
		wire [64:0] initInput, tempInput,initInput_S,readOut,chosenInput;
		wire ready, notReady;
		//data_operandA is multiplier, data_operandB is multiplicand
		output [31:0] result;
		
		output done;
		output of;
				
		or or5(notReady, counterIn[0], counterIn[1], counterIn[2], counterIn[3], counterIn[4]);
		not(ready,notReady);
		
		assign initInput[64:33] = 32'b0;
		assign initInput[32:1] = data_operandB;
		assign initInput[0] = 0;
		
		multCycle sc0(initInput_S, data_operandA, initInput); // take the initial input, then perform 1 cycle on it
		 
		multCycle sc(tempInput, data_operandA, readOut); // Perform a boothcycle on non-zero cycles
		
		multiplexer64 m11(chosenInput, tempInput, initInput_S,  ready);
		
		singleReg64 value(readOut, chosenInput, clock,reset, 1'b1);
		
		and(done, ready, counterIn[5]);
		
		checkOverflow cof(of,readOut, data_operandA, data_operandB);
		
		assign result = readOut[32:1];

endmodule

module fullDiv(result, done,exception, counterIn, data_operandA, data_operandB, reset, clock);
		input reset,clock;
		input [5:0] counterIn;
		input [31:0] data_operandA, data_operandB;
		output [31:0] result;
		output done;

		output exception;
		wire [31:0] initPosA, initPosB,quotRead, remRead,initQuot_S, initRem_S;
		wire flipResultBit;
		wire notReady;
		wire readyToFlip;
		wire [31:0] chosenRem, chosenQuot,initRem, initQuot,quotWrite, remWrite,flippedResult;
		initFlipLogic ifl(flipResultBit, initPosA, initPosB, data_operandA, data_operandB);
			
		wire ready;	
		or or5(notReady, counterIn[0], counterIn[1], counterIn[2], counterIn[3], counterIn[4]);
		not(ready,notReady);
		
		assign initRem = initPosA; // should be flipped A
		assign initQuot = 32'b0;
		
		divideCycle dc0(initQuot_S,initRem_S, initQuot,initRem, initPosB, counterIn[4:0]); // data_operand B is divisor
		divideCycle dc(quotWrite, remWrite,quotRead, remRead, initPosB, counterIn[4:0]); // data_operand B is divisor
		
		multiplexer m1(chosenQuot, quotWrite, initQuot_S, ready);
		multiplexer m2(chosenRem, remWrite, initRem_S,  ready);
		
		singleReg quotient(quotRead, chosenQuot,clock,reset, 1'b1);
		singleReg remain_Dend(remRead, chosenRem, clock, reset, 1'b1);
		
		and(done, ready, counterIn[5]);
		
		checkZero cz(exception,data_operandB); //check if initial was all 0s.
		and(readyToFlip, flipResultBit, done);
		flipVal fv23(flippedResult, quotRead);
		multiplexer m3(result, quotRead, flippedResult, readyToFlip);
		
endmodule

module divideCycle(remQuotientNew, remainDendNew, remQuotientOld, remainDendOld, divisor, cycleNum);

	input [31:0] remainDendOld;
	input [31:0] divisor;
	input [4:0] cycleNum;
	input [31:0] remQuotientOld;

	output [31:0] remQuotientNew;
	output [31:0] remainDendNew;
	
	wire GTE;
	wire LT;
	
	wire[4:0] shiftAmt;
	wire[31:0] shiftedDend;
	wire [31:0] shiftedSor;
	wire[31:0] difference1;
	wire[31:0] differenceFinal;
	wire [31:0] remQuotientTemp;
	
	genvar i;
	generate
	for (i = 0; i < 5; i = i+1) begin: NotLoop
		not(shiftAmt[i], cycleNum[i]);
	end
	endgenerate
	
	rightBarrelShifter rbs1(shiftedDend, remainDendOld, shiftAmt);  // shift the der/Dividend thing
	
	leftBarrelShifter lbs1(shiftedSor, divisor, shiftAmt);  // shift the der/Dividend thing
	
	adder32bit_8 abs(difference1, shiftedDend, divisor, 1'b1); // subtract divisor from shiftedNumber
	
	leftBarrelShifter lbs2(remQuotientTemp, remQuotientOld, 5'b00001);  //shift the old quotient left by one bit
	
	isLT lt(LT, shiftedDend[31], divisor[31],difference1[31]);		// Figure out if the difference was > 0.
	
	not(GTE, LT);
	
	assign remQuotientNew[0] = GTE;        									// Set the last bit of the difference equal to 1.
	assign remQuotientNew[31:1] = remQuotientTemp[31:1];				//Set the new quotient just equal to temp (which was shifted and correct)
	
	adder32bit_8 abs3(differenceFinal, remainDendOld, shiftedSor,1'b1); // subtract shifted Divisor from the remainder
	
	multiplexer m1(remainDendNew, remainDendOld, differenceFinal, GTE); // if its the difference is <0, then don't subtract
	
endmodule

module multCycle(readOut,m_cand, wholeNum);  
	  input [31:0] m_cand;
	  input [64:0] wholeNum; 
	  output [64:0] readOut; 
	  
	  wire [64:0] tempWholeNum;
	  wire [31:0]firstRes;
	  wire addSub;
	  wire doNothing;
	  
	  assign addSub = wholeNum[1];
	  
	  adder32bit_8 ab(firstRes, wholeNum[64:33], m_cand,addSub);
 	
	  xor(doNothing, wholeNum[1], wholeNum[0]);
	  
	  assign tempWholeNum[32:0] = wholeNum[32:0];
	
	  multiplexer mux(tempWholeNum[64:33], wholeNum[64:33], firstRes, doNothing); 
	  
	  oneBitShifterMod64 obsm(readOut, tempWholeNum);
	
endmodule

module initFlipLogic(flipResultBit, correctA, correctB, dataA, dataB);
	
	input [31:0] dataA, dataB;
	output [31:0] correctA, correctB;
	output flipResultBit;
	
	wire [31:0] flippedA, flippedB;
	
	flipVal fva (flippedA, dataA);
	flipVal fvb(flippedB, dataB);
	
	multiplexer m1(correctA, dataA, flippedA, dataA[31]);
	multiplexer m2(correctB, dataB, flippedB, dataB[31]);

	xor x1(flipResultBit, dataA[31], dataB[31]);
	
endmodule
	

module flipVal(dataOut,dataIn);
	input [31:0] dataIn;
	output [31:0] dataOut;
	
	adder32bit_8 abc(dataOut, 32'b0, dataIn, 1'b1);

endmodule



module oneBitShifterMod(out, data);
	
	input [32:0] data; 
	output [32:0] out;
	
	//1
	genvar i1;
	generate
	for (i1 = 1; i1 < 33; i1 = i1+1) begin: rightShiftLoop1_md
		assign out[i1-1] = data[i1];
	end
	endgenerate
	
	assign out[32] = data[32];	
		
endmodule

module oneBitShifterMod64(out, data);
	
	input [64:0] data; 
	output [64:0] out;
	
	genvar i1;
	generate
	for (i1 = 1; i1 < 65; i1 = i1+1) begin: rightShiftLoop1_md 
		assign out[i1-1] = data[i1];
	end
	endgenerate
	
	assign out[64] = data[64];
		
endmodule

module checkOverflow(ofTOTAL,data, A, B);

	input [31:0] A, B;
	input [64:0] data;
	output ofTOTAL;
	
	wire oc1, oc2, oc3, oc4, overall, of, last0_A, last0_B;
	
	checkZero c1(last0_A, A[31:0]);
	checkZero c2(last0_B, B[31:0]);
	
	and a1(oc1, data[32], A[31], B[31]);
	and a2(oc2, data[32], ~A[31], ~B[31]);
	and a3(oc3, ~data[32], A[31], ~B[31]);
	and a4(oc4, ~data[32], ~A[31], B[31]);
	
	assign overall =  (oc1 | oc2 | oc3 | oc4) & (~last0_A & ~last0_B);
	
	wire [31:0] tempCase1, tempCase2;
	wire notCase2,notof;
	
	assign tempCase1[31] = data[64];
	assign tempCase2[31] = data[64];
	
	genvar i1;
	generate
	for (i1 = 62; i1 > 31; i1 = i1-1) begin: case1
		and(tempCase1[i1-32], data[i1+1], tempCase1[i1-31]);
	end
	endgenerate
	
	genvar i2;
	generate
	for (i2 = 62; i2 > 31; i2 = i2-1) begin: case2
		or(tempCase2[i2-32], data[i2+1], tempCase2[i2-31]);
	end
	endgenerate
	
	not(notCase2,tempCase2[0]);
	or(notof, tempCase1[0], notCase2);
	not(of, notof);
	
	or(ofTOTAL, of, overall);
	
endmodule


module up_counter(out,enable,clk,reset);
	output [5:0] out;	 //potentially change								
	input enable, clk, reset;
	reg [5:0] out;		//potentially change	initial out = 6'b0;
	initial 
	begin
		out = 6'b111111;
	end
	always @(posedge clk)
	if (reset) begin
	  out <= 6'b0;
	end else if (enable) begin
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
			6'd31: out <= 6'd32;
			6'd32: out <= 6'd63;		
		endcase
	end
endmodule 

module checkZero(isZero, data);

	input [31:0] data;
	output isZero;
	
	wire [31:0] tempCase;

	assign tempCase[0] = data[0];
	
	genvar i2;
	generate
	for (i2 = 1; i2 < 32; i2 = i2+1) begin: case1
		or(tempCase[i2], data[i2], tempCase[i2-1]);
	end
	endgenerate
	
	not(isZero,tempCase[31]);

endmodule

module multiplexer33bit(out,input1, input2, selectBit);
	input [32:0] input1, input2;
	input selectBit;
	output [32:0] out;
	genvar i;
	generate
	for (i = 0; i < 33; i = i+1) begin: Loop
		assign out[i] = selectBit ? input2[i]:input1[i];
	end
	endgenerate
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	

module multiplexer64(out,input1, input2, selectBit);
	input [64:0] input1, input2;
	input selectBit;
	output [64:0] out;
	genvar i;
	generate
	for (i = 0; i < 65; i = i+1) begin: multiplexerLoop
		assign out[i] = selectBit ? input2[i]:input1[i];
	end
	endgenerate
	
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	

module multiplexer1(out,input1, input2, selectBit);
	input input1, input2;
	input selectBit;
	output out;
	assign out = selectBit ? input2:input1;
	//Case select = 0: input1
	//Case select = 1: input2
endmodule	

module singleReg64(readOut, writeIn, clk, clr, ena);

	input clk, clr, ena;
	input [64:0] writeIn;
	output [64:0] readOut;
	wire clrn;
	assign clrn = ~clr;
	
	genvar i;
	generate
	for (i = 0; i < 65; i = i+1) begin: loop1
		dffe currDFFE(.d(writeIn[i]), .clk(clk), .clrn(clrn), .prn(1'b1), .ena(ena), .q(readOut[i]));
	end
	endgenerate

endmodule

//////////////// RECYCLED CODE BELOW!!! Register File
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module regfile_jx35(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, 
ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB, allRegData);

   input clock, ctrl_writeEnable, ctrl_reset; // before code
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB; // before code
   input [31:0] data_writeReg;  // before code
	output [31:0] data_readRegA, data_readRegB; // before code
	output [1023:0] allRegData;
	
	// Take control bits, and manufacture 3 sets of registers.
	wire [31:0] registerWriteEnable, rweTemp, wireRegA,wireRegB;
	decoder32 writeDecode(rweTemp,ctrl_writeReg,ctrl_writeEnable);
	
	assign registerWriteEnable[31:1] = rweTemp[31:1];
	assign registerWriteEnable[0] = 1'b0;
	
	
	decoder32 RegA(wireRegA, ctrl_readRegA,1'b1);
	decoder32 RegB(wireRegB, ctrl_readRegB,1'b1);
	genvar i;
	generate
	for (i = 0; i < 32; i = i+1) begin: registerLoop
		wire [31:0] toRA, toRB,data_tri;
		singleReg allRegisters(toRA, data_writeReg, clock, ctrl_reset, registerWriteEnable[i]);
		assign toRB = toRA;
		triBuffer tBuffRegA(data_readRegA,toRA,wireRegA[i]);
		triBuffer tBuffRegB(data_readRegB,toRB,wireRegB[i]);
		assign allRegData[i*32 +: 32] = toRB;
	end
	endgenerate
	
endmodule

// Code to write a single register
module singleReg(readOut, writeIn, clk, clr, ena);

	input clk, clr, ena;
	input [31:0] writeIn;
	output [31:0] readOut;
	wire clrn;
	assign clrn = ~clr;
	
	genvar i;
	generate
	for (i = 0; i < 32; i = i+1) begin: loop1
		dffe currDFFE(.d(writeIn[i]), .clk(clk), .clrn(clrn), .prn(1'b1), .ena(ena), .q(readOut[i]));
	end
	endgenerate

endmodule

module triBuffer(out,in, oe);
	input [31:0] in;
	input oe;
	output [31:0] out;
	assign out = oe ? in: 32'bz;
endmodule


module decoder32(registerOutput, select, writeEnable);
	input [4:0] select;
	input writeEnable;
	output [31:0] registerOutput;
	
	and and0(registerOutput[0], ~select[4], ~select[3], ~select[2], ~select[1], ~select[0], writeEnable);
   and and1(registerOutput[1], ~select[4], ~select[3], ~select[2], ~select[1], select[0], writeEnable);
   and and2(registerOutput[2], ~select[4], ~select[3], ~select[2], select[1], ~select[0], writeEnable);
   and and3(registerOutput[3], ~select[4], ~select[3], ~select[2], select[1], select[0], writeEnable);
   and and4(registerOutput[4], ~select[4], ~select[3], select[2], ~select[1], ~select[0], writeEnable);
   and and5(registerOutput[5], ~select[4], ~select[3], select[2], ~select[1], select[0], writeEnable);
   and and6(registerOutput[6], ~select[4], ~select[3], select[2], select[1], ~select[0], writeEnable);
   and and7(registerOutput[7], ~select[4], ~select[3], select[2], select[1], select[0], writeEnable);
   and and8(registerOutput[8], ~select[4], select[3], ~select[2], ~select[1], ~select[0], writeEnable);
   and and9(registerOutput[9], ~select[4], select[3], ~select[2], ~select[1], select[0], writeEnable);
   and and10(registerOutput[10], ~select[4], select[3], ~select[2], select[1], ~select[0], writeEnable);
   and and11(registerOutput[11], ~select[4], select[3], ~select[2], select[1], select[0], writeEnable);
   and and12(registerOutput[12], ~select[4], select[3], select[2], ~select[1], ~select[0], writeEnable);
   and and13(registerOutput[13], ~select[4], select[3], select[2], ~select[1], select[0], writeEnable);
   and and14(registerOutput[14], ~select[4], select[3], select[2], select[1], ~select[0], writeEnable);
   and and15(registerOutput[15], ~select[4], select[3], select[2], select[1], select[0], writeEnable);
   and and16(registerOutput[16], select[4], ~select[3], ~select[2], ~select[1], ~select[0], writeEnable);
   and and17(registerOutput[17], select[4], ~select[3], ~select[2], ~select[1], select[0], writeEnable);
   and and18(registerOutput[18], select[4], ~select[3], ~select[2], select[1], ~select[0], writeEnable);
   and and19(registerOutput[19], select[4], ~select[3], ~select[2], select[1], select[0], writeEnable);
   and and20(registerOutput[20], select[4], ~select[3], select[2], ~select[1], ~select[0], writeEnable);
   and and21(registerOutput[21], select[4], ~select[3], select[2], ~select[1], select[0], writeEnable);
   and and22(registerOutput[22], select[4], ~select[3], select[2], select[1], ~select[0], writeEnable);
   and and23(registerOutput[23], select[4], ~select[3], select[2], select[1], select[0], writeEnable);
   and and24(registerOutput[24], select[4], select[3], ~select[2], ~select[1], ~select[0], writeEnable);
   and and25(registerOutput[25], select[4], select[3], ~select[2], ~select[1], select[0], writeEnable);
   and and26(registerOutput[26], select[4], select[3], ~select[2], select[1], ~select[0], writeEnable);
   and and27(registerOutput[27], select[4], select[3], ~select[2], select[1], select[0], writeEnable);
   and and28(registerOutput[28], select[4], select[3], select[2], ~select[1], ~select[0], writeEnable);
   and and29(registerOutput[29], select[4], select[3], select[2], ~select[1], select[0], writeEnable);
   and and30(registerOutput[30], select[4], select[3], select[2], select[1], ~select[0], writeEnable);
	and and31(registerOutput[31], select[4], select[3], select[2], select[1], select[0], writeEnable);
endmodule