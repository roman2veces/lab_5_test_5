----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 06:03:41 PM
-- Design Name: 
-- Module Name: circuit_final - Behavioral
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

entity circuit_final is
  Port ( 
    clk :       IN STD_LOGIC;
    reset : IN STD_LOGIC;
    button_A: IN STD_LOGIC;
    button_B: IN STD_LOGIC;
    button_C: IN STD_LOGIC;
        --SEG_0 :     IN STD_LOGIC_VECTOR(3 downto 0);
        --SEG_1 :     IN STD_LOGIC_VECTOR(3 downto 0);
        --SEG_2 :     IN STD_LOGIC_VECTOR(3 downto 0);
        --SEG_3 :     IN STD_LOGIC_VECTOR(3 downto 0);
    AN :        OUT STD_LOGIC_VECTOR(7 downto 0);
    SEVEN_SEG : OUT STD_LOGIC_VECTOR(7 downto 0)
  );
end circuit_final;

architecture Behavioral of circuit_final is

    signal unique_A :std_logic;
    signal unique_B :std_logic;
    signal unique_C :std_logic;
    signal SEG_0_signal : STD_LOGIC_VECTOR(3 downto 0);
    signal SEG_1_signal : STD_LOGIC_VECTOR(3 downto 0);
    signal SEG_2_signal : STD_LOGIC_VECTOR(3 downto 0);
    signal SEG_3_signal : STD_LOGIC_VECTOR(3 downto 0);
    signal debounce_A: std_logic;
    signal debounce_B: std_logic;
    signal debounce_C: std_logic;
    signal debounce_reset: std_logic;
    
    
    
    component pulse_generator is 
        Port ( 
            clk: in std_logic;
            reset: in std_logic;
            input: in std_logic;
            output: out std_logic
        );
    end component;
        
    COMPONENT DEBOUNCE IS
        GENERIC(
            counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
        PORT(
            clk     : IN  STD_LOGIC;  --input clock
            button  : IN  STD_LOGIC;  --input signal to be debounced
            result  : OUT STD_LOGIC); --debounced signal
    END COMPONENT;
    
    component DISP_7_SEG_LAB4 IS
    PORT (
        CLK :       IN STD_LOGIC;
        SEG_0 :     IN STD_LOGIC_VECTOR(3 downto 0);
        SEG_1 :     IN STD_LOGIC_VECTOR(3 downto 0);
        SEG_2 :     IN STD_LOGIC_VECTOR(3 downto 0);
        SEG_3 :     IN STD_LOGIC_VECTOR(3 downto 0);
        AN :        OUT STD_LOGIC_VECTOR(7 downto 0);
        SEVEN_SEG : OUT STD_LOGIC_VECTOR(7 downto 0)
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
    
begin

U1: DISP_7_SEG_LAB4 port map(
        CLK => clk, 
        SEG_0 => SEG_0_signal,
        SEG_1 => SEG_1_signal,
        SEG_2 => SEG_2_signal,
        SEG_3 => SEG_3_signal,
        AN => AN,
        SEVEN_SEG => SEVEN_SEG  
    ); 

U2: digilock port map(
        clk => clk, 
        reset => debounce_reset,
        SEG_0 => SEG_0_signal,
        SEG_1 => SEG_1_signal,
        SEG_2 => SEG_2_signal,
        SEG_3 => SEG_3_signal,
        A => unique_A,
        B => unique_B,
        C => unique_C
    );
    
    U3: pulse_generator port map(clk => clk, reset => debounce_reset,  input => debounce_A, output => unique_A);
    U4: pulse_generator port map(clk => clk, reset => debounce_reset,  input => debounce_B, output => unique_B);
    U5: pulse_generator port map(clk => clk, reset => debounce_reset,  input => debounce_C, output => unique_C);
    U6: DEBOUNCE port map(clk => clk, button => button_A, result => debounce_A);
    U7: DEBOUNCE port map(clk => clk, button => button_B, result => debounce_B);
    U8: DEBOUNCE port map(clk => clk, button => button_C, result => debounce_C);
    U9: DEBOUNCE port map(clk => clk, button => reset, result => debounce_reset);

end Behavioral;
