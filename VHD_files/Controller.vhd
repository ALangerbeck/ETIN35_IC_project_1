



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Controller is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            load    : out std_logic;
            result_1 : out std_logic_vector(15 downto 0);
            result_2 : out std_logic_vector(15 downto 0);
            result_3 : out std_logic_vector(15 downto 0);
            result_4 : out std_logic_vector(15 downto 0);
            ready  : out std_logic
         );

end Controller;

architecture Controller_arch of Controller is

-- SIGNAL DEFINITIONS HERE IF NEEDED




-- COMPONENT DEFINITION



begin
   


end Controller_arch;