



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Should the top top wrapper have any input or outputs? Or should they just map our signals to propper pads?

entity TOP_TOP is 

--how to write a port empty entity?

end TOP_TOP;


architecture TOP_TOP_arch of TOP_TOP is

-- SIGNAL DEFINITIONS
    signal clk_module : std_logic;
    signal rst_module : std_logic;
    signal input_module : std_logic_vector(7 downto 0);
    signal valid_input_module : std_logic;
    signal ready_module : std_logic;
    signal output_module : std_logic_vector(8 downto 0);


-- COMPONENT DEFINITION

component TOP_matmult is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            ready  : out std_logic;
            output : out std_logic_vector(8 downto 0)
         );

end component;

begin 

TOP : TOP_matmult 

    port map(  clk     => clk_module,
            rst     => rst,
            input   => input_module,
            valid_input => valid_input_module,
            ready  => ready_module,
            output => output_module
         );



end TOP_TOP_arch;
