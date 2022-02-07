library ieee;
use ieee.std_logic_1164.all;

entity shift_reg_tb is
end entity;


architecture structural of  shift_reg_tb is


--Signal Declaration
signal clk  : std_logic := '0';
signal rst  : std_logic := '1';
signal shift_enable : std_logic := '0';
signal input : std_logic_vector(7 downto 0);
signal output  : std_logic_vector(7 downto 0);
constant period : time := 100 ns;
--signal message : string(1 to 16) := "           RESET";

--component

component shift_reg is 
    generic( data_size: integer);
    port (  clk     : in std_logic;
            rst     : in std_logic;
            shift_enable : std_logic;
            input : in std_logic_vector(data_size-1 downto 0);
            output  : out std_logic_vector(data_size-1 downto 0)
         );
end component; 

begin

    clk <= not(clk) after period;
    rst <= '1','0' after 2* period, '1' after 30 * period;

    DUT: shift_reg
    generic map (
        data_size => 8
        )
    port map(
        clk   => clk,
        rst   => rst,
        shift_enable => shift_enable,
        input => input,
        output  => output
        );

    -- Test data

    input <= "00000101",                    -- A = 5
        "00001001" after 1 * period*2,   -- A = 9
        "00010001" after 2 * period*2,   -- A = 17
        "10010001" after 3 * period*2,   -- A = 145 or -111
        "10010100" after 4 * period*2,   -- A = 148
        "00000011" after 5 * period*2,   -- A = 3
        "00100011" after 6 * period*2,   -- A = 35
        "11110010" after 7 * period*2,   -- A = 242
        "00110001" after 8 * period*2,   -- A = 49
        "11110010" after 9 * period*2,   -- A = 242 or -14
        "11110010" after 10 * period*2,
        "00100011" after 11 * period*2,   -- A = 35
        "11110010" after 12 * period*2,   -- A = 242
        "00110001" after 13 * period*2,   -- A = 49
        "11110010" after 14 * period*2,   -- A = 242 or -14
        "11110010" after 15 * period*2,
        "00000000" after 30 * period*2;

    shift_enable <= '0',
        '1' after 2 * period*2,
        '0' after 30 * period*2;

end structural;