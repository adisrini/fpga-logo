module skeleton(resetn,
    ps2_clock, ps2_data,                                        // ps2 related I/O
    debug_data_in, debug_addr, leds,                        // extra debugging ports
    lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
    seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,     // seven segements
    VGA_CLK,                                                        //  VGA Clock
    VGA_HS,                                                         //  VGA H_SYNC
    VGA_VS,                                                         //  VGA V_SYNC
    VGA_BLANK,                                                      //  VGA BLANK
    VGA_SYNC,                                                       //  VGA SYNC
    VGA_R,                                                          //  VGA Red[9:0]
    VGA_G,                                                          //  VGA Green[9:0]
    VGA_B,                                                          //  VGA Blue[9:0]
    CLOCK_50,
    s1,
    s2);                                                    // 50 MHz clock
        
    ////////////////////////    VGA ////////////////////////////
    output          VGA_CLK;                //  VGA Clock
    output          VGA_HS;                 //  VGA H_SYNC
    output          VGA_VS;                 //  VGA V_SYNC
    output          VGA_BLANK;              //  VGA BLANK
    output          VGA_SYNC;               //  VGA SYNC
    output  [7:0]   VGA_R;                  //  VGA Red[9:0]
    output  [7:0]   VGA_G;                  //  VGA Green[9:0]
    output  [7:0]   VGA_B;                  //  VGA Blue[9:0]
    input               CLOCK_50;

    ////////////////////////    PS2 ////////////////////////////
    input           resetn;
    inout           ps2_data, ps2_clock;
    
    ////////////////////////    LCD and Seven Segment   ////////////////////////////
    output             lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
    output  [7:0]   leds, lcd_data;
    output  [6:0]   seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
    output  [31:0]  debug_data_in;
    output   [11:0]   debug_addr;
    
    
    input s1, s2;
    
    
    wire             clock;
    wire             lcd_write_en;
    wire    [31:0] lcd_write_data;
    wire    [7:0]    ps2_key_data;
    wire             ps2_key_pressed;
    wire    [7:0]    ps2_out;   
    
    // clock divider (by 5, i.e., 10 MHz)
    pll div(CLOCK_50,inclock);
    assign clock = CLOCK_50;
    
    // UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
    //assign clock = inclock;
	 
	 	// Defined wires
	wire [31:0] logo_command;
	wire [7:0] data_ps2ascii;
	reg [7:0] last_pressed;
	reg trigger;
	wire trigger_out;
	wire [2:0] position_double;
	wire [1:0] position;
	wire sk_ctrl_MEM_VGAE;
	wire [7:0] sk_vga_data_in;
	wire [18:0] sk_vga_address;
	wire command_ready;
	wire [31:0] command_register;
	wire [31:0] command;
    
    // your processor
 		processor myprocessor(clock, ~resetn, command_ready, command, /*lcd_write_en, lcd_write_data,*/ debug_data_in, debug_addr,sk_ctrl_MEM_VGAE, sk_vga_address, sk_vga_data_in, command_register);
    
    // keyboard controller
    PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
    
//  case (ps2_out)
//      15
    
    // lcd controller
    lcd mylcd(clock, ~resetn, 1'b1, ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
    
    // example for sending ps2 data to the first two seven segment displays
    Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
    Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
    
    // the other seven segment displays are currently set to 0
    Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
    Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
    Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
    Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
    Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
    Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
    
    // some LEDs that you could use for debugging if you wanted
    assign leds = 8'b00101011;
        
    // VGA
    Reset_Delay         r0  (.iCLK(CLOCK_50),.oRESET(DLY_RST)   );
    VGA_Audio_PLL       p1  (.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)   );
    vga_controller vga_ins(.iRST_n(DLY_RST),
                                 .iVGA_CLK(VGA_CLK),
                                 .oBLANK_n(VGA_BLANK),
                                 .oHS(VGA_HS),
                                 .oVS(VGA_VS),
                                 .b_data(VGA_B),
                                 .g_data(VGA_G),
                                 .r_data(VGA_R));
    
    
endmodule