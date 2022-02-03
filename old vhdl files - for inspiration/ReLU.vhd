library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RELU is
generic( W: integer);
port (
    ofmap_in : in STD_LOGIC_VECTOR ( W-1 downto 0 );
    valid_ofmap : in STD_LOGIC;
    ofmap_relu : out STD_LOGIC_VECTOR ( W-1 downto 0 )
  );
end RELU;

architecture arch of RELU is

begin

process(valid_ofmap, ofmap_in)
begin
ofmap_relu <= (others => '0');
if(valid_ofmap = '1') then
    
    if (ofmap_in(W-1) ='1') then
    
    ofmap_relu <= (others => '0');
    else
    ofmap_relu <= ofmap_in;
    
    
    end if;

end if;

end process;


end arch;
