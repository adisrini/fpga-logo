`timescale 1 ns/ 100 ps
module processor_pipeline_stall_tb();

	reg clock, reset/*, ps2_key_pressed*/;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
	wire 	[31:0] 	dmem_data_in;
	wire	[11:0]	dmem_address;
	wire ctrl_MEM_VGAE;
	wire [7:0] debug_vga_in;
	wire [18:0] debug_vga_address;
	
	processor p(clock, reset, dmem_data_in, dmem_address,ctrl_MEM_VGAE, debug_vga_address, debug_vga_in);

	initial
	begin
		$display($time, "<<Starting the simulation>> ");
//		$monitor("Reading the values of clock %b, reset %b, dmem_data_in %b, dmem_address %b, data_writeReg %b p.instr %b, p.rd %b, p.rs %b, p.rt %b, p.shamt %b, p.alu_op %b,p.opcode %b, p.jumpInst %b, p.pc_immedInst %b,p.be_or_NextInst %b, p.jump_or_NextInst %b, p.jrVal_or_NextInst %b, jumpInst %b, jump%b", clock, reset, dmem_data_in, dmem_address, data_writeReg, p.instr, p.rd, p.rs, p.rt, p.shamt, p.alu_op,p.opcode,p.jumpInst, p.pc_immedInst,p.be_or_NextInst, p.jump_or_NextInst, p.jrVal_or_NextInst,p.jumpInst, p.jump);
//		$monitor("Reading the values of clock %b, reset %b, dmem_data_in %b, dmem_address %b, data_writeReg %b p.instr %b program_counter %b", clock, reset, dmem_data_in, dmem_address, data_writeReg, p.instr,p.pcReadOut);
//		$monitor("%d %d %d %d a, b: %d %d %d inst %d %d %d %d %d", p.reg1,p.debug_data_in,p.ctrl_MEM_DMWE, p.debug_address, p.forwardA, p.forwardB, p.bypass, p.instruction_if_id_in, p.instruction_if_id_out, p.instruction_id_ex_out, p.instruction_ex_mem_out, p.instruction_mem_wb_out);
		$monitor("%d %d %d %d", p.reg1, ctrl_MEM_VGAE, debug_vga_address, debug_vga_in);
		reset = 1;
		clock = 0;
		#20
		reset = 0;
		#30000
		$stop;
	end
		always
			#20 clock = ~clock;
endmodule
