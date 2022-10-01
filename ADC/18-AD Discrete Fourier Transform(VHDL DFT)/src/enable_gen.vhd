library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity enable_gen is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
		      ena_gen   : out std_logic
                );
end enable_gen;

architecture Behavioral of enable_gen is
	  
	  signal counter  : unsigned(7 downto 0):= (others => '0');
	  signal counter2 : unsigned(7 downto 0) := (others => '0');
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
            
--            counter2 <= counter2 + 1;
--            if(counter2=79) then --39
--                counter2 <= (others => '0');
--                dac_load <= '1';     
--            else
--                dac_load <= '0';
--            end if;
            end if;
    end process;
    
end Behavioral;