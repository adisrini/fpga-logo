`timescale 1 ns/ 100 ps
module processor_pipeline_tb();

	reg clock, reset/*, ps2_key_pressed*/;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
	wire 	[31:0] 	dmem_data_in;
	wire	[11:0]	dmem_address;
	
	processor p(clock, reset, dmem_data_in, dmem_address);

	initial
	begin
		$display($time, "<<Starting the simulation>> ");
//		$monitor("Reading the values of clock %b, reset %b, dmem_data_in %b, dmem_address %b, data_writeReg %b p.instr %b, p.rd %b, p.rs %b, p.rt %b, p.shamt %b, p.alu_op %b,p.opcode %b, p.jumpInst %b, p.pc_immedInst %b,p.be_or_NextInst %b, p.jump_or_NextInst %b, p.jrVal_or_NextInst %b, jumpInst %b, jump%b", clock, reset, dmem_data_in, dmem_address, data_writeReg, p.instr, p.rd, p.rs, p.rt, p.shamt, p.alu_op,p.opcode,p.jumpInst, p.pc_immedInst,p.be_or_NextInst, p.jump_or_NextInst, p.jrVal_or_NextInst,p.jumpInst, p.jump);
//		$monitor("Reading the values of clock %b, reset %b, dmem_data_in %b, dmem_address %b, data_writeReg %b p.instr %b program_counter %b", clock, reset, dmem_data_in, dmem_address, data_writeReg, p.instr,p.pcReadOut);
		$monitor("clock %b PC_COUNTER %d %d %d %d %d %d Instructions start here %d %d %d %d", clock, p.data_PC, p.reg0, p.reg1, p.reg2, p.reg3, p.alu_MEM_result,p.data_PC_PLUS_ONE_if_id_in, p.data_PC_PLUS_ONE_if_id_out,p.data_PC_PLUS_ONE_id_ex_out,p.data_PC_PLUS_ONE_ex_mem_out, p.instruction_if_id_in,p.instruction_if_id_out,p.instruction_id_ex_out,p.instruction_ex_mem_out);
		reset = 1;
		clock = 0;
	#20
		reset = 0;
		#3000
		$stop;
	end
	always
		#20 clock = ~clock;
endmodule