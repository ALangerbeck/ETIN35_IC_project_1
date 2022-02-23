library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

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
	signal result_1,result_2,result_3,result_4: std_logic_vector(17 downto 0);
	signal address_rom: std_logic_vector(3 downto 0);
	
	constant period : time := 100 ns;
	file input_file : text;
	file rom_file : text;
	file out_file : text;
	
	--Component declaratio
	component Controller is 
		port (
				clk     : in std_logic;
				rst     : in std_logic;
				input   : in std_logic_vector(7 downto 0);
				valid_input : in std_logic;
				dataROM : in std_logic_vector(13 downto 0); 
				load    : out std_logic;
				result_1 : out std_logic_vector(17 downto 0);
				result_2 : out std_logic_vector(17 downto 0);
				result_3 : out std_logic_vector(17 downto 0);
				result_4 : out std_logic_vector(17 downto 0);
				ready  : out std_logic;
				address_out: out std_logic_vector(3 downto 0)
		       );
	end component;
	
begin

	clk <= not(clk) after period*0.5;
	rst <= '1','0' after 1 * period;
	valid_input <= '0', '1' after 1*period,'0' after 2*period ;
	
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
		ready => ready,
		address_out => address_rom );
		
	read_input : process
		variable v_ILINE     : line;
	    variable v_SPACE     : character;
	    variable variable_input : std_logic_vector(7 downto 0);
	    
	    begin
	   		wait until valid_input = '1';
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
	
	read_rom: process(address_rom,clk)
		variable target_line:	integer; 
		variable line_counter: integer := 0;
		variable lineData :	line;
		variable readData : std_logic_vector(13 downto 0);
		
		
		begin
		file_open(rom_file, "C:\Users\98all\Documents\LTH\ETIN35_IC_project_1\VHD_files\testBenches\RomCoeff.txt", read_mode);
		target_line := to_integer(unsigned(address_rom));
		while line_counter <= target_line loop
			if not endfile(rom_file) then
				readline(rom_file,lineData);
				read(lineData,readData);
			end if;
			line_counter := line_counter + 1;
		end loop;
		dataROM <= readData;
		file_close(rom_file);
	end process;
	
	--write_ram : process(load)
			
	--end process;
		  
	--input <= "00000000",
	--valid_input <= '0',
	--	'1' after 2*periods;
end structural;