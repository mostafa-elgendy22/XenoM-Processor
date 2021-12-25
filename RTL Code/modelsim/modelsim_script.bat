vlib work
vcom ../basic_components/*.vhd

vcom ../decode_stage/control_unit.vhd
vcom ../decode_stage/register_file.vhd
vcom ../decode_stage/decoding_stage.vhd


vcom ../execute_stage/ALU.vhd
vcom ../execute_stage/flagsRegister.vhd
vcom ../execute_stage/execute_stage.vhd


vcom ../fetch_stage/instruction_memory.vhd
vcom ../fetch_stage/fetch_stage.vhd

vcom ../memory_stage/InputOutputPort.vhd

vcom ../processor.vhd

vmap -c
vsim -do ../processor.do