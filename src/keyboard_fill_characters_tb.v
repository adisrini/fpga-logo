`timescale 1 ns/ 100 ps
module keyboard_fill_characters_tb();
	reg [7:0] data_PS2key;
	reg ctrl_PS2pressed, reset;
	wire [31:0] out;
	
	characterData cd(out, data_PS2key, ctrl_PS2pressed, 1'b1, reset);
	
	initial
	begin
		$monitor("Values: data_PS2key %h, ctrl_PS2pressed %b, reset %b, output %h %h %h %h", clock, ps2_info, reset, out[31:24], out[23:16], out[15:8], out[7:0]);
		ctrl_PS2pressed = 1'b0;
		reset = 1'b1;
		#20
		reset = 1'b0;
		data_PS2key = 8'h1c;
		ctrl_PS2pressed = 1'b1;
		#50
		ctrl_PS2pressed = 1'b0;
		#100
		data_PS2key = 8'h31;
		ctrl_PS2pressed = 1'b1;
		#30
		ctrl_PS2pressed = 1'b0;
		#100
		data_PS2key = 8'h23;
		ctrl_PS2pressed = 1'b1;
		#120
		ctrl_PS2pressed = 1'b0;
		#50
		data_PS2key = 8'h36;
		ctrl_PS2pressed = 1'b1;
		#120
		ctrl_PS2pressed = 1'b0;
		$stop;
	end
endmodule
