LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY RegFile IS 
    PORT (
       clk              : IN     STD_LOGIC ;
       rst              : IN     STD_LOGIC ;

       Rsrc1_address    : IN     STD_LOGIC_VECTOR (2  DOWNTO 0) ; -- 3bit
       Rsrc2_address    : IN     STD_LOGIC_VECTOR (2  DOWNTO 0) ; -- 3bit
       Rdst_address     : IN     STD_LOGIC_VECTOR (2  DOWNTO 0) ; -- 3bit

       write_back_enable: IN     STD_LOGIC ;                  
       write_address    : IN     STD_LOGIC_VECTOR (2  DOWNTO 0); --3bits input 

       write_data       : IN     STD_LOGIC_VECTOR (15 DOWNTO 0) ;

       Rsrc1_data       : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0) ;   
       Rsrc2_data       : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0) ;  
       Rdst_data        : OUT    STD_LOGIC_VECTOR (15 DOWNTO 0)   
    
      


    );

END RegFile;

ARCHITECTURE a_RegFile OF RegFile IS

COMPONENT Latch IS
GENERIC (data_width : INTEGER := 16);
PORT (
       D : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
       clk, enable, reset : IN STD_LOGIC;
       Q : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)
);
END COMPONENT ;

COMPONENT Decoder IS
PORT 
(
    INP : IN    STD_LOGIC_VECTOR (2 DOWNTO 0) ;
    ENB : IN    STD_LOGIC ;
    Q   : OUT   STD_LOGIC_VECTOR (7 DOWNTO 0)   
);
END COMPONENT ;

COMPONENT tri_state_buffer IS
GENERIC (data_width : INTEGER := 16);
PORT (
       X : IN STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
       C : IN STD_LOGIC;
       Y : OUT STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0)
);
END COMPONENT ;
-- address control signals 
SIGNAL enb_Rsrc1_address : STD_LOGIC_VECTOR (7 DOWNTO 0); 
SIGNAL enb_Rsrc2_address : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL enb_Rdst_address : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL enb_read_address : STD_LOGIC_VECTOR (7 DOWNTO 0); 
SIGNAL enb_write_address: STD_LOGIC_VECTOR (7 DOWNTO 0);


-- regester out
type reg_output is array (0 to 7) of STD_LOGIC_VECTOR (15 DOWNTO 0) ;
SIGNAL r_FF_OUT : reg_output ;
SIGNAL enable_read_decode : STD_LOGIC ;

SIGNAL not_clk : STD_LOGIC ;
BEGIN
enable_read_decode <= '1' ;
not_clk <= not clk ;
--Source decoders for reading from registers
src1 :  Decoder PORT MAP (Rsrc1_address ,enable_read_decode  , enb_Rsrc1_address);
src2 :  Decoder PORT MAP (Rsrc2_address ,enable_read_decode  , enb_Rsrc2_address);
dst  :  Decoder PORT MAP (Rdst_address , enable_read_decode  , enb_Rdst_address);

--destination decoders for writing data in reg
destination     :  Decoder  PORT MAP (write_address , write_back_enable , enb_write_address);

-- 8  16-bit Registers with tri state buffer
loop1:  FOR i in 0 to 7 GENERATE 

rx              :  Latch     GENERIC MAP (16)  PORT MAP ( write_data ,  clk, enb_write_address(i), rst ,r_FF_OUT(i));

tx1             :  tri_state_buffer GENERIC MAP (16) PORT MAP (r_FF_OUT(i) , enb_Rsrc1_address(i) , Rsrc1_data);
tx2             :  tri_state_buffer GENERIC MAP (16) PORT MAP (r_FF_OUT(i) , enb_Rsrc2_address(i) , Rsrc2_data);
tx3             :  tri_state_buffer GENERIC MAP (16) PORT MAP (r_FF_OUT(i) , enb_Rdst_address(i)  , Rdst_data);


END GENERATE ;
            



END a_RegFile ;