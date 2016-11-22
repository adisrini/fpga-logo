transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/VGA_Audio_PLL.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/Reset_Delay.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/skeleton.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/PS2_Interface.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/PS2_Controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/Hexadecimal_To_Seven_Segment.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/dmem.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/Altera_UP_PS2_Data_In.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/Altera_UP_PS2_Command_Out.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/vga_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/video_sync_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/img_index.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/img_data.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/processor_jx35.v}
vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored/db {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/db/pll_altpll.v}
vlog -sv -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/lcd.sv}

vlog -vlog01compat -work work +incdir+C:/Users/Aditya\ Srinivasan/Desktop/skeleton_jx35_restored {C:/Users/Aditya Srinivasan/Desktop/skeleton_jx35_restored/processor_jx35_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  processor_jx35_tb

add wave *
view structure
view signals
run -all
