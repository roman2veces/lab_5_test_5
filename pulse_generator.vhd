----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2022 10:50:27 AM
-- Design Name: 
-- Module Name: pulse_generator - Behavioral
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

entity pulse_generator is
  Port ( 
    clk: in std_logic;
    reset: in std_logic;
    input: in std_logic;
    output: out std_logic
  );
end pulse_generator;

architecture Behavioral of pulse_generator is
    
    type state is (not_pulse, pulse, synchronized);
    signal current_state: state := not_pulse;
    signal next_state: state := not_pulse;
   
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= not_pulse;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    process(current_state, input)
    begin
        case current_state is
            when not_pulse => output <= '0';
                if input = '1' then
                    next_state <= pulse;
               -- else 
               --     next_state <= not_pulse;
                end if;
            
            when pulse => output <= '1';
                if input = '1' then
                    next_state <= synchronized;
                else 
                    next_state <= not_pulse;
                end if;
                
            when synchronized => output <= '0';
                if input = '0' or input = 'U' then
                    next_state <= not_pulse;
               -- else 
               --     next_state <= not_pulse;
                end if;
        end case;         
    end process;
end Behavioral;