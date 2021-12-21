LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY instruction_memory IS
       PORT (
              address : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
              dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE instruction_memory OF instruction_memory IS

       TYPE ram_type IS ARRAY(0 TO (2 ** 20) - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
       SIGNAL ram : ram_type;

BEGIN
       dataout(31 DOWNTO 16) <= ram(to_integer(unsigned(address)));
       dataout(15 DOWNTO 0) <= ram(to_integer(unsigned(address + 1)));
END ARCHITECTURE;