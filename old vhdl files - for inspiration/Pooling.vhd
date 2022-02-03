library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Pooling is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    ofmap_RELU : in STD_LOGIC_VECTOR ( 3 downto 0 );
    valid_data : in STD_LOGIC;
    pooling_out : out STD_LOGIC_VECTOR ( 3 downto 0 );
    valid_pooling : out STD_LOGIC
  );

end Pooling;

architecture Behavioral of Pooling is

    -- Define a enumeration type for the states
    type state_type is (s_1, s_2, s_3, s_4, s_discard);
    
    

    -- SIGNAL DEFINITIONS HERE IF NEEDED
    signal current_state, next_state : state_type;
    signal counter_row, counter_row_next, counter_col, counter_col_next : std_logic_vector(3 downto 0);
    signal n_1_current, n_1_next, n_2_current, n_2_next, n_3_current, n_3_next, n_4_current, n_4_next : std_logic_vector(3 downto 0);
    

    
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

    state_logic : process(ofmap_RELU, valid_data, current_state, counter_row, counter_col, n_1_current, n_2_current, n_3_current, n_4_current)
    begin 
        pooling_out <= n_1_current;
        
        next_state <= current_state;
        
        n_1_next <= n_1_current;
        n_2_next <= n_2_current;
        n_3_next <= n_3_current;
        n_4_next <= n_4_current;
        
        counter_row_next <= counter_row;
        counter_col_next <= counter_col;
        
        valid_pooling<='0';
        
        case current_state is
            when s_1 =>
                pooling_out <= n_1_current;
                if valid_data = '1' then 
                    if ofmap_RELU > n_1_current then
                        n_1_next <= ofmap_RELU;
                    end if;
                    counter_row_next <= counter_row + 1;
                end if;
                if counter_row = "1111" then
                    counter_row_next <= "0000";
                    next_state<= s_2;
                    if counter_col = "1110" then
                        valid_pooling <= '1';
                        n_1_next <= "0000";
                    end if;
                end if;    
            when s_2 =>
                pooling_out <= n_2_current;
                if valid_data = '1' then 
                    if ofmap_RELU > n_2_current then
                        n_2_next <= ofmap_RELU;
                    end if;
                    counter_row_next <= counter_row + 1;
                end if;
                if counter_row = "1111" then
                    counter_row_next <= "0000";
                    next_state<= s_3;
                    if counter_col = "1110" then
                        valid_pooling <= '1';
                        n_2_next <= "0000";
                    end if;
                end if; 
            when s_3 =>
                pooling_out <= n_3_current;
                if valid_data = '1' then 
                    if ofmap_RELU > n_3_current then
                        n_3_next <= ofmap_RELU;
                    end if;
                    counter_row_next <= counter_row + 1;
                end if;
                if counter_row = "1111" then
                    counter_row_next <= "0000";
                    next_state<= s_4;
                    if counter_col = "1110" then
                        valid_pooling <= '1';
                        n_3_next <= "0000";
                    end if;
                end if; 
            when s_4 =>
                pooling_out <= n_4_current;
                if valid_data = '1' then 
                    if ofmap_RELU > n_4_current then
                        n_4_next <= ofmap_RELU;
                    end if;
                    counter_row_next <= counter_row + 1;
                end if;
                if counter_row = "1111" then
                    counter_row_next <= "0000";
                    next_state<= s_discard;
                    if counter_col = "1110" then
                        valid_pooling <= '1';
                        n_4_next <= "0000";
                    end if;
                end if; 
            when s_discard =>
                if valid_data = '1' then 
                     if counter_col = "1110" then
                        counter_col_next <= "0000";
                     else
                        counter_col_next <= counter_col +1;
                     end if;
                      next_state <= s_1;  

                    
                end if;
        end case;
        
    
    end process;
    
    number_box_one : reg
    generic map(
        W => 4)
    port map(
        clk => clk,
        rst => rst,
        next_out => n_1_next,
        output => n_1_current);

    number_box_two : reg
    generic map(
        W => 4)
    port map(
        clk => clk,
        rst => rst,
        next_out => n_2_next,
        output => n_2_current);

    number_box_three : reg
    generic map(
        W => 4)
    port map(
        clk => clk,
        rst => rst,
        next_out => n_3_next,
        output => n_3_current);

    number_box_four : reg
    generic map(
        W => 4)
    port map(
        clk => clk,
        rst => rst,
        next_out => n_4_next,
        output => n_4_current);

    counter_row_reg : reg
    generic map(
        W => 4)
    port map(
        clk => clk,
        rst => rst,
        next_out => counter_row_next,
        output => counter_row);

    counter_col_reg : reg
    generic map(
        W => 4)
    port map(
        clk => clk,
        rst => rst,
        next_out => counter_col_next,
        output => counter_col);

    state_reg : process  ( clk, rst ) 
    begin 
        if rst = '1' then
            current_state <= s_1;
        elsif rising_edge(clk) then 
            current_state <= next_state;
        end if;
        
    end process; 

end Behavioral;
