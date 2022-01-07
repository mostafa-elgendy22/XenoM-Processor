LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SP IS
				  PORT (
					 clk : IN std_logic;
					 reset:IN std_logic;
					 stackCtl : IN std_logic_vector(2 DOWNTO 0); -- (2) stack enable, (1:0) stack operation
 
					 
					 data : OUT std_logic_vector(31 DOWNTO 0)
				  );
END ENTITY;


ARCHITECTURE SP OF SP IS 

SIGNAL mydata : std_logic_vector(31 DOWNTO 0) ;

SIGNAL newdata: std_logic_vector(31 DOWNTO 0) ;

SIGNAL uMyData: unsigned(31 DOWNTO 0);
SIGNAL uNewdata:unsigned(31 DOWNTO 0);
BEGIN
		uMyData <= unsigned(mydata) ;
		
		WITH stackCtl SELECT uNewdata <=
												uMyData + 1 WHEN "100",
												uMyData - 1 WHEN "101",
												uMyData + 2 WHEN "110",
												uMyData - 2 WHEN "111",
												uMyData   	WHEN OTHERS ;
												
		newdata <= std_logic_vector(uNewData) ;
	
		PROCESS(clk) BEGIN
			IF(reset = '1') THEN
				mydata <= (OTHERS => '0') ; 
			ELSIF(rising_edge(clk)) THEN 
				mydata <= newdata ;
			END IF ;
		END PROCESS ;

		data <= mydata ;
END SP ;