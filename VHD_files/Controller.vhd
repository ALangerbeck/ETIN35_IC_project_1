



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Controller is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            load    : out std_logic;
            result_1 : out std_logic_vector(15 downto 0);
            result_2 : out std_logic_vector(15 downto 0);
            result_3 : out std_logic_vector(15 downto 0);
            result_4 : out std_logic_vector(15 downto 0);
            ready  : out std_logic
         );

end Controller;

architecture Controller_arch of Controller is

-- SIGNAL DEFINITIONS HERE IF NEEDED

    type state_type is (s_idle, s_shift_input, s_operation); --not sure about this.
    signal current_state : state_type := s_idle;
    signal next_state : state_type;
    signal shift_count : std_logic_vector (1 downto 0) := "00";
    signal next_shift_count : std_logic_vector (1 downto 0);
    signal count, next_count : std_logic_vector (6 downto 0);


-- COMPONENT DEFINITION

    component Multiplier_Unit is 
        port (  clk     : in std_logic;
                rst     : in std_logic;
                input   : in std_logic_vector(7 downto 0);
                coefficient : in std_logic_vector(6 downto 0);
                enable    : in std_logic;
                clear    : in std_logic;
                result : out std_logic_vector(15 downto 0)
             );
    end component;

begin
   
    state_logic : process(current_state, valid_input)
    begin 
        next_state <= current_state;

        case current_state is
            when s_idle =>
                if(valid_input == '1') then 
                    next_state <= s_shift_input;
                end if; 
            when s_shift_input =>


        end case;

    end process;

    read_indata : process
    begin 
        if(current_state == s_shift_inout) then
            next_shift_count <= shift_count + 1;
            case shift_count is 
                when "00" =>

                when "01" =>

                when "10" =>

                when "11" =>

                when others => -- should never happen but vivado complains

            end case;
        end if;
    end process; 

    operation_ctrl : process
    begin 

    end process;

    MU_1 : Multiplier_Unit 
    port map(  
        clk     => clk,
        rst     => rst,
        input   =>
        coefficient =>
        enable    =>
        clear    =>
        result =>
    );

    state_reg : process  ( clk, rst ) 
    begin 
        if rst = '1' then
            current_state <= s_idle;
        elsif rising_edge(clk) then 
            current_state <= next_state;
        end if;
        
    end process; 


end Controller_arch;