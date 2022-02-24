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
            result_1 : in std_logic_vector(17 downto 0);
            result_2 : in std_logic_vector(17 downto 0);
            result_3 : in std_logic_vector(17 downto 0);
            result_4 : in std_logic_vector(17 downto 0);
            output : out std_logic_vector(8 downto 0)
         );

end RAM_ctrl;



--load is saved in a register and then the things with ram start happen next clock cycle
--but being saved in registers happen same clock cycle as load is high so that needs to be 
--modified in the ASMD. 

architecture RAM_ctrl_arch of RAM_ctrl is

-- SIGNAL DEFINITIONS HERE IF NEEDED
    
    type state_type is (s_start_save, s_save2, s_save3, s_save4, s_read);
    signal current_state : state_type;
    signal next_state : state_type;
    signal ram_address : std_logic_vector(7 downto 0);
    signal result_1_reg, result_1_next : std_logic_vector(17 downto 0);
    signal result_2_reg, result_2_next : std_logic_vector(17 downto 0);
    signal result_3_reg, result_3_next : std_logic_vector(17 downto 0);
    signal result_4_reg, result_4_next : std_logic_vector(17 downto 0);
    signal start : std_logic;
    signal LOW  : std_logic;
    signal write_enable : std_logic;
    signal address, next_address : std_logic_vector(7 downto 0);
    signal RY : std_logic;
    signal data_in, data_out : std_logic_vector(31 downto 0);
    signal out_reg, out_reg_next : std_logic_vector(8 downto 0);
    signal count, next_count : std_logic; 


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
   
    reg_logic : process(load, result_1_reg, result_2_reg, result_3_reg, result_4_reg)
    begin
        result_1_next <= result_1_reg;
        result_2_next <= result_2_reg;
        result_3_next <= result_3_reg;
        result_4_next <= result_4_reg;
        if(start='1') then
            result_1_next <= result_1;
            result_2_next <= result_2;
            result_3_next <= result_3;
            result_4_next <= result_4;
        end if;
    end process;

    state_logic : process(current_state)
    begin 
        next_address <= address;
        next_state <= current_state;
        write_enable <= '1';
        ram_address <= address;
        data_in <= "00000000000000" & result_1_reg;
        out_reg_next <= out_reg; 
        case current_state is
            when s_start_save =>
                if(start='1') then 
                    next_state <= s_save2;
                    next_address <= address + 1;
                    write_enable <= '0';
                elsif(ready_to_read='1' and read_ram = '1') then
                    next_state <= s_read;
                    ram_address <= input;
                end if;
            when s_save2 =>
                next_state <= s_save3;
                next_address <= address + 1;
                write_enable <= '0';
                data_in <= "00000000000000" & result_2_reg;
            when s_save3 =>
                next_state <= s_save4;
                next_address <= address + 1;
                write_enable <= '0';
                data_in <= "00000000000000" & result_3_reg;
            when s_save4 =>
                next_state <= s_start_save;
                next_address <= address + 1;
                write_enable <= '0';
                data_in <= "00000000000000" & result_4_reg;
            when s_read => 
                if(count ='0') then 
                    next_count <= '1';
                    output <= data_out(17 downto 9);
                    out_reg_next <= data_out (8 downto 0);
                else
                    next_count <= '0';
                    output <= out_reg;
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

    load_reg : process(clk,rst)   
    begin 
        if rising_edge(clk) then 
            if rst = '1' then
                count <= '0';
                start <= '0';
            else 
                count <= next_count;
                start <= load;
            end if;
        end if;
        
    end process; 

    out_buffer : reg 
    generic map( 
        W => 9)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => out_reg_next,
        output  => out_reg
    );

    r_result_1 : reg 
    generic map( 
        W => 18)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_1_next,
        output  => result_1_reg
    );

    r_result_2 : reg 
    generic map( 
        W => 18)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_2_next,
        output  => result_2_reg
    );

    r_result_3 : reg 
    generic map( 
        W => 18)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_3_next,
        output  => result_3_reg
    );

    r_result_4 : reg 
    generic map( 
        W => 18)
    port map(  
        clk     => clk,
        rst     => rst,
        next_out => result_4_next,
        output  => result_4_reg
    );

    state_reg : process (clk, rst, next_state) 
    begin 
        if rst = '1' then
            current_state <= s_start_save;
        elsif rising_edge(clk) then 
            current_state <= next_state;
        end if;
    end process; 


end RAM_ctrl_arch;