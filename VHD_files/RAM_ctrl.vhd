



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAM_ctrl is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            load    : in std_logic;
            result_1 : in std_logic_vector(15 downto 0);
            result_2 : in std_logic_vector(15 downto 0);
            result_3 : in std_logic_vector(15 downto 0);
            result_4 : in std_logic_vector(15 downto 0);
            ready  : in std_logic
         );

end RAM_ctrl;

architecture RAM_ctrl_arch of RAM_ctrl is

-- SIGNAL DEFINITIONS HERE IF NEEDED




-- COMPONENT DEFINITION



begin
   


end RAM_ctrl_arch;