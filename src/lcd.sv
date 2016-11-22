module lcd(clock, reset, write_en, data, _lcd_data, _lcd_rw, _lcd_en, _lcd_rs, _lcd_on, _lcd_blon);

	input clock, reset, write_en;
	input [7:0] data;
	output _lcd_rw, _lcd_en, _lcd_rs, _lcd_on, _lcd_blon;
	output [7:0] _lcd_data;
	
	typedef enum {A,B,C,D} state_type;
	state_type state1, state2;
	
	reg [8:0] curbuf;
	reg lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	reg [7:0] lcd_data;
	
	typedef reg [7:0] line_type [0:15];
	line_type line1, line2;

	reg [3:0] ptr;
	reg [5:0] index;
	reg [17:0] delay;
	reg [4:0] count;
	reg cstart, cdone, prestart, mstart;
	reg printed_crlf, valid_char, buf_changed, buf_changed_ack;

	always @(*) begin
		if (data >= 32 && data < 128) begin
			valid_char <= 1;
		end else begin
			valid_char <= 0;
		end
	end		

	integer i;

	always @(posedge clock or posedge reset)
	begin
		
		if (reset==1) begin
			buf_changed <= 0;
			printed_crlf <= 0;
			ptr <= 0;
			for (i=0; i<=15; i=i+1) begin
				line1[i] <= 8'h20;
				line2[i] <= 8'h20;
			end
			
		end else begin		
			if (buf_changed_ack==1) begin
				buf_changed <= 0;
			end
		
			if (write_en==1) begin
				if (data==9'h0D || (ptr==0 && valid_char==1 && printed_crlf==0)) begin
					for (i=0; i<=15; i=i+1) begin
						line1[i] <= line2[i];
						line2[i] <= 8'h20;
						buf_changed <= 1;
					end
					ptr <= 0;
				end
				
				if (data==9'h0D) begin
					printed_crlf <= 1;
				end else if (valid_char==1) begin
					printed_crlf <= 0;
					line2[ptr] <= data;
					ptr <= ptr+4'b1;
					buf_changed <= 1;
				end
			end	
		end
	end


	always @(*)
	begin
		if (index==0) begin
			curbuf <= (9'h38);
		end else if (index==1) begin
			curbuf <= (9'h0C);
		end else if (index==2) begin
			curbuf <= (9'h01);
		end else if (index==3) begin
			curbuf <= (9'h06);
		end else if (index==4) begin
			curbuf <= (9'h80);
		end else if (index==21) begin
			curbuf <= (9'hC0);
		end else if (index < 21) begin
			curbuf <= ({1'b1,line1[index-5]});
		end else begin
			curbuf <= ({1'b1,line2[index-22]});
		end
	end
	
	
	always @(posedge clock or posedge reset) begin
		if (reset==1) begin
			buf_changed_ack <= 0;
			index <= 0;
			state1 <= A;
			delay <= 0;
			cstart <= 0;
			lcd_data <= 0; 
			lcd_rs <= 0;

		end else begin
			if (index <= 37) begin
				buf_changed_ack <= 0;				
				case (state1)
					A : begin
							lcd_data <= curbuf[7:0];
							lcd_rs <= curbuf[8];
							cstart <= 1;
							state1 <= B;
						end
					B : begin
							if (cdone == 1) begin
								cstart <= 0;
								state1 <= C;
							end
						end
					C : begin
							if (delay < 262142) begin
								delay <= delay+18'b1;
							end else begin
								delay <= 0;
								state1 <= D;
							end
						end
					D : begin
							index <= index + 6'b1;
							state1 <= A;
						end
				endcase
			end else if (buf_changed == 1) begin
				buf_changed_ack <= 1;
				index <= 0;
			end
		end
	end


	always @(posedge clock or posedge reset)
	begin	
		if (reset==1) begin
			cdone <= 0;
			lcd_en <= 0;
			prestart <= 0;
			mstart <= 0;
			count <= 0;
			state2 <= A;

		end else begin
			if (prestart==0 && cstart==1) begin
				mstart <= 1;
				cdone <= 0;
			end
			prestart <= cstart;
			
			if (mstart==1) begin
				case (state2)
					A : state2 <= B;
					B : begin
							lcd_en <= 1;
							state2 <= C;
						end
					C : begin
							if (count < 16) begin
								count <= count + 5'b1;
							end else begin
								state2 <= D;
							end
						end
					D : begin
							lcd_en <= 0;
							mstart <= 0;
							cdone <= 1;
							count <= 0;
							state2 <= A;
						end
				endcase
			end
		end
	end

	assign _lcd_rw = 0;
	assign _lcd_blon = 1;
	assign _lcd_on = 1;

	assign _lcd_en = lcd_en;
	assign _lcd_rs = lcd_rs;
	assign _lcd_data = lcd_data;
	
endmodule

