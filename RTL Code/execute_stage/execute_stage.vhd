LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY execute_stage IS
       PORT (
              clk : IN STD_LOGIC;
              ALU_op1, ALU_op2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              ALU_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              ALU_result : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              instruction_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
              EM_data : out STD_LOGIC_VECTOR (35 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE execute_stage OF execute_stage IS
       SIGNAL ALU_flags, ALU_flags_en : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

       EM_data <= ALU_result & instruction_address;

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
END ARCHITECTURE;