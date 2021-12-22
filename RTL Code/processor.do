project compileall
vsim -gui work.processor

# change the name of memory file in the following command
mem load -i {../Memory Files/mem1.mem} /processor/fetch/instruction_memory/ram

add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/processor_reset \
sim:/processor/FD

radix signal sim:/processor/FD Hexadecimal
radix signal sim:/processor/fetch/FD_data Hexadecimal

force -freeze sim:/processor/clk 0 0, 1 {100 ps} -r 200
force -freeze sim:/processor/processor_reset 1 0
run {200 ps}

force -freeze sim:/processor/processor_reset 0 0
run {800 ps}