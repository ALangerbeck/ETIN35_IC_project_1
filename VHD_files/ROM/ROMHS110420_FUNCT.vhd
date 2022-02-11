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

 

------------------------------------------------------------------------------
--  Function         : Entity FOR VHDL funct model OF ROM CMOS65 
--  Release Date     : Jun, 2006 
--  Last Modified By : AB
--  Version          : 3.0   
------------------------------------------------------------------------------

--------------------- START OF HEADER ---------------------------
-- This Header Gives Information about the parameters & options present in the Model

-- words = 128
-- bits  = 20
-- mux   = 16 
-- 
-- 
-----------------------------------------------------------------------

LIBRARY IEEE;                   USE IEEE.STD_LOGIC_1164.ALL;
                                USE IEEE.STD_LOGIC_ARITH.ALL;
                                USE IEEE.STD_LOGIC_TEXTIO.ALL;
LIBRARY STD;                    USE STD.TEXTIO.ALL;

ENTITY  ST_ROMHS_128x20m16_L IS

--synopsys synthesis_off
    GENERIC (
        Words : Natural := 128;
        Bits : Natural := 20;
        Addr : Natural := 7;
        
        Debug_Mode : String := "ALL_WARNING_MODE";
        InitFileName : String  := "ST_ROMHS_128x20m16_L.cde";
        BinaryInit : Natural := 1;
        InstancePath : String := "ST_ROMHS_128x20m16_L"
    );
--synopsys synthesis_on

    PORT (
        Q : OUT std_logic_vector(19 DOWNTO 0);
        CK : IN std_logic;
        CSN : IN std_logic;
        A : IN std_logic_vector(6 DOWNTO 0)    
    );
END ST_ROMHS_128x20m16_L;



        


LIBRARY IEEE;                   USE IEEE.STD_LOGIC_1164.ALL;
                                USE IEEE.STD_LOGIC_ARITH.ALL;
                                USE IEEE.STD_LOGIC_TEXTIO.ALL;
LIBRARY STD;                    USE STD.TEXTIO.ALL;
 
ARCHITECTURE VHDL_FUNCT of ST_ROMHS_128x20m16_L IS
 
--synopsys synthesis_off
 
    SIGNAL Aint : std_logic_vector(Addr-1 DOWNTO 0);
    SIGNAL CKint : std_logic;
    SIGNAL CSint : std_logic;
    SIGNAL CSNint : std_logic;
    SIGNAL CKint_rising : std_logic;
    SIGNAL Qint : std_logic_vector(Bits-1 DOWNTO 0);
    
       
    SIGNAL debug_level : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
    
-- check for Valid address

 FUNCTION AddrFilter(Input : std_logic_vector) RETURN std_logic_vector IS
    VARIABLE UFound : Boolean := FALSE;
    VARIABLE Output : std_logic_vector(Input'RANGE);
  BEGIN
        FOR i IN Input'RANGE LOOP
            IF (Input(i) = 'U') then
                UFound := TRUE;
                EXIT;
            END IF;
        END LOOP;
         IF (UFound) THEN
             Output := (OTHERS => 'U');
           ELSIF (is_x(Input)) THEN
             Output := (OTHERS => 'X');
           ELSE
             Output := to_x01(Input);
        END IF;
        RETURN Output;
  END AddrFilter;
 
   -- This function is taken from STD_LOGIC_ARITH package
   -- found in Cadence's Leapfrog installation (library IEEE).
   -- It returns the integer value of the oper.
   -- If size > 31 take only lower 31 bits
   -- If in oper, there is any element of value 'X' or 'Z', then
   -- value 0 will be returned.
-- Binary address to integer
 
  FUNCTION to_integer (oper : std_logic_vector) return integer is
      VARIABLE value     : integer := 0;
      VARIABLE temp_no   : integer := 1;
      VARIABLE temp_oper : std_logic_vector(oper'range) := oper;
      VARIABLE index     : integer := 1;
   BEGIN
      ASSERT ((FALSE) or (oper'length <= 31)) REPORT "(" & InstancePath & ")" &  " Argument is too large in to_integer, only lower 31 bits will be taken. " SEVERITY WARNING;
 
      IF (not (is_X(oper))) THEN
         FOR i IN temp_oper'reverse_range LOOP
            CASE (temp_oper(I)) IS
               WHEN '1' =>
                  value := value + temp_no;
               WHEN others =>
                  null;
            END CASE;
               index := index + 1;
               EXIT when index > 31;
               temp_no := temp_no + temp_no;
         END LOOP;
      ELSE
         ASSERT (FALSE) REPORT "(" & InstancePath & ")" &  " Illegal value detected in the conversion of to_integer. " SEVERITY WARNING;
         value := 0;
      END IF;
      RETURN (value);
   END to_integer;
-- HEX code file reading
 
PROCEDURE Char2QuadBits(C: Character; RESULT: out Bit_Vector(3 downto 0); GOOD: out Boolean; ISSUE_ERROR: in Boolean) IS
  BEGIN
   CASE c IS
        WHEN '0' => RESULT :=  x"0"; good := TRUE;
        WHEN '1' => RESULT :=  x"1"; good := TRUE;
        WHEN '2' => RESULT :=  x"2"; good := TRUE;
        WHEN '3' => RESULT :=  x"3"; good := TRUE;
        WHEN '4' => RESULT :=  x"4"; good := TRUE;
        WHEN '5' => RESULT :=  x"5"; good := TRUE;
        WHEN '6' => RESULT :=  x"6"; good := TRUE;
        WHEN '7' => RESULT :=  x"7"; good := TRUE;
        WHEN '8' => RESULT :=  x"8"; good := TRUE;
        WHEN '9' => RESULT :=  x"9"; good := TRUE;
        WHEN 'A' => RESULT :=  x"A"; good := TRUE;
        WHEN 'B' => RESULT :=  x"B"; good := TRUE;
        WHEN 'C' => RESULT :=  x"C"; good := TRUE;
        WHEN 'D' => RESULT :=  x"D"; good := TRUE;
        WHEN 'E' => RESULT :=  x"E"; good := TRUE;
        WHEN 'F' => RESULT :=  x"F"; good := TRUE;

        WHEN 'a' => RESULT :=  x"A"; good := TRUE;
        WHEN 'b' => RESULT :=  x"B"; good := TRUE;
        WHEN 'c' => RESULT :=  x"C"; good := TRUE;
        WHEN 'd' => RESULT :=  x"D"; good := TRUE;
        WHEN 'e' => RESULT :=  x"E"; good := TRUE;
        WHEN 'f' => RESULT :=  x"F"; good := TRUE;
             WHEN others =>
          IF ISSUE_ERROR THEN
                ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 801 ) HREAD Error: Read a '" & c & "' , expected a Hex character (0-F). " SEVERITY WARNING;
          END IF;
              good := FALSE;
      END CASE;
  END Char2QuadBits;

-- Reading Hex code file
PROCEDURE HREAD(L:inout LINE; VALUE:out BIT_VECTOR;GOOD: out BOOLEAN) is
        VARIABLE ok: boolean;
        VARIABLE c:  character;
        CONSTANT ne: integer := (value'length-1)/4;
        VARIABLE bv: bit_vector(0 to value'length-1);
        VARIABLE s:  string(1 to ne);
    BEGIN
        LOOP                                    -- skip white space
                read(l,c);
                EXIT when ((c /= ' ') and (c /= CR) and (c /= HT));
        END LOOP;

     Char2QuadBits(c, bv(0 to 3), ok, TRUE);
        IF not ok THEN
                good := FALSE;
                RETURN;
        END IF;
   if ( ne >= 1) then
     read(L, s, ok);
        if not ok then
              good := FALSE;
              return;
        end if;
   end if;
   
     if value'length mod 4 /= 0 then
        for i in 1 to ne-1 loop
                Char2QuadBits(s(i), bv(4*i to 4*i+3), ok, TRUE);
                if not ok then
                        good := FALSE;
                        return;
                end if;
        end loop;
      else
       for i in 1 to ne loop
                Char2QuadBits(s(i), bv(4*i to 4*i+3), ok, TRUE);
                if not ok then
                        good := FALSE;
                        return;
                end if;
        end loop;
       end if;
        good := TRUE;
        value := bv;
end HREAD;

--synopsys synthesis_on

BEGIN

--synopsys synthesis_off

  Filter : BLOCK
      BEGIN
          CKint <= to_ux01(CK);
          CSNint <= to_ux01(CSN);
          CSint <= NOT CSNint;
          
          
          Aint <= AddrFilter(A);
      END BLOCK;



-------------------  READ PROCESS -------------------------
 
ReadProc: PROCESS (CKint, CSint  )
 
   SUBTYPE MType IS std_logic_vector(Q'RANGE);
   TYPE MemType IS ARRAY (0 TO Words-1) OF MType;

   CONSTANT WordX : std_logic_vector(Q'RANGE) := (OTHERS => 'X');
   CONSTANT WordU : std_logic_vector(Q'RANGE) := (OTHERS => 'U');
   VARIABLE isMessageDisplayed : BOOLEAN := FALSE;
   VARIABLE INFO_LINE : LINE;
   file OUTPUT: TEXT  open WRITE_MODE is "STD_OUTPUT";
 
   FUNCTION InitMem (FileName : String; debug_level : std_logic_vector(1 DOWNTO 0)) RETURN MemType IS
 
       FILE     InitFile : Text;
       VARIABLE InitLine : Line;
       VARIABLE Address : Natural;
       VARIABLE Value1 : Mtype;
       VARIABLE Value2 : MType;
       VARIABLE Contents : MemType;
       VARIABLE Good : Boolean;
       VARIABLE tmp: STD_ULOGIC_VECTOR(((((Bits-1)/4)+1)*4 - 1) DOWNTO 0);
       VARIABLE tmp1: STD_ULOGIC_VECTOR((Bits-1) DOWNTO 0);
       VARIABLE fileOpenStatus : FILE_OPEN_STATUS := NAME_ERROR;
       VARIABLE mode : FILE_OPEN_KIND := READ_MODE;


   BEGIN

       -- file format is:
       -- one <value> per line starting at <address>=0
       -- <value> is a std_logic_vector
       -- expressed according to parameter <Format>:
       -- BinaryInit = 1 means Binary (default)
       -- BinaryInit = 0 means Hexadecimal

       FILE_OPEN(fileOpenStatus,InitFile, InitFileName, mode);
       Address := 0;
       ReadFile: WHILE (NOT ENDFILE(InitFile)) LOOP
           readline(InitFile, InitLine);
           Good := TRUE;
           CASE BinaryInit IS
               WHEN 1 =>
                   read(InitLine, Value2, Good);
               WHEN 0 =>
                   HREAD(InitLine, tmp, GOOD);
                   for j in 0 to bits-1 loop
                     tmp1(j) := tmp(j);
                   end loop;
                   Value1 := STD_LOGIC_VECTOR(tmp1);

               WHEN OTHERS =>
                   ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 802 ) ROM Init failed: bad format. " SEVERITY FAILURE;
           END CASE;
           IF Good THEN
               IF (Address = Words) THEN
                   ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 803 ) Too many data words in the personality file. " SEVERITY FAILURE;
               END IF;
               CASE BinaryInit IS
                   WHEN 1 =>
                       Contents(Address) := Value2;
                   WHEN 0 =>
                       Contents(Address) := Value1;        -- (Q'left downto 0);
                   WHEN OTHERS =>
                       NULL;
               END CASE;
           ELSE
               ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 802 ) ROM Initialization : Data Read failed " SEVERITY FAILURE;
           END IF;
           Address := Address+1;
       END LOOP ReadFile;

       IF (Address /= Words) THEN
           ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 804 ) Words in the personality file less than that given by address bounds. " SEVERITY FAILURE;
       END IF;
       RETURN Contents;
   END InitMem;

-------------------------------------- ROM INITIALIZATION ------------------
 
      VARIABLE Mem : MemType;
 
--------------------------------------- READ PROCEDURE --------------------
 
PROCEDURE ReadCycle (CONSTANT Address : IN std_logic_vector) IS
    VARIABLE V_Location : Integer;

BEGIN

    CASE Address(0) IS

        WHEN 'U' =>
            Qint <= TRANSPORT WordX AFTER 1 ns;
            ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 010 ) Illegal Value on Address Bus during Read Cycle. Output Corrupted " SEVERITY WARNING;
        WHEN 'X' =>
            Qint <= TRANSPORT WordX AFTER 1 ns;
            ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 010 ) Illegal Value on Address Bus during Read Cycle. Output Corrupted " SEVERITY WARNING;
        WHEN OTHERS =>
            V_Location := to_integer(Address);
            IF (V_Location >= Words) THEN
                ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 703 ) Address Out Of Range during Read Cycle. Output Corrupted " SEVERITY WARNING;
                Qint <= TRANSPORT WordX AFTER 1 ns;
            ELSE
                Qint   <= TRANSPORT (Mem(V_Location)) AFTER 1 ns;
            END IF;
 
    END CASE;

END ReadCycle;
 
-----------------------------------------------------------
 
 BEGIN
     --------------ROM INITIALIZATION------------
     IF (NOW = 0 ns) THEN
        Mem := InitMem(InitFileName, debug_level);
     END IF;

     --------------------------------------------  

     IF (debug_mode = "ALL_WARNING_MODE") THEN
     debug_level <= (Others => '0');
     ELSIF (debug_mode = "NO_WARNING_MODE") THEN
     debug_level <= "10";  
     END IF; 

     --Display of messages at 0 time
     IF (NOW = 0 ns AND NOT(isMessageDisplayed)) THEN
         isMessageDisplayed := TRUE;
         WRITE(INFO_LINE, InstancePath);
         WRITE(INFO_LINE, STRING'(" : INFORMATION"));
         WRITELINE(OUTPUT, INFO_LINE);

         WRITE(INFO_LINE, STRING'("*******************************"));
         WRITELINE(OUTPUT, INFO_LINE); 
  
         WRITE(INFO_LINE, STRING'("This is a purely FUNCTIONAL MODEL"));
         WRITELINE(OUTPUT, INFO_LINE);

         IF(debug_mode = "ALL_WARNING_MODE") THEN
            WRITE(INFO_LINE, STRING'("All Messages are Switched ON"));
         ELSIF(debug_mode = "NO_WARNING_MODE") THEN
            WRITE(INFO_LINE, STRING'("All Messages are Switched OFF"));
         END IF;  
         WRITELINE(OUTPUT, INFO_LINE);
     END IF;    
     
     
        
            IF (CKint'EVENT AND CSint /= '0') THEN
                IF rising_edge(CKint) THEN
                   CKint_rising <= '1';
                   IF (CSint = '1') THEN
                       
                           ReadCycle( Address  => Aint);
                           
                   ELSIF is_x(CSint) THEN
                       IF (CSint = 'X') THEN
                          ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 001 ) Illegal Value on Chip Select. Output Corrupted " SEVERITY WARNING;
                          Qint <= TRANSPORT WordX AFTER 1 ns;
                       ELSE
                          ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 001 ) Illegal Value on Chip Select. Output Corrupted " SEVERITY WARNING;
                          Qint <= TRANSPORT WordU AFTER 1 ns;
                       END IF;
                   END IF;
                ELSIF is_x(CKint) THEN
                   ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 003 ) Illegal Value on Clock. Output Corrupted " SEVERITY WARNING;
                   Qint <= TRANSPORT WordX AFTER 1 ns;
                END IF;
            END IF;
        

     IF (CSint'EVENT) THEN
         IF ((CSint /= '0') AND is_x(CKint)) THEN
             Qint <= TRANSPORT WordX AFTER 1 ns;
         END IF;
     END IF;

     

 END PROCESS ReadProc;
  
  
 QUpdate : PROCESS(Qint)
 BEGIN
    Q <= Qint;
 END PROCESS QUpdate; 
        
---------------------------------------------------------------------- 
--
--                      WARNING MESSAGES LIST
--                      =====================
--
-- (InstancePath-1)  Bad Format of initialization file
--
-- (InstancePath-2)  Data Read Failed
--
-- (InstancePath-3)  Illegal Address bit during Read cycle
--
-- (InstancePath-4)  Address out of range during Read cycle
--
----------------------------------------------------------------------
--synopsys synthesis_on
END VHDL_FUNCT;



        

CONFIGURATION CfG_ST_ROMHS_128x20m16_L_VHDL_FUNCT OF ST_ROMHS_128x20m16_L IS
    FOR VHDL_FUNCT
    END FOR;
END CfG_ST_ROMHS_128x20m16_L_VHDL_FUNCT;

CONFIGURATION CfG_ST_ROMHS_128x20m16_L OF ST_ROMHS_128x20m16_L IS
    FOR VHDL_FUNCT
    END FOR;
END CfG_ST_ROMHS_128x20m16_L;



 

------------------------------------------------------------------------------
--  Function         : Entity FOR VHDL funct model OF ROM CMOS65 
--  Release Date     : Jun, 2006 
--  Last Modified By : AB
--  Version          : 3.0   
------------------------------------------------------------------------------

--------------------- START OF HEADER ---------------------------
-- This Header Gives Information about the parameters & options present in the Model

-- words = 384
-- bits  = 20
-- mux   = 16 
-- 
-- 
-----------------------------------------------------------------------

LIBRARY IEEE;                   USE IEEE.STD_LOGIC_1164.ALL;
                                USE IEEE.STD_LOGIC_ARITH.ALL;
                                USE IEEE.STD_LOGIC_TEXTIO.ALL;
LIBRARY STD;                    USE STD.TEXTIO.ALL;

ENTITY  ST_ROMHS_384x20m16_L IS

--synopsys synthesis_off
    GENERIC (
        Words : Natural := 384;
        Bits : Natural := 20;
        Addr : Natural := 9;
        
        Debug_Mode : String := "ALL_WARNING_MODE";
        InitFileName : String  := "ST_ROMHS_384x20m16_L.cde";
        BinaryInit : Natural := 1;
        InstancePath : String := "ST_ROMHS_384x20m16_L"
    );
--synopsys synthesis_on

    PORT (
        Q : OUT std_logic_vector(19 DOWNTO 0);
        CK : IN std_logic;
        CSN : IN std_logic;
        A : IN std_logic_vector(8 DOWNTO 0)    
    );
END ST_ROMHS_384x20m16_L;



        


LIBRARY IEEE;                   USE IEEE.STD_LOGIC_1164.ALL;
                                USE IEEE.STD_LOGIC_ARITH.ALL;
                                USE IEEE.STD_LOGIC_TEXTIO.ALL;
LIBRARY STD;                    USE STD.TEXTIO.ALL;
 
ARCHITECTURE VHDL_FUNCT of ST_ROMHS_384x20m16_L IS
 
--synopsys synthesis_off
 
    SIGNAL Aint : std_logic_vector(Addr-1 DOWNTO 0);
    SIGNAL CKint : std_logic;
    SIGNAL CSint : std_logic;
    SIGNAL CSNint : std_logic;
    SIGNAL CKint_rising : std_logic;
    SIGNAL Qint : std_logic_vector(Bits-1 DOWNTO 0);
    
       
    SIGNAL debug_level : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
    
-- check for Valid address

 FUNCTION AddrFilter(Input : std_logic_vector) RETURN std_logic_vector IS
    VARIABLE UFound : Boolean := FALSE;
    VARIABLE Output : std_logic_vector(Input'RANGE);
  BEGIN
        FOR i IN Input'RANGE LOOP
            IF (Input(i) = 'U') then
                UFound := TRUE;
                EXIT;
            END IF;
        END LOOP;
         IF (UFound) THEN
             Output := (OTHERS => 'U');
           ELSIF (is_x(Input)) THEN
             Output := (OTHERS => 'X');
           ELSE
             Output := to_x01(Input);
        END IF;
        RETURN Output;
  END AddrFilter;
 
   -- This function is taken from STD_LOGIC_ARITH package
   -- found in Cadence's Leapfrog installation (library IEEE).
   -- It returns the integer value of the oper.
   -- If size > 31 take only lower 31 bits
   -- If in oper, there is any element of value 'X' or 'Z', then
   -- value 0 will be returned.
-- Binary address to integer
 
  FUNCTION to_integer (oper : std_logic_vector) return integer is
      VARIABLE value     : integer := 0;
      VARIABLE temp_no   : integer := 1;
      VARIABLE temp_oper : std_logic_vector(oper'range) := oper;
      VARIABLE index     : integer := 1;
   BEGIN
      ASSERT ((FALSE) or (oper'length <= 31)) REPORT "(" & InstancePath & ")" &  " Argument is too large in to_integer, only lower 31 bits will be taken. " SEVERITY WARNING;
 
      IF (not (is_X(oper))) THEN
         FOR i IN temp_oper'reverse_range LOOP
            CASE (temp_oper(I)) IS
               WHEN '1' =>
                  value := value + temp_no;
               WHEN others =>
                  null;
            END CASE;
               index := index + 1;
               EXIT when index > 31;
               temp_no := temp_no + temp_no;
         END LOOP;
      ELSE
         ASSERT (FALSE) REPORT "(" & InstancePath & ")" &  " Illegal value detected in the conversion of to_integer. " SEVERITY WARNING;
         value := 0;
      END IF;
      RETURN (value);
   END to_integer;
-- HEX code file reading
 
PROCEDURE Char2QuadBits(C: Character; RESULT: out Bit_Vector(3 downto 0); GOOD: out Boolean; ISSUE_ERROR: in Boolean) IS
  BEGIN
   CASE c IS
        WHEN '0' => RESULT :=  x"0"; good := TRUE;
        WHEN '1' => RESULT :=  x"1"; good := TRUE;
        WHEN '2' => RESULT :=  x"2"; good := TRUE;
        WHEN '3' => RESULT :=  x"3"; good := TRUE;
        WHEN '4' => RESULT :=  x"4"; good := TRUE;
        WHEN '5' => RESULT :=  x"5"; good := TRUE;
        WHEN '6' => RESULT :=  x"6"; good := TRUE;
        WHEN '7' => RESULT :=  x"7"; good := TRUE;
        WHEN '8' => RESULT :=  x"8"; good := TRUE;
        WHEN '9' => RESULT :=  x"9"; good := TRUE;
        WHEN 'A' => RESULT :=  x"A"; good := TRUE;
        WHEN 'B' => RESULT :=  x"B"; good := TRUE;
        WHEN 'C' => RESULT :=  x"C"; good := TRUE;
        WHEN 'D' => RESULT :=  x"D"; good := TRUE;
        WHEN 'E' => RESULT :=  x"E"; good := TRUE;
        WHEN 'F' => RESULT :=  x"F"; good := TRUE;

        WHEN 'a' => RESULT :=  x"A"; good := TRUE;
        WHEN 'b' => RESULT :=  x"B"; good := TRUE;
        WHEN 'c' => RESULT :=  x"C"; good := TRUE;
        WHEN 'd' => RESULT :=  x"D"; good := TRUE;
        WHEN 'e' => RESULT :=  x"E"; good := TRUE;
        WHEN 'f' => RESULT :=  x"F"; good := TRUE;
             WHEN others =>
          IF ISSUE_ERROR THEN
                ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 801 ) HREAD Error: Read a '" & c & "' , expected a Hex character (0-F). " SEVERITY WARNING;
          END IF;
              good := FALSE;
      END CASE;
  END Char2QuadBits;

-- Reading Hex code file
PROCEDURE HREAD(L:inout LINE; VALUE:out BIT_VECTOR;GOOD: out BOOLEAN) is
        VARIABLE ok: boolean;
        VARIABLE c:  character;
        CONSTANT ne: integer := (value'length-1)/4;
        VARIABLE bv: bit_vector(0 to value'length-1);
        VARIABLE s:  string(1 to ne);
    BEGIN
        LOOP                                    -- skip white space
                read(l,c);
                EXIT when ((c /= ' ') and (c /= CR) and (c /= HT));
        END LOOP;

     Char2QuadBits(c, bv(0 to 3), ok, TRUE);
        IF not ok THEN
                good := FALSE;
                RETURN;
        END IF;
   if ( ne >= 1) then
     read(L, s, ok);
        if not ok then
              good := FALSE;
              return;
        end if;
   end if;
   
     if value'length mod 4 /= 0 then
        for i in 1 to ne-1 loop
                Char2QuadBits(s(i), bv(4*i to 4*i+3), ok, TRUE);
                if not ok then
                        good := FALSE;
                        return;
                end if;
        end loop;
      else
       for i in 1 to ne loop
                Char2QuadBits(s(i), bv(4*i to 4*i+3), ok, TRUE);
                if not ok then
                        good := FALSE;
                        return;
                end if;
        end loop;
       end if;
        good := TRUE;
        value := bv;
end HREAD;

--synopsys synthesis_on

BEGIN

--synopsys synthesis_off

  Filter : BLOCK
      BEGIN
          CKint <= to_ux01(CK);
          CSNint <= to_ux01(CSN);
          CSint <= NOT CSNint;
          
          
          Aint <= AddrFilter(A);
      END BLOCK;



-------------------  READ PROCESS -------------------------
 
ReadProc: PROCESS (CKint, CSint  )
 
   SUBTYPE MType IS std_logic_vector(Q'RANGE);
   TYPE MemType IS ARRAY (0 TO Words-1) OF MType;

   CONSTANT WordX : std_logic_vector(Q'RANGE) := (OTHERS => 'X');
   CONSTANT WordU : std_logic_vector(Q'RANGE) := (OTHERS => 'U');
   VARIABLE isMessageDisplayed : BOOLEAN := FALSE;
   VARIABLE INFO_LINE : LINE;
   file OUTPUT: TEXT  open WRITE_MODE is "STD_OUTPUT";
 
   FUNCTION InitMem (FileName : String; debug_level : std_logic_vector(1 DOWNTO 0)) RETURN MemType IS
 
       FILE     InitFile : Text;
       VARIABLE InitLine : Line;
       VARIABLE Address : Natural;
       VARIABLE Value1 : Mtype;
       VARIABLE Value2 : MType;
       VARIABLE Contents : MemType;
       VARIABLE Good : Boolean;
       VARIABLE tmp: STD_ULOGIC_VECTOR(((((Bits-1)/4)+1)*4 - 1) DOWNTO 0);
       VARIABLE tmp1: STD_ULOGIC_VECTOR((Bits-1) DOWNTO 0);
       VARIABLE fileOpenStatus : FILE_OPEN_STATUS := NAME_ERROR;
       VARIABLE mode : FILE_OPEN_KIND := READ_MODE;


   BEGIN

       -- file format is:
       -- one <value> per line starting at <address>=0
       -- <value> is a std_logic_vector
       -- expressed according to parameter <Format>:
       -- BinaryInit = 1 means Binary (default)
       -- BinaryInit = 0 means Hexadecimal

       FILE_OPEN(fileOpenStatus,InitFile, InitFileName, mode);
       Address := 0;
       ReadFile: WHILE (NOT ENDFILE(InitFile)) LOOP
           readline(InitFile, InitLine);
           Good := TRUE;
           CASE BinaryInit IS
               WHEN 1 =>
                   read(InitLine, Value2, Good);
               WHEN 0 =>
                   HREAD(InitLine, tmp, GOOD);
                   for j in 0 to bits-1 loop
                     tmp1(j) := tmp(j);
                   end loop;
                   Value1 := STD_LOGIC_VECTOR(tmp1);

               WHEN OTHERS =>
                   ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 802 ) ROM Init failed: bad format. " SEVERITY FAILURE;
           END CASE;
           IF Good THEN
               IF (Address = Words) THEN
                   ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 803 ) Too many data words in the personality file. " SEVERITY FAILURE;
               END IF;
               CASE BinaryInit IS
                   WHEN 1 =>
                       Contents(Address) := Value2;
                   WHEN 0 =>
                       Contents(Address) := Value1;        -- (Q'left downto 0);
                   WHEN OTHERS =>
                       NULL;
               END CASE;
           ELSE
               ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 802 ) ROM Initialization : Data Read failed " SEVERITY FAILURE;
           END IF;
           Address := Address+1;
       END LOOP ReadFile;

       IF (Address /= Words) THEN
           ASSERT (to_integer(debug_level) >= 3) REPORT "(" & InstancePath & ")" &  " (MSG_ID 804 ) Words in the personality file less than that given by address bounds. " SEVERITY FAILURE;
       END IF;
       RETURN Contents;
   END InitMem;

-------------------------------------- ROM INITIALIZATION ------------------
 
      VARIABLE Mem : MemType;
 
--------------------------------------- READ PROCEDURE --------------------
 
PROCEDURE ReadCycle (CONSTANT Address : IN std_logic_vector) IS
    VARIABLE V_Location : Integer;

BEGIN

    CASE Address(0) IS

        WHEN 'U' =>
            Qint <= TRANSPORT WordX AFTER 1 ns;
            ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 010 ) Illegal Value on Address Bus during Read Cycle. Output Corrupted " SEVERITY WARNING;
        WHEN 'X' =>
            Qint <= TRANSPORT WordX AFTER 1 ns;
            ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 010 ) Illegal Value on Address Bus during Read Cycle. Output Corrupted " SEVERITY WARNING;
        WHEN OTHERS =>
            V_Location := to_integer(Address);
            IF (V_Location >= Words) THEN
                ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 703 ) Address Out Of Range during Read Cycle. Output Corrupted " SEVERITY WARNING;
                Qint <= TRANSPORT WordX AFTER 1 ns;
            ELSE
                Qint   <= TRANSPORT (Mem(V_Location)) AFTER 1 ns;
            END IF;
 
    END CASE;

END ReadCycle;
 
-----------------------------------------------------------
 
 BEGIN
     --------------ROM INITIALIZATION------------
     IF (NOW = 0 ns) THEN
        Mem := InitMem(InitFileName, debug_level);
     END IF;

     --------------------------------------------  

     IF (debug_mode = "ALL_WARNING_MODE") THEN
     debug_level <= (Others => '0');
     ELSIF (debug_mode = "NO_WARNING_MODE") THEN
     debug_level <= "10";  
     END IF; 

     --Display of messages at 0 time
     IF (NOW = 0 ns AND NOT(isMessageDisplayed)) THEN
         isMessageDisplayed := TRUE;
         WRITE(INFO_LINE, InstancePath);
         WRITE(INFO_LINE, STRING'(" : INFORMATION"));
         WRITELINE(OUTPUT, INFO_LINE);

         WRITE(INFO_LINE, STRING'("*******************************"));
         WRITELINE(OUTPUT, INFO_LINE); 
  
         WRITE(INFO_LINE, STRING'("This is a purely FUNCTIONAL MODEL"));
         WRITELINE(OUTPUT, INFO_LINE);

         IF(debug_mode = "ALL_WARNING_MODE") THEN
            WRITE(INFO_LINE, STRING'("All Messages are Switched ON"));
         ELSIF(debug_mode = "NO_WARNING_MODE") THEN
            WRITE(INFO_LINE, STRING'("All Messages are Switched OFF"));
         END IF;  
         WRITELINE(OUTPUT, INFO_LINE);
     END IF;    
     
     
        
            IF (CKint'EVENT AND CSint /= '0') THEN
                IF rising_edge(CKint) THEN
                   CKint_rising <= '1';
                   IF (CSint = '1') THEN
                       
                           ReadCycle( Address  => Aint);
                           
                   ELSIF is_x(CSint) THEN
                       IF (CSint = 'X') THEN
                          ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 001 ) Illegal Value on Chip Select. Output Corrupted " SEVERITY WARNING;
                          Qint <= TRANSPORT WordX AFTER 1 ns;
                       ELSE
                          ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 001 ) Illegal Value on Chip Select. Output Corrupted " SEVERITY WARNING;
                          Qint <= TRANSPORT WordU AFTER 1 ns;
                       END IF;
                   END IF;
                ELSIF is_x(CKint) THEN
                   ASSERT ((NOW = 0 ns) or (to_integer(debug_level) >= 2)) REPORT "(" & InstancePath & ")" &  " (MSG_ID 003 ) Illegal Value on Clock. Output Corrupted " SEVERITY WARNING;
                   Qint <= TRANSPORT WordX AFTER 1 ns;
                END IF;
            END IF;
        

     IF (CSint'EVENT) THEN
         IF ((CSint /= '0') AND is_x(CKint)) THEN
             Qint <= TRANSPORT WordX AFTER 1 ns;
         END IF;
     END IF;

     

 END PROCESS ReadProc;
  
  
 QUpdate : PROCESS(Qint)
 BEGIN
    Q <= Qint;
 END PROCESS QUpdate; 
        
---------------------------------------------------------------------- 
--
--                      WARNING MESSAGES LIST
--                      =====================
--
-- (InstancePath-1)  Bad Format of initialization file
--
-- (InstancePath-2)  Data Read Failed
--
-- (InstancePath-3)  Illegal Address bit during Read cycle
--
-- (InstancePath-4)  Address out of range during Read cycle
--
----------------------------------------------------------------------
--synopsys synthesis_on
END VHDL_FUNCT;



        

CONFIGURATION CfG_ST_ROMHS_384x20m16_L_VHDL_FUNCT OF ST_ROMHS_384x20m16_L IS
    FOR VHDL_FUNCT
    END FOR;
END CfG_ST_ROMHS_384x20m16_L_VHDL_FUNCT;

CONFIGURATION CfG_ST_ROMHS_384x20m16_L OF ST_ROMHS_384x20m16_L IS
    FOR VHDL_FUNCT
    END FOR;
END CfG_ST_ROMHS_384x20m16_L;


