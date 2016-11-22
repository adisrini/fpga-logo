transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/VGA_Audio_PLL.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/Reset_Delay.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/skeleton.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/PS2_Interface.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/PS2_Controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/Hexadecimal_To_Seven_Segment.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/dmem.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/Altera_UP_PS2_Data_In.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/Altera_UP_PS2_Command_Out.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/vga_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/video_sync_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/img_index.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/img_data.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/processor_as577.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor/db {C:/Users/Aditya Srinivasan/Desktop/processor/db/pll_altpll.v}
vlog -sv -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/lcd.sv}

vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/processor {C:/Users/Aditya Srinivasan/Desktop/processor/processor_pipeline_stall_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  processor_pipeline_stall_tb

add wave *
view structure
view signals
run -all