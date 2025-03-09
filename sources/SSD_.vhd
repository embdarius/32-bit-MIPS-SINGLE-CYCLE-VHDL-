library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD1 is
    Port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           digit4 : in STD_LOGIC_VECTOR (3 downto 0);
           digit5 : in STD_LOGIC_VECTOR (3 downto 0);
           digit6 : in STD_LOGIC_VECTOR (3 downto 0);
           digit7 : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD1;

architecture Behavioral of SSD1 is

    signal counter: std_logic_vector(16 downto 0);
    signal number: std_logic_vector(3 downto 0);
    signal an_signal: std_logic_vector(7 downto 0);
    signal cat_signal: std_logic_vector(6 downto 0);
    
    
begin
    process(clk)
    begin
        if clk'event and clk='1' then
           counter <= counter + 1;
        end if;
    end process; 
    
    process(counter, DIGIT0, DIGIT1, DIGIT2, DIGIT3, DIGIT4, DIGIT5, DIGIT6, DIGIT7)
    begin
        case counter(15 downto 13) is
            when "000" => number <= DIGIT0;
            when "001" => number <= DIGIT1;
            when "010" => number <= DIGIT2;
            when "011" => number <= DIGIT3;
            when "100" => number <= DIGIT4;
            when "101" => number <= DIGIT5;
            when "110" => number <= DIGIT6;
            when "111" => number <= DIGIT7;
            
            when others => number <= DIGIT0;
        end case;
    end process;
    
    process(counter)
    begin
        case counter(15 downto 13) is
            when "000" => an_signal <= "11111110";
            when "001" => an_signal <= "11111101";
            when "010" => an_signal <= "11111011";
            when "011" => an_signal <= "11110111";
            when "100" => an_signal <= "11101111";
            when "101" => an_signal <= "11011111";
            when "110" => an_signal <= "10111111";
            when "111" => an_signal <= "01111111";
            
            when others => an_signal <= "01111111";
        end case;
    end process;
    
    an<=an_signal;
    
    process(number)
    begin
        case number is
            when "0000" => cat_signal <= "1000000";
            when "0001" => cat_signal <= "1111001";
            when "0010" => cat_signal <= "0100100";
            when "0011" => cat_signal <= "0110000";
            when "0100" => cat_signal <= "0011001";
            when "0101" => cat_signal <= "0010010";
            when "0110" => cat_signal <= "0000010";
            when "0111" => cat_signal <= "1111000";
            when "1000" => cat_signal <= "0000000";
            when "1001" => cat_signal <= "0010000";
            when "1010" => cat_signal <= "0001000";
            when "1011" => cat_signal <= "0000011";
            when "1100" => cat_signal <= "1000110";   
            when "1101" => cat_signal <= "0100001";    
            when "1110" => cat_signal <= "0000110";
            when "1111" => cat_signal <= "0001110";
            
            when others => cat_signal <= "0001110";
        end case;
     end process;
     
     cat<=cat_signal;

end Behavioral;