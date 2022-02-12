library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity controller_tb is
end entity;


architecture structural of  controller_tb is


	--Signal Declaration
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal valid_input : std_logic := '0';
	signal load,ready : std_logic;
	signal input : std_logic_vector(7 downto 0) := (others => '0'); 
	signal dataROM : std_logic_vector(13 downto 0) := (others => '0');
	signal result_1,result_2,result_3,result_4: std_logic_vector(15 downto 0);
	
	constant period : time := 100 ns;
	file input_file : text;
	
	--Component declaratio
	component Controller is 
		port (
				clk     : in std_logic;
				rst     : in std_logic;
				input   : in std_logic_vector(7 downto 0);
				valid_input : in std_logic;
				dataROM : in std_logic_vector(13 downto 0); 
				load    : out std_logic;
				result_1 : out std_logic_vector(15 downto 0);
				result_2 : out std_logic_vector(15 downto 0);
				result_3 : out std_logic_vector(15 downto 0);
				result_4 : out std_logic_vector(15 downto 0);
				ready  : out std_logic
		       );
	end component;
	
begin

	clk <= not(clk) after period;
	rst <= '1','0' after 1 * period;
	valid_input <= '0', '1' after 1*period ;
	
	
	
	DUT: controller port map(
		clk => clk,
		rst => rst,
		input => input,
		valid_input => valid_input,
		dataROM => dataROM,
		load => load,
		result_1 => result_1,
		result_2 => result_2,
		result_3 => result_3,
		result_4  => result_4,
		ready => ready );
		
	process is
		variable v_ILINE     : line;
	    variable v_SPACE     : character;
	    variable variable_input : std_logic_vector(7 downto 0);
	    
	    begin
	    if (valid_input = '1') then
	    	
	    	file_open(input_file, "C:\Users\98all\Documents\LTH\ETIN35_IC_project_1\VHD_files\testBenches\input_stimuli.txt",  read_mode);
			while not endfile(input_file) loop
                readline(input_file,v_ILINE);
                read(V_ILINE,variable_input);
                input <= variable_input;
				wait for period;
			end loop;
			file_close(input_file);
		end if;
	end process;
		  
	--input <= "00000000",
	--valid_input <= '0',
	--	'1' after 2*periods;
end structural;