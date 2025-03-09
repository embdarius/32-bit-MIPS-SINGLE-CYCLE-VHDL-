library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EX is
Port(RD1 : in std_logic_vector(31 downto 0);
     ALUSrc : in std_logic;
     RD2 : in std_logic_vector(31 downto 0);
     Ext_Imm : in std_logic_vector(31 downto 0);
     sa: in std_logic_vector(4 downto 0);
     func : in std_logic_vector(5 downto 0);
     ALUOp : in std_logic_vector(1 downto 0);
     PCplus4 : in std_logic_vector(31 downto 0);
     
     zero : out std_logic;
     greaterThanZero : out std_logic;
     greaterOrEqualToZero : out std_logic;
     
     ALURes : out std_logic_vector(31 downto 0);
     Branch_Address : out std_logic_vector(31 downto 0);
     clk : in std_logic
     
);

end EX;

architecture Behavioral of EX is
signal ALUCtrl : std_logic_vector(3 downto 0);
signal mux_out : std_logic_vector(31 downto 0);
signal ALUResSig : std_logic_vector(31 downto 0);

begin
process(ALUOp, func)
    begin
    case ALUOp is 
        when "01" => ALUCtrl <= "0001";   --ADD
        when "10" => ALUCtrl <= "0010";   --SUB
        when "11" => 
            case func is
                when "100110" => ALUCtrl <= "0011"; --XOR
                when "100000" => ALUCtrl <= "0001"; -- ADD
                when "100010" => ALUCtrl <= "0010"; --SUB
                when "000010" => ALUCtrl <= "0110"; -- SRL
                when "100100" => ALUCtrl <= "0111"; --AND LOGIC
                when "100101" => ALUCtrl <= "1000"; --OR LOGIC 
                when "000000" => ALUCtrl <= "1001"; -- SLL, NOOP 
                
                when others => ALUCtrl <= "1111"; -- ERROR 
            end case;
        when others => ALUCtrl <= "1111"; --ERROR 
    end case;
end process;

process(sa, RD1, mux_out, ALUCtrl)
    begin
    case ALUCtrl is
        when "0011" => ALUResSig <= RD1 XOR mux_out;
        when "0110" => ALUResSig <= to_stdlogicvector(to_bitvector(RD1) srl conv_integer(mux_out));
        when "0111" => ALUResSig <= RD1 AND mux_out;
        when "1000" => ALUResSig <= RD1 OR mux_out;
        when "1001" => ALUResSig <= to_stdlogicvector(to_bitvector(RD1) sll conv_integer(mux_out));
        when "0001" => ALUResSig <= RD1 + mux_out;
        when "0010" => ALUResSig <= RD1 - mux_out;
        when others => ALUResSig <= X"11111111";
    end case;
    
end process;

mux_out <= RD2 when ALUSrc = '0' else EXT_Imm;
zero <= '1' when ALUResSig = X"00000000" else '0';
greaterThanZero <= '1' when ALUResSig > X"00000000" else '0';
greaterOrEqualToZero <= '1' when ALUResSig >= X"00000000" else '0';

Branch_Address <= std_logic_vector(unsigned(PCPlus4) + (unsigned(EXT_Imm) sll 2));

ALURes <= ALUResSig;

end Behavioral;