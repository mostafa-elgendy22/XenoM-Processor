LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY fetch_stage IS
       PORT (
              clk : IN STD_LOGIC;
              processor_reset : IN STD_LOGIC;
              is_hlt_instruction : IN STD_LOGIC;
              is_int_instruction : IN STD_LOGIC;
              int_index : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
              instruction_bus : INOUT STD_LOGIC_VECTOR (31 DOWNTO 0);
              exception_enable : IN STD_LOGIC;
              exception_handler_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
              exception_instruction_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
              FD_enable : OUT STD_LOGIC;
              FD_data : OUT STD_LOGIC_VECTOR (51 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE fetch_stage OF fetch_stage IS

       SIGNAL D_PC, Q_PC, D_EPC, Q_EPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
       SIGNAL next_instruction_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
       SIGNAL instruction_memory_address : STD_LOGIC_VECTOR(19 DOWNTO 0);
       SIGNAL instruction_memory_dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
       SIGNAL instruction_we : STD_LOGIC;
       SIGNAL PC_enable : STD_LOGIC;
       SIGNAL PC_clock : STD_LOGIC;
       SIGNAL int_handler_address, padded_int_index : STD_LOGIC_VECTOR(19 DOWNTO 0);
       SIGNAL ground : STD_LOGIC := '0';

BEGIN
       padded_int_index <= (19 DOWNTO 3 => '0') & int_index;
       int_handler_address <= padded_int_index + 6;

       PC : ENTITY work.DFF_register
              GENERIC MAP(data_width => 32)
              PORT MAP(
                     clk => PC_clock,
                     enable => PC_enable,
                     reset => ground,
                     D => D_PC,
                     Q => Q_PC
              );
       D_EPC <= X"000" & exception_instruction_address;
       EPC : ENTITY work.DFF_register
              GENERIC MAP(data_width => 32)
              PORT MAP(
                     clk => clk,
                     enable => exception_enable,
                     reset => ground,
                     D => D_EPC,
                     Q => Q_EPC
              );

       instruction_memory : ENTITY work.instruction_memory
              PORT MAP(
                     address => instruction_memory_address,
                     dataout => instruction_memory_dataout
              );

       memory_tri_state_buffer : ENTITY work.tri_state_buffer
              GENERIC MAP(data_width => 32)
              PORT MAP(
                     X => instruction_memory_dataout,
                     C => instruction_we,
                     Y => instruction_bus
              );

       instruction_memory_address <= (OTHERS => '0') WHEN processor_reset = '1'
              ELSE
              exception_handler_address WHEN exception_enable = '1'
              ELSE
              int_handler_address WHEN is_int_instruction = '1'
              ELSE
              Q_PC(19 DOWNTO 0);

       next_instruction_address <= Q_PC + 1 WHEN (instruction_bus(31) = '0')
              OR (instruction_bus(31 DOWNTO 30) = "10" AND instruction_bus(26) = '0')
              OR (instruction_bus(31 DOWNTO 30) = "11" AND instruction_bus(29) = '0')
              ELSE
              Q_PC + 2 WHEN (instruction_bus(31 DOWNTO 30) = "10" AND instruction_bus(26) = '1')
              OR (instruction_bus(31 DOWNTO 30) = "11" AND instruction_bus(29) = '1')
              ELSE
              Q_PC;

       D_PC <= instruction_bus WHEN processor_reset = '1' OR is_int_instruction = '1' OR exception_enable = '1'
              ELSE
              next_instruction_address;

       PC_enable <= '0' WHEN is_hlt_instruction = '1'
              ELSE
              '1';

       PC_clock <= NOT clk;

       FD_enable <= NOT processor_reset;

       FD_data(51 DOWNTO 20) <= (OTHERS => '0') WHEN processor_reset = '1' OR is_int_instruction = '1' OR exception_enable = '1'
              ELSE
              instruction_bus;

       FD_data(19 DOWNTO 0) <= Q_PC(19 DOWNTO 0);

       PROCESS (clk) IS
       BEGIN
              IF rising_edge(clk) THEN
                     instruction_we <= '1';
              END IF;

              IF falling_edge(clk) THEN
                     instruction_we <= '0';
              END IF;
       END PROCESS;

END ARCHITECTURE;