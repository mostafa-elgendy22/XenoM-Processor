LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY data_memory IS
   PORT (
      clk : IN STD_LOGIC;
      address : IN STD_LOGIC_VECTOR(19 DOWNTO 0); --20bit memory address from execution unit 
      datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32 data input    
      memory_read : IN STD_LOGIC; -- signal read from memory with address
      memory_write : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --signal write in memory
      dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

--memory write 2 bits
-- 0|0  noop
---------------------
-- 0|1  16 bit data
---------------------
-- 1|1  32 bit data 
ARCHITECTURE a_data_memory OF data_memory IS

   TYPE memory_type IS ARRAY(0 TO (2 ** 20) - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL ram : memory_type;

BEGIN
   PROCESS (clk) IS
   BEGIN
      IF rising_edge(clk) THEN
         -- data write In memory 16 bit data 
         IF memory_write(0) = '1' THEN
            ram(to_integer(unsigned(address))) <=datain(15 DOWNTO 0);
         END IF;
         -- data write In memory 32 bit data 
         IF memory_write(1) = '1' THEN
            ram(to_integer(unsigned(address + 1))) <=  datain(31 DOWNTO 16);
         END IF;

      END IF;
   END PROCESS;
   -- data out from memory 
   dataout(31 DOWNTO 16) <= ram(to_integer(unsigned(address + 1))) WHEN memory_read = '1'
   ELSE
      (OTHERS => 'Z');
   dataout(15 DOWNTO 0) <= ram(to_integer(unsigned(address))) WHEN memory_read = '1'
ELSE
   (OTHERS => 'Z');
END ARCHITECTURE;