`timescale 1 ns / 100 ps
module fsm_counter_tb();
	reg clock, reset/*, ps2_key_pressed*/;
	
	// GRADER OUTPUTS - YOU MUST CONNECT TO YOUR DMEM
	wire 	[31:0] 	dmem_data_in;
	wire	[11:0]	dmem_address;
	
	processor p(clock, reset, dmem_data_in, dmem_address);
	
	initial
	begin
	$monitor("clock %d, trigger %d, instr %b", clock, p.initialize, p.instruction_if_id_in);
	clock = 1'b0;
	reset = 1'b1;
	#20
	reset = 1'b0;
	#500
	$stop;
	end
	
	always
	#20 clock = ~clock;

endmodule
