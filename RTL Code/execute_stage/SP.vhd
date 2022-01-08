LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SP IS
       PORT (
              clk : IN STD_LOGIC;
              reset : IN STD_LOGIC;
              stackCtl : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- (2) stack enable, (1:0) stack operation
              data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
              newdata: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END ENTITY;
ARCHITECTURE SP OF SP IS
      
BEGIN
       PROCESS (clk) 
	VARIABLE mydata : STD_LOGIC_VECTOR(31 DOWNTO 0);
      	VARIABLE mynewdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
	BEGIN		
              IF (reset = '1') THEN
                     mydata := "00000000000011111111111111111111";
                     mynewdata := mydata ;
              ELSIF (rising_edge(clk)) THEN
                     mydata := mynewdata ;
                     CASE stackCtl IS 
                            WHEN "100" => mynewdata := STD_LOGIC_VECTOR(UNSIGNED(mydata) - 1) ;
                            WHEN "101" => mynewdata := STD_LOGIC_VECTOR(UNSIGNED(mydata) + 1) ;
                            WHEN "110" => mynewdata := STD_LOGIC_VECTOR(UNSIGNED(mydata) - 2) ;
                            WHEN "111" => mynewdata := STD_LOGIC_VECTOR(UNSIGNED(mydata) + 2) ;
                            WHEN OTHERS=> mynewdata := mydata ;
                     END CASE ;
              END IF;

		data <= mydata;
       		newdata <= mynewdata;
       END PROCESS;
       
END SP;
