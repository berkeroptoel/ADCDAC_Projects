
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY cordic_rotation IS
  PORT( clk                               :   IN    std_logic;
        resetn                            :   IN    std_logic;
        start                             :   in    std_logic;
        xin                               :   in    std_logic_vector(31 downto 0);
        yin                               :   in    std_logic_vector(31 downto 0);
        zin                               :   in    std_logic_vector(31 downto 0);
        done_out                          :   OUT   std_logic:='0';
        sin_out                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix16_En15
        cos_out                           :   OUT   std_logic_vector(31 DOWNTO 0)
        );
END cordic_rotation;



ARCHITECTURE rtl OF cordic_rotation IS

    --atan:fi(x,1,16,15)
    TYPE signed_array IS ARRAY (natural RANGE <> ) OF signed(15 DOWNTO 0);
    CONSTANT atan_array : signed_array(0 TO 29) := 
    (
    to_signed(16#6488#, 16),to_signed(16#3b59#, 16),to_signed(16#1f5b#, 16),
    to_signed(16#0feb#, 16),to_signed(16#07fd#, 16),to_signed(16#0400#, 16),
    to_signed(16#0200#, 16),to_signed(16#0100#, 16),to_signed(16#0080#, 16),
    to_signed(16#0040#, 16),to_signed(16#0020#, 16),to_signed(16#0010#, 16),
    to_signed(16#0008#, 16),to_signed(16#0004#, 16),to_signed(16#0002#, 16),
    to_signed(16#0001#, 16),to_signed(16#0000#, 16),to_signed(16#0000#, 16),
    to_signed(16#0000#, 16),to_signed(16#0000#, 16),to_signed(16#0000#, 16),
    to_signed(16#0000#, 16),to_signed(16#0000#, 16),to_signed(16#0000#, 16),
    to_signed(16#0000#, 16),to_signed(16#0000#, 16),to_signed(16#0000#, 16),
    to_signed(16#0000#, 16),to_signed(16#0000#, 16),to_signed(16#0000#, 16)
    );
      

    SIGNAL z : signed(31 DOWNTO 0):=X"00000000";  -- sfix32_En15 --pi/4
    SIGNAL x : signed(31 DOWNTO 0):=X"00000000"; 
    SIGNAL y : signed(31 DOWNTO 0):=X"00000000"; 
    
    type states is (PRE_IDLE,IDLE, CALC, DONE);
    signal c_state : states := PRE_IDLE; 
    signal i : integer := 0; 

BEGIN
    
         
    process(clk, resetn)
    begin
        if resetn = '0' then
        
--            x <= to_signed(16#00004dbc#, 32);
--            y <= to_signed(16#00000000#, 32);
--            z <= to_signed(16#0000860b#, 32);

        c_state <= PRE_IDLE;
                 
        elsif rising_edge(clk) then
        
        case c_state is
        
        when PRE_IDLE =>
            
            done_out <= '0';
            if (start='1') then
				x <= signed(xin);
				y <= signed(yin);
				z <= signed(zin);
                c_state <= IDLE;
            else
                c_state <= PRE_IDLE;
--                x <= X"00000000"; 
--                y <= X"00000000";
--                z <= X"00000000";
                
            end if;
            
        when IDLE =>

            c_state <= CALC;

        
        when CALC =>
        
            if (z>=0) then
            x <= x - (shift_right(y,i));
            y <= y + (shift_right(x,i));
            z <= z - atan_array(i);
            else
            x <= x + (shift_right(y,i));
            y <= y - (shift_right(x,i));
            z <= z + atan_array(i);
            end if;

            if(i=29) then
            i <= 0;
            c_state <= DONE;
            else
            i<=i+1;
            c_state <= CALC;
            end if;
            
            
        when DONE =>
            done_out <= '1';
            sin_out <= std_logic_vector(y);
            cos_out <= std_logic_vector(x);
            c_state <= PRE_IDLE;
            
        end case;
        

            
            
        end if;

    end process;




END rtl;

