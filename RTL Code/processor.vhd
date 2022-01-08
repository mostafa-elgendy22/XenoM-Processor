-- vsg_off
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY processor IS
       PORT (
              clk : IN STD_LOGIC;
              processor_reset : IN STD_LOGIC;
              instruction_bus : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END ENTITY;

ARCHITECTURE processor OF processor IS

       SIGNAL ground : STD_LOGIC := '0';
       SIGNAL neg_clk : STD_LOGIC;

       -- Fetch stage parameters
       CONSTANT instruction_i0 : INTEGER := 51;
       CONSTANT instruction_i1 : INTEGER := 20;
       CONSTANT FD_instruction_address_i0 : INTEGER := 19;
       CONSTANT FD_instruction_address_i1 : INTEGER := 0;
       --SIGNAL FD_enable : STD_LOGIC;
       SIGNAL FD_data : STD_LOGIC_VECTOR(51 DOWNTO 0);
       SIGNAL FD : STD_LOGIC_VECTOR(51 DOWNTO 0);

       -- Decode stage parameters
       CONSTANT DE_Rdst_adress_i0 : INTEGER := 76;
       CONSTANT DE_Rdst_adress_i1 : INTEGER := 74;
       CONSTANT DE_instruction_address_i0 : INTEGER := 73;
       CONSTANT DE_instruction_address_i1 : INTEGER := 54;
       CONSTANT ALU_operation_i0 : INTEGER := 53;
       CONSTANT ALU_operation_i1 : INTEGER := 51;
       CONSTANT flags_write_enable_i0 : INTEGER := 50;
       CONSTANT flags_write_enable_i1 : INTEGER := 48;
       CONSTANT operand1_i0 : INTEGER := 47;
       CONSTANT operand1_i1 : INTEGER := 32;
       CONSTANT operand2_i0 : INTEGER := 31;
       CONSTANT operand2_i1 : INTEGER := 16;
       -- 1 bit index
       CONSTANT write_back_enable_out_i : INTEGER := 15;
       CONSTANT io_read_i : INTEGER := 14;
       CONSTANT io_write_i : INTEGER := 13;
       CONSTANT is_call_or_int_instruction_i : INTEGER := 12;
       CONSTANT is_hlt_instruction_i : INTEGER := 11;
       CONSTANT is_store_instruction_i : INTEGER := 10;
       CONSTANT memory_write_i : INTEGER := 9;
       CONSTANT memory_read_i : INTEGER := 8;
       ------------------
       CONSTANT stack_control_i0 : INTEGER := 7;
       CONSTANT stack_control_i1 : INTEGER := 5;
       CONSTANT enable_out_i : INTEGER := 4; -- 1 bit
       CONSTANT branch_type_i0 : INTEGER := 3;
       CONSTANT branch_type_i1 : INTEGER := 0;

       SIGNAL DE : STD_LOGIC_VECTOR (76 DOWNTO 0); -- output of the DE reg
       SIGNAL DE_data : STD_LOGIC_VECTOR (76 DOWNTO 0); -- input to the DE reg

       -- Execute stage parameters
       CONSTANT exeception_enable_i :INTEGER := 74;
       CONSTANT exeception_handler_address_i0 :INTEGER := 73;
       CONSTANT exeception_handler_address_i1 :INTEGER := 70;

       CONSTANT EM_Rdst_address_i0 :INTEGER := 69;
       CONSTANT EM_Rdst_address_i1 :INTEGER := 67;

       CONSTANT EM_io_read_out_i :INTEGER := 66 ;
       CONSTANT EM_io_write_out_i :INTEGER := 65 ;

       CONSTANT EM_is_call_or_int_instruction_i :INTEGER := 64;
       CONSTANT EM_memory_write_i :INTEGER :=63 ;
       CONSTANT EM_memory_read_i :INTEGER :=62 ;

       CONSTANT EM_stack_control_i0:INTEGER :=61;
       CONSTANT EM_stack_control_i1:INTEGER :=60;

       CONSTANT EM_write_back_enable_i:INTEGER :=59 ; 

       CONSTANT EM_ALU_op2_i0:INTEGER :=58 ;
       CONSTANT EM_ALU_op2_i1:INTEGER :=43 ;
       
       CONSTANT EM_CCR_i0 :INTEGER := 40 ;
       CONSTANT EM_CCR_i1 :INTEGER := 38 ;

       CONSTANT ALU_result_i0 : INTEGER := 39;
       CONSTANT ALU_result_i1 : INTEGER := 20;

       CONSTANT EM_instruction_address_i0 : INTEGER := 19;
       CONSTANT EM_instruction_address_i1 : INTEGER := 0;

      


       SIGNAL EM_data : STD_LOGIC_VECTOR (74 DOWNTO 0);
       SIGNAL EM : STD_LOGIC_VECTOR (74 DOWNTO 0);
       SIGNAL EM_enable : STD_LOGIC := '1';

       --Write back signals
       SIGNAL WB_enable_in : STD_LOGIC;
       SIGNAL WB_write_address : STD_LOGIC_VECTOR (2 DOWNTO 0);
       SIGNAL WB_write_data : STD_LOGIC_VECTOR (15 DOWNTO 0);

       -- Memory data 
       SIGNAL MW : STD_LOGIC_VECTOR (36 DOWNTO 0);
       SIGNAL MW_data : STD_LOGIC_VECTOR (36 DOWNTO 0);

       -- Memory stage parameters
       CONSTANT data_out_i0 : INTEGER := 36;
       CONSTANT data_out_i1 : INTEGER := 21;

       CONSTANT execution_result_i0 : INTEGER := 20;
       CONSTANT execution_result_i1 : INTEGER := 5;

       CONSTANT int_index_Rdst_address_i0 : INTEGER := 4;
       CONSTANT int_index_Rdst_address_i1 : INTEGER := 2;

       CONSTANT write_back_enable_i : INTEGER := 1;
       CONSTANT io_memory_read_i : INTEGER := 0;

     

BEGIN
       neg_clk <= NOT clk;

       ---------fetch stage ------------ 
       fetch : ENTITY work.fetch_stage
              PORT MAP(
                     clk => clk,
                     processor_reset => processor_reset,
                     is_hlt_instruction => DE(is_hlt_instruction_i),
                     instruction_bus => instruction_bus,
                     branch_type => EM(branch_type_i0 DOWNTO branch_type_i1),
                     int_index => EM(EM_Rdst_address_i0 DOWNTO EM_Rdst_address_i1),
                     exception_enable => EM(exeception_enable_i),
                     exception_handler_index => EM(exeception_handler_address_i0 DOWNTO exeception_handler_address_i1),
                     exception_instruction_address => EM(EM_instruction_address_i0 DOWNTO EM_instruction_address_i1),
                     FD_data => FD_data
              );

       FD_register : ENTITY work.DFF_register
              GENERIC MAP(data_width => 52)
              PORT MAP(
                     clk => neg_clk,
                     enable => '1',
                     reset => ground,
                     D => FD_data,
                     Q => FD
              );

       --------decode stage -------------
       decode : ENTITY work.decoding_stage
              PORT MAP(
                     clk => clk,
                     rst => processor_reset,
                     write_back_enable_in => WB_enable_in,
                     instruction => FD(instruction_i0 DOWNTO instruction_i1),
                     FD_instruction_address => FD(FD_instruction_address_i0 DOWNTO FD_instruction_address_i1),
                     write_address => WB_write_address,
                     write_data => WB_write_data,

                     write_back_enable_out => DE_data(write_back_enable_out_i),
                     io_read => DE_data(io_read_i),
                     io_write => DE_data(io_write_i),
                     is_call_or_int_instruction => DE_data(is_call_or_int_instruction_i),
                     is_hlt_instruction => DE_data(is_hlt_instruction_i),
                     is_store_instruction => DE_data(is_store_instruction_i),

                     memory_write => DE_data(memory_write_i),
                     memory_read => DE_data(memory_read_i),
                     stack_control => DE_data(stack_control_i0 DOWNTO stack_control_i1),
                     enable_out => DE_data(enable_out_i),
                     branch_type => DE_data(branch_type_i0 DOWNTO branch_type_i1),

                     ---- Related to the flags and ALU
                     ALU_operation => DE_data(ALU_operation_i0 DOWNTO ALU_operation_i1),
                     flags_write_enable => DE_data(flags_write_enable_i0 DOWNTO flags_write_enable_i1),
                     operand1 => DE_data(operand1_i0 DOWNTO operand1_i1),
                     operand2 => DE_data(operand2_i0 DOWNTO operand2_i1),

                     DE_instruction_address => DE_data(DE_instruction_address_i0 DOWNTO DE_instruction_address_i1),

                     Rdst_address_out => DE_data (DE_Rdst_adress_i0 DOWNTO DE_Rdst_adress_i1) 

              );

       DE_register : ENTITY work.DFF_register
              GENERIC MAP(data_width => 77)
              PORT MAP(
                     clk => neg_clk,
                     enable => EM_enable, --------TODO
                     reset => ground,
                     D => DE_data,
                     Q => DE
              );

       --------execute stage -------------
       execute : ENTITY work.execute_stage
              PORT MAP(
                     clk => clk,
                     rst => processor_reset,
                     
                     ALU_op1 => DE(operand1_i0 DOWNTO operand1_i1),
                     ALU_op2 => DE(operand2_i0 DOWNTO operand2_i1),
                     ALU_sel => DE(ALU_operation_i0 DOWNTO ALU_operation_i1),

                     CCR => EM_data (EM_CCR_i0 DOWNTO EM_CCR_i1),
                     stack_control => DE(stack_control_i0 DOWNTO stack_control_i1),
                     -- MWdata, EMdata
                     DE_instruction_address => DE(DE_instruction_address_i0 DOWNTO DE_instruction_address_i1),
                     write_back_enable_in=>DE(write_back_enable_out_i), 
                     io_read_in =>  DE(io_read_i),
                     io_write_in => DE(io_write_i),
                     is_call_or_int_instruction_in=>DE(is_call_or_int_instruction_i),
                     memory_write_in=> DE(memory_write_i),
                     memory_read_in =>DE(memory_read_i),
                     -- Rsrc1_address : in std_logic_vector(2 downto 0);
                     -- Rsrc2_address : in std_logic_vector(2 downto 0);
                     -- Rdst_em_address : in std_logic_vector(2 downto 0);
                     -- Rdst_mw_address : in std_logic_vector(2 downto 0);
                     -- mw_write_enable : in std_logic;
                     -- em_write_enable : in std_logic;
                     -- mw_io_read : in std_logic;
                     -- mw_mem_read : in std_logic;
                     Rdst_address_in => DE(DE_Rdst_adress_i0 DOWNTO DE_Rdst_adress_i1),
                     
                     io_read_out=> EM_data (EM_io_read_out_i),-- 1
                     io_write_out=> EM_data (EM_io_write_out_i) ,--1
                     is_call_or_int_instruction_out=>EM_data (EM_is_call_or_int_instruction_i),--DONE 1 
                     memory_write_out=>EM_data(EM_memory_write_i),--1
                     memory_read_out=>EM_data(EM_memory_read_i),--1
                     stack_control_out=>EM_data( EM_stack_control_i0 DOWNTO EM_stack_control_i1) ,--2
                     write_back_enable_out=>EM_data(EM_write_back_enable_i),-- 1
                     ALU_op2_out =>EM_data(EM_ALU_op2_i0 DOWNTO EM_ALU_op2_i1),--DONE 16
                     Rdst_address_out =>EM_data(EM_Rdst_address_i0 DOWNTO EM_Rdst_address_i1), --3 bit
                     EM_instruction_address => EM_data(EM_instruction_address_i0 DOWNTO EM_instruction_address_i1),--DONE 20
                     ExecResult => EM_data(ALU_result_i0 DOWNTO ALU_result_i1),-- 20
                     exeception_handler_address => EM_data(exeception_handler_address_i0 DOWNTO exeception_handler_address_i1),
                     exeception_enable => EM_data(exeception_enable_i)
                     );

       EM_register : ENTITY work.DFF_register
              GENERIC MAP(data_width => 75)
              PORT MAP(
                     clk => neg_clk,
                     enable => EM_enable,
                     reset => ground,
                     D => EM_data,
                     Q => EM
              );

       --------memory stage ---------------
       memory : ENTITY work.memory_stage
              PORT MAP(
                     --- for IN/OUT Port
                     Io_read=> EM (EM_io_read_out_i),
                     Io_write=>EM (EM_io_write_out_i),
                     IO_reset=>'0',
                     -- for memory 
                     mem_clk=>clk,
                     mem_address=>EM (ALU_result_i0 DOWNTO ALU_result_i1),
                     memory_read =>EM(EM_memory_read_i),
                     memory_write =>EM(EM_memory_write_i),
                     --data in
                     operand1=>EM(EM_ALU_op2_i0 DOWNTO EM_ALU_op2_i1),
                     instruction_address => EM(EM_instruction_address_i0 DOWNTO EM_instruction_address_i1),
                     --selection 
                     call_int_instruction=>EM(EM_is_call_or_int_instruction_i),
                     -- signals 
                     write_back_enable =>EM(EM_write_back_enable_i),
                     write_back_enable_out=> MW_data(write_back_enable_i),

                     io_memory_read=>MW_data(io_memory_read_i),
                     execution_stage_result=>MW_data( execution_result_i0 DOWNTO execution_result_i1),

                     int_index_Rdst_address =>EM(EM_Rdst_address_i0 DOWNTO EM_Rdst_address_i1),
                     int_index_Rdst_address_out=>MW_data(int_index_Rdst_address_i0 DOWNTO int_index_Rdst_address_i1),

                     data_out=>MW_data( data_out_i0 DOWNTO data_out_i1)
              );

       MW_register : ENTITY work.DFF_register
              GENERIC MAP(data_width => 37)
              PORT MAP(
                     clk => neg_clk,
                     enable => EM_enable, --TODO
                     reset => ground,
                     D => MW_data,
                     Q => MW
              );

        -- write back stage  
        WB_write_address <= MW (int_index_Rdst_address_i0 DOWNTO int_index_Rdst_address_i1);
        WB_enable_in <= MW (write_back_enable_i);
        WB_write_data <= MW(execution_result_i0 DOWNTO execution_result_i1) WHEN  MW(io_memory_read_i) ='0' ELSE
                              MW ( data_out_i0 DOWNTO data_out_i1) ;



END ARCHITECTURE;