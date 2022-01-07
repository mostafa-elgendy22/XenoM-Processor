LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity decoding_stage is
    port (
      --------------------------- inputs ---------------------------
      clk                         : IN STD_LOGIC;
      rst                         : IN STD_LOGIC;
      write_back_enable_in        : IN STD_LOGIC;                  
      instruction                 : IN STD_LOGIC_VECTOR(31 downto 0);
      FD_instruction_address      : IN STD_LOGIC_VECTOR(19 downto 0);
      write_address               : IN STD_LOGIC_VECTOR (2  DOWNTO 0); --3bits input 
      write_data                  : IN STD_LOGIC_VECTOR (15 DOWNTO 0); 
      --------------------------- outputs ---------------------------
      ---- Related to the registers for the forwarding unit
      Rsrc1_address_out               : out std_logic_vector(2 downto 0);
      Rsrc2_address_out               : out std_logic_vector(2 downto 0);
      Rdst_address_out                : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
      --  Related to the immediate_data
      immediate_data_out    : out STD_LOGIC_VECTOR (15 DOWNTO 0);
      is_immediate_out      : out std_logic;
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
      operand1 : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0);   
      operand2 : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0);

      DE_instruction_address : OUT STD_LOGIC_VECTOR(19 downto 0)

  
    );
  end entity;
    

  architecture a_decoding_stage OF decoding_stage is 
    SIGNAL  Rsrc1_data                  : STD_LOGIC_VECTOR (15 DOWNTO 0);   
    SIGNAL  Rsrc2_data                  : STD_LOGIC_VECTOR (15 DOWNTO 0);  
    SIGNAL  Rdst_data                   : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL  immediate_data_signal              : STD_LOGIC_VECTOR (15 DOWNTO 0);

    SIGNAL Rsrc1_address_signal : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rsrc2_address_signal : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rdst_address_signal : STD_LOGIC_VECTOR (2 DOWNTO 0);
    
    SIGNAL is_immediate_signal :STD_LOGIC ;
    SIGNAL is_operation_on_Rdst :STD_LOGIC ;

    BEGIN 

    DE_instruction_address <= FD_instruction_address;

    Control_unit :  ENTITY work.control_unit 
    port MAP  (    
                    instruction   => instruction ,
                    clk           =>      clk,
                     --------------------------- outputs ---------------------------
                    is_immediate  =>  is_immediate_signal, 
                    immediate_data => immediate_data_signal,
  
                    ---- Related to the reg file and the operands
                    write_back_enable=> write_back_enable_out, 
                    Rsrc1_address   =>Rsrc1_address_signal, 
                    Rsrc2_address   =>Rsrc2_address_signal,
                    Rdst_address    =>Rdst_address_signal, 
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
                      Rsrc1_address=>Rsrc1_address_signal  ,
                      Rsrc2_address=>Rsrc2_address_signal,
                      Rdst_address=>Rdst_address_signal,
                      write_back_enable=>write_back_enable_in,
                      write_address=> write_address ,
                      write_data => write_data ,
                      Rsrc1_data=> Rsrc1_data ,  
                      Rsrc2_data => Rsrc2_data ,
                      Rdst_data =>Rdst_data );

       operand1 <= Rdst_data when is_operation_on_Rdst = '1' else Rsrc1_data;
       operand2 <= immediate_data_signal when is_immediate_signal = '1' else Rsrc2_data;
       Rsrc1_address_out <=Rsrc1_address_signal;
       Rsrc2_address_out <=Rsrc2_address_signal;
       Rdst_address_out<=Rdst_address_signal;
       immediate_data_out <= immediate_data_signal;
       is_immediate_out <= is_immediate_signal;
       

  END architecture ;