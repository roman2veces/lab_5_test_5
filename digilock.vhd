----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 07:10:40 PM
-- Design Name: 
-- Module Name: digilock - Behavioral
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

entity digilock is
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
end digilock;

architecture Behavioral of digilock is

    type state is (init, E0, E1, E2, E3, opened, alarm);
    signal current_state: state := init;
    signal futur_state: state := init;
    signal pressed_value_print: std_logic_vector(3 downto 0) := "0000";
    signal unique_A: std_logic;
    signal unique_B: std_logic;
    signal unique_C: std_logic;
    
    component pulse_generator is 
        Port ( 
            clk: in std_logic;
            reset: in std_logic;
            input: in std_logic;
            output: out std_logic
        );
    end component;
    
begin

   -- test1: pulse_generator port map(clk => clk, reset => reset,  input => A, output => unique_A);
   -- test2: pulse_generator port map(clk => clk, reset => reset,  input => B, output => unique_B);
   -- test3: pulse_generator port map(clk => clk, reset => reset,  input => C, output => unique_C);

    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= init;
        elsif rising_edge(clk) then
            current_state <= futur_state;
        end if;
    end process;
    
    --process (current_state, unique_A, unique_B, unique_C)
    process (current_state, A, B, C)
   -- variable code: std_logic_vector(15 downto 0) := "0011000100110010";
    variable entree_0: std_logic_vector(3 downto 0);
    variable entree_1: std_logic_vector(3 downto 0);
    variable entree_2: std_logic_vector(3 downto 0);
    variable entree_3: std_logic_vector(3 downto 0);
  --  variable concat: std_logic_vector(15 downto 0);
    variable compteur: integer RANGE 0 TO 4 := 0;
    variable pressed_value: std_logic_vector(3 downto 0);
    
    begin
        --if unique_A = '1' then
        if A = '1' then
            pressed_value := "0001";
        --elsif unique_B = '1' then
        elsif B = '1' then
            pressed_value := "0010";
        --elsif unique_C = '1' then
        elsif C = '1' then
            pressed_value := "0011";
        else
            pressed_value := "0000";
        end if;
        
        pressed_value_print <= pressed_value;
        
        case current_state is 
            when init =>
                SEG_0 <= "0100"; -- 0100 = 4 = L
                SEG_1 <= "0000"; -- 0000 = 0 = -
                SEG_2 <= "0000";
                SEG_3 <= "0000";
                if pressed_value = "0001" then
                    futur_state <= E0;
                else 
                    futur_state <= init;
                end if;    
                
            when E0 =>     
                SEG_0 <= "0001"; -- 0100 = 4 = L
                SEG_1 <= "0001"; -- 0000 = 0 = -
                SEG_2 <= "0001";
                SEG_3 <= "0001";
                if pressed_value = "0010" then
                    futur_state <= E1;
                else 
                    futur_state <= E0;
                end if;
            
            when E1 =>
                SEG_0 <= "0010"; -- 0100 = 4 = L
                SEG_1 <= "0010"; -- 0000 = 0 = -
                SEG_2 <= "0010";
                SEG_3 <= "0010";
                if B = '1' then
                    futur_state <= E2;
                else 
                    futur_state <= E1;
                end if;
            
            when E2 =>
               SEG_0 <= "0011"; -- 0100 = 4 = L
               SEG_1 <= "0011"; -- 0000 = 0 = -
               SEG_2 <= "0011";
               SEG_3 <= "0011";
               if B = '1' then
                    futur_state <= E3;
               else 
                    futur_state <= E2;
               end if;
            when E3 => 
               SEG_0 <= "0100"; -- 0100 = 4 = L
               SEG_1 <= "0100"; -- 0000 = 0 = -
               SEG_2 <= "0100";
               SEG_3 <= "0100";
               if B = '1' then
                    futur_state <= opened;  
               else 
                    futur_state <= E3;
               end if;
                
            when opened =>
                SEG_0 <= "0101"; -- 0101 = 5 = O
                SEG_1 <= "0101";
                SEG_2 <= "0101";
                SEG_3 <= "0101";
                if B = '1' then
                    futur_state <= alarm;
                else 
                    futur_state <= opened;
                end if;
            
            when alarm =>
                SEG_0 <= "0110"; -- 0101 = 5 = O
                SEG_1 <= "0110";
                SEG_2 <= "0110"; -- 0100 = 4 = L
                SEG_3 <= "0110"; -- 0001 = 1 = A 
                if B = '1' then
                    futur_state <= init;
                else 
                    futur_state <= alarm;
                end if;
            when others =>
              etat_prochain <= init;
        end case;      
    end process;


end Behavioral;
