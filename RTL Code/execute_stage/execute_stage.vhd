library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute_stage is
  port (
    clk : in std_logic;
    rst : in std_logic;

    ALU_op1, ALU_op2 : in std_logic_vector(15 downto 0);
    
    ALU_immediate  : in std_logic_vector(15 downto 0);
    ALU_sel : in std_logic_vector(2 downto 0);

    CCR : out std_logic_vector(2 downto 0);
    stack_control : in std_logic_vector(2 downto 0);

     MWdata, EMdata : in std_logic_vector(15 downto 0);

    DE_instruction_address : in std_logic_vector (19 downto 0);

    write_back_enable_in : in std_logic;
    io_read_in : in std_logic;
    io_write_in : in std_logic;
    is_store_instruction : in std_logic;
    is_call_or_int_instruction_in : in std_logic;
    memory_write_in : in std_logic;
    memory_read_in : in std_logic;

    Rsrc1_address : in std_logic_vector(2 downto 0);
     Rsrc2_address : in std_logic_vector(2 downto 0);
     Rdst_em_address : in std_logic_vector(2 downto 0);
     Rdst_mw_address : in std_logic_vector(2 downto 0);
     mw_write_enable : in std_logic;
     em_write_enable : in std_logic;
     mw_io_read : in std_logic;
     mw_mem_read : in std_logic;
    Rdst_address_in : in std_logic_vector(2 downto 0);

    branchControl: out std_logic_vector(3 DOWNTO 0);

    io_read_out : out std_logic;
    io_write_out : out std_logic;
    is_call_or_int_instruction_out : out std_logic;
    memory_write_out : out std_logic;
    memory_read_out : out std_logic;
    stack_control_out : out std_logic_vector(1 downto 0);
    write_back_enable_out : out std_logic;
    ALU_op1_out : out std_logic_vector(15 downto 0);
    jmp_address : out std_logic_vector(15 downto 0);
    Rdst_address_out : out std_logic_vector(2 downto 0);
    EM_instruction_address : out std_logic_vector (19 downto 0);

    ExecResult : out std_logic_vector(19 downto 0);
    exeception_handler_address :out std_logic_vector(3 downto 0);
    exeception_enable: out std_logic ;
    is_immediate : in std_logic;
    branch_type_in: in std_logic_vector(3 downto 0)
  );
end entity;

architecture execute_stage of execute_stage is
  signal ALU_flags, ALU_flags_en : std_logic_vector(2 downto 0);
  signal SP_old : std_logic_vector(31 downto 0);
  signal SP_new : std_logic_vector(31 downto 0);

  signal myCCR : STD_LOGIC_VECTOR(2 DOWNTO 0);

  signal Operand1_Override_Command, Operand2_Override_Command : std_logic_vector(1 downto 0);

  signal execution_stage_result : std_logic_vector(19 downto 0);
  signal ALU_result : std_logic_vector(15 downto 0);
  signal ALU_res : std_logic_vector(19 downto 0);
  signal ALU_Actual_Operand1, ALU_Actual_Operand2 : std_logic_vector(15 downto 0);
  signal padded_execution_stage_result : std_logic_vector(31 downto 0);
begin
  EM_instruction_address <= DE_instruction_address;
  Rdst_address_out <= Rdst_address_in;
  io_read_out <= io_read_in;
  io_write_out <= io_write_in;
  is_call_or_int_instruction_out <= is_call_or_int_instruction_in;
  memory_write_out <= memory_write_in;
  memory_read_out <= memory_read_in;
  stack_control_out <= stack_control(1 downto 0);
  write_back_enable_out <= write_back_enable_in;
  ALU_op1_out <= ALU_op1 ;

  CCR <= myCCR  ;

    ALU_Actual_Operand1 <= ALU_op1 when is_store_instruction='0' else ALU_immediate ;

    ALU_Actual_Operand2 <= ALU_op2 ;

    

    A : entity work.ALU port map(
      op1 => ALU_Actual_Operand1,
      op2 => ALU_Actual_Operand2,
      funcSel => ALU_sel,
      result => ALU_result,
      flags => ALU_flags,
      flagsEn => ALU_flags_en,
      branch_type =>branch_type_in,
      is_immediate => is_immediate
      );

  F : entity work.flagsRegister
    port map(
      newFlags => ALU_flags,
      writeEnables => ALU_flags_en,
      flags => myCCR,
      clk => clk
    );

  SP : entity work.SP
    port map(
      clk => clk,
      reset => rst,
      stackCtl => stack_control,
      data => SP_old,
      newdata => SP_new
    );
  FU : entity work.ForwardingUnit
     port map(
       src1Addr => Rsrc1_address,
       src2Addr => Rsrc2_address,
       mwDstAddr => Rdst_mw_address,
       emDstAddr => Rdst_em_address,

       mwWriteEn => mw_write_enable,
       emWriteEn => em_write_enable,
       mwMemRead => mw_mem_read,
       mwIORead => mw_io_read,

       op1Override => Operand1_Override_Command,
       op2Override => Operand2_Override_Command

     );
     padded_execution_stage_result <= SP_old;
  EXP : entity work.exeception_detection_unit
    port map(
      SP => padded_execution_stage_result,
      stack_control => stack_control,
      memory_write => memory_write_in,
      memory_read => memory_read_in,
      execution_stage_result => execution_stage_result,
      exeception_handler_address =>exeception_handler_address,
      exeception_enable =>exeception_enable
    );

    BC: entity work.BC 
          port map(
            branchType => branch_type_in ,
            CCR  => myCCR ,
            branchControl => branchControl
          );
    
    ALU_res <= "0000" & ALU_result;
  execution_stage_result <= 
  SP_old(19 downto 0) WHEN (stack_control = "100" or stack_control = "110") ELSE -- General push
  SP_new(19 downto 0) WHEN (stack_control = "101" or stack_control = "111") ELSE -- General pull
  ALU_res;
  jmp_address <= ALU_result;
  ExecResult <= execution_stage_result;
end architecture;