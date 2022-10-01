library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dds_core is
        Port (      clk         :   in std_logic;
                    reset       :   in std_logic;
                    enable      :   in std_logic;
                    tuningWord  :   in std_logic_vector(31 downto 0);
                    done_dds    :   out std_logic;
                    dds_out     :   out std_logic_vector(7 downto 0)                    
        );
end dds_core;

architecture Behavioral of dds_core is
       
        signal fOut_step        : signed (7 downto 0) := X"00";             -- for output of dds_core
        signal phAcc            : signed (31 downto 0):= X"00000000";       -- phase accumullator
        signal phAcc_control    : signed (35 downto 0):= X"000000000";
        signal count            : signed (7 downto 0) := X"00";             -- after truncate phAcc
        signal tuningWord_in    : signed (31 downto 0):= X"00000000";       -- tuning word (frekans atlama bilgisi)
        signal phAcc_res        : signed (35 downto 0):= X"000000001";      -- phase accumulator resolution
        constant nco_res        : signed (7 downto 0) := X"20";             -- phase accumulator bit length
        
        signal enable_reg       : std_logic_vector(9 downto 0)  := "0000000000";
               
        type states is (PRE_DEF, ADD, TRUNC, ASSIGN);
        signal dds_state : states := PRE_DEF; 
      
begin
    
    dds_sm : process(clk,reset)
    begin 
        if reset = '0' then
            fOut_step  <= (others => '0');
            phAcc      <= (others => '0');
            count      <= (others => '0');
            dds_state  <= PRE_DEF;
            
        elsif clk'event and clk = '1' then
            
            case dds_state is
           
            when PRE_DEF =>
                if(enable = '1') then 
                    phAcc_res <= shift_left(phAcc_res,to_integer(nco_res));
                    tuningWord_in <= signed(tuningWord); 
                    dds_state <= ADD;
                else 
                    dds_state <= PRE_DEF;
                end if;
             
            when ADD =>
                if (phAcc_control < phAcc_res) then
                    phAcc <= phAcc + tuningWord_in;
                    phAcc_control <= phAcc_control + tuningWord_in;
                    dds_state <= TRUNC;
                else 
                    phAcc <= (others => '0');
                    phAcc_control <= (others => '0');
                    dds_state <= ADD;            
                end if;
                
            when TRUNC =>
                count <= resize(shift_right(phAcc,24),8); 
                dds_state <= ASSIGN;
            
            when ASSIGN =>
                fOut_step <= count;
                phAcc_res <= X"000000001";
                tuningWord_in <= (others => '0');     
                dds_state <= PRE_DEF;
            
            end case;
            
        dds_out <= std_logic_vector(fOut_step);     
            
        end if;

    end process;
    
    delay10 : process(clk,reset)  
        begin
        if reset = '0' then
            enable_reg <= (others => '0');
            
        elsif clk'event and clk = '1' then
            
            enable_reg(0)      <= enable;
            enable_reg(9 downto 1) <= enable_reg(8 downto 0);
          
        end if;
    
    end process delay10;
    
    done_dds <= enable_reg(9);

end Behavioral;