project compileall
vsim -gui work.fetch_stage

mem load -filltype value -filldata 16#000A -fillradix symbolic /fetch_stage/instruction_memory/ram(0)
mem load -filltype value -filldata 16#0000 -fillradix symbolic /fetch_stage/instruction_memory/ram(1)
mem load -filltype value -filldata 16#3AAA -fillradix symbolic /fetch_stage/instruction_memory/ram(655360)
mem load -filltype value -filldata 16#FCCC -fillradix symbolic /fetch_stage/instruction_memory/ram(655361)
mem load -filltype value -filldata 16#3BBB -fillradix symbolic /fetch_stage/instruction_memory/ram(655362)
mem load -filltype value -filldata 16#3DDD -fillradix symbolic /fetch_stage/instruction_memory/ram(655363)
mem load -filltype value -filldata 16#5555 -fillradix symbolic /fetch_stage/instruction_memory/ram(655364)


add wave -position insertpoint  \
sim:/fetch_stage/clk \
sim:/fetch_stage/processor_reset \
sim:/fetch_stage/hlt_instruction \
sim:/fetch_stage/D_PC \
sim:/fetch_stage/next_instruction_address \
sim:/fetch_stage/PC_enable \
sim:/fetch_stage/Q_PC \
sim:/fetch_stage/instruction_memory_dataout \
sim:/fetch_stage/instruction_we \
sim:/fetch_stage/instruction

radix signal sim:/fetch_stage/instruction_memory_dataout Hexadecimal
radix signal sim:/fetch_stage/instruction Hexadecimal
radix signal sim:/fetch_stage/D_PC Hexadecimal
radix signal sim:/fetch_stage/Q_PC Hexadecimal
radix signal sim:/fetch_stage/next_instruction_address Hexadecimal


force -freeze sim:/fetch_stage/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/fetch_stage/processor_reset 1 0
force -freeze sim:/fetch_stage/hlt_instruction 0 0
run {200 ps}

force -freeze sim:/fetch_stage/processor_reset 0 0
run {800 ps}