`timescale 1 ns/ 100 ps
module jx35_alu_tb();
   reg [31:0] data_operandA, data_operandB;
   reg [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	reg clock,ctrl_mult_div;
   wire [31:0] data_result;
   wire isNotEqual, isLessThan, overflow;
	
	jx35_alu t(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow, ctrl_mult_div,clock);
	
	initial
	begin
		$display($time, "<<Starting the simulation>> ");
		data_operandA = 32'h00000212;
		data_operandB = 32'h00000011;
		$display("Initial values of A %b and B %b", data_operandA, data_operandB);
		$monitor("Reading the values of clock %b opcode %b and result%d, isNotEqual %b, is less than %b, overflow %b multdiv result %d ctrl_mult %d ctrl_div %d and ready %d",clock,ctrl_ALUopcode,data_result, isNotEqual, isLessThan, overflow,t.mult_div_result, t.ctrl_mult, t.ctrl_div, t.data_resultRDY);
		clock = 0;
		ctrl_ALUopcode = 5'b00110;
		ctrl_shiftamt = 5'b00111;
		ctrl_mult_div = 1'b1;
		#20 
		ctrl_ALUopcode = 5'b00000;
		ctrl_mult_div = 1'b0;
		data_operandA = 32'h00000000;
		data_operandB = 32'h00000000;
		#1500
		ctrl_ALUopcode = 5'b00111;
		ctrl_mult_div = 1'b1;
		#1500
		ctrl_ALUopcode = 5'b00111;
		ctrl_mult_div = 1'b0;
		#1500
		$stop;
	end
	always
		#6 clock = ~clock;
	always
		#12 ctrl_ALUopcode = ctrl_ALUopcode+1;
endmodule
