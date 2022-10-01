LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wave_fit IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        ena_in                            :   in std_logic;
        ena_out                           :   out std_logic;
        Input                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En15
        Out1                              :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END wave_fit;


ARCHITECTURE rtl OF wave_fit IS

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL Input_signed                     : signed(31 DOWNTO 0);  -- sfix32_En15
  SIGNAL Constant_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Product_cast                     : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL Product_mul_temp                 : signed(40 DOWNTO 0);  -- sfix41_En15
  SIGNAL Product_out1                     : signed(39 DOWNTO 0);  -- sfix40_En15
  SIGNAL Delay_out1                       : signed(39 DOWNTO 0);  -- sfix40_En15
  SIGNAL Sum_add_cast                     : signed(63 DOWNTO 0);  -- sfix64_En15
  SIGNAL Sum_add_cast_1                   : signed(63 DOWNTO 0);  -- sfix64_En15
  SIGNAL Sum_out1                         : signed(63 DOWNTO 0);  -- sfix64_En15
  SIGNAL Data_Type_Conversion_out1        : unsigned(7 DOWNTO 0);  -- uint8
  signal ena_sig : std_logic := '0';

BEGIN
  Input_signed <= signed(Input);

  Constant_out1 <= to_unsigned(16#64#, 8);

  Product_cast <= signed(resize(Constant_out1, 9));
  Product_mul_temp <= Input_signed * Product_cast;
  Product_out1 <= Product_mul_temp(39 DOWNTO 0);

  

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      Delay_out1 <= to_signed(0, 40);
    ELSIF clk'EVENT AND clk = '1' THEN
      
        Delay_out1 <= Product_out1;
        ena_sig <= ena_in;
      
    END IF;
  END PROCESS Delay_process;


  Sum_add_cast <= resize(Delay_out1, 64);
  Sum_add_cast_1 <= signed(resize(Constant_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 64));
  Sum_out1 <= Sum_add_cast + Sum_add_cast_1;

  Data_Type_Conversion_out1 <= unsigned(Sum_out1(22 DOWNTO 15));

  Out1 <= std_logic_vector(Data_Type_Conversion_out1);

  ena_out <= ena_sig; 
  

END rtl;