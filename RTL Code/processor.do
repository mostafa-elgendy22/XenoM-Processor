vsim -gui work.processor

# change the name of memory file in the following command
mem load -i {../../Memory Files/mem2.mem} /processor/fetch/instruction_memory/ram

add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/processor_reset \
sim:/processor/fetch/instruction_bus \
sim:/processor/fetch/D_PC \
sim:/processor/fetch/Q_PC \
sim:/processor/fetch/next_instruction_address \
sim:/processor/fetch/branch_type \
sim:/processor/fetch/exception_enable \
sim:/processor/fetch/exception_handler_index \
sim:/processor/decode/instruction \
sim:/processor/decode/FD_instruction_address \
sim:/processor/decode/Control_unit/ALU_operation \
sim:/processor/decode/is_immediate_out \
sim:/processor/decode/Control_unit/write_back_enable \
sim:/processor/decode/Control_unit/branch_type \
sim:/processor/decode/operand1 \
sim:/processor/decode/operand2 \
sim:/processor/decode/branch_type \
sim:/processor/decode/Rdst_address_out \
sim:/processor/execute/Rdst_address_in \
sim:/processor/DE_data \
sim:/processor/DE \
sim:/processor/execute/DE_instruction_address \
sim:/processor/execute/branch_type_in \
sim:/processor/execute/branch_type_out \
sim:/processor/execute/ALU_op1 \
sim:/processor/execute/ALU_op2 \
sim:/processor/execute/ALU_sel \
sim:/processor/execute/ExecResult \
sim:/processor/execute/SP_old \
sim:/processor/execute/SP_new \
sim:/processor/execute/stack_control \
sim:/processor/memory/instruction_address \
sim:/processor/memory/data_out \
sim:/processor/memory/memory_read \
sim:/processor/memory/memory_write \
sim:/processor/memory/mem_address \
sim:/processor/memory/write_back_enable_out \
sim:/processor/memory/write_back_enable \
sim:/processor/memory/operand1 \
sim:/processor/memory/execution_stage_result \
sim:/processor/memory/data_out \
sim:/processor/memory/int_index_Rdst_address \
sim:/processor/WB_enable_in \
sim:/processor/WB_write_address \
sim:/processor/WB_write_data \
sim:/processor/decode/Register_file/write_data \
sim:/processor/decode/Register_file/write_address \
sim:/processor/decode/Register_file/write_back_enable 

# radix signal sim:/processor/* Hexadecimal



force -freeze sim:/processor/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/processor/processor_reset 1 0
run {200 ps}

force -freeze sim:/processor/processor_reset 0 0
run {8000 ps}