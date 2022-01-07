LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--if ( Rsrc1 = EM.destination 
--  && EM.Enable) then 
-- 
--			override RSRC1 with EM result
--
--else if (Rsrc1 = MW.destination) &&(   MW Enable
--		  									  	  || MW.mem_read 
--		  										  || MW.io_read ) then 
--
--			override RSRC1 with MW result
--
--else
--			keep RSRC1 as is
--
--//same story for Rsrc2 	
ENTITY ForwardingUnit IS 

			PORT(
					src1Addr, src2Addr   : IN std_logic_vector(2 DOWNTO 0);
					mwDstAddr, emDstAddr : IN std_logic_vector(2 DOWNTO 0);
					
					mwWriteEn,emWriteEn : IN std_logic ;  
					
					mwMemRead, mwIORead : IN std_logic ;
					
					op1Override, op2Override : OUT std_logic_vector(1 DOWNTO 0)
			
			);
			
			CONSTANT ALU_OVERRIDE_OPERAND_WITH_EM_RESULT : std_logic_vector(1 DOWNTO 0) 
	      := "00" ;
			
			CONSTANT ALU_OVERRIDE_OPERAND_WITH_MW_RESULT : std_logic_vector(1 DOWNTO 0) 
	      := "10" ;
			
			CONSTANT ALU_NO_OVERRIDE_OPERAND : std_logic_vector(1 DOWNTO 0) 
	      := "01" ;
			
			--Doesn't mean anything
			CONSTANT ALU_OVERRIDE_OPERAND_INVALID : std_logic_vector(1 DOWNTO 0) 
	      := "11" ;
			
END ForwardingUnit ;

ARCHITECTURE ForwardingUnit OF ForwardingUnit IS
BEGIN
			Forwarding: PROCESS IS BEGIN
								IF((src1Addr = emDstAddr) AND emWriteEn='1') THEN
										op1Override <= ALU_OVERRIDE_OPERAND_WITH_EM_RESULT ;
										
								ELSIF((src1Addr = mwDstAddr) AND 
										 (	  mwWriteEn='1'
										  OR mwMemRead='1'
										  OR mwIORead ='1'        )) THEN
										op1Override <= ALU_OVERRIDE_OPERAND_WITH_MW_RESULT ;
								ELSE
										op1Override <= ALU_NO_OVERRIDE_OPERAND ;
								END IF;
								-----------------------------------------------------------		
								IF((src2Addr = emDstAddr) AND emWriteEn='1') THEN
										op2Override <= ALU_OVERRIDE_OPERAND_WITH_EM_RESULT ;
										
								ELSIF((src2Addr = mwDstAddr) AND 
										 (	  mwWriteEn='1'
										  OR mwMemRead='1'
										  OR mwIORead ='1'    ))THEN
										op2Override <= ALU_OVERRIDE_OPERAND_WITH_MW_RESULT ;
								ELSE
										op2Override <= ALU_NO_OVERRIDE_OPERAND ;
								END IF;
			END PROCESS ;
END ForwardingUnit;