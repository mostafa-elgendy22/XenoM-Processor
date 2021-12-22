LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS 
	
	PORT(
			op1,op2 : IN std_logic_vector(15 DOWNTO 0);
			funcSel : IN std_logic_vector(2  DOWNTO 0);
			
			result : OUT std_logic_vector(15 DOWNTO 0);
			flags  : OUT std_logic_vector(2  DOWNTO 0);
			flagsEn: OUT std_logic_vector(2  DOWNTO 0)
	);
	
	--///////////////////////////////////////////////////////////////////////////////////////////////////////
	--*******************************************************************************************************
	--///////////////////////////////////////////////////////////////////////////////////////////////////////
	CONSTANT ALU_ADD : std_logic_vector(2 DOWNTO 0) 
			:= "000" ;
			
	CONSTANT ALU_SUB : std_logic_vector(2 DOWNTO 0) 
	      := "001" ;
			
	CONSTANT ALU_AND : std_logic_vector(2 DOWNTO 0) 
	      := "010" ;
			
	CONSTANT ALU_INC : std_logic_vector(2 DOWNTO 0) 
	      := "011" ;
			
	CONSTANT ALU_NOT : std_logic_vector(2 DOWNTO 0) 
	      := "100" ;
			
	CONSTANT ALU_NOP : std_logic_vector(2 DOWNTO 0) 
	      := "101" ;
			
	CONSTANT ALU_SETC: std_logic_vector(2 DOWNTO 0) 
	      := "110" ;
			
	CONSTANT ALU_IDEN: std_logic_vector(2 DOWNTO 0)
			:= "111" ;
	--///////////////////////////////////////////////////////////////////////////////////////////////////////
	--*******************************************************************************************************
	--///////////////////////////////////////////////////////////////////////////////////////////////////////			
	CONSTANT UPDATE_ONLY_CARRY_FLAG 		  : std_logic_vector(2 DOWNTO 0)
			:= "100" ;
	CONSTANT UPDATE_ALL_EXCEPT_CARRY_FLAG : std_logic_vector(2 DOWNTO 0) 
		   := "011" ;
	CONSTANT UPDATE_ALL_FLAGS 				  : std_logic_vector(2 DOWNTO 0)
			:= "111" ;
	CONSTANT UPDATE_NO_FLAGS				  : std_logic_vector(2 DOWNTO 0)
			:=	"000"	;
	--///////////////////////////////////////////////////////////////////////////////////////////////////////
	--*******************************************************************************************************
	--/////////////////////////////////////////////////////////////////////////////////////////////////////// 
END ALU ;

ARCHITECTURE ALU OF ALU IS 

signal res : std_logic_vector(15 DOWNTO 0);

signal resultCarryPlus : unsigned(16 DOWNTO 0);
signal resultCarryMinus: unsigned(16 DOWNTO 0);
signal resultCarryInc  : unsigned(16 DOWNTO 0);

signal uop1 : unsigned(16 DOWNTO 0);
signal uop2 : unsigned(16 DOWNTO 0);
BEGIN

	uop1 <= resize(unsigned(op1),17) ;
	uop2 <= resize(unsigned(op2),17) ;
	
	resultCarryPlus <= uop1 + uop2 ;
	resultCarryMinus<= uop1 - uop2 ;
	resultCarryInc  <= uop1 + 1 ;
	
	WITH funcSel SELECT res <=
			std_logic_vector(resultCarryPlus(15 DOWNTO 0))  WHEN ALU_ADD ,
			std_logic_vector(resultCarryMinus(15 DOWNTO 0)) WHEN ALU_SUB ,
			op1 AND op2 										      WHEN ALU_AND ,
			std_logic_vector(resultCarryInc(15 DOWNTO 0))   WHEN ALU_INC , 
			NOT op1 												      WHEN ALU_NOT ,
			op1 															WHEN ALU_IDEN,
			(others => 'Z')									      WHEN OTHERS ;

	flags(0) <= '1' WHEN unsigned(res) = 0 else '0' ;
	flags(1) <= res(15) ;
	
	WITH funcSel SELECT flags(2) <=
				resultCarryPlus(16)  WHEN ALU_ADD ,
				resultCarryMinus(16) WHEN ALU_SUB ,
				resultCarryInc(16)	WHEN ALU_INC ,
				'1'					   WHEN ALU_SETC,
				'Z'						WHEN OTHERS ;
				
	WITH funcSel SELECT flagsEn <= 
				UPDATE_ONLY_CARRY_FLAG 			WHEN ALU_SETC,
				
				UPDATE_ALL_EXCEPT_CARRY_FLAG  WHEN ALU_AND ,
				UPDATE_ALL_EXCEPT_CARRY_FLAG  WHEN ALU_NOT ,
				
				UPDATE_ALL_FLAGS					WHEN ALU_ADD ,
				UPDATE_ALL_FLAGS					WHEN ALU_INC ,
				UPDATE_ALL_FLAGS					WHEN ALU_SUB ,
				
				
				UPDATE_NO_FLAGS					WHEN OTHERS  ;
				
				
	result <= res ;

END ALU ;