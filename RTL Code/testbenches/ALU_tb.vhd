LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;



ENTITY ALU_tb IS 

function to_string ( a: std_logic_vector) return string is
variable b : string (1 to a'length) := (others => NUL);
variable stri : integer := 1; 
begin
    for i in a'range loop
        b(stri) := std_logic'image(a((i)))(2);
    stri := stri+1;
    end loop;
return b;
end function;

END ALU_tb ;


ARCHITECTURE tb of ALU_tb IS

signal ALUFuncSelect : std_logic_vector(2 DOWNTO 0);
signal input1,input2,result : std_logic_vector(15 DOWNTO 0);
signal ALUFlags, ALUFlagsWriteEnable : std_logic_vector(2 DOWNTO 0) ;

signal clk : std_logic := '0' ;
signal flagRegisterOutput : std_logic_vector(2 DOWNTO 0);

signal expectedResult : std_logic_vector(15 DOWNTO 0);
BEGIN

	clk <= not clk AFTER 1ns ;
	
	--Designs under test (DUTs)
	A : ENTITY work.ALU(ALU)
			PORT MAP (
						op1 => input1,
						op2 => input2,
			      funcSel=> ALUFuncSelect,
			
					result => result,
					flags  => ALUFlags,
					flagsEn => ALUFlagsWriteEnable
			);
	
	
	F : ENTITY work.flagsRegister(flagsRegister)
			PORT MAP (
						newFlags => ALUFlags,
						writeEnables => ALUFlagsWriteEnable,
			
						flags => flagRegisterOutput,
						
						clk   => clk
			);
	
	
	stimulus : PROCESS BEGIN
				ALUFuncSelect <= "000" ;--ALU_ADD ;
				
				-------********************************************--------
				input1 <= "0000000000000000" ;
				input2 <= "0000000000000000" ;
				expectedResult <= "0000000000000000";
				WAIT FOR 1ns ;
				
				IF NOT(result = expectedResult ) THEN
						REPORT "/////TEST CASE #1 FAILED!!!///// " 
						& to_string(input1) 
						& " + " 
						& to_string(input2)  
						& " should equal " 
						& to_string(expectedResult) 
						& " but " 
						& to_string(result) 
						& " was found instead." ;
				END IF;			
				WAIT FOR 1ns;
				-------********************************************--------
				-------********************************************--------				
				input1 <= "0000000000000001" ;
				input2 <= "0000000000000000" ;
				expectedResult <= "0000000000000001";
				WAIT FOR 1ns ;
				
				IF NOT(result = expectedResult ) THEN
						REPORT "/////TEST CASE #2 FAILED!!!///// " 
						& to_string(input1) 
						& " + " 
						& to_string(input2)  
						& " should equal " 
						& to_string(expectedResult) 
						& " but " 
						& to_string(result) 
						& " was found instead." ;
				END IF;
				WAIT FOR 1ns ;
				-------********************************************--------

				
				
				REPORT "TESTCASES SUCCEEDED";
	END PROCESS stimulus ;

END tb ;