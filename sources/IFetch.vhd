library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
Port(clk : in std_logic;
     jump : in std_logic;
     pcsrc : in std_logic;
     branch_address : in std_logic_vector(31 downto 0);
     jump_address : in std_logic_vector(31 downto 0);
     pc_enable : in std_logic;
     pc_reset : in std_logic;
     instr : out std_logic_vector(31 downto 0);
     PCplus4 : out std_logic_vector(31 downto 0)
     );

end IFetch;

architecture Behavioral of IFetch is
signal PC : std_logic_vector(31 downto 0) := X"00000000";
signal mux_right : std_logic_vector(31 downto 0);
signal mux_left : std_logic_vector(31 downto 0);
signal address_summer : std_logic_vector(31 downto 0);
signal rom_address : std_logic_vector(31 downto 0);


type ROM_ARRAY is array(0 to 31) of std_logic_vector(31 downto 0);
signal ROM_DATA : ROM_ARRAY := (
                        
                                B"001000_00000_01000_0000000000000000",         --addi $8, $0, 0    --In registrul 8 se incarca valoarea 0  (0+0)
                                B"001000_00000_01001_0000000000000010",         --addi $9, $0, 2    --In registrul 9 se incarca valoarea 2  (0+2)
                                B"001000_00000_01010_0000000000001010",         --addi $10, $0, 10  --In registrul 10, se incarca valoarea 10(0+10) -- ROL DE CONTOR     
                                
                                                                                --loop_start:
                                B"001000_00000_01000_0000000000000001",         --addi $8, $8, 1    --La registrul 8 se adauga 1
                                B"000000_01000_01000_00000_00000_000000",       --sll $8, $8, 1     --Se shifteaza la stanga cu 1 bit registrul 8
                                B"000000_01001_01000_01000_00000_100000",       --add $8, $8, $9    --Se adauga la registrul 8, valoarea registrului 8 si se stocheaza in registrul 9
                                B"001000_01001_01001_0000000000000010",         --addi $9, $9, 2    --Se adauga la registrul 9 valoarea 2
                                B"000000_01001_01001_00000_00000_000000",       --sll $9, $9, 1     --Se shifteaza la stanga cu 1 bit registrul 9
                                B"001000_01010_01010_1111111111111111",         --addi $10, $10, -1     --Se decrementeaza contorul
                                B"000111_01010_00000_0000000000000011",         --bgtz $10, loop_start      --Se verifica daca contorul a ajuns la final, daca nu se continua bucla 
                                
                                B"001000_00000_01011_0000000000001111",         --addi $11, $0, 15      --Se incarca in registrul 11, valoarea 15 ( 0 + 15)
                                B"000000_01000_01011_01000_00000_100010",       --sub $8, $8, $11       --Se scade din registrul 8 valoarea din registrul 11
                                B"001000_00000_01011_0000000000100100",         --addi $11, $0, 16      --Se adauga la registrul 11 valoarea 16
                                B"000000_01011_01000_01000_00000_100110",       --xor $8, $8, $11       --Se face XOR intre reg 8 si reg 11, se salveaza in reg 8
                                B"000000_00000_00000_00000_00000_000000",       --noop                  --noop
                                B"101011_01000_00000_0000000000000011",         --sw $8, 4*($0)         --Se stocheaza rezultatul final (din registrul 8) in adresa de memorie 4*(Valoarea din REG 0)
                                
                                others => X"FFFFFFFF");
signal instruction : std_logic_vector(31 downto 0); 

begin
process(clk, pc_reset, pc_enable) 
begin
    if pc_reset = '1' then
        PC <= (others => '0');
    elsif rising_edge(clk) then 
        if pc_enable = '1' then 
            PC <= mux_right; 
        end if; 
    end if;
end process;

address_summer <= PC + 1;    --PC + 4 ( next instruction ) 

rom_address(6 downto 2) <= PC(6 downto 2);
rom_address(31 downto 7) <= (others => '0');
rom_address(1 downto 0) <= "00";
instruction <= rom_data(conv_integer(rom_address));


mux_left <= branch_address when PCSrc = '1' else address_summer;
mux_right <= jump_address when Jump = '1' else mux_left;


instr <= instruction;
PCplus4 <= address_summer;

end Behavioral;
