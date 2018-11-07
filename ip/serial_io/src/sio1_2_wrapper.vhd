--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
--Date        : Tue Nov 06 13:47:54 2018
--Host        : CUTLASS running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target sio1_2_wrapper.bd
--Design      : sio1_2_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sio1_2_wrapper is
  port (
    acquire : in STD_LOGIC;
    adc_clk_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_clk_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_cnvrt_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_cnvrt_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_100 : in STD_LOGIC;
    din_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    din_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 );
    dout_strobe : out STD_LOGIC;
    en_tst_ptrn : in STD_LOGIC;
    reset : in STD_LOGIC;
    send_bitslip : in STD_LOGIC
  );
end sio1_2_wrapper;

architecture STRUCTURE of sio1_2_wrapper is
  component sio1_2 is
  port (
    clk_100 : in STD_LOGIC;
    reset : in STD_LOGIC;
    acquire : in STD_LOGIC;
    din_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    din_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    adc_clk_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_clk_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_cnvrt_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_cnvrt_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    send_bitslip : in STD_LOGIC;
    en_tst_ptrn : in STD_LOGIC;
    dout_strobe : out STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component sio1_2;
begin
sio1_2_i: component sio1_2
     port map (
      acquire => acquire,
      adc_clk_n(0) => adc_clk_n(0),
      adc_clk_p(0) => adc_clk_p(0),
      adc_cnvrt_n(0) => adc_cnvrt_n(0),
      adc_cnvrt_p(0) => adc_cnvrt_p(0),
      clk_100 => clk_100,
      din_n(1 downto 0) => din_n(1 downto 0),
      din_p(1 downto 0) => din_p(1 downto 0),
      dout(17 downto 0) => dout(17 downto 0),
      dout_strobe => dout_strobe,
      en_tst_ptrn => en_tst_ptrn,
      reset => reset,
      send_bitslip => send_bitslip
    );
end STRUCTURE;