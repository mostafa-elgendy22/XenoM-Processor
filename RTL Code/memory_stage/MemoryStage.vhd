LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY memory_stage IS
    PORT (
        --- for IN/OUT Port
        Io_read, Io_write, IO_reset : IN STD_LOGIC; --signal for enable read/write  and reset

        -- for memory 
        mem_clk : IN STD_LOGIC;
        mem_address : IN STD_LOGIC_VECTOR(19 DOWNTO 0); --20bit memory address from execution unit 
        memory_read : IN STD_LOGIC; -- signal read from memory with address
        memory_write : IN STD_LOGIC; --signal write in memory

        -- data 
        operand1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); --16 bit data input for 
        instruction_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
        --selection 
        call_int_instruction : IN STD_LOGIC;

        -- signals 
        write_back_enable :IN STD_LOGIC ;
        write_back_enable_out :OUT STD_LOGIC ;

        io_memory_read: OUT STD_LOGIC ;
        execution_stage_result : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);

        int_index_Rdst_address :IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        int_index_Rdst_address_out :OUT STD_LOGIC_VECTOR (2 DOWNTO 0);

        data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE a_memory_stage OF memory_stage IS
    SIGNAL mem_write : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL IO_Output : STD_LOGIC_VECTOR (15 DOWNTO 0); --16bit IO/data ouput 
    SIGNAL  mem_dataout : STD_LOGIC_VECTOR(15 DOWNTO 0);--16bit mem/data out
    SIGNAL mem_datain :  STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32 data input    
    SIGNAL operand1_exp :  STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32 data input   
    SIGNAL instruction_address_exp :  STD_LOGIC_VECTOR(31 DOWNTO 0); -- 32 data input    
    SIGNAL instruction_address_1 :  STD_LOGIC_VECTOR (19 DOWNTO 0); 


BEGIN
    mem_write <= call_int_instruction & memory_write;
    io_memory_read <= Io_read or memory_read;
    execution_stage_result <= mem_address (15 DOWNTO 0);
    -- expand operand 1
    operand1_exp <=(15 DOWNTO 0 => '0') &operand1;
    -- expand instruction address +1
    instruction_address_1 <= instruction_address+1 ;
    instruction_address_exp <= (11 DOWNTO 0 => '0') & instruction_address_1 ;
    --memory data input
    mem_datain <= operand1_exp WHEN call_int_instruction ='0'
    ELSE instruction_address_exp ;

    IOPort : ENTITY work.IO_Port
        PORT MAP(
            Input  =>operand1,
            Io_read =>Io_read,
            Io_write =>Io_write,
            reset => IO_reset,
            Output => IO_Output
        );
    mem : ENTITY work.data_memory
        PORT MAP(
            clk => mem_clk,
            address => mem_address,
            datain => mem_datain, --TODO mux here 
            memory_read => memory_read,
            memory_write => mem_write,
            dataout => mem_dataout
        );

    data_out <=  IO_Output WHEN Io_read ='1'
    ELSE   mem_dataout WHEN  memory_read ='1'
    ELSE (others=>'Z');


END ARCHITECTURE;