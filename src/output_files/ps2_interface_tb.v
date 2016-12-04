`timescale 1 ns/ 100 ps
module ps2_interface_tb();
	reg 			inclock, resetn;
	reg 			ps2_clock, ps2_data;
	wire 			ps2_key_pressed;
	wire 	[7:0] 	ps2_key_data;
	wire 	[7:0] 	last_data_received;

	
	PS2_Interface interface(inclock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, last_data_received);
	
	initial
	begin
		$monitor("ps2_data %d, ps2_key_data %d, ps2_key_pressed %d, last_data_received %d", ps2_data, ps2_key_data, ps2_key_pressed, last_data_received);
		resetn = 0;
		inclock = 0;
		ps2_clock = 0;
		ps2_data = 0;
		#20
		resetn = 1;
		#2000
		$stop;
	end
endmodule
