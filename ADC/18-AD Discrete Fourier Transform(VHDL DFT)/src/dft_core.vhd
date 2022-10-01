----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2021 23:03:09
-- Design Name: 
-- Module Name: dft_core - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dft_core is
 Port (
    clk   :   IN    std_logic;
    reset :   IN    std_logic;
    a     :   IN    std_logic_vector(11 DOWNTO 0):=X"000";  -- ufix12
    b     :   IN    std_logic_vector(11 DOWNTO 0):=X"000";  -- ufix12 
    --validin:  in std_logic;
    mem_filled: in std_logic;
    validout: out std_logic;
    out_real: OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En15 
    out_imag: OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En15 
    out_index: out std_logic_vector(5 downto 0);
    bram_read_ena :out std_logic;
    bram_read_addr:out std_logic_vector(5 downto 0):="000000";
    out_test : out std_logic_vector(1 downto 0)
  );
end dft_core;

architecture Behavioral of dft_core is

--(a+ib) x (c+di)
--(ac-bd)+j(bc+ad)
--a=ADC
--b=0
--c=twiddle real
--d=twiddle imag

    --twiddle:fi(x,1,16,15)
    TYPE signed_array IS ARRAY (natural RANGE <> ) OF signed(15 DOWNTO 0);
    CONSTANT twiddle_real : signed_array(0 TO 63) := 
    (
    to_signed(16#7fff#, 16),to_signed(16#7f62#, 16),to_signed(16#7d8a#, 16),
    to_signed(16#7a7d#, 16),to_signed(16#7642#, 16),to_signed(16#70e3#, 16),
    to_signed(16#6a6e#, 16),to_signed(16#62f2#, 16),to_signed(16#5a82#, 16),
    to_signed(16#5134#, 16),to_signed(16#471d#, 16),to_signed(16#3c57#, 16),
    to_signed(16#30fc#, 16),to_signed(16#2528#, 16),to_signed(16#18f9#, 16),
	to_signed(16#0c8c#, 16),to_signed(16#0000#, 16),to_signed(16#f374#, 16),
	to_signed(16#e707#, 16),to_signed(16#dad8#, 16),to_signed(16#cf04#, 16),
	to_signed(16#c3a9#, 16),to_signed(16#b8e3#, 16),to_signed(16#aecc#, 16),
	to_signed(16#a57e#, 16),to_signed(16#9d0e#, 16),to_signed(16#9592#, 16),
	to_signed(16#8f1d#, 16),to_signed(16#89be#, 16),to_signed(16#8583#, 16),
	to_signed(16#8276#, 16),to_signed(16#809e#, 16),to_signed(16#8000#, 16),
	to_signed(16#809e#, 16),to_signed(16#8276#, 16),to_signed(16#8583#, 16),
	to_signed(16#89be#, 16),to_signed(16#8f1d#, 16),to_signed(16#9592#, 16),
	to_signed(16#9d0e#, 16),to_signed(16#a57e#, 16),to_signed(16#aecc#, 16),
	to_signed(16#b8e3#, 16),to_signed(16#c3a9#, 16),to_signed(16#cf04#, 16),
	to_signed(16#dad8#, 16),to_signed(16#e707#, 16),to_signed(16#f374#, 16),
	to_signed(16#0000#, 16),to_signed(16#0c8c#, 16),to_signed(16#18f9#, 16),
	to_signed(16#2528#, 16),to_signed(16#30fc#, 16),to_signed(16#3c57#, 16),
	to_signed(16#471d#, 16),to_signed(16#5134#, 16),to_signed(16#5a82#, 16),
	to_signed(16#62f2#, 16),to_signed(16#6a6e#, 16),to_signed(16#70e3#, 16),
	to_signed(16#7642#, 16),to_signed(16#7a7d#, 16),to_signed(16#7d8a#, 16),
	to_signed(16#7f62#, 16)
    );
    
    --twiddle:fi(x,1,16,15)
    CONSTANT twiddle_imag : signed_array(0 TO 63) := 
    (
    to_signed(16#0000#, 16),to_signed(16#f374#, 16),to_signed(16#e707#, 16),
    to_signed(16#dad8#, 16),to_signed(16#cf04#, 16),to_signed(16#c3a9#, 16),
    to_signed(16#b8e3#, 16),to_signed(16#aecc#, 16),to_signed(16#a57e#, 16),
    to_signed(16#9d0e#, 16),to_signed(16#9592#, 16),to_signed(16#8f1d#, 16),
    to_signed(16#89be#, 16),to_signed(16#8583#, 16),to_signed(16#8276#, 16),
	to_signed(16#809e#, 16),to_signed(16#8000#, 16),to_signed(16#809e#, 16),
	to_signed(16#8276#, 16),to_signed(16#8583#, 16),to_signed(16#89be#, 16),
	to_signed(16#8f1d#, 16),to_signed(16#9592#, 16),to_signed(16#9d0e#, 16),
	to_signed(16#a57e#, 16),to_signed(16#aecc#, 16),to_signed(16#b8e3#, 16),
	to_signed(16#c3a9#, 16),to_signed(16#cf04#, 16),to_signed(16#dad8#, 16),
	to_signed(16#e707#, 16),to_signed(16#f374#, 16),to_signed(16#0000#, 16),
	to_signed(16#0c8c#, 16),to_signed(16#18f9#, 16),to_signed(16#2528#, 16),
	to_signed(16#30fc#, 16),to_signed(16#3c57#, 16),to_signed(16#471d#, 16),
	to_signed(16#5134#, 16),to_signed(16#5a82#, 16),to_signed(16#62f2#, 16),
	to_signed(16#6a6e#, 16),to_signed(16#70e3#, 16),to_signed(16#7642#, 16),
	to_signed(16#7a7d#, 16),to_signed(16#7d8a#, 16),to_signed(16#7f62#, 16),
	to_signed(16#7fff#, 16),to_signed(16#7f62#, 16),to_signed(16#7d8a#, 16),
	to_signed(16#7a7d#, 16),to_signed(16#7642#, 16),to_signed(16#70e3#, 16),
	to_signed(16#6a6e#, 16),to_signed(16#62f2#, 16),to_signed(16#5a82#, 16),
	to_signed(16#5134#, 16),to_signed(16#471d#, 16),to_signed(16#3c57#, 16),
	to_signed(16#30fc#, 16),to_signed(16#2528#, 16),to_signed(16#18f9#, 16),
	to_signed(16#0c8c#, 16)
    );
    
    signal validout_sig: std_logic:='0';
    signal cnt: unsigned(5 downto 0):=(others => '0'); --validin'e göre sayar
    signal frame_cnt: unsigned(5 downto 0):=(others => '0');
    signal cnt_out: unsigned(5 downto 0):=(others => '0'); --validout'a göre sayar
    signal index_cnt: unsigned(5 downto 0):=(others => '0');
    signal a_unsigned: unsigned(11 downto 0);
    signal b_unsigned: unsigned(11 downto 0);
    signal a_cast: signed(12 DOWNTO 0);  --sfix13
    signal c_cur: signed(15 DOWNTO 0);   --sfix16_En15
    signal ac_sig:signed(28 DOWNTO 0);   --sfix29_En15
    signal ac_cast:signed(27 DOWNTO 0);  -- sfix28_En15
    signal ac:signed(31 DOWNTO 0);       -- sfix32_En15
    signal ac_reg:signed(31 DOWNTO 0);   -- sfix32_En15
    signal b_cast: signed(12 DOWNTO 0);  --sfix13
    signal d_cur: signed(15 DOWNTO 0);   --sfix16_En15
    signal bd_sig:signed(28 DOWNTO 0);   --sfix29_En15
    signal bd_cast:signed(27 DOWNTO 0);  -- sfix28_En15
    signal bd:signed(31 DOWNTO 0);       -- sfix32_En15
    signal bd_reg:signed(31 DOWNTO 0);   -- sfix32_En15
    SIGNAL add_out1: signed(31 downto 0); -- sfix32_En15
    SIGNAL add_out1_reg: signed(31 downto 0); -- sfix32_En15
    signal bc_sig:signed(28 DOWNTO 0);   --sfix29_En15
    signal bc_cast:signed(27 DOWNTO 0);  -- sfix28_En15
    signal bc:signed(31 DOWNTO 0);       -- sfix32_En15
    signal bc_reg:signed(31 DOWNTO 0);   -- sfix32_En15
    signal ad_sig:signed(28 DOWNTO 0);   --sfix29_En15
    signal ad_cast:signed(27 DOWNTO 0);  -- sfix28_En15
    signal ad:signed(31 DOWNTO 0);       -- sfix32_En15
    signal ad_reg:signed(31 DOWNTO 0);   -- sfix32_En15
    SIGNAL add_out2: signed(31 downto 0); -- sfix32_En15
    SIGNAL add_out2_reg: signed(31 downto 0); -- sfix32_En15
    SIGNAL validin_reg  : std_logic_vector(0 TO 3);  -- ufix1 [3]
    
    signal real_part_reg_out : signed(31 downto 0);
    signal real_part_sum: signed(31 downto 0):=(others => '0');
    signal imag_part_reg_out : signed(31 downto 0);
    signal imag_part_sum: signed(31 downto 0):=(others => '0');
    
    signal twiddle_index: unsigned(11 downto 0):=(others => '0');
    signal accum_reset: std_logic :='0';
    
    type states is(idle,data_temp,dft_phase_on,dft_phase_off);
    signal cur_state : states := idle;
    TYPE adc_data_array IS ARRAY (natural RANGE <> ) OF unsigned(11 DOWNTO 0);
--    signal input_data_real : adc_data_array(0 TO 63):=
--   (
--    to_unsigned(16#200#, 12),to_unsigned(16#29e#, 12),to_unsigned(16#32d#, 12),
--    to_unsigned(16#39e#, 12),to_unsigned(16#3e7#, 12),to_unsigned(16#400#, 12),
--    to_unsigned(16#3e7#, 12),to_unsigned(16#39e#, 12),to_unsigned(16#32d#, 12),
--    to_unsigned(16#29e#, 12),to_unsigned(16#200#, 12),to_unsigned(16#162#, 12),
--    to_unsigned(16#0d3#, 12),to_unsigned(16#062#, 12),to_unsigned(16#019#, 12),
--	to_unsigned(16#000#, 12),to_unsigned(16#019#, 12),to_unsigned(16#062#, 12),
--	to_unsigned(16#0d3#, 12),to_unsigned(16#162#, 12),to_unsigned(16#200#, 12),
--	to_unsigned(16#29e#, 12),to_unsigned(16#32d#, 12),to_unsigned(16#39e#, 12),
--	to_unsigned(16#3e7#, 12),to_unsigned(16#400#, 12),to_unsigned(16#3e7#, 12),
--	to_unsigned(16#39e#, 12),to_unsigned(16#32d#, 12),to_unsigned(16#29e#, 12),
--	to_unsigned(16#200#, 12),to_unsigned(16#162#, 12),to_unsigned(16#0d3#, 12),
--	to_unsigned(16#062#, 12),to_unsigned(16#019#, 12),to_unsigned(16#000#, 12),
--	to_unsigned(16#019#, 12),to_unsigned(16#062#, 12),to_unsigned(16#0d3#, 12),
--	to_unsigned(16#162#, 12),to_unsigned(16#200#, 12),to_unsigned(16#29e#, 12),
--	to_unsigned(16#32d#, 12),to_unsigned(16#39e#, 12),to_unsigned(16#3e7#, 12),
--	to_unsigned(16#400#, 12),to_unsigned(16#3e7#, 12),to_unsigned(16#39e#, 12),
--	to_unsigned(16#32d#, 12),to_unsigned(16#29e#, 12),to_unsigned(16#200#, 12),
--	to_unsigned(16#162#, 12),to_unsigned(16#0d3#, 12),to_unsigned(16#062#, 12),
--	to_unsigned(16#019#, 12),to_unsigned(16#000#, 12),to_unsigned(16#019#, 12),
--	to_unsigned(16#062#, 12),to_unsigned(16#0d3#, 12),to_unsigned(16#162#, 12),
--	to_unsigned(16#200#, 12),to_unsigned(16#29e#, 12),to_unsigned(16#32d#, 12),
--	to_unsigned(16#39e#, 12)
--    );
    signal input_data_real : adc_data_array(0 TO 63):=
       (
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12)
    );
    signal input_data_imag : adc_data_array(0 TO 63):=
       (
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
    to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),to_unsigned(16#000#, 12),
	to_unsigned(16#000#, 12)
    );
    signal data_cnt: unsigned(5 downto 0):=(others => '0');
    signal bram_addr_cnt: unsigned(6 downto 0):=(others => '0');
    signal data_cnt_d1: unsigned(5 downto 0):=(others => '0');
    signal validin : std_logic :='0';
    signal k_count: unsigned(5 downto 0):=(others => '0');
    
begin


    
    process(clk,reset)
    begin
    if reset='0' then
    
    elsif clk'event and clk='1' then
    
    case cur_state is
    when idle =>
                if mem_filled='1' then
                cur_state <= data_temp;
                else
                cur_state <= idle;
                end if;
                out_test <= "00";
                
                
    when data_temp => 
                bram_addr_cnt <= bram_addr_cnt + 1;
                data_cnt_d1 <= bram_addr_cnt(5 downto 0);
                --if(bram_addr_cnt=63) then
                --bram_addr_cnt <= (others => '0');
                --elsif(bram_addr_cnt=64) then
                if(bram_addr_cnt=64) then
                bram_addr_cnt <= (others => '0');
                cur_state <= dft_phase_on;
                end if;
                
                out_test <= "01";
           
                input_data_real(to_integer(data_cnt_d1)) <= unsigned(a);
                input_data_imag(to_integer(data_cnt_d1)) <= (others => '0');
                
    when dft_phase_on =>
                
                bram_read_ena <= '0';
                data_cnt <= data_cnt + 1;
                if(data_cnt=63) then
                data_cnt <= (others => '0');
                cur_state <= dft_phase_off;
                end if;
                validin <= '1'; 
                out_test <= "10"; 
    
    when dft_phase_off =>
    
                validin <= '0'; 
                k_count <= k_count + 1;
                if(k_count=63) then
                k_count <= (others => '0');
                cur_state <= idle;
                else
                cur_state <= dft_phase_on;
                end if;
                out_test <= "11";
    
    when others =>
    
    end case;
    
    end if;
    end process;
    
    bram_read_addr <= std_logic_vector(bram_addr_cnt(5 downto 0));
    
    
  PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      cnt <= (others => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      if(validin='1') then
      cnt <= cnt + 1;
      if(cnt=63) then
      frame_cnt <= frame_cnt + 1;
      end if;
      end if;
    END IF;
  END PROCESS ;
 
  PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      validin_reg <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      validin_reg(0) <= validin;
      validin_reg(1) <= validin_reg(0);
      validin_reg(2) <= validin_reg(1);
      validin_reg(3) <= validin_reg(2);
    END IF;
  END PROCESS;
  
  validout_sig <= validin_reg(1);
  
  PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      cnt_out <= (others => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF validout_sig = '1' THEN
        cnt_out <= cnt_out + 1;
        if(cnt_out=63) then
        index_cnt <= index_cnt + 1;
        end if;
      END IF;
    END IF;
  END PROCESS;
   
   twiddle_index <= (frame_cnt*cnt) mod 64;
   a_unsigned <= unsigned(a);
   b_unsigned <= unsigned(b);

  --a_cast <= signed(resize(a_unsigned, 13));
  a_cast <= signed(resize(input_data_real(to_integer(cnt)),13));
  c_cur <= twiddle_real(to_integer(twiddle_index));
  ac_sig <= a_cast * c_cur;
  ac_cast <= ac_sig(27 DOWNTO 0);
  ac <= resize(ac_cast, 32);
  
  Dly1 : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      ac_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      ac_reg <= ac;
    END IF;
  END PROCESS Dly1;
  
  
  --b_cast <= signed(resize(b_unsigned, 13));
  b_cast <= signed(resize(input_data_imag(to_integer(cnt)),13));
  d_cur <= twiddle_imag(to_integer(twiddle_index));
  bd_sig <= b_cast * d_cur;
  bd_cast <= bd_sig(27 DOWNTO 0);
  bd <= resize(bd_cast, 32);
  
  Dly2 : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      bd_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      bd_reg <= bd;
    END IF;
  END PROCESS Dly2;
  
  add_out1 <= ac_reg - bd_reg;
  
  Dly5 : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      add_out1_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      add_out1_reg <= add_out1;
    END IF;
  END PROCESS Dly5;
  
  
  bc_sig <= b_cast*c_cur;
  bc_cast <= bc_sig(27 DOWNTO 0);
  bc <= resize(bc_cast, 32);
  
  Dly3 : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      bc_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      bc_reg <= bc;
    END IF;
  END PROCESS Dly3;
  
  ad_sig <= a_cast*d_cur;
  ad_cast <= ad_sig(27 DOWNTO 0);
  ad <= resize(ad_cast, 32);
  
  Dly4 : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      ad_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      ad_reg <= ad;
    END IF;
  END PROCESS Dly4;
  
  add_out2 <= bc_reg + ad_reg;


 Dly6 : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      add_out2_reg <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      add_out2_reg <= add_out2;
    END IF;
  END PROCESS Dly6;
  
--  real_part_sum <= real_part_reg_out + add_out1_reg;
  
--  Real_accum : PROCESS (clk, reset)
--  BEGIN
--    IF reset = '0' THEN
--      real_part_reg_out <= to_signed(0, 32);
--    ELSIF clk'EVENT AND clk = '1' THEN
--      IF validout_sig = '1' THEN
--            if(cnt_out=63) then
--            real_part_reg_out <= to_signed(0, 32);
--            else
--            real_part_reg_out <= real_part_sum;
--            end if;
--      END IF;
--    END IF;
--  END PROCESS Real_accum;
  
--  imag_part_sum <= imag_part_reg_out + add_out2_reg;
  
--  Imag_accum : PROCESS (clk, reset)
--  BEGIN
--    IF reset = '0' THEN
--      imag_part_reg_out <= to_signed(0, 32);
--    ELSIF clk'EVENT AND clk = '1' THEN
--      IF validout_sig = '1' THEN
--            if(cnt_out=63) then
--            imag_part_reg_out <= to_signed(0, 32);
--            else
--            imag_part_reg_out <= imag_part_sum;
--            end if;
--      END IF;
--    END IF;
--  END PROCESS Imag_accum;
  
  Real_Imag_accum : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      real_part_sum <= to_signed(0, 32);
      imag_part_sum <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF validout_sig = '1' THEN
            
            real_part_sum <= real_part_sum + add_out1_reg;
            imag_part_sum <= imag_part_sum + add_out2_reg;
      
      else
      
            real_part_sum <= to_signed(0, 32);
            imag_part_sum <= to_signed(0, 32);
            
      END IF;
      
    END IF;
  END PROCESS Real_Imag_accum;
  

  PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      validout <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN

            if(cnt_out=63) then
            validout <= '1';
            else
            validout <= '0';
            end if;

    END IF;
  END PROCESS ;
  
  
  real_part_reg_out <= real_part_sum;
  imag_part_reg_out <= imag_part_sum;
  out_real <= std_logic_vector(real_part_reg_out);
  out_imag <= std_logic_vector(imag_part_reg_out);
  out_index <= std_logic_vector(index_cnt);
  
  
  
end Behavioral;
