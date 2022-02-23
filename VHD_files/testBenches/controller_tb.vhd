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
	
	read_rom: process(address_rom)
	   
	   begin
	   case address_rom is
	       when "0000" => dataROM <= "00000110010110";
	       when "0001" => dataROM <= "00010110000001";
	       when "0010" => dataROM <= "00010000000011";
	       when "0011" => dataROM <= "00000010000010";
	       when "0100" => dataROM <= "00010000001111";
	       when "0101" => dataROM <= "00000100000100";
	       when "0110" => dataROM <= "00011000000110";
	       when "0111" => dataROM <= "00000010000010";
	       when "1000" => dataROM <= "00100100101000";
	       when "1001" => dataROM <="00000110000010";
	       when "1010" => dataROM <="00100000001001";
           when "1011" => dataROM <="00000010000010";
           when "1100" => dataROM <="00000010001010";
           when "1101" => dataROM <="00001000000000";
           when "1110" => dataROM <="00000100001100";
           when "1111" => dataROM <="00000010000010";
           when others => dataROM <= (others => '0');
           end case;
	   end process;
	
--	read_rom: process
--		variable target_line:	integer; 
--		variable line_counter: integer := 0;
--		variable lineData :	line;
--		variable readData : std_logic_vector(13 downto 0);
		
		
--		begin
--		wait until address_rom'event;
--		file_open(rom_file, "C:\Users\98all\Documents\LTH\ETIN35_IC_project_1\VHD_files\testBenches\RomCoeff.txt", read_mode);
--		target_line := to_integer(unsigned(address_rom));
--		while not endfile(rom_file) loop --line_counter <= target_line loop
--				readline(rom_file,lineData);
--				read(lineData,readData);
--				if(line_counter = target_line) then
--				    dataROM <= readData;
--				end if;
--                line_counter := line_counter + 1;
--		end loop;
--		--dataROM <= readData;
--		file_close(rom_file);
--	end process;

end structural;