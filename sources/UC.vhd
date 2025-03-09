library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
Port(
    Instr : in std_logic_vector(5 downto 0);        --Instr = OPCODE 
    RegDst : out std_logic;
    ExtOp : out std_logic;
    ALUSrc : out std_logic;
    Branch : out std_logic;
    Jump : out std_logic;
    ALUOp : out std_logic_vector(1 downto 0);
    MemWrite : out std_logic;
    MemToReg : out std_logic;
    RegWrite : out std_logic 
);
end UC;

architecture Behavioral of UC is

begin
    process(Instr)
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        ALUOp <= "00";
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '0';
        
        case Instr is 
            when "000000" => RegDst <= '1';         --TYPE R
                             RegWrite <= '1';
                             ALUOp <= "11";  -- TO INDICATE TYPE R INSTRUCTION 
                                
                                
                                                --Type I 
            when "001000" => ExtOp <= '1';      --ADD IMMEDIATE INSTRUCTION
                             ALUSrc <= '1';
                             ALUOp <= "01";     --ALUOp code for Addition 
                             RegWrite <= '1';
                             
                             
            when "100011" => ALUSrc <= '1';         --LOAD WORD INSTRUCTION 
                             MemToReg <= '1';
                             RegWrite <= '1';
                             EXTOp <= '1';   
                             ALUOp <= "01";
                             
            when "101011" => MemWrite <= '1';       --STORE WORD INSTRUCTION 
                             MemToReg <= 'X';
                             EXTOp <= '1';
                             RegDst <= 'X';
                             ALUSrc <= '1';
                             ALUOp <= "01";         
                             
            when "000100" => Branch <= '1';         --BRANCH ON EQUAL OPERATION 
                             ALUOp <= "10";         --ALUOp code for subtraction ( to compare values )
                             MemToReg <= 'X';
                             EXTOp <= '1';
                             RegDST <= 'X';
            
            when "000111" => Branch <= '1';     --BRANCH ON GREATER THAN 0 INSTRUCTION 
                             ALUOp <= "10";     --ALUOp code for subtraction( to compare values )
                             MemToReg <= 'X';
                             EXTOp <= '1';
                             RegDst <= 'X';
            
            when "000001" => Branch <= '1';     --BRANCH ON GREATER/EQUAL THAN 0 INSTRUCTION 
                             ALUOp <= "10";    --ALUOp code for subtraction( to compare values)
                             MemToReg <= 'X';
                             EXTOp <= '1';
                             RegDst <= 'X';
            --TYPE J
            
            when "000110" => Jump <= '1';
                             RegDST <= 'X';
                             ALUSrc <= 'X';
                             EXTOp <= 'X';
                             ALUOp <= "XX";
                             MemToReg <= 'X';
                             Branch <= 'X';
            when others => 
        end case; 
    end process;

end Behavioral;
