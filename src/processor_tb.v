`timescale 1 ns / 100 ps
module processor_tb();
	reg clock, reset;
	wire [31:0] dmem_data_in;
	wire [11:0] dmem_address;
	processor p(clock, reset, /*ps2_key_pressed, ps2_out, lcd_write, lcd_data,*/ dmem_data_in, dmem_address);
	
	initial
	begin
		$monitor("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %b %d %d %b", p.data_PC, p.reg0, p.reg1, p.reg2, p.reg3, p.reg4, p.reg5, p.reg6, p.reg7, p.reg8, p.reg9, p.reg10, p.reg11, p.reg12, p.reg13, p.reg14, p.reg15, p.reg16, p.reg17, p.reg18, p.reg19, p.reg20, p.reg21, p.reg22, p.reg23, p.reg24, p.reg25, p.reg26, p.reg27, p.reg28, p.reg29, p.reg30, p.reg31, p.instruction, dmem_address, dmem_data_in, p.ctrl_DMWE);
		clock = 1'b0;
		reset = 1'b0;
		#300
		$stop;
	end
	
	always
		#10 clock = ~clock;


endmodule
