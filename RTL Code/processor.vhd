LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY processor IS
       PORT (
              clk : IN STD_LOGIC;
              processor_reset : IN STD_LOGIC;
              instruction_bus : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE processor OF processor IS

       SIGNAL ground : STD_LOGIC := '0';
       SIGNAL neg_clk : STD_LOGIC;

       -- Fetch stage parameters
       CONSTANT instruction_i0 : INTEGER := 51;
       CONSTANT instruction_i1 : INTEGER := 20;
       CONSTANT instruction_address_i0 : INTEGER := 19;
       CONSTANT instruction_address_i1 : INTEGER := 0;
       SIGNAL FD_enable : STD_LOGIC;
       SIGNAL FD_data : STD_LOGIC_VECTOR(51 DOWNTO 0);
       SIGNAL FD : STD_LOGIC_VECTOR(51 DOWNTO 0);

       -- change this later
       SIGNAL is_hlt_instruction : STD_LOGIC := '0';

BEGIN
       neg_clk <= NOT clk;

       fetch : ENTITY work.fetch_stage
              PORT MAP(
                     clk => clk,
                     processor_reset => processor_reset,
                     hlt_instruction => is_hlt_instruction,
                     instruction_bus => instruction_bus,
                     FD_enable => FD_enable,
                     FD_data => FD_data
              );

       FD_register : ENTITY work.DFF_register
              GENERIC MAP(data_width => 52)
              PORT MAP(
                     clk => neg_clk,
                     enable => FD_enable,
                     reset => ground,
                     D => FD_data,
                     Q => FD
              );

END ARCHITECTURE;