LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY taylor_code IS
  PORT( clk                               :   IN    std_logic;
        resetn                            :   IN    std_logic;
        start                             :   in    std_logic;
        nxt_symbol                        :   in    std_logic;
        xin                               :   in    std_logic_vector(31 downto 0);
        yin                               :   in    std_logic_vector(31 downto 0);
        zin                               :   in    std_logic_vector(31 downto 0);
        cos_quad                          :   in    std_logic;
        done_out                          :   OUT   std_logic:='0';
        sin_out                           :   OUT   std_logic_vector(33 DOWNTO 0);  
        cos_out                           :   OUT   std_logic_vector(33 DOWNTO 0);
        S                                 :   OUT   std_logic_vector(63 DOWNTO 0);
        QcoefVal                          :   out std_logic_vector(1 downto 0);
        curr                              :   out std_logic_vector(3 downto 0)  -- sfix64_En15
        );
END taylor_code;



ARCHITECTURE rtl OF taylor_code IS

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
    
    type coef_array is array (0 to 7) of std_logic_vector(1 downto 0);
    constant I_coef : coef_array := ("11","11","11","11","01","01","01","11"); --I=[-1,-1,-1,-1,1,1,1,-1];
    constant Q_coef : coef_array := ("11","11","01","01","11","01","11","11"); --Q=[-1,-1,1,1,-1,1,-1,-1];
    signal Current_I_coef : std_logic_vector(1 downto 0);
    signal Current_Q_coef : std_logic_vector(1 downto 0);
    
    SIGNAL Imult                     : signed(33 DOWNTO 0);  -- sfix34_En15
    SIGNAL Qmult                     : signed(33 DOWNTO 0);  -- sfix64_En15
    SIGNAL Imult_cast                : signed(63 DOWNTO 0);  -- sfix64_En15
    SIGNAL Qmult_cast                : signed(63 DOWNTO 0);  -- sfix64_En15
    SIGNAL modulated                 : signed(63 DOWNTO 0);  -- sfix64_En15
  
    SIGNAL z : signed(31 DOWNTO 0):=X"00000000";  -- sfix32_En15 --pi/4
    SIGNAL x : signed(31 DOWNTO 0):=X"00000000"; 
    SIGNAL y : signed(31 DOWNTO 0):=X"00000000"; 
    
    type states is (PRE_IDLE,IDLE, CALC, QAM_stp1, QAM_stp2, QAM_stp3, DONE);
    signal c_state : states := PRE_IDLE; 
    signal i : integer := 0; 
    signal k : integer := 0; 

BEGIN
    
   QcoefVal <=  Current_Q_coef;
   curr <= std_logic_vector(to_unsigned(k,4));
       
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
            
            Current_I_coef <= I_coef(k);
            Current_Q_coef <= Q_coef(k);
            
 
            if (start='1') then
				x <= signed(xin);
				y <= signed(yin);
				z <= signed(zin);
                c_state <= IDLE;
                
            if (nxt_symbol='1') then
            k <= k + 1;   
                if(k=7) then
                k <= 0;
                end if;         
            end if;
                
            else
                c_state <= PRE_IDLE;                
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
            c_state <= QAM_stp1;
            else
            i<=i+1;
            c_state <= CALC;
            end if;
            
        when QAM_stp1 => 
            

            if (cos_quad='1') then
            x <= x;
            else
            x <= not x;
            --x <= x * to_signed(-16#2#, 2);
            end if;
            c_state <= QAM_stp2;
  
        
        when QAM_stp2 => 
          
            Imult <= signed(Current_I_coef) * x;
            Qmult <= signed(Current_Q_coef) * y;
            c_state <= QAM_stp3;
  
        when QAM_stp3 => 
        
            Imult_cast <= resize(Imult, 64);
            Qmult_cast <= resize(Qmult, 64);
            modulated <= Imult_cast + Qmult_cast;
            c_state <= DONE;
            
        when DONE =>
            done_out <= '1';
            sin_out <= std_logic_vector(Qmult);
            cos_out <= std_logic_vector(Imult);
            S <= std_logic_vector(modulated);
            c_state <= PRE_IDLE;
            
        end case;
        

            
            
        end if;

    end process;




END rtl;