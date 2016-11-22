`timescale 1 ns/ 100 ps
module sameRegister_5bit_tb();


	reg [4:0] inputA, inputB;
	
	wire [4:0] same;
	
	sameRegister_5bit sr(same, inputA, inputB);

	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		$monitor("Reading the values of inputA %b, inputB %b, same %b", inputA, inputB, same);
		inputA = 5'b00000;
		inputB = 5'b00000;
		#25000
		$stop;
	end
		always
			#20 inputA[0] = ~inputA[0];
		always
			#40 inputA[1] = ~inputA[1];
		always
			#80 inputA[2] = ~inputA[2];
		always
			#160 inputA[3] = ~inputA[3];
		always
			#320 inputA[4] = ~inputA[4];
		always
			#640 inputB[0] = ~inputB[0];
		always
			#1280 inputB[1] = ~inputB[1];
		always
			#2560 inputB[2] = ~inputB[2];
		always
			#5120 inputB[3] = ~inputB[3];
		always
			#10240 inputB[4] = ~inputB[4];
endmodule