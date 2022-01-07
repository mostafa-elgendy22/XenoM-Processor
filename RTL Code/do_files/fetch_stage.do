vsim -gui work.fetch_stage

# change the name of memory file in the following command
mem load -i {../../../Memory Files/mem1.mem} /fetch_stage/instruction_memory/ram


add wave -position insertpoint  \
sim:/fetch_stage/clk \
sim:/fetch_stage/processor_reset \
sim:/fetch_stage/is_hlt_instruction \
sim:/fetch_stage/branch_type \
sim:/fetch_stage/int_index \
sim:/fetch_stage/D_PC \
sim:/fetch_stage/instruction_memory_address \
sim:/fetch_stage/next_instruction_address \
sim:/fetch_stage/PC_enable \
sim:/fetch_stage/Q_PC \
sim:/fetch_stage/instruction_memory_dataout \
sim:/fetch_stage/instruction_bus \
sim:/fetch_stage/exception_enable \
sim:/fetch_stage/exception_handler_index \
sim:/fetch_stage/exception_handler_address \
sim:/fetch_stage/exception_instruction_address \
sim:/fetch_stage/Q_EPC \
sim:/fetch_stage/FD_enable \
sim:/fetch_stage/FD_data

radix signal sim:/fetch_stage/instruction_memory_dataout Hexadecimal
radix signal sim:/fetch_stage/instruction_memory_address Hexadecimal
radix signal sim:/fetch_stage/instruction_bus Hexadecimal
radix signal sim:/fetch_stage/D_PC Hexadecimal
radix signal sim:/fetch_stage/Q_PC Hexadecimal
radix signal sim:/fetch_stage/Q_EPC Hexadecimal
radix signal sim:/fetch_stage/int_handler_address Hexadecimal
radix signal sim:/fetch_stage/exception_instruction_address Hexadecimal
radix signal sim:/fetch_stage/exception_handler_address Hexadecimal
radix signal sim:/fetch_stage/next_instruction_address Hexadecimal
radix signal sim:/fetch_stage/FD_data Hexadecimal


force -freeze sim:/fetch_stage/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/fetch_stage/processor_reset 1 0
#force -freeze sim:/fetch_stage/is_hlt_instruction 0 0
run {200 ps}

force -freeze sim:/fetch_stage/processor_reset 0 0
run {200 ps}

force -freeze sim:/fetch_stage/branch_type 1101 0
force -freeze sim:/fetch_stage/int_index 000 0
run {200 ps}

force -freeze sim:/fetch_stage/branch_type 0000 0
run {200 ps}

force -freeze sim:/fetch_stage/exception_enable 1 0
force -freeze sim:/fetch_stage/exception_instruction_address 16#AAAAAAAA 0
force -freeze sim:/fetch_stage/exception_handler_index 16#8 0
run {200 ps}

force -freeze sim:/fetch_stage/exception_enable 0 0
run {600 ps}