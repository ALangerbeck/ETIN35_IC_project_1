library ieee;
use ieee.std_logic_1164.all;

entity controller_tb is
end entity;


architecture structural of  controller_tb is


	--Signal Declaration
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal valid_input : std_logic := 0;
	signal load,ready : std_logic;
	signal input : std_logic_vector(7 downto 0) := (others => '0'); 
	signal dataROM : std_logic_vector(13 downto 0) := (others => '0');
	signal restult_1,restult_2,restult_3,restult_4: std_logic_vector(15 downto 0);
	
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

	DUT: controller port map(
		clk => clk,
		rst => rst,
		input => input,
		valid_input => valid_input,
		dataROM => dataROM,
		load => load,
		result_1 => result_1,
		result_1 => result_2,
		result_3 => result_3,
		result_4  => result_4,
		ready => ready );
		
		



end structural;