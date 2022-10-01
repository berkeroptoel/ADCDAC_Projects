
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity threshold_core is
   
    Port (
            clk                 : in std_logic;
            rst                 : in std_logic;
            ena                 : in std_logic;
            filter_in           : in std_logic_vector(40 downto 0);
            threshold_out       : out std_logic
     );
end threshold_core;

architecture Behavioral of threshold_core is

signal cons_threshold : std_logic_vector(35 downto 0):= X"EF3897C63"; 

begin

    process(clk,rst) 
        begin
            if rst = '0' then
               
               threshold_out <= '0';
                     
            elsif rising_edge(clk) then
                
                if(filter_in < cons_threshold) then
                    
                    threshold_out <= '0';
                
                else
                
                    threshold_out <= '1';
                
                end if; 
            
            end if;
        
        end process;

end Behavioral;
