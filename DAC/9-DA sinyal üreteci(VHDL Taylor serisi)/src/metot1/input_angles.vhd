library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all ;


entity input_angles is
       Port ( 
              clk       : in STD_LOGIC;
		      reset_n   : in std_logic ;
              taylor_load   : out std_logic := '0';
              z_out  : out  STD_LOGIC_VECTOR (31 downto 0)
                );
end input_angles;

architecture Behavioral of input_angles is
	  
	  signal counter  : unsigned(31 downto 0):= (others => '0') ;
      signal init : signed(31 DOWNTO 0):=X"ffff36f0";  -- (-pi/2):-1.5708  fi(init,1,32,15)
      constant stp : signed(31 DOWNTO 0):=X"0000080a"; --(pi/50):0.0628 fi(init,1,32,15)
      signal i   : integer := 0; 

	  
begin

    
      process(clk,reset_n)
      begin
		if reset_n = '0' then
		      
		      counter <= (others => '0') ;
		      
       elsif clk'event and clk= '1' then
           
            counter<=counter + 1;
            if(counter=39) then 
            counter <= (others => '0');
               
                if (i<50) then
                init <= init + stp;
                else
                init <= init - stp;
                end if;
                
                i <= i + 1;
                if(i=99) then
                i <= 0;
                end if;
                      
            end if;    
    
            if(counter = 0) then
            taylor_load <= '1';
            else
            taylor_load <= '0';
            end if;
            
        end if;
   
 
      end process;
      
 
       z_out <= std_logic_vector(init);
       
       
 end Behavioral;