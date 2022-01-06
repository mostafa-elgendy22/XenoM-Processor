vlib work
vcom ../../basic_components/*.vhd

vcom ../instruction_memory.vhd
vcom ../fetch_stage.vhd

vmap -c
vsim -do ../../do_files/fetch_stage.do