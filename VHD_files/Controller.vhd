library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Controller is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            -- Temporary...maybe..perhaps
            dataROM : in std_logic_vector(13 downto 0); 
            --
            read_ram : in std_logic; -- added for reading ram function
            ready_to_start : in std_logic; 
            load    : out std_logic;
            result_1 : out std_logic_vector(17 downto 0);
            result_2 : out std_logic_vector(17 downto 0);
            result_3 : out std_logic_vector(17 downto 0);
            result_4 : out std_logic_vector(17 downto 0);
            ready  : out std_logic;
            address_out: out std_logic_vector(3 downto 0)
         );

end Controller;

architecture Controller_arch of Controller is

-- SIGNAL DEFINITIONS HERE IF NEEDED

    type state_type is (s_idle, s_shift_input, s_prepare_operation, s_multiply_state, s_prepare_next_column, s_read_ram); --not sure about this.
    signal current_state : state_type := s_idle;
    signal next_state : state_type;
    signal shift_count : std_logic_vector (1 downto 0) := "00";
    signal next_shift_count : std_logic_vector (1 downto 0);
    signal count : std_logic_vector (4 downto 0) := "00000";
    signal next_count : std_logic_vector (4 downto 0);
    signal count_col, next_count_col : std_logic_vector(2 downto 0); --could be smaller
    signal count_mul, next_count_mul : std_logic_vector(2 downto 0);
    signal en1, en2, en3, en4, m_en, clear : std_logic;
    signal shift_reg_in_1, shift_reg_in_2, shift_reg_in_3, shift_reg_in_4 : std_logic_vector(7 downto 0);
    signal shift_reg_out_1, shift_reg_out_2, shift_reg_out_3, shift_reg_out_4 : std_logic_vector(7 downto 0);
    signal mu_in1, mu_in2, mu_in3, mu_in4 : std_logic_vector(7 downto 0);
    signal coe_in : std_logic_vector(6 downto 0);
    signal mu_out_1, mu_out_2, mu_out_3, mu_out_4 : std_logic_vector(17 downto 0); --Conplains should be 16 elements has 18
    signal coe_1, next_coe_1, coe_2, next_coe_2 : std_logic_vector(6 downto 0);
    signal address : std_logic_vector(3 downto 0) := "0000";
    signal next_address : std_logic_vector(3 downto 0);


-- COMPONENT DEFINITION

    component Multiplier_Unit is 
        port (  clk     : in std_logic;
                rst     : in std_logic;
                input   : in std_logic_vector(7 downto 0);
                coefficient : in std_logic_vector(6 downto 0);
                enable    : in std_logic;
                clear    : in std_logic;
                result : out std_logic_vector(17 downto 0)
             );
    end component;

    component reg is 
        generic( W: integer);
        port (  clk     : in std_logic;
                rst     : in std_logic;
                next_out : in std_logic_vector(W-1 downto 0);
                output  : out std_logic_vector(W-1 downto 0)
                 );
    end component; 

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
   	address_out <= address;
     mu_in1 <= shift_reg_out_1;
     mu_in2 <= shift_reg_out_2;
     mu_in3 <= shift_reg_out_3;
     mu_in4 <= shift_reg_out_4;

    state_logic : process(current_state, valid_input, count,count_col, count_mul, read_ram, ready_to_start)
    begin 
        next_state <= current_state;
        ready <= '0';
        case current_state is
            when s_idle =>
            	ready <= '1';
                if(valid_input = '1') then 
                    next_state <= s_shift_input;
                elsif(read_ram = '1') then 
                    next_state <= s_read_ram;
                end if; 
            when s_shift_input =>
                if(count = "11111") then --not compeletly sure of this timing, maybe change, but then neccessary to change ASMD
                    next_state <= s_prepare_operation;
                end if;
            when s_prepare_operation =>
                next_state <= s_multiply_state;
            when s_multiply_state =>
                if(count_mul = "111") then 
                    next_state <= s_prepare_next_column;
        			--next_count_col <= count_col + 1;
                    --load <= '1';
                end if;
            when s_prepare_next_column =>
                if(count_col = "100") then 
                    next_state <= s_idle;
                else
                    next_state <= s_multiply_state;
                end if;
            when s_read_ram => 
                if(ready_to_start = '1') then 
                    next_state <= s_idle;
                end if;
        end case;

    end process;

    shift_reg_ctrl : process(input, shift_count, count, current_state, shift_reg_out_1, shift_reg_out_2, shift_reg_out_3, shift_reg_out_4)
    begin 
        en1 <= '0';
        en2 <= '0';
        en3 <= '0';
        en4 <= '0';
        shift_reg_in_1 <= input;
        shift_reg_in_2 <= input;
        shift_reg_in_3 <= input;
        shift_reg_in_4 <= input;
        next_shift_count <= shift_count;
        next_count <= count;
        case current_state is
        when s_shift_input =>
            next_shift_count <= shift_count + 1;
            next_count <= count +1;
            case shift_count is 
                when "00" =>
                    en1 <= '1';
                when "01" =>
                    en2 <= '1';
                when "10" =>
                    en3 <= '1';
                when "11" =>
                    en4 <= '1';
                when others => -- should never happen but vivado complains

            end case;
        when s_multiply_state =>
            en1 <= '1';
            en2 <= '1';
            en3 <= '1';
            en4 <= '1';
            shift_reg_in_1 <= shift_reg_out_1;
            shift_reg_in_2 <= shift_reg_out_2;
            shift_reg_in_3 <= shift_reg_out_3;
            shift_reg_in_4 <= shift_reg_out_4;
         when others =>
         
        end case;
    end process; 

    operation_ctrl : process(current_state,coe_1,coe_2,count_col,count_mul,address,dataROM,count_mul,
    	shift_reg_out_1,shift_reg_out_2,shift_reg_out_3,shift_reg_out_4,clk)
    begin 
        m_en <= '0';
        clear <= '0';
        next_coe_1 <= coe_1;
        next_coe_2 <= coe_2;
        coe_in <= coe_1;
        next_count_col <= count_col;
        next_count_mul <= count_mul;
        next_address <= address;
        load <= '0';
        
        case current_state is
        when s_prepare_operation =>
            clear <= '1';
            -- Might change later
            next_coe_1 <= dataROM(13 downto 7); --assign from rom memory
            next_coe_2 <= dataROM(6 downto 0); --assign from rom memory
            next_address <= address +1;
            --
        when s_multiply_state =>
            next_count_mul <= count_mul +1;
            m_en <= '1';
            if(count_mul(0) = '1') then --unsure about this syntax for count_mul(0)
            	--ROM shenanigans
                next_coe_1 <= dataROM(13 downto 7); --assign from rom memory
                next_coe_2 <= dataROM(6 downto 0); --assign from rom memory
                coe_in <= coe_2;
            else
                coe_in <= coe_1;
                next_address <= address +1;
            end if;
            
            if(count_mul = "111") then
                next_count_col <= count_col + 1;
                load <= '1';
            end if;
            
        when s_prepare_next_column =>
            clear <= '1';
        when s_idle =>
        	next_count_col <= (others =>'0');
            next_count_mul <= "000"; 
        	--next_count <= (others =>'0');
        when others =>
        
        end case;
        
    end process;

    data_out : process(mu_out_1,mu_out_2,mu_out_3,mu_out_4)
    begin 
        result_1 <= mu_out_1;
        result_2 <= mu_out_2;
        result_3 <= mu_out_3;
        result_4 <= mu_out_4;
    end process;

    shift_reg_1 : shift_reg
    generic map ( 
        data_size => 8)
    port map(  
        clk     => clk,
        rst     => rst,
        shift_enable => en1,
        input => shift_reg_in_1,
        output  => shift_reg_out_1
    );

    shift_reg_2 : shift_reg
    generic map ( 
        data_size => 8)
    port map(  
        clk     => clk,
        rst     => rst,
        shift_enable => en2,
        input => shift_reg_in_2,
        output  => shift_reg_out_2
    );

    shift_reg_3 : shift_reg
    generic map ( 
        data_size => 8)
    port map(  
        clk     => clk,
        rst     => rst,
        shift_enable => en3,
        input => shift_reg_in_3,
        output  => shift_reg_out_3
    );

    shift_reg_4 : shift_reg
    generic map ( 
        data_size => 8)
    port map(  
        clk     => clk,
        rst     => rst,
        shift_enable => en4,
        input => shift_reg_in_4,
        output  => shift_reg_out_4
    );

    address_reg : reg 
    generic map( 
        W => 4)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_address,
        output  => address
    );

    count_reg : reg 
    generic map( 
        W => 5)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_count,
        output  => count
    );

    shift_count_reg : reg 
    generic map( 
        W => 2)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_shift_count,
        output  => shift_count
    );

    count_col_reg : reg 
    generic map( 
        W => 3)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_count_col,
        output  => count_col
    );

    count_mul_reg : reg 
    generic map( 
        W => 3)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_count_mul,
        output  => count_mul
    );

    coe_1_reg : reg 
    generic map( 
        W => 7)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_coe_1,
        output  => coe_1
    );

    coe_2_reg : reg 
    generic map( 
        W => 7)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_coe_2,
        output  => coe_2
    );

    MU_1 : Multiplier_Unit 
    port map(  
        clk     => clk,
        rst     => rst,
        input   => mu_in1,
        coefficient => coe_in,
        enable    => m_en,
        clear    => clear,
        result => mu_out_1
    );

    MU_2 : Multiplier_Unit 
    port map(  
        clk     => clk,
        rst     => rst,
        input   => mu_in2,
        coefficient => coe_in,
        enable    => m_en,
        clear    => clear,
        result => mu_out_2
    );

    MU_3 : Multiplier_Unit 
    port map(  
        clk     => clk,
        rst     => rst,
        input   => mu_in3,
        coefficient => coe_in,
        enable    => m_en,
        clear    => clear,
        result => mu_out_3
    );

    MU_4 : Multiplier_Unit 
    port map(  
        clk     => clk,
        rst     => rst,
        input   => mu_in4,
        coefficient => coe_in,
        enable    => m_en,
        clear    => clear,
        result => mu_out_4
    );

    state_reg : process  ( clk, rst, next_state ) 
    begin 
        if rst = '1' then
            current_state <= s_idle;
        elsif rising_edge(clk) then 
            current_state <= next_state;
        end if;
    end process; 


end Controller_arch;