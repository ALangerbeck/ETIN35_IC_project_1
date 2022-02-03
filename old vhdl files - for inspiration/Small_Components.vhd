----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2021 07:52:35 PM
-- Design Name: 
-- Module Name: Small_Components - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package small_component_pack is

    component reg
    generic( W : integer );
    port (  clk     : in std_logic;
            rst     : in std_logic;
            next_out : in std_logic_vector(W-1 downto 0);
            output  : out std_logic_vector(W-1 downto 0)
         );
    end component;
    
    
end small_component_pack; 

-----------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg is 
    generic( W: integer);
    port (  clk     : in std_logic;
            rst     : in std_logic;
            next_out : in std_logic_vector(W-1 downto 0);
            output  : out std_logic_vector(W-1 downto 0)
         );
end reg; 

architecture behavioral of reg is

begin

    reg : process  ( clk, rst ) 
    begin 
        if rst = '1' then
            output <= (others => '0');
        elsif rising_edge(clk) then 
            output <= next_out;
        end if;
        
    end process; 

end behavioral; 
