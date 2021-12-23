project compileall
vsim -gui work.processor

# change the name of memory file in the following command
mem load -i {../Memory Files/mem1.mem} /processor/fetch/instruction_memory/ram

add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/processor_reset \
sim:/processor/FD \
sim:/processor/decode/instruction \
sim:/processor/decode/FD_instruction_address \
sim:/processor/decode/Control_unit/ALU_operation \
sim:/processor/decode/operand1 \
sim:/processor/decode/operand2 \
sim:/processor/execute/ALU_op1 \
sim:/processor/execute/ALU_op2 \
sim:/processor/execute/ALU_result \
sim:/processor/execute/ALU_sel 


radix signal sim:/processor/FD Hexadecimal

radix signal sim:/processor/decode/instruction Hexadecimal
radix signal sim:/processor/decode/FD_instruction_address Hexadecimal
radix signal sim:/processor/decode/operand1 Hexadecimal
radix signal sim:/processor/decode/operand2 Hexadecimal

radix signal sim:/processor/execute/ALU_op1 Hexadecimal
radix signal sim:/processor/execute/ALU_op2 Hexadecimal
radix signal sim:/processor/execute/ALU_result Hexadecimal


force -freeze sim:/processor/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/processor/processor_reset 1 0
run {200 ps}

force -freeze sim:/processor/processor_reset 0 0
run {2000 ps}