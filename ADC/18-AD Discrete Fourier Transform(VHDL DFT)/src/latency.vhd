-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\magnitude\latency.vhd
-- Created: 2021-09-27 19:49:50
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 0.1
-- Target subsystem base rate: 0.1
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        0.1
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- Out1                          ce_out        0.1
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: latency
-- Source Path: magnitude/latency
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.latency_pkg.ALL;

ENTITY latency IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        In1                               :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        ce_out                            :   OUT   std_logic;
        Out1                              :   OUT   std_logic_vector(5 DOWNTO 0)  -- ufix6
        );
END latency;


ARCHITECTURE rtl OF latency IS

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL In1_unsigned                     : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Delay_reg                        : vector_of_unsigned6(0 TO 34);  -- ufix6 [35]
  SIGNAL Delay_out1                       : unsigned(5 DOWNTO 0);  -- ufix6

BEGIN
  In1_unsigned <= unsigned(In1);

  enb <= clk_enable;

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      Delay_reg <= (OTHERS => to_unsigned(16#00#, 6));
    ELSIF clk'EVENT AND clk = '1' THEN
     
        Delay_reg(0) <= In1_unsigned;
        Delay_reg(1 TO 34) <= Delay_reg(0 TO 33);
      
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(34);

  Out1 <= std_logic_vector(Delay_out1);

  ce_out <= clk_enable;

END rtl;

