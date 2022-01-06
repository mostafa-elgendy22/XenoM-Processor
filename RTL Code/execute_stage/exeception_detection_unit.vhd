LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY exeception_detection_unit IS
       PORT (
            --   Input : IN STD_LOGIC_VECTOR (15 DOWNTO 0); --16 bit data input
            --   Io_read, Io_write ,reset: IN STD_LOGIC;    --signal for enable read/write  and reset
            --   Output : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) --16bit data ouput 
       );
END ENTITY;

ARCHITECTURE execeptionDetectionUnit OF exeception_detection_unit IS
-- 16 bit data signal 
-- Signal Data : STD_LOGIC_VECTOR (15 DOWNTO 0) ;

BEGIN
    --    --port data 
    --    Data <= (OTHERS => '0') WHEN reset ='1' 
    --           ELSE Input WHEN Io_read ='1' ;
    --    --port output data 
    --    Output <= Data WHEN Io_write ='1'
    --    ELSE (OTHERS => 'Z');
           
       
END ARCHITECTURE;