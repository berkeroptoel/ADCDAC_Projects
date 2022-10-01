library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_control is
    Port (
            clk             : in std_logic;
            rstn            : in std_logic;
            ena_in          : in  std_logic;
            address         : out std_logic_vector(5 downto 0);
            mem_filled      : out std_logic
         );
end ram_control;

architecture Behavioral of ram_control is
    
    signal ena_count        : unsigned(5 downto 0)  := (others => '0');
    signal temp_address     : unsigned(5 downto 0)  := (others => '0');
begin

    process(clk,rstn) 
    begin
        
        if rstn = '0' then
            mem_filled              <= '0';
            temp_address            <= (others => '0');
            ena_count               <= (others => '0');
            
        elsif clk'event and clk = '1' then
            
            if ena_in = '1' then 
                ena_count           <= ena_count + 1;
                temp_address        <= temp_address + 1;
                
                if ena_count = 63 then
                    mem_filled      <= '1';
                    ena_count       <= (others => '0');
                else
                    mem_filled      <= '0';                
                end if;
            end if;
    
        end if;
        
    end process;

    address <= std_logic_vector(temp_address);

end Behavioral;
