library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ID is
Port(RegWrite : in std_logic;
     Instr : in std_logic_vector(25 downto 0);
     RegDst : in std_logic;
     ExtOp : in std_logic;
     RD1 : out std_logic_vector(31 downto 0);
     RD2 : out std_logic_vector(31 downto 0);
     WD : in std_logic_vector(31 downto 0);
     Ext_Imm : out std_logic_vector(31 downto 0);
     func : out std_logic_vector(5 downto 0);
     sa : out std_logic_vector(4 downto 0);
     write_enable : in std_logic;
     clk : in std_logic
);
end ID;

architecture Behavioral of ID is
type REG_ARRAY is array(0 to 31) of std_logic_vector(31 downto 0);
signal REG_DATA : REG_ARRAY := (others => X"00000000");

signal write_address : std_logic_vector(4 downto 0);

begin
    write_address <= Instr(20 downto 16) when RegDst = '0' else Instr(15 downto 11);
    
    process(clk, RegWrite, write_enable)
    begin
        if rising_edge(clk) then
            if(RegWrite = '1' and write_enable = '1') then
                REG_DATA(conv_integer(write_address)) <= WD;
            end if;
        end if;
    
    end process;
    
    RD1 <= REG_DATA(conv_integer(Instr(25 downto 21)));
    RD2 <= REG_DATA(conv_integer(Instr(20 downto 16)));
    
    Ext_Imm(15 downto 0) <= Instr(15 downto 0);
    Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0');
    
    func <= Instr(5 downto 0);
    sa <= Instr(10 downto 6);

end Behavioral;
