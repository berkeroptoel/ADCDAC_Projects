library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity sine_wave1 is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
		      ena       : in std_logic;
              dac_data1  : out  STD_LOGIC_VECTOR (8 downto 0);
              dac_data2  : out  STD_LOGIC_VECTOR (8 downto 0);
              dac_data3  : out  STD_LOGIC_VECTOR (8 downto 0);
              dac_data4  : out  STD_LOGIC_VECTOR (8 downto 0);
              dac_load   : out std_logic := '0';
              channel    : out std_logic_vector(1 downto 0)
                );
end sine_wave1;

architecture Behavioral of sine_wave1 is
	  signal counter  : unsigned(31 downto 0):= (others => '0') ;
	  signal counter2 : unsigned(31 downto 0):= (others => '0') ;

	  signal lut_addr1: unsigned(8 downto 0):= (others => '0') ;
	  signal lut_addr2: unsigned(8 downto 0):= (others => '0') ;
	  signal lut_addr3: unsigned(8 downto 0):= (others => '0') ;
	  signal lut_addr4: unsigned(8 downto 0):= (others => '0') ;
	  signal channel_temp: unsigned(1 downto 0):= (others => '0') ;

	  
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
                channel_temp <= channel_temp + 1;       
                --channel_temp <= "01";     
            else
                dac_load <= '0';
            end if;
            
            --dac lut addressing
            counter2<=counter2 + 1;
            if(counter2=39) then --159
            counter2 <= (others => '0');
            
                lut_addr1 <= lut_addr1 + 1;
                if (lut_addr1=499) then
                lut_addr1 <= (others => '0');
                end if;
            
                lut_addr2 <= lut_addr2 + 1;
                if (lut_addr2=199) then
                lut_addr2 <= (others => '0');
                end if;
            
                lut_addr3 <= lut_addr3 + 1;
                if (lut_addr3=99) then
                lut_addr3 <= (others => '0');
                end if;
            
                lut_addr4 <= lut_addr4 + 1;
                if (lut_addr4=39) then
                lut_addr4 <= (others => '0');
                end if;
            
            end if;    

        else
            
        end if;
   
      end if;
      end process;
      
       dac_data1   <= std_logic_vector(lut_addr1);
       dac_data2   <= std_logic_vector(lut_addr2);
       dac_data3   <= std_logic_vector(lut_addr3);
       dac_data4   <= std_logic_vector(lut_addr4);
       
       channel <= std_logic_vector(channel_temp);
       
 end Behavioral;
