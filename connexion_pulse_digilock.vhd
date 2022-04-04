----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2022 09:50:25 AM
-- Design Name: 
-- Module Name: connexion_pulse_digilock - Behavioral
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

entity connexion_pulse_digilock is
  Port ( 
    clk :   IN STD_LOGIC;
    reset : IN STD_LOGIC;
    button_A: IN STD_LOGIC;
    button_B: IN STD_LOGIC;
    button_C: IN STD_LOGIC;
    SEG_0 :     IN STD_LOGIC_VECTOR(3 downto 0);
    SEG_1 :     IN STD_LOGIC_VECTOR(3 downto 0);
    SEG_2 :     IN STD_LOGIC_VECTOR(3 downto 0);
    SEG_3 :     IN STD_LOGIC_VECTOR(3 downto 0)
  );
end connexion_pulse_digilock;

architecture Behavioral of connexion_pulse_digilock is

    component pulse_generator is 
        Port ( 
            clk: in std_logic;
            reset: in std_logic;
            input: in std_logic;
            output: out std_logic
        );
    end component;
    
    component digilock is
        Port ( 
            clk: in std_logic;
            reset: in std_logic;
            A: in std_logic;
            B: in std_logic;
            C: in std_logic;
            SEG_0: out std_logic_vector(3 downto 0);
            SEG_1: out std_logic_vector(3 downto 0);
            SEG_2: out std_logic_vector(3 downto 0);
            SEG_3: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal unique_A :std_logic;
    signal unique_B :std_logic;
    signal unique_C :std_logic;
begin

    U2: digilock port map(
        clk => clk, 
        reset => reset,
        SEG_0 => SEG_0,
        SEG_1 => SEG_1,
        SEG_2 => SEG_2,
        SEG_3 => SEG_3,
        A => unique_A,
        B => unique_B,
        C => unique_C
    );
    
    U3: pulse_generator port map(clk => clk, reset => reset,  input => button_A, output => unique_A);
    U4: pulse_generator port map(clk => clk, reset => reset,  input => button_B, output => unique_B);
    U5: pulse_generator port map(clk => clk, reset => reset,  input => button_C, output => unique_C);

end Behavioral;
