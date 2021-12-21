LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY fetch_stage IS
       PORT (
              clk : IN STD_LOGIC;
              reset : IN STD_LOGIC;
              hlt_instruction : IN STD_LOGIC;
              data_bus : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE fetch_stage OF fetch_stage IS
       SIGNAL D_PC, Q_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
       SIGNAL memory_dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
       SIGNAL databus_we : STD_LOGIC;
       SIGNAL PC_enable : STD_LOGIC;
       SIGNAL PC_clock : STD_LOGIC;
BEGIN
       PC : ENTITY work.DFF_register
              GENERIC MAP(data_width => 32)
              PORT MAP(
                     clk => PC_clock,
                     reset => reset,
                     enable => PC_enable,
                     D => D_PC,
                     Q => Q_PC
              );

       instruction_memory : ENTITY work.instruction_memory
              PORT MAP(
                     address => Q_PC(19 DOWNTO 0),
                     dataout => memory_dataout
              );

       memory_tri_state_buffer : ENTITY work.tri_state_buffer
              GENERIC MAP(data_width => 32)
              PORT MAP(
                     X => memory_dataout,
                     C => databus_we,
                     Y => data_bus
              );

       PROCESS (clk) IS
       BEGIN
              IF rising_edge(clk) THEN
                     databus_we <= '1';
              END IF;

              IF falling_edge(clk) THEN
                     databus_we <= '0';
              END IF;
       END PROCESS;
       D_PC <= Q_PC + 1 WHEN data_bus(31) = '0'
              ELSE
              Q_PC + 2 WHEN data_bus(31) = '1'
              ELSE
              D_PC;

       PC_enable <= NOT hlt_instruction;
       PC_clock <= NOT clk;
END ARCHITECTURE;