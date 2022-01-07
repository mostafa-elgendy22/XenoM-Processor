vsim -gui work.data_memory
# vsim -gui work.data_memory 
# Start time: 01:42:55 on Jan 07,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.math_real(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.data_memory(a_data_memory)
mem load -i {../Memory Files/mem1.mem} data_memory/ram
add wave -position end  sim:/data_memory/clk
add wave -position end  sim:/data_memory/address
add wave -position end  sim:/data_memory/datain
add wave -position end  sim:/data_memory/memory_read
add wave -position end  sim:/data_memory/memory_write
add wave -position end  sim:/data_memory/dataout
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Yousif-Ahmed  Hostname: DESKTOP-2B1I9VO  ProcessID: 9912
#           Attempting to use alternate WLF file "./wlftev3di6".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftev3di6
force -freeze sim:/data_memory/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/data_memory/datain 16#FFFF 0
force -freeze sim:/data_memory/address 20#00000 0
# ** Error: Bad base to make_vreg.
#    Time: 0 ps  Iteration: 0  Instance: /data_memory
# ** Error: Bad digit in make_vreg.
#    Time: 0 ps  Iteration: 0  Instance: /data_memory
force -freeze sim:/data_memory/memory_read 0 0
force -freeze sim:/data_memory/memory_write 01 0
run
force -freeze sim:/data_memory/memory_write 00 0
force -freeze sim:/data_memory/memory_read 1 0
run
force -freeze sim:/data_memory/memory_write 01 0
force -freeze sim:/data_memory/address 00000000000000000000 0
force -freeze sim:/data_memory/memory_write 01 0
force -freeze sim:/data_memory/memory_read 0 0
run
force -freeze sim:/data_memory/datain 32#FFFFFFFF 0
# ** Error: Bad base to make_vreg.
#    Time: 300 ps  Iteration: 2  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
# ** Error: Bad digit in make_vreg.
#    Time: 300 ps  Iteration: 2  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
force -freeze sim:/data_memory/memory_write 11 0
run
force -freeze sim:/data_memory/datain 32#FFFFFFFF 0
# ** Error: Bad base to make_vreg.
#    Time: 400 ps  Iteration: 2  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
# ** Error: Bad digit in make_vreg.
#    Time: 400 ps  Iteration: 2  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
run
force -freeze sim:/data_memory/memory_read 1 0
force -freeze sim:/data_memory/memory_write 00 0
run
quit -sim
# End time: 01:51:38 on Jan 07,2022, Elapsed time: 0:08:43
# Errors: 6, Warnings: 4
# Compile of DataMemory.vhd was successful.
# Compile of instruction_memory.vhd was successful.
# 2 compiles, 0 failed with no errors.
vsim -gui work.data_memory
# vsim -gui work.data_memory 
# Start time: 01:52:20 on Jan 07,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.math_real(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.data_memory(a_data_memory)
mem load -i {../Memory Files/mem1.mem} data_memory/ram
add wave -position end  sim:/data_memory/clk
add wave -position end  sim:/data_memory/address
add wave -position end  sim:/data_memory/datain
add wave -position end  sim:/data_memory/memory_read
add wave -position end  sim:/data_memory/memory_write
add wave -position end  sim:/data_memory/dataout
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Yousif-Ahmed  Hostname: DESKTOP-2B1I9VO  ProcessID: 9912
#           Attempting to use alternate WLF file "./wlftcimicy".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftcimicy
force -freeze sim:/data_memory/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/data_memory/address 20#00000 0
# ** Error: Bad base to make_vreg.
#    Time: 0 ps  Iteration: 0  Instance: /data_memory
# ** Error: Bad digit in make_vreg.
#    Time: 0 ps  Iteration: 0  Instance: /data_memory
force -freeze sim:/data_memory/datain 16#FFFF 0
force -freeze sim:/data_memory/memory_write 01 0
force -freeze sim:/data_memory/memory_read 0 0
run
force -freeze sim:/data_memory/memory_write 00 0
force -freeze sim:/data_memory/memory_read 1 0
run
force -freeze sim:/data_memory/address 32#FFFFF 0
# ** Error: Bad base to make_vreg.
#    Time: 200 ps  Iteration: 1  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
# ** Error: Bad digit in make_vreg.
#    Time: 200 ps  Iteration: 1  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
force -freeze sim:/data_memory/address 20#00000 0
# ** Error: Bad base to make_vreg.
#    Time: 200 ps  Iteration: 1  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
# ** Error: Bad digit in make_vreg.
#    Time: 200 ps  Iteration: 1  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
force -freeze sim:/data_memory/datain 32#FFFFFFFF 0
# ** Error: Bad base to make_vreg.
#    Time: 200 ps  Iteration: 1  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
# ** Error: Bad digit in make_vreg.
#    Time: 200 ps  Iteration: 1  Instance: /data_memory File: D:/Repos/Computer-Architecture-Project/RTL Code/memory_stage/DataMemory.vhd
force -freeze sim:/data_memory/memory_write 11 0
force -freeze sim:/data_memory/memory_read 0 0
run
force -freeze sim:/data_memory/memory_read 1 0
force -freeze sim:/data_memory/memory_write 00 0
run

