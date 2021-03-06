LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Latch IS
       GENERIC (data_width : INTEGER := 16);
       PORT (
              D : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
              clk, enable, reset : IN STD_LOGIC;
              Q : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE a_Latch OF Latch IS
BEGIN
       PROCESS (clk, enable, reset)
       BEGIN
              IF reset = '1' THEN
                     Q <= (OTHERS => '0');
              ELSIF  enable = '1' THEN
                     Q <= D;
              END IF;
       END PROCESS;
END ARCHITECTURE;
