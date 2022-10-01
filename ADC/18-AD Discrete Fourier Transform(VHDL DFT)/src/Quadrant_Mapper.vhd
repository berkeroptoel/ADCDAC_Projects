-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\magnitude\Quadrant_Mapper.vhd
-- Created: 2021-09-26 19:09:52
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Quadrant_Mapper
-- Source Path: magnitude/mag_cal/Complex to Magnitude-Angle HDL Optimized/Quadrant_Mapper
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Quadrant_Mapper IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        xin                               :   IN    std_logic_vector(32 DOWNTO 0);  -- sfix33_En15
        yin                               :   IN    std_logic_vector(32 DOWNTO 0);  -- sfix33_En15
        xout                              :   OUT   std_logic_vector(32 DOWNTO 0);  -- sfix33_En15
        yout                              :   OUT   std_logic_vector(32 DOWNTO 0)  -- sfix33_En15
        );
END Quadrant_Mapper;


ARCHITECTURE rtl OF Quadrant_Mapper IS

  -- Signals
  SIGNAL xin_signed                       : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL abs_y                            : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL abs_cast                         : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL xAbs                             : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL xAbsReg                          : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL yin_signed                       : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL abs_y_1                          : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL abs_cast_1                       : signed(33 DOWNTO 0);  -- sfix34_En15
  SIGNAL yAbs                             : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL yAbsReg                          : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL xout_tmp                         : signed(32 DOWNTO 0);  -- sfix33_En15
  SIGNAL yout_tmp                         : signed(32 DOWNTO 0);  -- sfix33_En15

BEGIN
  xin_signed <= signed(xin);

  abs_cast <= resize(xin_signed, 34);
  
  abs_y <=  - (abs_cast) WHEN xin_signed < to_signed(0, 33) ELSE
      resize(xin_signed, 34);
  xAbs <= abs_y(32 DOWNTO 0);

  DelayxAbs_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      xAbsReg <= to_signed(0, 33);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        xAbsReg <= xAbs;
      END IF;
    END IF;
  END PROCESS DelayxAbs_process;


  yin_signed <= signed(yin);

  abs_cast_1 <= resize(yin_signed, 34);
  
  abs_y_1 <=  - (abs_cast_1) WHEN yin_signed < to_signed(0, 33) ELSE
      resize(yin_signed, 34);
  yAbs <= abs_y_1(32 DOWNTO 0);

  DelayyAbs_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      yAbsReg <= to_signed(0, 33);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        yAbsReg <= yAbs;
      END IF;
    END IF;
  END PROCESS DelayyAbs_process;


  
  relop_relop1 <= '1' WHEN xAbsReg > yAbsReg ELSE
      '0';

  
  xout_tmp <= yAbsReg WHEN relop_relop1 = '0' ELSE
      xAbsReg;

  xout <= std_logic_vector(xout_tmp);

  
  yout_tmp <= xAbsReg WHEN relop_relop1 = '0' ELSE
      yAbsReg;

  yout <= std_logic_vector(yout_tmp);

END rtl;
