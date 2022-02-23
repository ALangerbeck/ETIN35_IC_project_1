



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP_matmult is 

    port (  clk     : in std_logic;
            rst     : in std_logic;
            input   : in std_logic_vector(7 downto 0);
            valid_input : in std_logic;
            ready  : out std_logic
         );

end TOP_matmult;

architecture TOP_matmult_arch of TOP_matmult is

-- SIGNAL DEFINITIONS

    signal result_1,result_2,result_3,result_4 : std_logic_vector(15 downto 0);
    signal internal_ready : std_logic;
    signal load : std_logic;
    signal rom_address: std_logic_vector(3 downto 0);
    signal romData : std_logic_vector(13 downto 0);
-- COMPONENT DEFINITION

    component Controller is 
    port (     clk     : in std_logic;
               rst     : in std_logic;
               input   : in std_logic_vector(7 downto 0);
               valid_input : in std_logic;
               -- Temporary...maybe..perhaps
               dataROM : in std_logic_vector(13 downto 0); 
               --
               load    : out std_logic;
               result_1 : out std_logic_vector(15 downto 0);
               result_2 : out std_logic_vector(15 downto 0);
               result_3 : out std_logic_vector(15 downto 0);
               result_4 : out std_logic_vector(15 downto 0);
               ready  : out std_logic;
               address_out: out std_logic_vector(3 downto 0)
         );
    end component;

    component RAM_ctrl is 
    port (  clk     : in std_logic;
            rst     : in std_logic;
            load    : in std_logic;
            result_1 : in std_logic_vector(15 downto 0);
            result_2 : in std_logic_vector(15 downto 0);
            result_3 : in std_logic_vector(15 downto 0);
            result_4 : in std_logic_vector(15 downto 0)
         );

    end component;
    
    component fake_ROM is
    port ( clk : in std_logic;
           address_input : in std_logic_vector(3 downto 0);
           dataRom_output : out std_logic_vector(13 downto 0)
         );
    end component;

begin
   
    inst_Controller : Controller
        port map(  
            clk     => clk,
            rst     => rst,
            input   => input,
            valid_input => valid_input,
            dataROM => romData,
            load    => load,
            result_1 => result_1,
            result_2 => result_2,
            result_3 => result_3,
            result_4 => result_4,
            ready  => ready,
            address_out => rom_address
         );

    inst_RAM_ctrl : RAM_ctrl 
    port map(  
            clk     => clk,
            rst     => rst,
            load    => load,
            result_1 => result_1,
            result_2 => result_2,
            result_3 => result_3,
            result_4 => result_4
         );
    inst_ROM : fake_rom
    port map(
        clk => clk,
        address_input => rom_address,
        dataRom_output => romData
    );

end TOP_matmult_arch;
