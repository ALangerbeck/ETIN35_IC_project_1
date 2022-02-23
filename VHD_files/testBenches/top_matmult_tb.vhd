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
	--Component declaration
	component TOP_matmult is 
	
		 port(  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            ready  : out std_logic
         );
	
	end component;
	
begin
    clk <= not(clk) after period*0.5;
    rst <= '0' after 2*period;
    
    DUT: Top_matmult port map(
            clk => clk,
            rst => rst,
            input => input,
            valid_input => valid_input,
            ready => ready
    );

    read_input : process
		variable v_ILINE     : line;
	    variable v_SPACE     : character;
	    variable variable_input : std_logic_vector(7 downto 0);
	    
	    begin
	        wait until rst = '0';
                wait until ready = '1';
                file_open(input_file, "C:\Users\98all\Documents\LTH\ETIN35_IC_project_1\VHD_files\testBenches\input_stimuli.txt",  read_mode);
                while not endfile(input_file) loop
                    readline(input_file,v_ILINE);
                    read(V_ILINE,variable_input);
                    input <= variable_input;
                    wait for period;
                end loop;
                file_close(input_file);
                wait;
	end process;

end structural;