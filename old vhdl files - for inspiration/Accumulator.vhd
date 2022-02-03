----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 03:23:12 PM
-- Design Name: 
-- Module Name: Accumulator - Behavioral
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

entity Accumulator is

-- if we have problems with the critical path we can change the acumulator so that we save the fou Psum when they are valid and then do one summation per clockcycle instead
-- of all at the same time. 
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    start : in STD_LOGIC;
    Psum1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Psum2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Psum3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Psum4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Fsum  : out STD_LOGIC_VECTOR( 3 downto 0 );
    valid_fsum : out STD_LOGIC
  );

end Accumulator;

architecture Behavioral of Accumulator is
    
-- SIGNAL DEFINITIONS HERE IF NEEDED
signal saved_sum_next, saved_sum_reg : std_logic_vector(7 downto 0);
signal Psum1_current, Psum1_next, Psum2_current, Psum2_next, Psum3_current, Psum3_next, Psum4_current, Psum4_next : std_logic_vector(7 downto 0);

    type state_type is (s_ready, s_sum, s_output_right); --not sure about this.
    signal current_state, next_state : state_type;


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
    
    update_Psum : process(start, Psum1, Psum2, Psum3, Psum4)
    begin
        Psum1_next <= Psum1_current;
        Psum2_next <= Psum2_current;
        Psum3_next <= Psum3_current;
        Psum4_next <= Psum4_current;
        if start = '1' then 
            Psum1_next <= Psum1;
            Psum2_next <= Psum2;
            Psum3_next <= Psum3;
            Psum4_next <= Psum4;
        end if;
    end process;
    
    state_logic : process(current_state, start)
    begin 
        valid_fsum <= '0';
        next_state <= current_state;
        case current_state is
            when s_ready =>
                if start = '1' then
                    next_state <= s_sum;
                end if;
            when s_sum =>
                next_state <= s_output_right;
            when s_output_right =>
                next_state <= s_ready;
                valid_fsum <= '1';
        end case;
    end process;
    
    sum : process(start, Psum1_current, Psum2_current, Psum3_current, Psum4_current)
    begin
        saved_sum_next <= saved_sum_reg;
        if current_state = s_sum then 
            saved_sum_next <= Psum1_current + Psum2_current + Psum3_current + Psum4_current;
        end if;
        
    end process;
    
    Final_sum : process(saved_sum_reg) -- this handels all "overflow" so that it becomes a random negative number.
    begin
        if saved_sum_reg(7) = saved_sum_reg(3) and saved_sum_reg(7) = saved_sum_reg(4) and saved_sum_reg(7) = saved_sum_reg(5) and saved_sum_reg(7) = saved_sum_reg(6) then
            Fsum <= saved_sum_reg(3 downto 0);
        elsif saved_sum_reg(7) = '0' then 
            Fsum <= "0111";
        else
            Fsum <= "1000";
        end if;
    end process;
    
    
    
    saved_sum : reg
    generic map(
        W => 8)
    port map(
        clk => clk,
        rst => rst,
        next_out => saved_sum_next,
        output => saved_sum_reg);
        
    P_sum_1 : reg
    generic map(
        W => 8)
    port map(
        clk => clk,
        rst => rst,
        next_out => Psum1_next,
        output => Psum1_current);
        
    P_sum_2 : reg
        generic map(
            W => 8)
        port map(
            clk => clk,
            rst => rst,
            next_out => Psum2_next,
            output => Psum2_current);

    P_sum_3 : reg
    generic map(
        W => 8)
    port map(
        clk => clk,
        rst => rst,
        next_out => Psum3_next,
        output => Psum3_current);

    P_sum_4 : reg
    generic map(
        W => 8)
    port map(
        clk => clk,
        rst => rst,
        next_out => Psum4_next,
        output => Psum4_current);
        
    state_reg : process  ( clk, rst ) 
        begin 
            if rst = '1' then
                current_state <= s_ready;
            elsif rising_edge(clk) then 
                current_state <= next_state;
            end if;
            
        end process; 

end Behavioral;
