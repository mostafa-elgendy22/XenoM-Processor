LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Decoder IS
    PORT 
    (
        INP : IN    STD_LOGIC_VECTOR (2 DOWNTO 0) ;
        ENB : IN    STD_LOGIC ;
        Q   : OUT   STD_LOGIC_VECTOR (7 DOWNTO 0)   
    );
    END Decoder ;
----------------------------------------------    
----------   3 * 8 DECODER   -----------------   
----------------------------------------------


Architecture  a_decoder OF Decoder IS 
Begin
    Q <=  "00000001" WHEN INP ="000" AND ENB ='1'
    ELSE  "00000010" WHEN INP ="001" AND ENB ='1'
    ELSE  "00000100" WHEN INP ="010" AND ENB ='1'
    ELSE  "00001000" WHEN INP ="011" AND ENB ='1'
    ELSE  "00010000" WHEN INP ="100" AND ENB ='1'
    ELSE  "00100000" WHEN INP ="101" AND ENB ='1'
    ELSE  "01000000" WHEN INP ="110" AND ENB ='1'
    ELSE  "10000000" WHEN INP ="111" AND ENB ='1'
    ELSE  "00000000";
END a_decoder ;    
