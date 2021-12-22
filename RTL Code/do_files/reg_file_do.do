vsim -gui work.regfile
# End time: 13:36:11 on Dec 22,2021, Elapsed time: 0:05:09
# Errors: 0, Warnings: 1
# vsim -gui work.regfile 
# Start time: 13:36:11 on Dec 22,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.regfile(a_regfile)
# Loading work.decoder(a_decoder)
# Loading work.dff_register(dff_register)
# Loading work.tri_state_buffer(tri_state_buffer)
add wave -position end  sim:/regfile/clk
add wave -position end  sim:/regfile/rst
add wave -position end  sim:/regfile/Rsrc1_address
add wave -position end  sim:/regfile/Rsrc2_address
add wave -position end  sim:/regfile/Rdst_address
add wave -position end  sim:/regfile/write_back_enable
add wave -position end  sim:/regfile/write_address
add wave -position end  sim:/regfile/write_data
add wave -position end  sim:/regfile/Rsrc1_data
add wave -position end  sim:/regfile/Rsrc2_data
add wave -position end  sim:/regfile/Rdst_data
add wave -position end  sim:/regfile/enb_Rsrc1_address
add wave -position end  sim:/regfile/enb_Rsrc2_address
add wave -position end  sim:/regfile/enb_Rdst_address
add wave -position end  sim:/regfile/enb_read_address
add wave -position end  sim:/regfile/enb_write_address
add wave -position end  sim:/regfile/r_FF_OUT
add wave -position end  sim:/regfile/enable_read_decode
add wave -position end  sim:/regfile/not_clk
force -freeze sim:/regfile/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/regfile/rst 1 0
run
force -freeze sim:/regfile/rst 0 0
force -freeze sim:/regfile/Rsrc1_address 000 0
force -freeze sim:/regfile/Rsrc2_address 001 0
force -freeze sim:/regfile/Rdst_address 010 0
force -freeze sim:/regfile/write_back_enable 1 0
force -freeze sim:/regfile/write_address 000 0
force -freeze sim:/regfile/write_data 16#FFFF 0
run
force -freeze sim:/regfile/write_address 001 0
force -freeze sim:/regfile/Rsrc1_address 001 0
force -freeze sim:/regfile/Rsrc2_address 100 0
force -freeze sim:/regfile/write_data 16#DDDD 0
run
run
force -freeze sim:/regfile/write_back_enable 0 0
force -freeze sim:/regfile/Rsrc1_address 001 0
force -freeze sim:/regfile/Rsrc1_address 010 0
force -freeze sim:/regfile/Rsrc2_address 001 0
run