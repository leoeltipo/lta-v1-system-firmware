----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2017 02:42:33 PM
-- Design Name: 
-- Module Name: vec2bit_6 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vec2bit_6 is
    Port ( vec_in : in STD_LOGIC_VECTOR (5 downto 0);
           out0 : out STD_LOGIC;
           out1 : out STD_LOGIC;
           out2 : out STD_LOGIC;
           out3 : out STD_LOGIC;
           out4 : out STD_LOGIC;
           out5 : out STD_LOGIC);
end vec2bit_6;

architecture Behavioral of vec2bit_6 is

begin

out0 <= vec_in(0);
out1 <= vec_in(1);
out2 <= vec_in(2);
out3 <= vec_in(3);
out4 <= vec_in(4);
out5 <= vec_in(5);

end Behavioral;
