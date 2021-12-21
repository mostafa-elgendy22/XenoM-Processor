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
# init
force -freeze sim:/control_unit/clk 0 0, 1 {50 ps} -r 100
# instruction NOP,
force -freeze sim:/control_unit/instruction 16#0000 0
run





