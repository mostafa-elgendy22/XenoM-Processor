# compile all projects
project compileall
#
# this command open the simulation for the entity named "control_unit"
vsim -gui work.control_unit(controlunit)
#
# add the signals you want to test in the wave
add wave -position insertpoint sim:/control_unit/*
#
#
# set the radix to Hexadecimal
radix signal sim:/control_unit/clk Binary
radix signal sim:/control_unit/instruction Binary
radix signal sim:/control_unit/is_immediate Binary
radix signal sim:/control_unit/immediate_data Binary
radix signal sim:/control_unit/write_back_enable Binary
radix signal sim:/control_unit/Rsrc1_address Binary
radix signal sim:/control_unit/Rsrc2_address Binary
radix signal sim:/control_unit/Rdst_address Binary
radix signal sim:/control_unit/is_operation_on_Rdst Binary
radix signal sim:/control_unit/flags_write_enable Binary
radix signal sim:/control_unit/ALU_operation Binary
radix signal sim:/control_unit/io_read Binary
radix signal sim:/control_unit/io_write Binary
radix signal sim:/control_unit/memory_write Binary
radix signal sim:/control_unit/memory_read Binary
radix signal sim:/control_unit/is_store_instruction Binary
radix signal sim:/control_unit/stack_control Binary
radix signal sim:/control_unit/enable_out Binary
radix signal sim:/control_unit/branch_type Binary
radix signal sim:/control_unit/is_call_or_int_instruction Binary
radix signal sim:/control_unit/is_hlt_instruction Binary

#
# init, output appears with the rising edge
force -freeze sim:/control_unit/clk 0 0, 1 {50 ps} -r 100
run

# Type 0
# instruction NOP,
force -freeze sim:/control_unit/instruction 2#00000000000000000000000000000000 0
run

# instruction SETC,
force -freeze sim:/control_unit/instruction 2#00000100000000000000000000000000 0
run

# instruction HLT,
force -freeze sim:/control_unit/instruction 2#00010000000000000000000000000000 0
run

# Type 1, Rdst = 101
# instruction NOT,
force -freeze sim:/control_unit/instruction 2#01000010100000000000000000000000 0
run

# instruction INC,
force -freeze sim:/control_unit/instruction 2#01000110100000000000000000000000 0
run

# instruction IN,
force -freeze sim:/control_unit/instruction 2#01010010100000000000000000000000 0
run

# instruction OUT,
force -freeze sim:/control_unit/instruction 2#01010110100000000000000000000000 0
run

# Type 2, Rdst = 111, Rsrc = 101 

# instruction MOV,
force -freeze sim:/control_unit/instruction 2#10000011110100000000000000000000 0
run

# Type 3.1, Rdst = 111, Rsrc = 101 
# instruction AND,
force -freeze sim:/control_unit/instruction 2#11000011110100000000000000000000 0
run

# instruction SUB,
force -freeze sim:/control_unit/instruction 2#11000111110100000000000000000000 0
run

# instruction ADD,
force -freeze sim:/control_unit/instruction 2#11001011110100000000000000000000 0
run

# Type 3.2, Rdst = 111, Rsrc = 101, Imm= 0x0003
# instruction IADD, TODO: not working
force -freeze sim:/control_unit/instruction 2#11001111110100000000000000110000 0
run

