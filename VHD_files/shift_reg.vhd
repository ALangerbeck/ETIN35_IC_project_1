library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity shift_reg is 
    generic( data_size: integer);
    port (  clk     : in std_logic;
            rst     : in std_logic;
            shift_enable : in std_logic;
            input : in std_logic_vector(data_size-1 downto 0);
            output  : out std_logic_vector(data_size-1 downto 0)
         );
end entity; 

architecture behavioral of shift_reg is

-- Signal Declaration

signal data0,data1,data2,data3,data4,data5,data6,data7 : std_logic_vector(data_size-1 downto 0);

-- Entitiy Structure

begin

	output <= data7;
	
    reg : process  ( clk, rst, shift_enable, input, data0, data1, data2, data3, data4,data5, data6) 
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
                data7 <= (others => '0');
            elsif shift_enable = '1' then
                data0 <= input;
                data1 <= data0;
                data2 <= data1;
                data3 <= data2;
                data4 <= data3;
                data5 <= data4;
                data6 <= data5;
                data7 <= data6;
            end if;
        end if;
        
    end process; 

	--output <= data7;

end behavioral; 