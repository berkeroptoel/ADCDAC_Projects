library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity dds_cnter is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
		      ena       : in std_logic;
              dac_load   : out std_logic := '0';
              channel    : out std_logic_vector(1 downto 0)
                );
end dds_cnter;

architecture Behavioral of dds_cnter is

	  signal counter  : unsigned(31 downto 0):= (others => '0') ;
	  signal channel_temp: unsigned(1 downto 0):= (others => '0') ;

	  
begin

    
      process(clk,reset_n)
      begin
		if reset_n = '0' then
		      counter <= (others => '0') ;
		      
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
              

        else
            
        end if;
   
      end if;
      end process;
   
       channel <= std_logic_vector(channel_temp);
       
 end Behavioral;
