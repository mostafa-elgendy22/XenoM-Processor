LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY flagsRegister IS 

	PORT(
			newFlags : IN std_logic_vector(2 DOWNTO 0);
			writeEnables: IN std_logic_vector(2 DOWNTO 0);
			
			flags: OUT std_logic_vector(2 DOWNTO 0);
			
			clk  : IN std_logic 
	);

END FlagsRegister ;


ARCHITECTURE flagsRegister of flagsRegister IS
	
signal flagsRegs : std_logic_vector(2 DOWNTO 0) ;

BEGIN

		flagsRegs(0) <= newFlags(0) WHEN rising_edge(clk) AND writeEnables(0) = '1' ;
		flagsRegs(1) <= newFlags(1) WHEN rising_edge(clk) AND writeEnables(1) = '1' ;    
		flagsRegs(2) <= newFlags(2) WHEN rising_edge(clk) AND writeEnables(2) = '1' ;
		
		
		flags(0) <= flagsRegs(0);
		flags(1) <= flagsRegs(1);
		flags(2) <= flagsRegs(2);
END flagsRegister ;