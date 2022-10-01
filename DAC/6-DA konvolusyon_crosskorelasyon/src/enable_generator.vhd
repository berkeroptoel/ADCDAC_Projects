library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity sine_z_gen is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
		      ena_gen   : out std_logic
                );
end sine_z_gen;

architecture Behavioral of sine_z_gen is
	  
	  signal counter  : unsigned(31 downto 0):= (others => '0');
begin

    
      process(clk,reset_n)
      begin
		if reset_n = '0' then
		      counter <= (others => '0') ;
       elsif clk'event and clk= '1' then
            
            counter<=counter + 1;
            if(counter=79) then --39
                counter <= (others => '0');
                ena_gen <= '1';     
            else
                ena_gen <= '0';
            end if;
            end if;
    end process;
    
end Behavioral;