library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CONV_Controller is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    start_in : in STD_LOGIC ;
    data_1 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    data_2 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    data_3 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    data_4 : out STD_LOGIC_VECTOR ( 63 downto 0 );
    address_1 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    address_2 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    address_3 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    address_4 : out STD_LOGIC_VECTOR ( 3 downto 0 );

    wen_1 : out STD_LOGIC := '0';
    wen_2 : out STD_LOGIC := '0';
    wen_3 : out STD_LOGIC := '0';
    wen_4 : out STD_LOGIC := '0';
    finish : out STD_LOGIC := '0';
    count_def : out STD_LOGIC_VECTOR ( 1 downto 0 ) ;
    count_PE : out STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0')
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of CONV_Controller : entity is true;

  
end CONV_Controller;
  
architecture arch of CONV_Controller is

signal address_1_next :    unsigned ( 3 downto 0 );
signal address_2_next :    unsigned ( 3 downto 0 );
signal address_3_next :    unsigned ( 3 downto 0 );
signal address_4_next :    unsigned ( 3 downto 0 );
signal address_1_current : unsigned ( 3 downto 0 );
signal address_2_current : unsigned ( 3 downto 0 );
signal address_3_current : unsigned ( 3 downto 0 );
signal address_4_current : unsigned ( 3 downto 0 );

signal count_def_next : unsigned( 1 downto 0 );
signal count_def_current : unsigned ( 1 downto 0 );
signal count_PE_next : unsigned ( 7 downto 0 );
signal count_PE_current : unsigned( 7 downto 0 );

TYPE State_type IS (s_init, s_count, s_finish);  -- Define the states
SIGNAL current_state, next_state  : State_type;
 

begin 

process(clk, rst)
begin

    if (rst = '1') then
    
        current_state <= s_init;
         address_1_current <= (others=>'0');
         address_2_current<= (others=>'0');
         address_3_current<= (others=>'0');
         address_4_current<= (others=>'0');
         count_def_current<= (others=>'0');
         count_PE_current <=  (others=>'0');
    elsif (rising_edge(clk)) then
    
        address_1_current<= address_1_next;
        address_2_current<= address_2_next;
        address_3_current<= address_3_next;
        address_4_current<= address_4_next;
        count_def_current<= count_def_next;
        count_PE_current <=  count_PE_next;
        current_state <= next_state;
        
    end if;

end process;

process(start_in, current_state, count_PE_current, count_def_current,address_1_current, address_2_current,address_3_current,address_4_current)

begin
next_state <= current_state;
address_1_next <=  address_1_current;
address_2_next <=  address_2_current;
address_3_next <= address_3_current;
address_4_next <=  address_4_current;
      case current_state is
                when s_init =>
                    address_1_next<= (others=>'0');
                    address_2_next<= (others=>'0');
                    address_3_next<= (others=>'0');
                    address_4_next<= (others=>'0');
                    count_def_next<= (others=>'0');
                    count_PE_next <= (others=>'0');
                    
                    if start_in = '1' then
                        next_state <= s_count;    
                    end if;
                    finish <= '0';
                  when s_count => 
                  --output logic counter PE and def
                  if  count_PE_current = 243 then
                  
                    count_PE_next <= (others=>'0');
                    count_def_next <= count_def_current+1;
                  --output logic address
                     case count_def_current is
                          when "00" =>
                              address_1_next <= address_1_current +1;
--                              address_2_next <=  address_2_current;
--                              address_3_next <= address_3_current;
--                              address_4_next <=  address_4_current;
                          when "01" =>
--                                  address_1_next <= address_1_current;
                                  address_2_next <= address_2_current +1; 
--                                  address_3_next <= address_3_current;
--                                  address_4_next <=  address_4_current;  
                          when "10" =>
--                                  address_1_next <= address_1_current;
--                                  address_2_next <=  address_2_current;                        
                                  address_3_next <= address_3_current +1;
--                                  address_4_next <=  address_4_current;  
                                    
                          when "11" =>
--                                  address_1_next <= address_1_current;
--                                  address_2_next <=  address_2_current;
--                                  address_3_next <= address_3_current;                      
                                  address_4_next <= address_4_current +1;
                          when others =>
                          address_1_next <= address_1_current;
                          address_2_next <=  address_2_current;
                          address_3_next <= address_3_current;                      
                          address_4_next <= address_4_current;                                          
                       end case;
                    
                  else
                     count_PE_next <= count_PE_current + 1;
                     count_def_next <= count_def_current;
                     address_1_next <= address_1_current;
                     address_2_next <=  address_2_current;
                     address_3_next <= address_3_current;                      
                     address_4_next <= address_4_current;                                          

                  end if;
                     
                    if  count_PE_current = 243 and address_4_current = "1111" then
                    next_state <= s_finish;
                    end if;    
                    finish <= '0';
                    
                    
                  when s_finish =>
                  finish <= '1';
                  next_state<= s_init;
                         
       end case;
count_PE <= std_logic_vector(count_PE_current);
count_def <= std_logic_vector(count_def_current);
address_1 <= std_logic_vector(address_1_current);
address_2 <= std_logic_vector(address_2_current);
address_3 <= std_logic_vector(address_3_current);
address_4 <= std_logic_vector(address_4_current);

end process;


end arch;