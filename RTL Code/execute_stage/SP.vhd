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

       SIGNAL mydata : STD_LOGIC_VECTOR(31 DOWNTO 0);

       SIGNAL mynewdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

       SIGNAL uMyData : unsigned(31 DOWNTO 0);
       SIGNAL uMyNewData : unsigned(31 DOWNTO 0);
BEGIN
       uMyData <= unsigned(mydata);
       mynewdata <= STD_LOGIC_VECTOR(uMyNewData);

       PROCESS (clk) BEGIN
              IF (reset = '1') THEN
                     mydata <= "00000000000011111111111111111111";
              ELSIF (rising_edge(clk)) THEN
                     CASE stackCtl IS 
                            WHEN "100" => uMyNewData <= uMyData - 1 ;
                            WHEN "101" => uMyNewData <= uMyData + 1 ;
                            WHEN "110" => uMyNewData <= uMyData - 2 ;
                            WHEN "111" => uMyNewData <= uMyData + 2 ;
                            WHEN OTHERS => uMyNewData <= uMyData ;
                     END CASE ;
                     mydata <= mynewdata;
              END IF;
       END PROCESS;

       data <= mydata;
       newdata <= mynewdata;
END SP;
