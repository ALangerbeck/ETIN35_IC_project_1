



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Should the top top wrapper have any input or outputs? Or should they just map our signals to propper pads?

entity TOP_TOP is 
    port(  
        rst_in : in std_logic; --is it really supposed to be inout?
        clk_in : in std_logic;
        input_in : in std_logic_vector(7 downto 0);
        valid_input_in : in std_logic;
        read_ram_in : in std_logic;
        ready_out : out std_logic;
        output_out : out std_logic_vector(5 downto 0)
        );
end TOP_TOP;


architecture TOP_TOP_arch of TOP_TOP is

-- SIGNAL DEFINITIONS
    signal clk_module : std_logic;
    signal rst_module : std_logic;
    signal input_module : std_logic_vector(7 downto 0);
    signal valid_input_module : std_logic;
    signal read_ram_module : std_logic;
    signal ready_module : std_logic;
    signal output_module : std_logic_vector(5 downto 0);


-- COMPONENT DEFINITION

component TOP_matmult is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            read_ram : in std_logic;
            ready  : out std_logic;
            output : out std_logic_vector(5 downto 0)
         );

end component;

component CPAD_S_74x50u_IN is 
    port (
        COREIO : out std_logic;
        PADIO : in std_logic
        );
end component; 

component CPAD_S_74x50u_OUT is 
    port (
        COREIO : in std_logic;
        PADIO : out std_logic
        );
end component; 

begin 

clk_pad : CPAD_S_74x50u_IN 
    port map(
        COREIO => clk_module,
        PADIO => clk_in
        );

rst_pad : CPAD_S_74x50u_IN 
    port map(
        COREIO => rst_module,
        PADIO => rst_in
        );

valid_input_pad : CPAD_S_74x50u_IN 
    port map(
        COREIO => valid_input_module,
        PADIO => valid_input_in
        );

read_ram_pad : CPAD_S_74x50u_IN 
    port map(
        COREIO => read_ram_module,
        PADIO => read_ram_in
        );

InPads : for i in 0 to 7 generate
InPad : CPAD_S_74x50u_IN
  port map( 
        COREIO => input_module(i),
        PADIO => input_in(i)
        );
end generate InPads;

ready_pad : CPAD_S_74x50u_OUT 
    port map(
        COREIO => ready_module,
        PADIO => ready_out
        );

OutPads : for i in 0 to 5 generate
OutPad : CPAD_S_74x50u_OUT
  port map( 
        COREIO => output_module(i),
        PADIO => output_out(i)
        );
end generate OutPads;

TOP : TOP_matmult 

    port map(  clk     => clk_module,
            rst     => rst_module,
            input   => input_module,
            valid_input => valid_input_module,
            read_ram => read_ram_module,
            ready  => ready_module,
            output => output_module
         );



end TOP_TOP_arch;
