LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY execute_stage IS
       PORT (
              clk : IN STD_LOGIC;
              ALU_op1, ALU_op2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              ALU_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              ALU_result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              stack_control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              DE_instruction_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
              EM_instruction_address : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE execute_stage OF execute_stage IS
       SIGNAL ALU_flags, ALU_flags_en : STD_LOGIC_VECTOR(2 DOWNTO 0);
       Signal SP_data : Std_logic_vector(31 downto 0);
BEGIN

       EM_instruction_address <= DE_instruction_address;

       A : ENTITY work.ALU PORT MAP(
              op1 => ALU_op1,
              op2 => ALU_op2,
              funcSel => ALU_sel,
              result => ALU_result,
              flags => ALU_flags,
              flagsEn => ALU_flags_en
              );

       F : ENTITY work.flagsRegister
              PORT MAP(
                     newFlags => ALU_flags,
                     writeEnables => ALU_flags_en,
                     flags => CCR,
                     clk => clk
              );

       SP : ENTITY work.SP
              PORT MAP(
                     clk => clk,
                     reset => '0',
                     stackCtl => stack_control,
                     data => SP_data
              );
END ARCHITECTURE;