LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY taylor_init IS
  PORT( clk                               :   IN    std_logic;
        resetn                            :   IN    std_logic;
        start                             :   in    std_logic;
        inp_val                           :   in    std_logic_vector(31 downto 0);
        ang_val                           :   out   std_logic_vector(31 downto 0);
        active                            :   out   std_logic := '0'
        );
END taylor_init;



ARCHITECTURE rtl OF taylor_init IS
    
    type states is (IDLE, CALC, GET);
    signal c_state : states := IDLE; 
    signal i : integer := 0; 
    signal k : integer := 0; 
    signal ang_val_sig : signed(31 DOWNTO 0);
    signal counter  : unsigned(31 downto 0):= (others => '0') ;

BEGIN
    

       
    process(clk, resetn)
    begin
        if resetn = '0' then
        
        counter <= (others => '0') ;
        active <= '0';
        c_state <= IDLE;
                 
        elsif rising_edge(clk) then
        
        case c_state is
        
            
        when IDLE =>

            if(start='1') then
            c_state <= CALC;
            ang_val_sig <= signed(inp_val);
            end if;
            active <= '0';
        
        when CALC =>
        
            counter <= counter + 1;
            if(counter = 7) then
            counter <= (others => '0');
            c_state <= GET;
            else
            c_state <= CALC;
            end if;
            active <= '1';
 
        when GET =>
            
            active <= '0';
            counter <= counter + 1;
            if(counter = 5) then
            counter <= (others => '0');
            c_state <= IDLE;
            end if;
            
        end case;
        

            
            
        end if;

    end process;


ang_val <= std_logic_vector(ang_val_sig);

END rtl;