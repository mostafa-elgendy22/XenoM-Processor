LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IO_Port_testbench IS
END IO_Port_testbench ;

Architecture a_IO_Port_testbench OF IO_Port_testbench is
    COMPONENT IO_Port IS
    PORT (
           Input : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
           Io_read, Io_write ,reset: IN STD_LOGIC;
           Output : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );

    END COMPONENT ;

    SIGNAL test_Input , test_Output : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL  test_Io_read , test_Io_write ,test_reset :STD_LOGIC ;
    BEGIN 
        PROCESS 
            BEGIN 
            -- CASE 0 : reset the data then write it
                test_Input <= x"FFFF" ;
                test_Io_read <= '0' ;
                test_Io_write <= '0' ;
                test_reset <= '1' ;
                WAIT FOR 100 ps;
                test_Io_write <= '1' ;
                WAIT FOR 100 ps;
                Assert (test_Output = x"0000") report "Output is not reset" severity ERROR;

            -- CASE 1 : write data after read from the input port
                test_reset<='0' ;
                test_Io_read<='1' ;
                test_Io_write <= '0' ;

                WAIT FOR 100 ps;
                test_Io_write <= '1' ;
                test_Io_read<='0' ;
                WAIT FOR 100 ps;
                Assert (test_Output = x"FFFF") report "Output is not valid" severity ERROR;

                WAIT ;
        END PROCESS;   
        uut : IO_Port  PORT MAP  ( 
                            Input =>test_Input,
                            Io_read =>test_Io_read ,
                            Io_write =>test_Io_write ,
                            reset => test_reset,
                            Output =>test_Output
                        );
END a_IO_Port_testbench ;


