LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS

       PORT (
              op1, op2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              funcSel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              branch_type  : IN std_logic_vector(3 downto 0); -- (3) branch enable, (2:0) branch operation

              result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              flagsEn : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              is_immediate : IN STD_LOGIC
       );

       --///////////////////////////////////////////////////////////////////////////////////////////////////////
       --*******************************************************************************************************
       --///////////////////////////////////////////////////////////////////////////////////////////////////////

       CONSTANT ALU_NOP : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "000";

       CONSTANT ALU_SUB : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "001";

       CONSTANT ALU_AND : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "010";

       CONSTANT ALU_INC : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "011";

       CONSTANT ALU_NOT : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "100";

       CONSTANT ALU_ADD : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "101";

       CONSTANT ALU_SETC : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "110";

       CONSTANT ALU_IDEN : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "111";
       --///////////////////////////////////////////////////////////////////////////////////////////////////////
       --*******************************************************************************************************
       --///////////////////////////////////////////////////////////////////////////////////////////////////////			
       CONSTANT UPDATE_ONLY_CARRY_FLAG : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "100";
       CONSTANT UPDATE_ALL_EXCEPT_CARRY_FLAG : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "011";
       CONSTANT UPDATE_ALL_FLAGS : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "111";
       CONSTANT UPDATE_NO_FLAGS : STD_LOGIC_VECTOR(2 DOWNTO 0)
       := "000";
       --///////////////////////////////////////////////////////////////////////////////////////////////////////
       --*******************************************************************************************************
       --/////////////////////////////////////////////////////////////////////////////////////////////////////// 
END ALU;

ARCHITECTURE ALU OF ALU IS

       SIGNAL res : STD_LOGIC_VECTOR(15 DOWNTO 0);

       SIGNAL resultCarryPlus : unsigned(16 DOWNTO 0);
       SIGNAL resultCarryMinus : unsigned(16 DOWNTO 0);
       SIGNAL resultCarryInc : unsigned(16 DOWNTO 0);

       SIGNAL uop1 : unsigned(16 DOWNTO 0);
       SIGNAL uop2 : unsigned(16 DOWNTO 0);
       SIGNAL result_or_immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
       
       uop1 <= resize(unsigned(op1), 17);
       uop2 <= resize(unsigned(op2), 17);

       resultCarryPlus <= uop1 + uop2;
       resultCarryMinus <= uop1 - uop2;
       resultCarryInc <= uop1 + 1;

       WITH funcSel SELECT res <=
              STD_LOGIC_VECTOR(resultCarryPlus(15 DOWNTO 0)) WHEN ALU_ADD,
              STD_LOGIC_VECTOR(resultCarryMinus(15 DOWNTO 0)) WHEN ALU_SUB,
              op1 AND op2 WHEN ALU_AND,
              STD_LOGIC_VECTOR(resultCarryInc(15 DOWNTO 0)) WHEN ALU_INC,
              NOT op1 WHEN ALU_NOT,
              op1 WHEN ALU_IDEN,
              (OTHERS => 'Z') WHEN OTHERS;

       flags(0) <= '1' WHEN unsigned(res) = 0 ELSE
       '0';
       flags(1) <= res(15);

       WITH funcSel SELECT flags(2) <=
              resultCarryPlus(16) WHEN ALU_ADD,
              resultCarryMinus(16) WHEN ALU_SUB,
              resultCarryInc(16) WHEN ALU_INC,
              '1' WHEN ALU_SETC,
              'Z' WHEN OTHERS;

       WITH funcSel SELECT flagsEn <=
              UPDATE_ONLY_CARRY_FLAG WHEN ALU_SETC,

              UPDATE_ALL_EXCEPT_CARRY_FLAG WHEN ALU_AND,
              UPDATE_ALL_EXCEPT_CARRY_FLAG WHEN ALU_NOT,

              UPDATE_ALL_FLAGS WHEN ALU_ADD,
              UPDATE_ALL_FLAGS WHEN ALU_INC,
              UPDATE_ALL_FLAGS WHEN ALU_SUB,
              UPDATE_NO_FLAGS WHEN OTHERS;
       
       result_or_immediate <= op2 WHEN (is_immediate = '1' and (funcSel = ALU_IDEN)) --  LDM
       ELSE
       res;

       result <= result_or_immediate;

END ALU;