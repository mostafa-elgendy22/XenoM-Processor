vsim -gui work.fetch_stage

mem load -filltype value -filldata 16#3FFF -fillradix symbolic /fetch_stage/instruction_memory/ram(0)
mem load -filltype value -filldata 16#FFFF -fillradix symbolic /fetch_stage/instruction_memory/ram(1)
mem load -filltype value -filldata 16#AAAA -fillradix symbolic /fetch_stage/instruction_memory/ram(2)
mem load -filltype value -filldata 16#3CCC -fillradix symbolic /fetch_stage/instruction_memory/ram(3)
mem load -filltype value -filldata 16#3BBB -fillradix symbolic /fetch_stage/instruction_memory/ram(4)
mem load -filltype value -filldata 16#3DDD -fillradix symbolic /fetch_stage/instruction_memory/ram(5)


add wave -position insertpoint  \
sim:/fetch_stage/clk \
sim:/fetch_stage/reset \
sim:/fetch_stage/hlt_instruction \
sim:/fetch_stage/D_PC \
sim:/fetch_stage/PC_enable \
sim:/fetch_stage/Q_PC \
sim:/fetch_stage/instruction_memory_dataout \
sim:/fetch_stage/instruction_we \
sim:/fetch_stage/instruction

radix signal sim:/fetch_stage/instruction_memory_dataout Hexadecimal
radix signal sim:/fetch_stage/instruction Hexadecimal
radix signal sim:/fetch_stage/D_PC Hexadecimal
radix signal sim:/fetch_stage/Q_PC Hexadecimal


force -freeze sim:/fetch_stage/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/fetch_stage/reset 1 0
force -freeze sim:/fetch_stage/hlt_instruction 0 0
run {50 ps}

force -freeze sim:/fetch_stage/reset 0 0
run {750 ps}