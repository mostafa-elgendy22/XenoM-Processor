library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY BC IS 
    PORT(
        branchType : IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;
        CCR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        branchControl : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );

    --Conditional jumps branchType values
    constant JN_instruction   : std_logic_vector(3 DOWNTO 0) := "1001";
    constant JZ_instruction   : std_logic_vector(3 DOWNTO 0) := "1010";
    constant JC_instruction   : std_logic_vector(3 DOWNTO 0) := "1011";

END BC ;


ARCHITECTURE BC OF BC IS 

SIGNAL conditionalJump : BOOLEAN ;
SIGNAL zeroJump : BOOLEAN ;
SIGNAL carryJump : BOOLEAN ;
SIGNAL negJump : BOOLEAN ;
BEGIN 
    zeroJump  <=  branchType = JZ_instruction ;
    carryJump <=  branchType = JC_instruction ;
    negJump   <=  branchType = JN_instruction  ;
    conditionalJump <= zeroJump OR carryJump OR negJump ;

    branchControl(2 DOWNTO 0) <= branchType(2 DOWNTO 0);

    branchControl(3) <= branchType(3) WHEN NOT(conditionalJump) 
                    ELSE '1' WHEN (  (zeroJump  AND (CCR(0)='1'))
                                  OR (carryJump AND (CCR(2)='1'))
                                  OR (negJump   AND (CCR(1)='1'))
                                  OR (branchType(2) = '1'))
                    ELSE '0'   ;
END BC ;