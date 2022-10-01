library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity wave_ctrl is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
		      ena       : in std_logic;
              dac_data1  : out  STD_LOGIC_VECTOR (8 downto 0);
              dac_load   : out std_logic := '0';
              channel    : out std_logic_vector(1 downto 0)
                );
end wave_ctrl;

architecture Behavioral of wave_ctrl is
	  
	  signal counter  : unsigned(31 downto 0):= (others => '0') ;
	  signal lut_addr1: unsigned(8 downto 0):= (others => '0') ;
	  signal channel_temp: unsigned(1 downto 0):= (others => '0') ;

	  
begin

    channel_temp <= "00";
    
      process(clk,reset_n)
      begin
		if reset_n = '0' then
		      counter <= (others => '0') ;
		      
       elsif clk'event and clk= '1' then
            
            if (ena='1') then
            
            counter<=counter + 1;
            if(counter=39) then

            
                lut_addr1 <= lut_addr1 + 1;
                if (lut_addr1=99) then
                lut_addr1 <= (others => '0');
                end if;
            
                counter <= (others => '0');
                dac_load <= '1';
            else
            
                dac_load <= '0';
                
            end if;    

        else
            
        end if;
   
      end if;
      end process;
      
       dac_data1 <= std_logic_vector(lut_addr1);
       channel   <= std_logic_vector(channel_temp);
       
 end Behavioral;
