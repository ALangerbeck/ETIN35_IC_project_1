



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Multiplier_Unit is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            coefficient : in std_logic_vector(6 downto 0);
            enable    : in std_logic;
            clear    : in std_logic;
            result : out std_logic_vector(14 downto 0)
         );

end Multiplier_Unit;

architecture Multiplier_Unit_arch of Multiplier_Unit is

-- SIGNAL DEFINITIONS HERE IF NEEDED

    signal result_reg_next, result_reg : std_logic_vector(14 downto 0);


-- COMPONENT DEFINITION

    component reg is 
        generic( W: integer);
        port (  clk     : in std_logic;
                rst     : in std_logic;
                next_out : in std_logic_vector(W-1 downto 0);
                output  : out std_logic_vector(W-1 downto 0)
             );
    end component; 


begin
   
    result <= result_reg_next;

   --Will probably need some kind of overflow check here or something like that. 

    operation : process(input, coefficient, enable, clear, result_reg)
    begin
        result_reg_next <= (others => '0');
        if(clear = '1') then
            result_reg_next <= (others => '0');
        elsif (enable = '1') then
            result_reg_next <= input * coefficient + result_reg;

        end if;
        
    end process;

    inst_reg : reg 
        generic map ( W => 15)
        port map(  clk     => clk,
                rst     => rst,
                next_out => result_reg_next,
                output  => result_reg
             ); 



end Multiplier_Unit_arch;