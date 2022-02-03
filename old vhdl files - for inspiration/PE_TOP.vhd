----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2021 07:45:30 PM
-- Design Name: 
-- Module Name: PE_TOP - Behavioral
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
--library UNISIM;
--use UNISIM.VCOMPONENTS.ALL;
entity PE_TOP is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    start : in STD_LOGIC; -- very unsure what to do with the start and finish signal. Maybe have a state machine where we can have the circuit active or unactive? 
    finish : in STD_LOGIC;
    f_in : in STD_LOGIC_VECTOR ( 3 downto 0 );
    valid_in_f : in STD_LOGIC;
    data_1 : in STD_LOGIC_VECTOR ( 63 downto 0 ); --renamed from ifmap_1
    data_2 : in STD_LOGIC_VECTOR ( 63 downto 0 ); --renamed from ifmap_2
    data_3 : in STD_LOGIC_VECTOR ( 63 downto 0 ); --renamed from ifmap_3
    data_4 : in STD_LOGIC_VECTOR ( 63 downto 0 ); --renamed from ifmap_4
    count_PE : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Psum_1 : out STD_LOGIC_VECTOR ( 7 downto 0 ); -- changed from ( 7 downto 0 )
    Psum_2 : out STD_LOGIC_VECTOR ( 7 downto 0 ); -- changed from ( 7 downto 0 ) 
    Psum_3 : out STD_LOGIC_VECTOR ( 7 downto 0 ); -- changed from ( 7 downto 0 )
    Psum_4 : out STD_LOGIC_VECTOR ( 7 downto 0 ); -- changed from ( 7 downto 0 )
    start_acc : out STD_LOGIC
  );
  --attribute NotValidForBitStream : boolean;
  --attribute NotValidForBitStream of PE_TOP : entity is true;
end PE_TOP;

architecture Behavioral of PE_TOP is

-- SIGNAL DEFINITIONS HERE IF NEEDED
    signal weights_reg_next, weights_reg : std_logic_vector ( 63 downto 0);
    --signal data_1_next, data_1_reg, data_2_next, data_2_reg, data_3_next, data_3_reg, data_4_next, data_4_reg : std_logic_vector ( 63 downto 0);
    signal update_data : std_logic;
    signal count : std_logic_vector( 1 downto 0);
    signal Psum_out_1, Psum_out_2, Psum_out_3, Psum_out_4 : std_logic_vector( 7 downto 0);
    signal weight_1, weight_2, weight_3, weight_4 : std_logic_vector(3 downto 0);
    
    -- Define a enumeration type for the states
    type state_type is (s_standby, s_ready, s_active); --not sure about this.
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
    
    component PE is 
        port (  clk     : in std_logic;
                rst     : in std_logic;
                data    : in std_logic_vector(63 downto 0);
                valid_d : in std_logic;
                weight  : in std_logic_vector (3 downto 0);
                count   : in std_logic_vector(1 downto 0);
                Psum_out  : out std_logic_vector(7 downto 0)
             );
    end component;


begin

    count <= count_PE(1 downto 0);
    
    update_PE : process(count_PE)
    begin
        update_data <= '0';

        if count_PE = "00000001" then
            update_data <= '1';

        end if;
    end process;
    
    select_weight : process(count)
    begin
        case count is -- not sure the weights are done in the correct order, need to double check. 
            when "01" =>
                weight_1 <= weights_reg(63 downto 60);
                weight_2 <= weights_reg(47 downto 44);
                weight_3 <= weights_reg(31 downto 28);
                weight_4 <= weights_reg(15 downto 12);
            when "10" =>
                weight_1 <= weights_reg(59 downto 56);
                weight_2 <= weights_reg(43 downto 40);
                weight_3 <= weights_reg(27 downto 24);
                weight_4 <= weights_reg(11 downto 8);
            when "11" =>
                weight_1 <= weights_reg(55 downto 52);
                weight_2 <= weights_reg(39 downto 36);
                weight_3 <= weights_reg(23 downto 20);
                weight_4 <= weights_reg(7 downto 4);
            when "00" =>
                weight_1 <= weights_reg(51 downto 48);
                weight_2 <= weights_reg(35 downto 32);
                weight_3 <= weights_reg(19 downto 16);
                weight_4 <= weights_reg(3 downto 0);
            when others => -- should never happen but vivado complains
                weight_1 <= weights_reg(63 downto 60);
                weight_2 <= weights_reg(59 downto 56);
                weight_3 <= weights_reg(55 downto 52);
                weight_4 <= weights_reg(51 downto 48);
        end case;
    
    end process;

    Psum_1 <= Psum_out_1;
    Psum_2 <= Psum_out_2;
    Psum_3 <= Psum_out_3;
    Psum_4 <= Psum_out_4;
    
    valid_out_data : process(current_state, start, count_PE, finish)
    begin 
        start_acc <= '0';
        next_state <= current_state;
        case current_state is
            when s_standby =>
                if start = '1' then
                    next_state <= s_ready;
                end if;
            when s_ready =>
                if count_PE(1 downto 0) = "01" then
                    next_state <= s_active;
                end if;
            when s_active =>
                if count_PE(1 downto 0) = "01" then
                    start_acc <= '1';
                end if;
                if finish = '1' then
                    next_state <= s_standby;
                end if;
        end case;
    end process;
    
    weights : process(valid_in_f, f_in, weights_reg_next, weights_reg)
    begin 
        weights_reg_next <= weights_reg;
        if valid_in_f = '1' then 
            weights_reg_next <= weights_reg(59 downto 56) & weights_reg(55 downto 52) & weights_reg(51 downto 48) & weights_reg(47 downto 44) & weights_reg(43 downto 40) 
                & weights_reg(39 downto 36) & weights_reg(35 downto 32) & weights_reg(31 downto 28) & weights_reg(27 downto 24) & weights_reg(23 downto 20) & weights_reg(19 downto 16) 
                & weights_reg(15 downto 12) & weights_reg(11 downto 8) & weights_reg(7 downto 4)  & weights_reg(3 downto 0) & f_in;
        end if;
    end process; 
    
    PE_1 : PE
    port map (  
        clk       => clk,
        rst       => rst,
        data      => data_1,
        valid_d   => update_data,
        weight    => weight_1,
        count     => count,
        Psum_out  => Psum_out_1
     );
     
    PE_2 : PE
     port map (  
         clk       => clk,
         rst       => rst,
         data      => data_2,
         valid_d   => update_data,
         weight    => weight_2,
         count     => count,
         Psum_out  => Psum_out_2
      );

    PE_3 : PE
    port map (  
        clk       => clk,
        rst       => rst,
        data      => data_3,
        valid_d   => update_data,
        weight    => weight_3,
        count     => count,
        Psum_out  => Psum_out_3
     );

    PE_4 : PE
    port map (  
        clk       => clk,
        rst       => rst,
        data      => data_4,
        valid_d   => update_data,
        weight    => weight_4,
        count     => count,
        Psum_out  => Psum_out_4
     );
    
    weights_register : reg
    generic map(
        W => 64)
    port map(
        clk => clk,
        rst => rst,
        next_out => weights_reg_next,
        output => weights_reg);

    state_reg : process  ( clk, rst ) 
    begin 
        if rst = '1' then
            current_state <= s_standby;
        elsif rising_edge(clk) then 
            current_state <= next_state;
        end if;
        
    end process; 

end Behavioral;