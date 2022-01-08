library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
  port (
    --------------------------- inputs ---------------------------
    instruction                 : in std_logic_vector(31 downto 0);
    clk                         : in std_logic;

    --------------------------- outputs ---------------------------

    ---- Related to the immediate data
    is_immediate                : out std_logic; -- if we need to us ethe immediate value 
    immediate_data              : out std_logic_vector(15 downto 0);

    ---- Related to the reg file and the operands
    write_back_enable           : out std_logic; -- if the instruction need to write back
    Rsrc1_address               : out std_logic_vector(2 downto 0);
    Rsrc2_address               : out std_logic_vector(2 downto 0);
    Rdst_address                : out std_logic_vector(2 downto 0);
    is_operation_on_Rdst        : out std_logic; -- if the operation will be made on the Rdst like the NOT and INC

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
    is_hlt_instruction          : out std_logic

  );
end control_unit;

architecture controlUnit of control_unit is
  -- ALU Operations
  constant NO_ALU_operation : std_logic_vector := "000";
  constant SUB_operation    : std_logic_vector := "001";
  constant AND_operation    : std_logic_vector := "010";
  constant INC_operation    : std_logic_vector := "011";
  constant NOT_operation    : std_logic_vector := "100";
  constant ADD_operation    : std_logic_vector := "101";
  constant SETC_operation   : std_logic_vector := "110";
  constant MOV_operation    : std_logic_vector := "111";

  -- Branch Operations -- (3) branch enable, (2:0) branch operation
  constant JMP_instruction  : std_logic_vector := "1000";
  constant JN_instruction   : std_logic_vector := "1001";
  constant JZ_instruction   : std_logic_vector := "1010";
  constant JC_instruction   : std_logic_vector := "1011";
  constant CALL_instruction : std_logic_vector := "1100";
  constant INT_instruction  : std_logic_vector := "1101";
  constant RET_instruction  : std_logic_vector := "1110";
  constant RTI_instruction  : std_logic_vector := "1111";

  -- Stack Control -- (2) stack enable, (1:0) stack operation
  constant PUSH_1_operation : std_logic_vector := "100";
  constant POP_1_operation  : std_logic_vector := "101";
  constant PUSH_2_operation : std_logic_vector := "110";
  constant POP_2_operation  : std_logic_vector := "111";

begin
  process(clk) is -- A or B -> if A else B ____ A/B -> A and B logic is here
  begin
    if rising_edge(clk) then  -- reset to zero at the start of every cycle
     ---- Related to the immediate data
     is_immediate                 <= '0'; -- reset to zero at the start of every cycle
     immediate_data               <= (others => '0'); -- reset to zero at the start of every cycle
 
     ---- Related to the reg file and the operands
     write_back_enable            <= '0'; -- reset to zero at the start of every cycle 
     is_operation_on_Rdst         <= '0'; -- reset to zero at the start of every cycle
     Rsrc1_address                <= (others => '0'); -- reset to zero at the start of every cycle
     Rsrc2_address                <= (others => '0'); -- reset to zero at the start of every cycle 
     Rdst_address                 <= (others => '0'); -- reset to zero at the start of every cycle 
 
     ---- Related to the flags and ALU
     flags_write_enable           <= (others => '0'); -- reset to zero at the start of every cycle 
     ALU_operation                <= NO_ALU_operation; -- reset to zero at the start of every cycle
 
     ---- Related to the IO
     io_read                      <= '0'; -- reset to zero at the start of every cycle 
     io_write                     <= '0'; -- reset to zero at the start of every cycle
 
     ---- Related to the memory
     memory_write                 <= '0'; -- reset to zero at the start of every cycle 
     memory_read                  <= '0'; -- reset to zero at the start of every cycle 
     is_store_instruction         <= '0'; -- reset to zero at the start of every cycle 
     stack_control                <= (others => '0'); -- reset to zero at the start of every cycle
 
     ---- Related to the branches and control signals
     enable_out                   <= '0'; -- reset to zero at the start of every cycle 
     is_call_or_int_instruction   <= '0'; -- reset to zero at the start of every cycle 
     is_hlt_instruction           <= '0'; -- reset to zero at the start of every cycle 
     branch_type                  <= (others => '0'); -- reset to zero at the start of every cycle


    -- elsif falling_edge(clk) then
      --***************************************************************************
      --------------------------- Type 0 Instructions ---------------------------
      --***************************************************************************
     
      if instruction(31 downto 30) = "00" then -- Type 0
        is_hlt_instruction <= instruction(28);
        --start------------------------- SETC/NOP or RIT/RTI 
        if instruction(27) = '0' then -- NOP or SETC 
          if instruction(26) = '0' then -- NOP 
            enable_out <= '0'; -- disable all the units
            ALU_operation <= NO_ALU_operation;
          else -- SETC
            -- TODO: control flags 
            ALU_operation <= SETC_operation;
          end if; -- NOP or SETC 
          --end------------------------- NOP or SETC 
          --***************************************************************************
          --start------------------------- RIT or RTI 
        else -- RIT or RTI 
          if instruction(26) = '0' then -- RTI 
            stack_control <= POP_2_operation;
            branch_type <= RTI_instruction;
            -- TODO: flags are restored
          else -- RET
            branch_type <= RET_instruction;
            stack_control <= POP_2_operation;
          end if; -- RIT or RTI 
          --end------------------------- RIT or RTI 
        end if; -- SETC/NOP or RIT/RTI 
        --end------------------------- SETC/NOP or RTI/RIT
        --***************************************************************************
        --------------------------- Type 1 Instructions ---------------------------
        --***************************************************************************

      elsif instruction(31 downto 30) = "01" then -- Type 1
        Rdst_address <= instruction(25 downto 23);
        --start-------------------------  Non-Jump or Jump Instructions
        --***************************************************************************
        --***************************************************************************
        --start-------------------------  Non-Jump Instructions
        if instruction(29) = '0' then -- Non-Jump Instructions
          --start------------------------- IO
          if instruction(28) = '1' then --  IO 
            io_read <= "not" (instruction(26));
            io_write <= instruction(26);
            --end-------------------------  IO
            --***************************************************************************
            --start------------------------- NOT/INC + PUSH/ POP
          else -- NOT/INC + PUSH/ POP
            --start------------------------- NOT or INC
            if instruction(27) = '0' then -- NOT/INC
              is_operation_on_Rdst <= '1';
              write_back_enable <= '1'; --  will write back in the Rdst
              if instruction(26) = '0' then -- NOT
                ALU_operation <= NOT_operation;
              else -- INC 
                ALU_operation <= INC_operation;
              end if; -- NOT/INC
              --end-------------------------  NOT or INC
              --***************************************************************************
              --start------------------------- PUSH or POP
            else -- PUSH/ POP
              if instruction(26) = '0' then -- PUSH
                stack_control <= PUSH_1_operation;
              else -- POP
                stack_control <= POP_1_operation;
              end if; -- PUSH/ POP
              --end------------------------- PUSH or POP
            end if; -- IO or NOT/INC + PUSH/ POP
          end if; -- Non-Jump Instructions
          --end------------------------- NOT/INC + PUSH/ POP
          --***************************************************************************
          --end-------------------------  Non-Jump Instructions
          --***************************************************************************
          --***************************************************************************
          --start------------------------- Jump Instructions
        else -- Jump Instructions
          --start------------------------- Jump Only or CALL/INT
          if instruction(28) = '0' then -- Jump Only or CALL/INT
            --start------------------------- Jump Only
            if instruction(27) = '0' then -- JMP or JN
                if instruction(26) = '0' then -- JMP
                branch_type <= JMP_instruction;
                else -- JN
                branch_type <= JN_instruction;
                end if; 
            else -- JZ or JC
              if instruction(26) = '0' then -- JZ
              branch_type <= JZ_instruction;
              else -- JC
              branch_type <= JC_instruction;
              end if;
            end if;
            --end------------------------- Jump Only
            --***************************************************************************
            --start------------------------- CALL or INT
          else -- CALL/INT
            is_call_or_int_instruction <= '1';
            if instruction(26) = '0' then -- CALL
              stack_control <= PUSH_1_operation;
              branch_type <= CALL_instruction;
            else -- INT
              stack_control <= PUSH_1_operation;
              branch_type <= INT_instruction;
              -- TODO: flags are reserved
            end if; -- CALL/INT
            --end------------------------- CALL or INT
          end if; -- Jump Only or CALL/INT
          --end------------------------- Jump Only or CALL/INT
        end if; -- Non-Jump or Jump
        --end------------------------- Non-Jump or Jump Instructions
        --***************************************************************************
        --------------------------- Type 2 Instructions ---------------------------
        --***************************************************************************

      elsif instruction(31 downto 30) = "10" then -- Type 2
        Rdst_address <= instruction(25 downto 23);
        if instruction(26) = '0' then -- MOV
          Rsrc1_address <= instruction(22 downto 20);
          ALU_operation <= MOV_operation;
        else -- LDM
          is_immediate <= '1';
          immediate_data <= instruction(22 downto 7);
          memory_read <= '1';
        end if; -- Type 2
        --***************************************************************************
        --------------------------- Type 3.1 Instructions ---------------------------
        --***************************************************************************

      else -- if instruction(31 downto 30) = "11" then  Type 3
        Rdst_address <= instruction(25 downto 23);
        Rsrc1_address <= instruction(22 downto 20);
        --------------------------- Type 3.1 Instructions
        --start------------------------- ALU only or STD/LDD
        if instruction(29) = '0' then -- ALU only
          write_back_enable <= '1'; -- all ALU instructions will write back in the Rdst
          Rsrc2_address <= instruction(19 downto 17); -- would mean nothing in case of immeduate value, like in IADD
          --start------------------------- AND or SUB
          if instruction(27 downto 26) = "00" then -- AND
            ALU_operation <= AND_operation;
          elsif instruction(27 downto 26) = "01" then -- SUB
            ALU_operation <= SUB_operation;
          end if; -- AND or SUB
          --end------------------------- AND or SUB
          --***************************************************************************
          --start------------------------- ADD or IADD
          if instruction(27) = '1' then -- ADD/IADD
            ALU_operation <= ADD_operation;
            if instruction(28) = '1' then -- IADD
              is_immediate <= instruction(28);
              immediate_data <= instruction(19 downto 4);
            end if; -- IADD
          end if; -- ADD or IADD
          --end------------------------- ADD or IADD
          --end------------------------- ALU only
          --***************************************************************************
          --------------------------- Type 3.2 Instructions
          --***************************************************************************
        
          else -- LDD or STD
          is_immediate <= instruction(28);
          immediate_data <= instruction(19 downto 4);
          --start------------------------- LDD or STD
          if instruction(26) = '0' then -- LDD
            write_back_enable <= '1';
            memory_read <= '1';
          elsif instruction(26) = '1' then -- STD
            is_store_instruction <= '1';
            memory_write <= '1';
          end if; -- STD or LDD
          --end------------------------- LDD or STD
        end if; -- ALU only or STD/LDD
        --end------------------------- ALU only or STD/LDD
      end if; -- Type 3
    end if; -- if falling/rising
  end process;
end architecture;