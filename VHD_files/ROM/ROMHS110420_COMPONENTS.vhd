--  
--  
--  ------------------------------------------------------------
--    STMicroelectronics N.V. 2011
--   All rights reserved. Reproduction in whole or part is prohibited  without the written consent of the copyright holder.                                                                                                                                                                                                                                                                                                                           
--    STMicroelectronics RESERVES THE RIGHTS TO MAKE CHANGES WITHOUT  NOTICE AT ANY TIME.
--  STMicroelectronics MAKES NO WARRANTY,  EXPRESSED, IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO ANY IMPLIED  WARRANTY OR MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE,  OR THAT THE USE WILL NOT INFRINGE ANY THIRD PARTY PATENT,  COPYRIGHT OR TRADEMARK.
--  STMicroelectronics SHALL NOT BE LIABLE  FOR ANY LOSS OR DAMAGE ARISING FROM THE USE OF ITS LIBRARIES OR  SOFTWARE.
--    STMicroelectronics
--   850, Rue Jean Monnet
--   BP 16 - 38921 Crolles Cedex - France
--   Central R&D / DAIS.
--                                                                                                                                                                                                                                                                                                                                                                             
--    
--  
--  ------------------------------------------------------------
--  
--  
--    User           : sophie dumont           
--    Project        : CMP_LUND_110420         
--    Division       : Not known               
--    Creation date  : 21 April 2011           
--    Generator mode : MemConfMAT10/distributed
--    
--    WebGen configuration            : C65LP_ST_ROMHS:320,26:MemConfMAT10/distributed:1.6-00
--  
--    HDL C65_ST_ROM Compiler version : 3.3@20081023.1 (UPT date)                             
--    
--  
--  For more information about the cuts or the generation environment, please
--  refer to files uk.env and ugnGuiSetupDB in directory DESIGN_DATA.
--   
--  
--  

        


library IEEE;
USE IEEE.STD_LOGIC_1164.all;

package ROMHS110420_COMPONENTS is

component ST_ROMHS_128x20m16_L
--synopsys synthesis_off
    GENERIC (
        InitFileName : String  := "ST_ROMHS_128x20m16_L.cde";
        BinaryInit : Natural := 1;
        InstancePath : String := "ST_ROMHS_128x20m16_L";
        Debug_Mode : String := "ALL_WARNING_MODE"
    );
--synopsys synthesis_on
    
    PORT (
        Q : OUT std_logic_vector(19 DOWNTO 0);
        CK : IN std_logic;
        CSN : IN std_logic;
        A : IN std_logic_vector(6 DOWNTO 0) 
    );

end component;
component ST_ROMHS_384x20m16_L
--synopsys synthesis_off
    GENERIC (
        InitFileName : String  := "ST_ROMHS_384x20m16_L.cde";
        BinaryInit : Natural := 1;
        InstancePath : String := "ST_ROMHS_384x20m16_L";
        Debug_Mode : String := "ALL_WARNING_MODE"
    );
--synopsys synthesis_on
    
    PORT (
        Q : OUT std_logic_vector(19 DOWNTO 0);
        CK : IN std_logic;
        CSN : IN std_logic;
        A : IN std_logic_vector(8 DOWNTO 0) 
    );

end component;

end ROMHS110420_COMPONENTS;

