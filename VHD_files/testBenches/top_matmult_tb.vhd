library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use STD.textio.all;

entity top_matmult_tb is
end entity;


architecture structural of  top_matmult_tb is


	--Signal Declaration
	file input_file : text;
	constant period : time := 100 ns;
	signal clk,valid_input: std_logic := '0';
	signal rst : std_logic := '1';
	signal input : std_logic_vector(7 downto 0) := "00000000";
	signal ready : std_logic;
	signal read_ram : std_logic;
	signal output : std_logic_vector(5 downto 0);
	--Component declaration
	component TOP_matmult is 
		 port(  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            read_ram : in std_logic;
            ready  : out std_logic;
            output : out std_logic_vector(5 downto 0)
         );
	
	end component;
	
begin
    clk <= not(clk) after period*0.5;
    --rst <= '0' after 2*period;
    
    DUT: Top_matmult port map(
            clk => clk,
            rst => rst,
            input => input,
            valid_input => valid_input,
            read_ram => read_ram,
            ready => ready, 
            output => output
    );

    read_input : process
		variable v_ILINE     : line;
	    variable v_SPACE     : character;
	    variable variable_input : std_logic_vector(7 downto 0);
	    variable count : integer;
	    
	    begin  
	           count := 0;
	           read_ram <= '0';
	           rst <= '1'; 
	           wait for 2*period;
	           rst <= '0';
	           wait until rst = '0' and ready = '1';
	           valid_input <= '1';
	            wait for period;
	            valid_input <= '0';
                file_open(input_file, "C:\Users\linat\OneDrive\Documents\GitHub\ETIN35_IC_project_1\FilesFromLabComp\Functional_Model_Stimuli\input_stimuli.txt",  read_mode);
                while not endfile(input_file) loop
                    count := count +1;
                    readline(input_file,v_ILINE);
                    read(V_ILINE,variable_input);
                    input <= variable_input;
                    wait for period;
                    if((count mod 32)= 0 and count/32 /=5 ) then 
                        wait until ready = '1';
                        valid_input <= '1';
                        wait for period; 
                        valid_input <= '0';
                    end if; 
                end loop;
                file_close(input_file);
                -- test for reading the ram!!!
                wait until ready = '1';
                wait for 4*period;
                read_ram <= '1';
                input <= (others => '0');
                wait for period;
                read_ram <= '0';
                wait;
                
                
	end process;

end structural;