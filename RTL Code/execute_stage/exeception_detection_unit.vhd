library ieee;
use ieee.std_logic_1164.all;
-- When an exception occurs, the address of the instruction causing the exception is saved in the 
-- exception program counter, and the correct exception handler is called. 
-- There are two types of exceptions that can occur: 
--1-- Empty stack exception occurs when a pop is called while the stack is empty. 
-- -- The exception handler address for this exception is stored in M[2] and M[3]. 
--2-- Invalid memory address occurs when the address exceeds the range of 0xFF00. 
-- -- The exception handler address for this exception is stored in M[4] and M[5] in
-- -- either data memory or instruction memory per your design.

entity exeception_detection_unit is
  port (
    SP : in std_logic_vector(31 downto 0); -- the stack pointer
    stack_control : in std_logic_vector(2 downto 0); -- (2) stack enable, (1:0) stack operation
    memory_write : in std_logic;
    memory_read : in std_logic;
    execution_stage_result : in std_logic_vector(19 downto 0); -- Memory adress or a vlaue to be written back in a register
    exeception_handler_address : out std_logic_vector(3 downto 0); -- the address of the handler called in the fetach stage
    exeception_enable : out std_logic -- whether there is an exception or not

  );
end entity;
architecture execeptionDetectionUnit of exeception_detection_unit is

  constant EMPTY_STACK_VALUE : std_logic_vector := X"000FFFFF";
  constant MAX_MEMORY_RANGE : std_logic_vector := X"FF00"; 
  -- stack control values
  constant POP_1_operation : std_logic_vector := "101";
  constant POP_2_operation : std_logic_vector := "111";
  -- exception handler address
  constant EMPTY_STACK_EXCEPTION_HANDLER : std_logic_vector := "0010";
  constant INVALID_MEMORY_ADRESS_EXCEPTION_HANDLER : std_logic_vector := "0100";

begin
  exeception_enable <=
    -- Empty stack exception
    '1' when memory_write = '1' and stack_control = POP_1_operation and SP <= EMPTY_STACK_VALUE else
    '1' when memory_write = '1' and stack_control = POP_2_operation and SP <= EMPTY_STACK_VALUE else
    -- Invalid memory address exception
    '1' when memory_write = '1' and stack_control(2) = '0' and execution_stage_result > MAX_MEMORY_RANGE else
    '1' when memory_read = '1' and stack_control(2) = '0' and execution_stage_result > MAX_MEMORY_RANGE else
    -- no exception
    '0';

  exeception_handler_address <=
    -- Empty stack exception
    EMPTY_STACK_EXCEPTION_HANDLER when memory_write = '1' and stack_control = POP_1_operation and SP <= EMPTY_STACK_VALUE else
    EMPTY_STACK_EXCEPTION_HANDLER when memory_write = '1' and stack_control = POP_2_operation and SP <= EMPTY_STACK_VALUE else
    -- Invalid memory address exception
    INVALID_MEMORY_ADRESS_EXCEPTION_HANDLER when memory_write = '1' and stack_control(2) = '0' and execution_stage_result > MAX_MEMORY_RANGE else
    INVALID_MEMORY_ADRESS_EXCEPTION_HANDLER when memory_read = '1' and stack_control(2) = '0' and execution_stage_result > MAX_MEMORY_RANGE else
    -- no exception
    (others => '0');
end architecture;