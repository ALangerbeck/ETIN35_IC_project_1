library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity RAM_ctrl is 

    port(  clk     : in std_logic;
            rst     : in std_logic;
            load    : in std_logic;
            ready_to_read : in std_logic;
            read_ram : in std_logic; -- added for reading ram function
            input   : in std_logic_vector(7 downto 0);
            result_1 : in std_logic_vector(14 downto 0);
            result_2 : in std_logic_vector(14 downto 0);
            result_3 : in std_logic_vector(14 downto 0);
            result_4 : in std_logic_vector(14 downto 0);
            ready_to_start : out std_logic;

            output : out std_logic_vector(4 downto 0)
         );

end RAM_ctrl;


architecture RAM_ctrl_arch of RAM_ctrl is

-- SIGNAL DEFINITIONS HERE IF NEEDED
    
    type state_type is (s_start_save, s_save2, s_save3, s_save4, s_read);
    signal current_state : state_type;
    signal next_state : state_type;
    signal ram_address : std_logic_vector(7 downto 0);
    signal result_1_reg, result_1_next : std_logic_vector(14 downto 0);
    signal result_2_reg, result_2_next : std_logic_vector(14 downto 0);
    signal result_3_reg, result_3_next : std_logic_vector(14 downto 0);
    signal result_4_reg, result_4_next : std_logic_vector(14 downto 0);
    signal LOW  : std_logic;
    signal write_enable : std_logic;
    signal address, next_address : std_logic_vector(7 downto 0);
    signal RY : std_logic;
    signal data_in, data_out : std_logic_vector(31 downto 0);
    signal out_reg, out_reg_next : std_logic_vector(9 downto 0);
    signal count, next_count : std_logic_vector(1 downto 0); 
    signal count_result, next_count_result : std_logic_vector(3 downto 0);
    signal read_ram_reg, read_ram_next : std_logic;  --added for refined reading
    signal read_matrix_reg, read_matrix_next : std_logic_vector(3 downto 0); --added for refined reading
    signal matrix_calculated_reg, matrix_calculated_next : std_logic_vector(3 downto 0); --added for refined reading
    signal temp_address : std_logic_vector(7 downto 0);


-- COMPONENT DEFINITION

    component reg is 
        generic( W: integer);
        port (  clk     : in std_logic;
                rst     : in std_logic;
                next_out : in std_logic_vector(W-1 downto 0);
                output  : out std_logic_vector(W-1 downto 0)
                 );
    end component; 

    component SRAM_SP_WRAPPER is
      port (
        ClkxCI  : in  std_logic;  -- Clk
        CSxSI   : in  std_logic;  --??,put as always low, test          -- Active Low
        WExSI   : in  std_logic;  --Write_enable          --Active Low
        AddrxDI : in  std_logic_vector (7 downto 0); --Address
        RYxSO   : out std_logic; --??
        DataxDI : in  std_logic_vector (31 downto 0); --Data in
        DataxDO : out std_logic_vector (31 downto 0) --Data out
        );
    end component;


begin

    LOW  <= '0';
   
    reg_logic : process(load, result_2, result_3, result_4, result_2_reg, result_3_reg, result_4_reg)
    begin
        result_2_next <= result_2_reg;
        result_3_next <= result_3_reg;
        result_4_next <= result_4_reg;
        if(load='1') then
            result_2_next <= result_2;
            result_3_next <= result_3;
            result_4_next <= result_4;
        end if;
    end process;

    calculated_matrixes : process(address, matrix_calculated_reg) --added for refined read, keeps track of how many matrixes has been calculated. 
    begin 
        matrix_calculated_next <= matrix_calculated_reg;
        if((address="00001111" or address="00011111" or address="00101111" or address="00111111" or address="01001111" or address="01011111" or 
            address="01101111" or address="01111111" or address="10001111" or address="10011111")and matrix_calculated_reg/="1001") then 
            matrix_calculated_next <= matrix_calculated_reg +1;
        end if;
    end process;

    state_logic : process(current_state, address, count, result_2_reg, result_3_reg, result_4_reg, ready_to_read, read_ram, data_out, read_ram_reg, result_1)
    begin 
        next_address <= address;
        next_state <= current_state;
	    next_count <= count;
        next_count_result <= count_result;
        write_enable <= '1';
        ram_address <= address;
        data_in <= (others => '0');
        out_reg_next <= out_reg;
        read_ram_next <= read_ram_reg;
        read_matrix_next <= read_matrix_reg;
        ready_to_start <= '0';
        temp_address <= "00000000";
        if(address="10100000") then 
            next_address <= (others => '0');
        end if;
        if(read_ram = '1') then 
            read_ram_next <= read_ram;
            read_matrix_next <= input(3 downto 0);
        end if;
	    output <= (others => '0');
        case current_state is
            when s_start_save =>
                if(load='1') then 
                    next_state <= s_save2;
                    next_address <= address + 1;
                    write_enable <= '0';
                    data_in <= "00000000000000000" & result_1;
                elsif((read_ram_reg = '1' or read_ram='1')and ready_to_read='1') then
                    if(read_ram = '1') then
                        if((input(3 downto 0)+1)<= matrix_calculated_reg) then
                            next_state <= s_read;
                            ram_address <= input(3 downto 0) & "0000";
                        end if;
                    else 
                        if((read_matrix_reg+1)<=matrix_calculated_reg) then
                            next_state <= s_read;
                            ram_address <= read_matrix_reg & "0000";
                        end if;
                    end if;
                end if;
            when s_save2 =>
                next_state <= s_save3;
                next_address <= address + 1;
                write_enable <= '0';
                data_in <= "00000000000000000" & result_2_reg;
            when s_save3 =>
                next_state <= s_save4;
                next_address <= address + 1;
                write_enable <= '0';
                data_in <= "00000000000000000" & result_3_reg;
            when s_save4 =>
                next_state <= s_start_save;
                next_address <= address + 1;
                write_enable <= '0';
                data_in <= "00000000000000000" & result_4_reg;
            when s_read => 
                if(count ="00") then 
                    if(count_result ="0000") then 
                        read_ram_next <= '0';
                    end if; 
                    next_count <= count +1;
                    output <= data_out(14 downto 10);
                    out_reg_next <= data_out (9 downto 0);
                elsif(count = "01") then 
                    next_count <= count +1;
                    output <= out_reg(9 downto 5);
                    next_count_result <= count_result +1;
                else
                    next_count <= "00";
                    output <= out_reg(4 downto 0);
                    if(count_result ="0100") then 
                        ready_to_start <= '1';
                    end if;
                    if(count_result ="0000") then 
                        next_state <= s_start_save;
                    else 
                        temp_address <= read_matrix_reg & "0000";
                        ram_address <= temp_address + count_result;
                    end if;
                end if;
        end case;
    end process;

    RAM : SRAM_SP_WRAPPER 
      port map(
        ClkxCI  => clk,
        CSxSI   => LOW,
        WExSI   => write_enable,
        AddrxDI => ram_address,
        RYxSO   => RY,
        DataxDI => data_in,
        DataxDO => data_out
        );

    address_reg : reg 
    generic map( 
        W => 8)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_address,
        output  => address
    );

    matrix_reg : reg 
    generic map( 
        W => 4)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => read_matrix_next,
        output  => read_matrix_reg
    );
    
    matrix_calc_reg : reg 
    generic map( 
        W => 4)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => matrix_calculated_next,
        output  => matrix_calculated_reg
    );

    count_reg : reg 
    generic map( 
        W => 2)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_count,
        output  => count
    );

    count_result_reg : reg 
    generic map( 
        W => 4)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => next_count_result,
        output  => count_result
    );

    load_reg : process(clk,rst)   
    begin 
        if rising_edge(clk) then 
            if rst = '1' then
                read_ram_reg <= '0';
            else 
                read_ram_reg <= read_ram_next;
            end if;
        end if;
        
    end process; 

    out_buffer : reg 
    generic map( 
        W => 10)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => out_reg_next,
        output  => out_reg
    );



    r_result_2 : reg 
    generic map( 
        W => 15)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_2_next,
        output  => result_2_reg
    );

    r_result_3 : reg 
    generic map( 
        W => 15)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_3_next,
        output  => result_3_reg
    );

    r_result_4 : reg 
    generic map( 
        W => 15)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_4_next,
        output  => result_4_reg
    );

    state_reg : process (clk, rst, next_state, read_ram_reg) 
    begin 
        if rst = '1' then
            current_state <= s_start_save;
        elsif rising_edge(clk) then 
            current_state <= next_state;
        end if;
    end process; 


end RAM_ctrl_arch;
