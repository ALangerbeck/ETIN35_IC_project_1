library ieee;
use ieee.std_logic_1164.all;

entity shift_reg_tb is
end entity;


architecture structural of  top_matmult_tb is


	--Signal Declaration
	
	--Component declaration
	component TOP_matmult is 
	
		port (  clk     : in std_logic;
				rst     : in std_logic;
				input   : in std_logic_vector(7 downto 0);
				dataRom : in std_logic_vector(13 downto 0);
				valid_input : in std_logic;
				ready  : out std_logic
			 );
	
	end component;
	
begin



end structural;