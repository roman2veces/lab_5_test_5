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
       -- print_compteur: out integer
   );
end digilock;

architecture Behavioral of digilock is

    type state is (init, E0, E1, E2, E3, opened, alarm);
    signal current_state: state := init;
    signal futur_state: state := init;
    --signal pressed_value_print: std_logic_vector(3 downto 0) := "0000";
    signal unique_A: std_logic;
    signal unique_B: std_logic;
    signal unique_C: std_logic;
   -- signal print_compteur: integer;
    
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
    variable compteur: integer := 0;
  --  variable pressed_value: std_logic_vector(3 downto 0);
    
    begin
        
        case current_state is 
            when init =>
                --SEG_0 <= "0100"; -- 0100 = 4 = L
                if compteur = 0 then 
                    SEG_0 <= "0110";
                    
               elsif compteur = 1 then 
                    SEG_0 <= "0111";
               elsif compteur = 2 then 
                    SEG_0 <= "1000";
               elsif compteur = 3 then 
                    SEG_0 <= "0101";
               else 
                    SEG_0 <= "0000";
               end if;
                SEG_1 <= "0000"; -- 0000 = 0 = -
                SEG_2 <= "0000";
                SEG_3 <= "0000";
                --if unique_A = '1' then
                if A = '1' then
                    entree_0 := "0001";
                --elsif unique_B = '1' then
                elsif B = '1' then
                    entree_0 := "0010";
                --elsif unique_C = '1' then
                elsif C = '1' then
                    entree_0 := "0011";
                else
                    entree_0 := "0000";
                end if;
                
               -- pressed_value_print <= pressed_value;
                
                if entree_0 /= "0000" then
               --     SEG_0 <= "0000"; -- 0100 = 4 = L
                    --SEG_1 <= "0000";
                    --SEG_2 <= "0000";
               --     SEG_3 <= entree_0;
                    --pressed_value := "0000";
                    futur_state <= E0;
                else 
                    futur_state <= init; 
                end if;  
                
            when E0 =>     
                --SEG_0 <= "0000";
                if compteur = 0 then 
                    SEG_0 <= "0110";
               elsif compteur = 1 then 
                    SEG_0 <= "0111";
               elsif compteur = 2 then 
                    SEG_0 <= "1000";
               elsif compteur = 3 then 
                    SEG_0 <= "0101";
               else 
                    SEG_0 <= "0000";
               end if; 
                SEG_1 <= "0000"; 
                SEG_2 <= "0000";
                SEG_3 <= entree_0;
                
                if A = '1' then
                    entree_1 := "0001";
                elsif B = '1' then
                    entree_1 := "0010";
                elsif C = '1' then
                    entree_1 := "0011";
                else
                    entree_1 := "0000";
                end if;
                
                if entree_1 /= "0000" then
                    futur_state <= E1;
                else 
                    futur_state <= E0;
                end if;  
                   
            when E1 =>
                --SEG_0 <= "0000"; -- 0100 = 4 = L
                if compteur = 0 then 
                    SEG_0 <= "0110";
               elsif compteur = 1 then 
                    SEG_0 <= "0111";
               elsif compteur = 2 then 
                    SEG_0 <= "1000";
               elsif compteur = 3 then 
                    SEG_0 <= "0101";
               else 
                    SEG_0 <= "0000";
               end if;
                SEG_1 <= "0000"; -- 0000 = 0 = -
                SEG_2 <= entree_1;
                SEG_3 <= entree_0;
                --SEG_3 <= "0010";
                --if unique_A = '1' then
                if A = '1' then
                    entree_2 := "0001";
                --elsif unique_B = '1' then
                elsif B = '1' then
                    entree_2 := "0010";
                --elsif unique_C = '1' then
                elsif C = '1' then
                    entree_2 := "0011";
                else
                    entree_2 := "0000";
                end if;
                
                --pressed_value_print <= pressed_value;
                
                if entree_2 /= "0000" then
                    compteur := 1;
                    --SEG_1 <= pressed_value;
                    --pressed_value := "0000";
                    futur_state <= E2;
                else 
                    compteur := 0;
                    futur_state <= E1;
                end if;  
            
            when E2 =>
               --SEG_0 <= "0000";
               if compteur = 0 then 
                    SEG_0 <= "0110";
               elsif compteur = 1 then 
                    SEG_0 <= "0111";
               elsif compteur = 2 then 
                    SEG_0 <= "1000";
               elsif compteur = 3 then 
                    SEG_0 <= "0101";
               else 
                    SEG_0 <= "0000";
               end if; 
               SEG_1 <= entree_2;
               SEG_2 <= entree_1;
               SEG_3 <= entree_0;
               if A = '1' then
                    entree_3 := "0001";
               elsif B = '1' then
                    entree_3 := "0010";
                --elsif unique_C = '1' then
               elsif C = '1' then
                    entree_3 := "0011";
               else
                    entree_3 := "0000";
               end if;
                
               if entree_3 /= "0000" then
                    futur_state <= E3;
               else 
                    futur_state <= E2;
               end if;
               
            when E3 => 
               SEG_0 <= entree_3;   
               SEG_1 <= entree_2;
               SEG_2 <= entree_1;
               SEG_3 <= entree_0;
               if entree_0 = "0011" and entree_1 = "0001" and entree_2 = "0011" and entree_3 = "0010" then
                    futur_state <= opened;  
               elsif compteur >= 2 then 
                    compteur := 0;
                   -- print_compteur <= compteur;
                    futur_state <= alarm;
               else 
                    compteur := compteur + 1;
                    --print_compteur <= compteur;
                    futur_state <= init;
               end if;
                
            when opened =>
                SEG_0 <= "0101"; -- 0101 = 5 = O
                SEG_1 <= "0101";
                SEG_2 <= "0101";
                SEG_3 <= "0101";
                if A = '1' or B = '1' or C = '1' then
                    futur_state <= init;
                else 
                    futur_state <= opened;
                end if;
            
            when alarm =>
                SEG_0 <= "0000"; 
                SEG_1 <= "0000";
                SEG_2 <= "0100"; 
                SEG_3 <= "0001"; 
               
                futur_state <= alarm;
                
            when others =>
              futur_state <= init;
        end case;      
    end process;


end Behavioral;
