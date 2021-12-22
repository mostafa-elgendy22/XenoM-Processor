project compileall
vsim -gui work.decoding_stage
add wave -position insertpoint sim:/decoding_stage/*

force -freeze sim:/decoding_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decoding_stage/rst 1 0
run

force -freeze sim:/decoding_stage/instruction 11011110111100000000000000110000 0
force -freeze sim:/decoding_stage/write_back_enable_in 1 0
force -freeze sim:/decoding_stage/write_address 111 0
force -freeze sim:/decoding_stage/write_data 16#FFFF 0
force -freeze sim:/decoding_stage/rst 0 0
run

run