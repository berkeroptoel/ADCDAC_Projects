LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wave_show IS
  PORT( clk                               :   IN    std_logic;
        resetn                            :   IN    std_logic;
        start                             :   in    std_logic;
        sine_wave_i : in std_logic_vector(31 downto 0);
        sine_wave_o : out std_logic_vector(31 downto 0);
        dac_load    : out std_logic := '0'
        );
END wave_show;



ARCHITECTURE rtl OF wave_show IS
    
    type states is (IDLE, WT,SHW);
    signal c_state : states := IDLE; 
    signal counter  : unsigned(31 downto 0):= (others => '0') ;
    signal sine_wave_sig: std_logic_vector(31 downto 0);

BEGIN
    

       
    process(clk, resetn)
    begin
        if resetn = '0' then
        
        counter <= (others => '0') ;
       
        c_state <= IDLE;
                 
        elsif rising_edge(clk) then
        
        case c_state is
        
            
        when IDLE =>

            if(start='1') then
            c_state <= WT;
            else
            c_state <= IDLE;
            end if;
            dac_load <= '0';
        
        when WT =>
        
            counter <= counter + 1;
            if(counter = 10) then
            counter <= (others => '0');
            c_state <= SHW;
            else
            c_state <= WT;
            end if;
            dac_load <= '0';
         
         when SHW => 
         
            sine_wave_sig <= sine_wave_i;
            dac_load <= '1';
            c_state <= IDLE;
               
        end case;
        

            
            
        end if;

    end process;


sine_wave_o <= std_logic_vector(sine_wave_sig);


END rtl;