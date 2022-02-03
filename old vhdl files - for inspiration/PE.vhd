----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2021 05:48:22 PM
-- Design Name: 
-- Module Name: PE - Behavioral
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PE is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            data    : in std_logic_vector(63 downto 0);
            valid_d : in std_logic;
            weight  : in std_logic_vector (3 downto 0);
            count   : in std_logic_vector(1 downto 0);
            Psum_out  : out std_logic_vector(7 downto 0)
         );

end PE;

architecture Behavioral of PE is

-- SIGNAL DEFINITIONS HERE IF NEEDED

    signal data_next, data_reg: std_logic_vector ( 63 downto 0);
    signal Psum_next, Psum_reg: std_logic_vector (7 downto 0);
    signal weight_sum : std_logic_vector(7 downto 0);


-- COMPONENT DEFINITION
    component reg is
    generic ( W : integer
            );
    port ( clk     : in  std_logic;
           rst     : in  std_logic;
           next_out : in std_logic_vector(W-1 downto 0);
           output  : out std_logic_vector(W-1 downto 0)
         );
    end component;


begin
    Psum_out <= Psum_reg;
    
    update_data_reg : process(data, data_reg, count, valid_d)
    begin
        data_next <= data_reg;

        if valid_d = '1' then 
            data_next <= data;
        elsif count = "00" then
            data_next <= '0' & data_reg(63 downto 1);
        end if;
        
    end process;
    
    mul : process(data_reg, count, weight, Psum_reg, weight_sum)
    begin 
        if weight(3) = '1' then 
            weight_sum <= "1111" & weight;
        else
            weight_sum <= "0000" & weight;
        end if;
        case count is
            when "01" =>
                if data_reg(0) = '1' then
                    Psum_next <= weight_sum;
                else
                    Psum_next <= "00000000";
                end if;
            when "10" =>
                if data_reg(1) = '1' then
                    Psum_next <= weight_sum + Psum_reg;
                else
                    Psum_next <= Psum_reg;
                end if;
            when "11" =>
                if data_reg(2) = '1' then
                    Psum_next <= weight_sum + Psum_reg;
                else
                    Psum_next <= Psum_reg;
                end if;
            when "00" =>
                if data_reg(3) = '1' then
                    Psum_next <= weight_sum + Psum_reg;
                else
                    Psum_next <= Psum_reg;
                end if;
            when others =>
                if data_reg(0) = '1' then
                    Psum_next <= weight_sum;
                else
                    Psum_next <= "00000000";
                end if;
        end case;
    
    end process; 

    d_reg : reg
    generic map(
        W => 64)
    port map(
        clk => clk,
        rst => rst,
        next_out => data_next,
        output => data_reg);

    P_sum : reg
    generic map(
        W => 8)
    port map(
        clk => clk,
        rst => rst,
        next_out => Psum_next,
        output => Psum_reg);

end Behavioral;
