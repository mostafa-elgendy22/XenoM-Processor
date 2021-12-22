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
radix signal sim:/control_unit/immediate_data Hexadecimal
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
set type 00
#
# instruction NOP,
force -freeze sim:/control_unit/instruction 2#${type}000000000000000000000000000000 0
run

# instruction SETC,
force -freeze sim:/control_unit/instruction 2#${type}000100000000000000000000000000 0
run

# instruction HLT,
force -freeze sim:/control_unit/instruction 2#${type}010000000000000000000000000000 0
run

# Type 1
set type 01
set Rdst 101
#
# instruction NOT,
force -freeze sim:/control_unit/instruction 2#${type}0000${Rdst}00000000000000000000000 0
run

# instruction INC,
force -freeze sim:/control_unit/instruction 2#${type}0001${Rdst}00000000000000000000000 0
run

# instruction IN,
force -freeze sim:/control_unit/instruction 2#${type}0100${Rdst}00000000000000000000000 0
run

# instruction OUT,
force -freeze sim:/control_unit/instruction 2#${type}0101${Rdst}00000000000000000000000 0
run

# Type 2
set type 10
set Rdst 111
set Rsrc 101
#
# instruction MOV,
force -freeze sim:/control_unit/instruction 2#${type}0000${Rdst}${Rsrc}00000000000000000000 0
run

# Type 3
set type 11
#
# Type 3.1

# instruction AND,
force -freeze sim:/control_unit/instruction 2#${type}0000${Rdst}${Rsrc}00000000000000000000 0
run

# instruction SUB,
force -freeze sim:/control_unit/instruction 2#${type}0001${Rdst}${Rsrc}00000000000000000000 0
run

# instruction ADD,
force -freeze sim:/control_unit/instruction 2#${type}0010${Rdst}${Rsrc}00000000000000000000 0
run

# Type 3.2
set Rdst 101
set Rsrc 111
set Imm 0000000000000011
#
# instruction IADD, TODO: not working
force -freeze sim:/control_unit/instruction 2#${type}0111${Rdst}${Rsrc}${Imm}0000 0
run

