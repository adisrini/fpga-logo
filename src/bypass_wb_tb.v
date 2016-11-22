`timescale 1 ns / 100 ps
module bypass_wb_tb();
	reg [4:0] rr1_ex, rr2_ex, wr_mem, wr_wb;
	reg regW_mem, regW_wb;
	wire [1:0] forwardA, forwardB;

	bypass_ex bx(rr1_ex, rr2_ex, wr_mem, wr_wb, regW_mem, regW_wb, forwardA, forwardB);

	initial
		begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("rr1 %b, rr2 %b, wr_m %b, wr_w %b, wren_m %b, wren_w %b, fwd_a %b, fwd_b %b", rr1_ex, rr2_ex, wr_mem, wr_wb, regW_mem, regW_wb, forwardA, forwardB);
		rr1_ex = 5'b00000;
		rr2_ex = 5'b00000;
		wr_mem = 5'b00000;
		wr_wb = 5'b00000;
		regW_mem = 1'b0;
		regW_wb = 1'b0;
		#20480
		$stop;
		end
	always
		#20 rr1_ex[0] = ~rr1_ex[0];
	always
		#40 rr1_ex[1] = ~rr1_ex[1];
	always
		#80 rr2_ex[0] = ~rr2_ex[0];
	always
		#160 rr2_ex[1] = ~rr2_ex[1];
	always
		#320 wr_mem[0] = ~wr_mem[0];
	always
		#640 wr_mem[1] = ~wr_mem[1];
	always
		#1280 wr_wb[0] = ~wr_wb[0];
	always
		#2560 wr_wb[1] = ~wr_wb[1];
	always
		#5120 regW_mem = ~regW_mem;
	always
		#10240 regW_wb = ~regW_wb;
endmodule
