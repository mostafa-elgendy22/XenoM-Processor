project compileall
vsim -gui work.processor

mem load -filltype value -filldata 16#000A -fillradix symbolic /processor/fetch/instruction_memory/ram(0)
mem load -filltype value -filldata 16#0000 -fillradix symbolic /processor/fetch/instruction_memory/ram(1)
mem load -filltype value -filldata 16#3AAA -fillradix symbolic /processor/fetch/instruction_memory/ram(655360)
mem load -filltype value -filldata 16#FCCC -fillradix symbolic /processor/fetch/instruction_memory/ram(655361)
mem load -filltype value -filldata 16#3BBB -fillradix symbolic /processor/fetch/instruction_memory/ram(655362)
mem load -filltype value -filldata 16#3DDD -fillradix symbolic /processor/fetch/instruction_memory/ram(655363)
mem load -filltype value -filldata 16#5555 -fillradix symbolic /processor/fetch/instruction_memory/ram(655364)


add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/processor_reset \
sim:/processor/instruction_bus \
sim:/processor/FD \
sim:/processor/fetch/FD_data

radix signal sim:/processor/FD Hexadecimal
radix signal sim:/processor/instruction_bus Hexadecimal
radix signal sim:/processor/fetch/FD_data Hexadecimal

force -freeze sim:/processor/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/processor/processor_reset 1 0
run {200 ps}

force -freeze sim:/processor/processor_reset 0 0
run {800 ps}