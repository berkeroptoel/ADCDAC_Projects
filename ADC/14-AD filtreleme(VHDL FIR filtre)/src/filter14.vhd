-- -------------------------------------------------------------
--
-- Module: filter14
-- Generated by MATLAB(R) 9.4 and Filter Design HDL Coder 3.1.3.
-- Generated on: 2021-03-12 11:36:01
-- -------------------------------------------------------------

-- -------------------------------------------------------------
-- HDL Code Generation Options:
--
-- TargetLanguage: VHDL
-- Name: filter14
-- ResetAssertedLevel: Active-low
-- TestBenchStimulus: impulse step ramp chirp noise 
-- GenerateHDLTestBench: off

-- -------------------------------------------------------------
-- HDL Implementation    : Fully parallel
-- Folding Factor        : 1
-- -------------------------------------------------------------
-- Filter Settings:
--
-- Discrete-Time FIR Filter (real)
-- -------------------------------
-- Filter Structure  : Direct-Form FIR
-- Filter Length     : 21
-- Stable            : Yes
-- Linear Phase      : Yes (Type 1)
-- Arithmetic        : fixed
-- Numerator         : s16,18 -> [-1.250000e-01 1.250000e-01)
-- Input             : s13,0 -> [-4096 4096)
-- Filter Internals  : Full Precision
--   Output          : s32,18 -> [-8192 8192)  (auto determined)
--   Product         : s28,18 -> [-512 512)  (auto determined)
--   Accumulator     : s32,18 -> [-8192 8192)  (auto determined)
--   Round Mode      : No rounding
--   Overflow Mode   : No overflow
-- -------------------------------------------------------------



LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY filter14 IS
   PORT( clk                             :   IN    std_logic; 
         clk_enable                      :   IN    std_logic; 
         reset                           :   IN    std_logic; 
         filter_in                       :   IN    std_logic_vector(12 DOWNTO 0); -- sfix13
         filter_out                      :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En18
         );

END filter14;


----------------------------------------------------------------
--Module Architecture: filter14
----------------------------------------------------------------
ARCHITECTURE rtl OF filter14 IS
  -- Local Functions
  -- Type Definitions
  TYPE delay_pipeline_type IS ARRAY (NATURAL range <>) OF signed(12 DOWNTO 0); -- sfix13
  -- Constants
  CONSTANT coeff1                         : signed(15 DOWNTO 0) := to_signed(-5391, 16); -- sfix16_En18
  CONSTANT coeff2                         : signed(15 DOWNTO 0) := to_signed(3443, 16); -- sfix16_En18
  CONSTANT coeff3                         : signed(15 DOWNTO 0) := to_signed(5013, 16); -- sfix16_En18
  CONSTANT coeff4                         : signed(15 DOWNTO 0) := to_signed(7609, 16); -- sfix16_En18
  CONSTANT coeff5                         : signed(15 DOWNTO 0) := to_signed(10867, 16); -- sfix16_En18
  CONSTANT coeff6                         : signed(15 DOWNTO 0) := to_signed(14467, 16); -- sfix16_En18
  CONSTANT coeff7                         : signed(15 DOWNTO 0) := to_signed(18069, 16); -- sfix16_En18
  CONSTANT coeff8                         : signed(15 DOWNTO 0) := to_signed(21315, 16); -- sfix16_En18
  CONSTANT coeff9                         : signed(15 DOWNTO 0) := to_signed(23904, 16); -- sfix16_En18
  CONSTANT coeff10                        : signed(15 DOWNTO 0) := to_signed(25568, 16); -- sfix16_En18
  CONSTANT coeff11                        : signed(15 DOWNTO 0) := to_signed(26146, 16); -- sfix16_En18
  CONSTANT coeff12                        : signed(15 DOWNTO 0) := to_signed(25568, 16); -- sfix16_En18
  CONSTANT coeff13                        : signed(15 DOWNTO 0) := to_signed(23904, 16); -- sfix16_En18
  CONSTANT coeff14                        : signed(15 DOWNTO 0) := to_signed(21315, 16); -- sfix16_En18
  CONSTANT coeff15                        : signed(15 DOWNTO 0) := to_signed(18069, 16); -- sfix16_En18
  CONSTANT coeff16                        : signed(15 DOWNTO 0) := to_signed(14467, 16); -- sfix16_En18
  CONSTANT coeff17                        : signed(15 DOWNTO 0) := to_signed(10867, 16); -- sfix16_En18
  CONSTANT coeff18                        : signed(15 DOWNTO 0) := to_signed(7609, 16); -- sfix16_En18
  CONSTANT coeff19                        : signed(15 DOWNTO 0) := to_signed(5013, 16); -- sfix16_En18
  CONSTANT coeff20                        : signed(15 DOWNTO 0) := to_signed(3443, 16); -- sfix16_En18
  CONSTANT coeff21                        : signed(15 DOWNTO 0) := to_signed(-5391, 16); -- sfix16_En18

  -- Signals
  SIGNAL delay_pipeline                   : delay_pipeline_type(0 TO 20); -- sfix13
  SIGNAL product21                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp                         : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product20                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_1                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product19                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_2                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product18                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_3                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product17                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_4                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product16                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_5                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product15                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_6                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product14                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_7                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product13                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_8                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product12                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_9                       : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product11                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_10                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product10                        : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_11                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product9                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_12                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product8                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_13                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product7                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_14                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product6                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_15                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product5                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_16                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product4                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_17                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product3                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_18                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product2                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_19                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL product1_cast                    : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL product1                         : signed(27 DOWNTO 0); -- sfix28_En18
  SIGNAL mul_temp_20                      : signed(28 DOWNTO 0); -- sfix29_En18
  SIGNAL sum1                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp                         : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum2                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_1                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum3                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_2                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum4                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_3                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum5                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_4                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum6                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_5                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum7                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_6                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum8                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_7                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum9                             : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_8                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum10                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_9                       : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum11                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_10                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum12                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_11                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum13                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_12                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum14                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_13                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum15                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_14                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum16                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_15                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum17                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_16                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum18                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_17                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum19                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_18                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL sum20                            : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL add_temp_19                      : signed(32 DOWNTO 0); -- sfix33_En18
  SIGNAL output_typeconvert               : signed(31 DOWNTO 0); -- sfix32_En18
  SIGNAL output_register                  : signed(31 DOWNTO 0); -- sfix32_En18


BEGIN

  -- Block Statements
  Delay_Pipeline_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      delay_pipeline(0 TO 20) <= (OTHERS => (OTHERS => '0'));
    ELSIF clk'event AND clk = '1' THEN
      IF clk_enable = '1' THEN
        delay_pipeline(0) <= signed(filter_in);
        delay_pipeline(1 TO 20) <= delay_pipeline(0 TO 19);
      END IF;
    END IF; 
  END PROCESS Delay_Pipeline_process;

  mul_temp <= delay_pipeline(20) * coeff21;
  product21 <= mul_temp(27 DOWNTO 0);

  mul_temp_1 <= delay_pipeline(19) * coeff20;
  product20 <= mul_temp_1(27 DOWNTO 0);

  mul_temp_2 <= delay_pipeline(18) * coeff19;
  product19 <= mul_temp_2(27 DOWNTO 0);

  mul_temp_3 <= delay_pipeline(17) * coeff18;
  product18 <= mul_temp_3(27 DOWNTO 0);

  mul_temp_4 <= delay_pipeline(16) * coeff17;
  product17 <= mul_temp_4(27 DOWNTO 0);

  mul_temp_5 <= delay_pipeline(15) * coeff16;
  product16 <= mul_temp_5(27 DOWNTO 0);

  mul_temp_6 <= delay_pipeline(14) * coeff15;
  product15 <= mul_temp_6(27 DOWNTO 0);

  mul_temp_7 <= delay_pipeline(13) * coeff14;
  product14 <= mul_temp_7(27 DOWNTO 0);

  mul_temp_8 <= delay_pipeline(12) * coeff13;
  product13 <= mul_temp_8(27 DOWNTO 0);

  mul_temp_9 <= delay_pipeline(11) * coeff12;
  product12 <= mul_temp_9(27 DOWNTO 0);

  mul_temp_10 <= delay_pipeline(10) * coeff11;
  product11 <= mul_temp_10(27 DOWNTO 0);

  mul_temp_11 <= delay_pipeline(9) * coeff10;
  product10 <= mul_temp_11(27 DOWNTO 0);

  mul_temp_12 <= delay_pipeline(8) * coeff9;
  product9 <= mul_temp_12(27 DOWNTO 0);

  mul_temp_13 <= delay_pipeline(7) * coeff8;
  product8 <= mul_temp_13(27 DOWNTO 0);

  mul_temp_14 <= delay_pipeline(6) * coeff7;
  product7 <= mul_temp_14(27 DOWNTO 0);

  mul_temp_15 <= delay_pipeline(5) * coeff6;
  product6 <= mul_temp_15(27 DOWNTO 0);

  mul_temp_16 <= delay_pipeline(4) * coeff5;
  product5 <= mul_temp_16(27 DOWNTO 0);

  mul_temp_17 <= delay_pipeline(3) * coeff4;
  product4 <= mul_temp_17(27 DOWNTO 0);

  mul_temp_18 <= delay_pipeline(2) * coeff3;
  product3 <= mul_temp_18(27 DOWNTO 0);

  mul_temp_19 <= delay_pipeline(1) * coeff2;
  product2 <= mul_temp_19(27 DOWNTO 0);

  product1_cast <= resize(product1, 32);

  mul_temp_20 <= delay_pipeline(0) * coeff1;
  product1 <= mul_temp_20(27 DOWNTO 0);

  add_temp <= resize(product1_cast, 33) + resize(product2, 33);
  sum1 <= add_temp(31 DOWNTO 0);

  add_temp_1 <= resize(sum1, 33) + resize(product3, 33);
  sum2 <= add_temp_1(31 DOWNTO 0);

  add_temp_2 <= resize(sum2, 33) + resize(product4, 33);
  sum3 <= add_temp_2(31 DOWNTO 0);

  add_temp_3 <= resize(sum3, 33) + resize(product5, 33);
  sum4 <= add_temp_3(31 DOWNTO 0);

  add_temp_4 <= resize(sum4, 33) + resize(product6, 33);
  sum5 <= add_temp_4(31 DOWNTO 0);

  add_temp_5 <= resize(sum5, 33) + resize(product7, 33);
  sum6 <= add_temp_5(31 DOWNTO 0);

  add_temp_6 <= resize(sum6, 33) + resize(product8, 33);
  sum7 <= add_temp_6(31 DOWNTO 0);

  add_temp_7 <= resize(sum7, 33) + resize(product9, 33);
  sum8 <= add_temp_7(31 DOWNTO 0);

  add_temp_8 <= resize(sum8, 33) + resize(product10, 33);
  sum9 <= add_temp_8(31 DOWNTO 0);

  add_temp_9 <= resize(sum9, 33) + resize(product11, 33);
  sum10 <= add_temp_9(31 DOWNTO 0);

  add_temp_10 <= resize(sum10, 33) + resize(product12, 33);
  sum11 <= add_temp_10(31 DOWNTO 0);

  add_temp_11 <= resize(sum11, 33) + resize(product13, 33);
  sum12 <= add_temp_11(31 DOWNTO 0);

  add_temp_12 <= resize(sum12, 33) + resize(product14, 33);
  sum13 <= add_temp_12(31 DOWNTO 0);

  add_temp_13 <= resize(sum13, 33) + resize(product15, 33);
  sum14 <= add_temp_13(31 DOWNTO 0);

  add_temp_14 <= resize(sum14, 33) + resize(product16, 33);
  sum15 <= add_temp_14(31 DOWNTO 0);

  add_temp_15 <= resize(sum15, 33) + resize(product17, 33);
  sum16 <= add_temp_15(31 DOWNTO 0);

  add_temp_16 <= resize(sum16, 33) + resize(product18, 33);
  sum17 <= add_temp_16(31 DOWNTO 0);

  add_temp_17 <= resize(sum17, 33) + resize(product19, 33);
  sum18 <= add_temp_17(31 DOWNTO 0);

  add_temp_18 <= resize(sum18, 33) + resize(product20, 33);
  sum19 <= add_temp_18(31 DOWNTO 0);

  add_temp_19 <= resize(sum19, 33) + resize(product21, 33);
  sum20 <= add_temp_19(31 DOWNTO 0);

  output_typeconvert <= sum20;

  Output_Register_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      output_register <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
      IF clk_enable = '1' THEN
        output_register <= output_typeconvert;
      END IF;
    END IF; 
  END PROCESS Output_Register_process;

  -- Assignment Statements
  filter_out <= std_logic_vector(output_register);
END rtl;
