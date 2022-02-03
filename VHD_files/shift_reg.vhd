library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shift_reg_8 is 
    generic( data_size: integer);
    port (  clk     : in std_logic;
            rst     : in std_logic;
            shift_enable : std_logic;
            input : in std_logic_vector(W-1 downto 0);
            output  : out std_logic_vector(W-1 downto 0)
         );
end shift_reg_8; 

architecture behavioral of reg is

-- Signal Declaration

signal data0,data1,data2,data3,data4,data5,data6 : std_logic_vector(w-1 downto 0);

-- Entitiy Structure

begin

    reg : process  ( clk, rst ) 
    begin 
        if rising_edge(clk) then 
            if rst = '1' then
                data0 <= (others => '0');
                data1 <= (others => '0');
                data2 <= (others => '0');
                data3 <= (others => '0');
                data4 <= (others => '0');
                data5 <= (others => '0');
                data6 <= (others => '0');
                output <= (others => '0');
            elsif shift_enable = '1'
                data0 <= input;
                data1 <= data0;
                data2 <= data1;
                data3 <= data2;
                data4 <= data3;
                data5 <= data4;
                data6 <= data5;
                output <= data6;
                output <= next_out;
            end if;
        end if;
        
    end process; 



end behavioral; 