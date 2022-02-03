



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP_matmult is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            ready  : out std_logic
         );

end TOP_matmult;

architecture TOP_matmult_arch of TOP_matmult is

-- SIGNAL DEFINITIONS HERE IF NEEDED




-- COMPONENT DEFINITION



begin
   

end TOP_matmult_arch;
