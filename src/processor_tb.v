`timescale 1 ns/ 100 ps
module processor_tb();

	reg clock, reset/*, ps2_key_pressed*/;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
	wire 	[31:0] 	dmem_data_in;
	wire	[11:0]	dmem_address;
		
	//just for now!!
	wire [31:0] data_writeReg;	
	processor p(clock, reset, dmem_data_in, dmem_address);

	initial
	begin
		$display($time, "<<Starting the simulation>> ");
//		$monitor("Reading the values of clock %b, reset %b, dmem_data_in %b, dmem_address %b, data_writeReg %b p.instr %b, p.rd %b, p.rs %b, p.rt %b, p.shamt %b, p.alu_op %b,p.opcode %b, p.jumpInst %b, p.pc_immedInst %b,p.be_or_NextInst %b, p.jump_or_NextInst %b, p.jrVal_or_NextInst %b, jumpInst %b, jump%b", clock, reset, dmem_data_in, dmem_address, data_writeReg, p.instr, p.rd, p.rs, p.rt, p.shamt, p.alu_op,p.opcode,p.jumpInst, p.pc_immedInst,p.be_or_NextInst, p.jump_or_NextInst, p.jrVal_or_NextInst,p.jumpInst, p.jump);
//		$monitor("Reading the values of clock %b, reset %b, dmem_data_in %b, dmem_address %b, data_writeReg %b p.instr %b program_counter %b", clock, reset, dmem_data_in, dmem_address, data_writeReg, p.instr,p.pcReadOut);
//		$monitor("PC_COUNTER %d alu_result_MEM_WB_out %d result %d, and rdy %d regWriteenable %d aluMem %d datawriteenable %d bypass_data_WB %d, STALL %d regs %d %d %d %d %d %d %d %d %d %d 31 %d write reg %d nextinstr %d writereg data %d Instructions start here %d %d %d %d,,,,, %d %d %d %d", p.pcReadOut, p.alu_result_MEM_WB_out, p.data_result_mult_div, p.data_resultRDY, p.reg_we_WB, p.alu_or_mem, p.mem_we_MEM, p.bypass_data_WB,p.stallLW, p.reg0,p.reg1,p.reg2,p.reg3,p.reg4,p.reg5,p.reg6,p.reg7, p.reg8, p.reg9, p.reg31, p.write_reg_no_multdiv_WB,p.next_inst_MEM_WB_out, p.data_writeReg, p.instr_IF_ID_in,p.instr_ID_EX_in,p.instr_EX_MEM_in,p.instr_MEM_WB_in,p.next_inst_IF_ID_in, p.next_inst_ID_EX_in, p.next_inst_EX_MEM_in, p.next_inst_MEM_WB_in);
		$monitor("PC_COUNTER %d multdivresult %d multdiv exception %d regs %d %d %d %d %d %d %d %d %d %d status: %d", p.pcReadOut,p.data_result_mult_div,p.data_exception_multdiv, p.reg1,p.reg2,p.reg3,p.reg4,p.reg5,p.reg6,p.reg7,p.reg8,p.reg9,p.reg31,p.status_reg_out);
		clock = 0;
		reset = 0;
		#20000
		$stop;
	end
		always
			#20 clock = ~clock;
endmodule