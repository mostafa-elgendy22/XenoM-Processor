LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tri_state_buffer IS
       GENERIC (data_width : INTEGER := 16);
       PORT (
              X : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
              C : IN STD_LOGIC;
              Y : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE tri_state_buffer OF tri_state_buffer IS
BEGIN
       Y <= X WHEN C = '1'
              ELSE
              (OTHERS => 'Z');
END ARCHITECTURE;
