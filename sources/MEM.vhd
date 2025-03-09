

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM is
Port(MemWrite : in std_logic;
     ALUResIn : in std_logic_vector(31 downto 0);
     RD2 : in std_logic_vector(31 downto 0);
     MemData : out std_logic_vector(31 downto 0);
     ALUResOut : out std_logic_vector(31 downto 0);
     clk : in std_logic;
     
     enable : in std_logic
     );
end MEM;

architecture Behavioral of MEM is
type RAM_ARRAY is array(0 to 63) of std_logic_vector(31 downto 0);
signal RAM_DATA : RAM_ARRAY := (others => X"00000000");

signal shifted_address : std_logic_vector(31 downto 0);
signal address : std_logic_vector(5 downto 0);

begin

    shifted_address <= (to_stdlogicvector(to_bitvector(ALUResIn) srl 2));
    address <= shifted_address(7 downto 2);

    process(clk)
    begin
        if rising_edge(clk) then
            if memwrite = '1' and enable = '1' then
                RAM_DATA(conv_integer(address)) <= RD2;
            end if;
        end if;
    end process;
    
    MemData <= RAM_DATA(conv_integer(address));
    ALUResOut <= ALUResIn;

end Behavioral;
