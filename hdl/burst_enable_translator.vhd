----------------------------------------------------------------------------------
-- Company: UNS 
-- Engineer: Angel Soto
-- 
-- Create Date: 18.04.2018 15:59:04
-- Design Name: 
-- Module Name: burst_enable_translator - Behavioral
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

entity burst_enable_translator is
    Port ( rst : in STD_LOGIC;
           clk125 : in STD_LOGIC;
           we_b_100 : in STD_LOGIC;
           we_b_125 : out STD_LOGIC);
end burst_enable_translator;

architecture Behavioral of burst_enable_translator is

TYPE State_type IS (idle, one, waiting);  -- Define the states
SIGNAL State : State_Type;    -- Create a signal that uses 

signal we_b_resinc, we_b_resinc1: std_logic:='0';

begin

process (clk125)
begin
    if rising_edge(clk125) then
        we_b_resinc <= we_b_100;
        we_b_resinc1 <= we_b_resinc;
    end if;    
end process;


process(clk125,rst) 
begin
    if rising_edge(clk125) then
        if rst = '1' then
            State <= idle;
        else
            case State is
                when idle =>
                    if (we_b_resinc1 = '1') then
                        State <= one;
                    else
                        State <= idle;
                    end if;
                    
                when one => 
                    State <= waiting;
                 
                when waiting =>
                    if (we_b_resinc1 = '0') then
                        State <= idle;
                    else
                        State <= waiting;
                    end if;
                
                when others =>
                    State <= idle;
            end case;
        end if;
    end if;
end process;

process(State)
begin
    case State is
        when idle =>
            we_b_125 <= '0';
        when one =>
            we_b_125 <= '1';
        when waiting =>
            we_b_125 <= '0';
        when others =>
            we_b_125 <= '0';
    end case;
end process;


end Behavioral;
