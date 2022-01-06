LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY data_memory IS
       PORT (
              address : IN STD_LOGIC_VECTOR(19 DOWNTO 0); --20bit memory address from execution unit 
              datain  : IN STD_LOGIC_VECTOR(31 DOWNTO 0) -- 32 data input    
              memory_read: IN STD_LOGIC;                -- signal read from memory with address
              memory_write:IN STD_LOGIC_Vector(1 DOWNTO 0); --signal write in memory
              dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); 
END ENTITY;

--memory write 2 bits
-- 0|0  noop
---------------------
-- 0|1  16 bit data
---------------------
-- 1|1  32 bit data 
ARCHITECTURE a_data_memory OF data_memory IS

       TYPE ram_type IS ARRAY(0 TO (2 ** 20) - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
       SIGNAL ram : ram_type;

BEGIN
    -- data out from memory 
       datout <= ram(to_integer(unsigned(address))) WHEN memory_read
       ELSE (others => x'z');
    -- data write In memory
       ram(to_integer(unsigned(address))) <= datain(31 DOWNTO 16) WHEN memory_write(0) ; 
       
       ram(to_integer(unsigned(address+1))) <= datain(15 DOWNTO 0) WHEN memory_write(1) ; 

END ARCHITECTURE;