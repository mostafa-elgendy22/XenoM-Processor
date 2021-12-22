LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity decoding_stage is
    port (
      --------------------------- inputs ---------------------------
      clk                         : in std_logic;
      rst                         : in std_logic ;
      write_back_enable_in        : IN STD_LOGIC ;                  
      instruction                 : in std_logic_vector(31 downto 0);
      write_address               : IN STD_LOGIC_VECTOR (2  DOWNTO 0); --3bits input 
      write_data                  : IN STD_LOGIC_VECTOR (15 DOWNTO 0); 
      --------------------------- outputs ---------------------------
      -- TODO: add immediate_data
      ---- Related to the reg file and the operands
      write_back_enable_out       : out std_logic; -- if the instruction need to write back
      
      ---- Related to the flags and ALU
      flags_write_enable          : out std_logic_vector(2 downto 0);
      ALU_operation               : out std_logic_vector(2 downto 0); -- Determine the ALU operation
  
      ---- Related to the IO
      io_read                     : out std_logic;
      io_write                    : out std_logic;
  
      ---- Related to the memory
      memory_write                : out std_logic;
      memory_read                 : out std_logic;
      is_store_instruction        : out std_logic;
      stack_control               : out std_logic_vector(2 downto 0); -- (2) stack enable, (1:0) stack operation
  
      ---- Related to the branches and control signals
      enable_out                  : out std_logic; -- from the the control unit to the buffers in all stages --
      branch_type                 : out std_logic_vector(3 downto 0); -- (3) branch enable, (2:0) branch operation
      is_call_or_int_instruction  : out std_logic;
      is_hlt_instruction          : out std_logic ;
     
      --- reg file output 
      operand1 : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0) ;   
      operand2 : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0) 
  
    );
  end entity;
    

  architecture a_decoding_stage OF decoding_stage is 
    SIGNAL  Rsrc1_data                  : STD_LOGIC_VECTOR (15 DOWNTO 0);   
    SIGNAL  Rsrc2_data                  : STD_LOGIC_VECTOR (15 DOWNTO 0);  
    SIGNAL  Rdst_data                   : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL  immediate_data              : STD_LOGIC_VECTOR (15 DOWNTO 0);

    SIGNAL Rsrc1_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rsrc2_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rdst_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
    
    SIGNAL is_immediate :STD_LOGIC ;
    SIGNAL is_operation_on_Rdst :STD_LOGIC ;

    BEGIN 

    operand1 <= Rdst_data when is_operation_on_Rdst = '1' else Rsrc1_data;
    operand2 <= immediate_data when is_immediate = '1' else Rsrc2_data;


    Control_unit :  ENTITY work.control_unit 
    port MAP  (    
                    instruction   => instruction ,
                    clk           =>      clk,
                     --------------------------- outputs ---------------------------
                    is_immediate  =>  is_immediate, 
                    immediate_data => immediate_data,
  
                    ---- Related to the reg file and the operands
                    write_back_enable=> write_back_enable_out, 
                    Rsrc1_address   =>Rsrc1_address, 
                    Rsrc2_address   =>Rsrc2_address,
                    Rdst_address    =>Rdst_address, 
                    is_operation_on_Rdst =>is_operation_on_Rdst , 
                
                    ---- Related to the flags and ALU
                    flags_write_enable =>   flags_write_enable, 
                    ALU_operation      =>   ALU_operation, 
                
                    ---- Related to the IO
                    io_read            =>   io_read,
                    io_write           =>   io_write, 
                
                    ---- Related to the memory
                    memory_write       =>   memory_write, 
                    memory_read        =>  memory_read, 
                    is_store_instruction =>is_store_instruction, 
                    stack_control        =>stack_control, 
                
                    ---- Related to the branches and control signals
                    enable_out           =>  enable_out, 
                    branch_type          =>   branch_type, 
                    is_call_or_int_instruction=>  is_call_or_int_instruction, 
                    is_hlt_instruction   =>  is_hlt_instruction      
  
    );

    Register_file :  ENTITY work.RegFile 
    PORT MAP      (  clk =>clk,
                      rst=>rst ,
                      Rsrc1_address=>Rsrc1_address  ,
                      Rsrc2_address=>Rsrc2_address,
                      Rdst_address=>Rdst_address,
                      write_back_enable=>write_back_enable_in,
                      write_address=> write_address ,
                      write_data => write_data ,
                      Rsrc1_data=> Rsrc1_data ,  
                      Rsrc2_data => Rsrc2_data ,
                      Rdst_data =>Rdst_data );

  END architecture ;