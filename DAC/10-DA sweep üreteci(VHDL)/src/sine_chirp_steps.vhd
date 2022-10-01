library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity sine_chirp is
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
end sine_chirp;

architecture Behavioral of sine_chirp is
	  signal counter  : unsigned(31 downto 0):= (others => '0') ;
	  signal counter2 : unsigned(31 downto 0):= (others => '0') ;
	  signal channel_temp: unsigned(1 downto 0):= (others => '0') ;
	  signal gen_sine: std_logic := '0';
	  constant xout : std_logic_vector(31 downto 0) :=X"00004dbc"; 
	  constant yout : std_logic_vector(31 downto 0) :=X"00000000"; 
      signal init : signed(31 DOWNTO 0):=X"ffff36f0";  -- (-pi/2):-1.5708  fi(init,1,32,15)
      constant stp1 : signed(31 DOWNTO 0):=X"00002836"; --(pi/10):fi(init,1,32,15)
      constant stp2 : signed(31 DOWNTO 0):=X"0000141b"; --(pi/20):fi(init,1,32,15)
      constant stp3 : signed(31 DOWNTO 0):=X"00000d67"; --(pi/30): fi(init,1,32,15)
      constant stp4 : signed(31 DOWNTO 0):=X"00000a0e"; --(pi/40): fi(init,1,32,15)
      constant stp5 : signed(31 DOWNTO 0):=X"0000080a"; --(pi/50):0.0628 fi(init,1,32,15)
      constant stp6 : signed(31 DOWNTO 0):=X"000006b4"; --(pi/60):fi(init,1,32,15)
      constant stp7 : signed(31 DOWNTO 0):=X"000005bf"; --(pi/70): fi(init,1,32,15)
      constant stp8 : signed(31 DOWNTO 0):=X"00000507"; --(pi/80): fi(init,1,32,15)
      constant stp9 : signed(31 DOWNTO 0):=X"00000478"; --(pi/90): fi(init,1,32,15)
      constant stp10 : signed(31 DOWNTO 0):=X"00000405"; --(pi/100): fi(init,1,32,15)
      signal i   : integer := 0; 
      type chirp_states is (s1,s2, s3, s4,s5,s6,s7,s8,s9,s10);
      signal chirp_state : chirp_states := s1; 
	  
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
          
           case chirp_state is
           
           when s1 =>    
           
                if (i<10) then
                init <= init + stp1;
                cos_sign <= '1';
                else
                init <= init - stp1;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=19) then
                i <= 0;
                chirp_state <= s2;
                end if;
                
           when s2 =>  
           
                if (i<20) then
                init <= init + stp2;
                cos_sign <= '1';
                else
                init <= init - stp2;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=39) then
                i <= 0;
                chirp_state <= s3;
                end if;
                
                
           when s3 =>  
           
                if (i<30) then
                init <= init + stp3;
                cos_sign <= '1';
                else
                init <= init - stp3;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=59) then
                i <= 0;
                chirp_state <= s4;
                end if;
                
                
           when s4 =>  
           
                if (i<40) then
                init <= init + stp4;
                cos_sign <= '1';
                else
                init <= init - stp4;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=79) then
                i <= 0;
                chirp_state <= s5;
                end if;
                
                
           when s5 =>     
           
                if (i<50) then
                init <= init + stp5;
                cos_sign <= '1';
                else
                init <= init - stp5;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=99) then
                i <= 0;
                chirp_state <= s6;
                end if;
                
                
           when s6 =>    
           
                if (i<60) then
                init <= init + stp6;
                cos_sign <= '1';
                else
                init <= init - stp6;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=119) then
                i <= 0;
                chirp_state <= s7;
                end if;
                
                
           when s7 =>  
           
                if (i<70) then
                init <= init + stp7;
                cos_sign <= '1';
                else
                init <= init - stp7;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=139) then
                i <= 0;
                chirp_state <= s8;
                end if;
                
                
           when s8 =>  
           
                if (i<80) then
                init <= init + stp8;
                cos_sign <= '1';
                else
                init <= init - stp8;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=159) then
                i <= 0;
                chirp_state <= s9;
                end if;
                
                
           when s9 =>  
           
                if (i<90) then
                init <= init + stp9;
                cos_sign <= '1';
                else
                init <= init - stp9;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=179) then
                i <= 0;
                chirp_state <= s10;
                end if;
                
                
           when s10 => 
           
                if (i<100) then
                init <= init + stp10;
                cos_sign <= '1';
                else
                init <= init - stp10;
                cos_sign <= '0';
                end if;
                
                i <= i + 1;
                if(i=199) then
                i <= 0;
                chirp_state <= s1;
                end if;
                
                
           end case;
           
  
            else
            
                gen_sine <= '0';
                
            end if;    

        else
            
        end if;
   
      end if;
      end process;
      
       
       channel <= std_logic_vector(channel_temp);
       
       x_out <= xout;
       y_out <= yout;
       z_out <= std_logic_vector(init);
       
 end Behavioral;
