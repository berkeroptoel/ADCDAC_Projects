library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity sine_z_gen is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
		      ena       : in std_logic;
              dac_load   : out std_logic := '0';
              channel    : out std_logic_vector(1 downto 0);
              x_out  : out  STD_LOGIC_VECTOR (31 downto 0);
              y_out  : out  STD_LOGIC_VECTOR (31 downto 0);
              z_out  : out  STD_LOGIC_VECTOR (31 downto 0);
              cos_sign : out std_logic
                );
end sine_z_gen;

architecture Behavioral of sine_z_gen is
	  
	  signal counter  : unsigned(31 downto 0):= (others => '0') ;
	  signal counter2 : unsigned(31 downto 0):= (others => '0') ;
	  signal channel_temp: unsigned(1 downto 0):= (others => '0') ;
	  signal gen_sine: std_logic := '0';
	  constant xout : std_logic_vector(31 downto 0) :=X"00004dbc";  --fi(0.6073,1,32,15)
	  constant yout : std_logic_vector(31 downto 0) :=X"00000000"; 
      signal init : signed(31 DOWNTO 0):=X"ffff36f0";  -- (-pi/2):-1.5708  fi(init,1,32,15)
      constant stp : signed(31 DOWNTO 0):=X"0000506c"; --(pi/50):0.628 fi(init,1,32,15)
      signal i   : integer := 0; 

	  
begin

    
      process(clk,reset_n)
      begin
		if reset_n = '0' then
		      counter <= (others => '0') ;
		      counter2 <= (others => '0') ;
       elsif clk'event and clk= '1' then
            
            if (ena='1') then
            
            --dac frequency and dac channel
            counter<=counter + 1;
            if(counter=39) then --39
                counter <= (others => '0');
                dac_load <= '1';
                --channel_temp <= channel_temp + 1;       
                channel_temp <= "00";     
            else
                dac_load <= '0';
            end if;
            
            --dac lut addressing
            counter2<=counter2 + 1;
            if(counter2=39) then --159
            counter2 <= (others => '0');
             
                gen_sine <= '1';
                
                if (i<5) then
                init <= init + stp;
                cos_sign <= '1';
                else
                init <= init - stp;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=9) then
                i <= 0;
                end if;
  
            else
            
                gen_sine <= '0';
                
            end if;    

        else
            
        end if;
   
      end if;
      end process;
      
       x_out <= xout;
       y_out <= yout;
       z_out <= std_logic_vector(init);
       
       channel <= std_logic_vector(channel_temp);
       
 end Behavioral;




