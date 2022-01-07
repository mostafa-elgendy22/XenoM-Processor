LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY execute_stage IS
       PORT (
              clk : IN STD_LOGIC;
              rst : IN STD_LOGIC;

              ALU_op1, ALU_op2, ALU_immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              ALU_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

              CCR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              stack_control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

              MWdata,EMdata : IN STD_LOGIC(15 DOWNTO 0);

              DE_instruction_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);

              write_back_enable_in : IN STD_LOGIC ;
              io_read_in : IN STD_LOGIC ;
              io_write_in : IN STD_LOGIC ;
              is_store_instruction : IN STD_LOGIC;
              is_call_or_int_instruction_in : IN STD_LOGIC ;
              memory_write_in : IN STD_LOGIC ;
              memory_read_in : IN STD_LOGIC ;

              Rsrc1_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              Rsrc2_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              Rdst_em_address: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              Rdst_mw_address: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              mw_write_enable: IN STD_LOGIC;
              em_write_enable: IN STD_LOGIC;
              mw_io_read     : IN STD_LOGIC ;
              mw_mem_read    : IN STD_LOGIC ;
              Rdst_address_in : IN STD_LOGIC(2 DOWNTO 0);

              io_read_out : OUT STD_LOGIC ;
              io_write_out: OUT STD_LOGIC ;
              is_call_or_int_instruction_out : OUT STD_LOGIC ;
              memory_write_out : OUT STD_LOGIC ; 
              memory_read_out : OUT STD_LOGIC ;
              stack_control_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
              write_back_enable_out : OUT STD_LOGIC ;
              ALU_op2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) ;
              Rdst_address_out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              EM_instruction_address : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);

              ExecResult : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE execute_stage OF execute_stage IS
       SIGNAL ALU_flags, ALU_flags_en : STD_LOGIC_VECTOR(2 DOWNTO 0);
       Signal SP_old : Std_logic_vector(31 downto 0);
       Signal SP_new : Std_logic_vector(31 downto 0);

       SIGNAL Operand1_Override_Command, Operand2_Override_Command : STD_LOGIC_VECTOR(1 DOWNTO 0);

       SIGNAL ALU_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
       SIGNAL ALU_res : STD_LOGIC_VECTOR(19 DOWNTO 0);
       SIGNAL ALU_Actual_Operand1,ALU_Actual_Operand2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

       EM_instruction_address <= DE_instruction_address;
       Rdst_address_out <= Rdst_address_in ;
       io_read_out <= io_read_in ;
       io_write_out <= io_write_in ;
       is_call_or_int_instruction_out <= is_call_or_int_instruction_in;
       memory_write_out <= memory_write_in ;
       memory_read_out <= memory_read_in ;
       stack_control_out <= stack_control;
       write_back_enable_out <= write_back_enable_in;

       WITH Operand1_Override_Command SELECT ALU_Actual_Operand1 <=
                            MWdata  WHEN "10"
                            EMdata  WHEN "00"
                            ALU_op1 WHEN OTHERS
       
       ALU_Actual_Operand2 <=    ALU_immediate IF  is_store_instruction = '1'
                            ELSE MWdata IF Operand2_Override_Command = "10"
                            ELSE EMdata IF Operand1_Override_Command = "00"
                            ELSE ALU_op2

       A : ENTITY work.ALU PORT MAP(
              op1 => ALU_Actual_Operand1,
              op2 => ALU_Actual_Operand2,
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
                     reset => rst,
                     stackCtl => stack_control,
                     data => SP_old,
                     newdata=> SP_new
              );
       FU : ENTITY work.FU
              PORT MAP(
                     src1Addr => Rsrc1_address    ,
                     src2Addr => Rsrc2_address     ,
			mwDstAddr => Rdst_mw_address   ,
                     emDstAddr => Rdst_em_address    ,
					
			mwWriteEn => mw_write_enable   ,
                     emWriteEn => em_write_enable   ,
			mwMemRead => mw_mem_read   ,
                     mwIORead  => mw_io_read ,
					
			op1Override => Operand1_Override_Command  ,
                     op2Override => Operand2_Override_Command

              );
       ALU_res = "0000" & ALU_result ;
       ExecResult <= SP_old IF   stack_control(2) = '1' AND is_call_or_int_instruction_in = '0'
                     ELSE SP_new stack_control(2) = '1' AND is_call_or_int_instruction_in = '1'
                     ELSE ALU_res
END ARCHITECTURE;