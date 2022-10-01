----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.09.2021 10:01:53
-- Design Name: 
-- Module Name: ask_modulation - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ask_modulation is

    generic(
            time_count      : integer   := 499
    );

    Port ( 
                clk             : in std_logic;
                resetn          : in std_logic;
                ena             : in std_logic; 
                sinus_in1       : in std_logic_vector(7 downto 0);
                sinus_in2       : in std_logic_vector(7 downto 0);
                ask_mod         : out std_logic_vector(7 downto 0);
                ask_done        : out std_logic
    );
end ask_modulation;

architecture Behavioral of ask_modulation is

    signal mes_sig              : unsigned(15 downto 0)             := "1001011100101011"; 
    signal i            : integer := 0;
    signal counter      : integer := 0;

begin

 process(clk, resetn)
    begin
        if resetn = '0' then
            
            counter <= 0;
            i<=0;

                 
        elsif rising_edge(clk) then
          
                    if(ena = '1') then
                        
                        if(counter = time_count) then
                            counter <= 0;
                
                            if(i=15) then
                                i <= 0;
                            else
                                i <= i+1;
                            end if;
                        
                        else
                            counter <= counter + 1;
                            if(mes_sig(i) = '1') then
                                ask_mod         <= std_logic_vector(sinus_in1);  
                            else
                                ask_mod         <= std_logic_vector(sinus_in2);  
                            end if;
                        end if;
                    
                    end if;
                
              
    
    end if;
    
   end process;
   
end Behavioral;
