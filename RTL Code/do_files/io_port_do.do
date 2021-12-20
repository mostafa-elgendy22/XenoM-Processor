vsim -gui work.io_port
# vsim -gui work.io_port 
# Start time: 23:24:12 on Dec 20,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.io_port(a_io_port)
add wave -position end  sim:/io_port/Input
add wave -position end  sim:/io_port/Io_read
add wave -position end  sim:/io_port/Io_write
add wave -position end  sim:/io_port/reset
add wave -position end  sim:/io_port/Output
add wave -position end  sim:/io_port/Data
force -freeze sim:/io_port/Input 16#FFFF 0
force -freeze sim:/io_port/Io_read 0 0
force -freeze sim:/io_port/Io_write 0 0
force -freeze sim:/io_port/reset 1 0
run
force -freeze sim:/io_port/reset 0 0
force -freeze sim:/io_port/Io_read 1 0
run
force -freeze sim:/io_port/Io_read 0 0
force -freeze sim:/io_port/Io_write 1 0
run
force -freeze sim:/io_port/Io_write 0 0
force -freeze sim:/io_port/Io_read 1 0
force -freeze sim:/io_port/Input 16#DDDD 0
run
force -freeze sim:/io_port/Io_read 0 0
force -freeze sim:/io_port/Io_write 1 0
run

