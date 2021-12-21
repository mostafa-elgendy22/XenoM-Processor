# compile all projects
project compileall
#
# this command open the simulation for the entity named "memandreg"
vsim -gui work.control_unit(controlunit)
#
# add the signals you want to test in the wave
add wave -position insertpoint sim:/control_unit/*
#
# init
force -freeze sim:/memcount/Clk 1 0, 0 {50 ps} -r 100



# instruction NOP,
force -freeze sim:/control_unit/instruction 16#0000 0
run