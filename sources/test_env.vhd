library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           
           );
end test_env;


architecture Behavioral of test_env is

component SSD1 is
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
end component SSD1;
signal d1,d2,d3,d4,d5,d6,d7,d8 : std_logic_vector(3 downto 0) := "0000";
signal out_cat : std_logic_vector(6 downto 0);
signal out_an : std_logic_vector(7 downto 0);

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component MPG;
signal mpg_btn : std_logic := '0';
signal mpg_en : std_logic; 


component IFetch is
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
end component IFetch;
signal current_instruction : std_logic_vector(31 downto 0);
signal PCplus4_sig : std_logic_vector(31 downto 0);
signal ifetch_ssd : std_logic_vector(31 downto 0);

component ID is
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
end component ID;
signal IDrdSUM : std_logic_vector(31 downto 0);
signal ID_rd1 : std_logic_vector(31 downto 0);
signal ID_rd2 : std_logic_vector(31 downto 0);
signal id_write_data : std_logic_vector(31 downto 0);
signal id_ext_imm : std_logic_vector(31 downto 0);
signal id_func : std_logic_vector(5 downto 0);
signal id_sa : std_logic_vector(4 downto 0);

signal opcode : std_logic_vector(5 downto 0);

component UC is
Port(
    Instr : in std_logic_vector(5 downto 0);
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
end component UC;
signal uc_regDst : std_logic;
signal uc_extOp : std_logic;
signal uc_aluSRC : std_logic;
signal uc_branch : std_logic;
signal uc_jump : std_logic;
signal uc_aluOP : std_logic_vector(1 downto 0);
signal uc_memWrite : std_logic;
signal uc_memToReg : std_logic;
signal uc_regWrite : std_logic;

signal mux_sel : std_logic_vector(2 downto 0);
signal ssd_mux : std_logic_vector(31 downto 0);


component EX is
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
end component EX;
signal ex_zero : std_logic;
signal ex_greaterThanZero : std_logic;
signal ex_greaterOrEqualToZero : std_logic;
signal ex_alures : std_logic_vector(31 downto 0);
signal ex_branch_address : std_logic_vector(31 downto 0);

component MEM is
Port(MemWrite : in std_logic;
     ALUResIn : in std_logic_vector(31 downto 0);
     RD2 : in std_logic_vector(31 downto 0);
     MemData : out std_logic_vector(31 downto 0);
     ALUResOut : out std_logic_vector(31 downto 0);
     clk : in std_logic;
     
     enable : in std_logic
     );
end component MEM;
signal mem_memdata : std_logic_vector(31 downto 0);
signal mem_ALUResOut : std_logic_vector(31 downto 0);


signal ext_imm_sig : std_logic_vector(31 downto 0);
signal pcsrc_sig : std_logic;
signal jump_address_sig : std_logic_vector(31 downto 0);

begin
    mpg_inst : mpg port map(
        input => btn(0),
        clock => clk, 
        en => mpg_en
    );
    
    ifetch_inst : IFetch port map(
        clk => clk, 
        jump => uc_jump,
        pcsrc => pcsrc_sig,
        jump_address => jump_address_sig,
        branch_address => ex_branch_address,
        pc_enable => mpg_en,
        pc_reset => btn(1),
        instr => current_instruction,
        PCplus4 => PCplus4_sig
    );
    
    uc_instance : UC port map(
        Instr => opcode,
        jump => uc_jump,
        branch => uc_branch,
        aluop => uc_aluop,
        extop => uc_extop, 
        regdst => uc_regdst,
        alusrc => uc_alusrc,
        memwrite => uc_memwrite,
        memtoreg => uc_memtoreg,
        regwrite => uc_regwrite
        
    );
    
    id_instance : ID port map(
        Instr => current_instruction(25 downto 0), 
        regWrite => uc_regWrite,
        regDst => uc_regDst,
        extOp => uc_extOp,
        rd1 => ID_rd1,
        rd2 => ID_rd2,
        wd => id_write_data,
        write_enable => mpg_en,
        clk => clk,
        EXT_Imm => id_ext_imm
    );
    
    ex_inst : EX port map(
           ALUSrc => uc_alusrc,
           ALUOp => uc_aluop,
           rd1 => id_rd1,
           rd2 => id_rd2,
           func => id_func,          --current_instruction(5 downto 0),
           sa => id_sa,              --current_instruction(10 downto 6),
           PCPlus4 => PCplus4_sig,
           EXT_Imm => id_ext_imm,    --ext_imm_sig 
           clk => clk,
           
           zero => ex_zero,
           greaterThanZero => ex_greaterThanZero,
           greaterOrEqualToZero => ex_greaterOrEqualToZero,
           
           alures => ex_alures,
           branch_address => ex_branch_address
    );
    
    mem_inst : MEM port map(
            ALUResIn => ex_alures,
            RD2 => ID_rd2, 
            memwrite => uc_memwrite,
            enable => mpg_en,
            clk => clk,
            
            memdata => mem_memdata,
            ALUResOut => mem_aluresout
    );
    
    ssd_inst : SSD1 port map(
        clk => clk,
        digit0 => ssd_mux(3 downto 0),
        digit1 => ssd_mux(7 downto 4),
        digit2 => ssd_mux(11 downto 8),
        digit3 => ssd_mux(15 downto 12),
        digit4 => ssd_mux(19 downto 16),
        digit5 => ssd_mux(23 downto 20),
        digit6 => ssd_mux(27 downto 24),
        digit7 => ssd_mux(31 downto 28),
        an => an,
        cat => cat
    );
    
    
    
    
    opcode <= current_instruction(31 downto 26);
   
    pcsrc_sig <= (uc_branch AND ex_zero) OR (uc_branch AND ex_greaterThanZero) OR (uc_branch AND ex_greaterOrEqualToZero);
    jump_address_sig <= PCPlus4_sig(31 downto 28) & current_instruction(25 downto 0) & "00";
    
    id_write_data <= mem_aluresout when uc_memtoreg = '0' else mem_memdata;  
    
    
    mux_sel <= sw(7 downto 5);
    ssd_mux <= current_instruction when mux_sel = "000" else
               PCplus4_sig when mux_sel = "001" else
               ID_RD1 when mux_sel = "010" else
               ID_RD2 when mux_sel = "011" else
               id_ext_imm when mux_sel = "100" else
               ex_alures when mux_sel = "101" else
               mem_memdata when mux_sel = "110" else
               id_write_data when mux_sel = "111";
     
     
    
     led(0) <= uc_jump;
     led(1) <= uc_branch;
     led(3 downto 2) <= uc_aluop;
     led(4) <= uc_extop;
     led(5) <= uc_regdst;
     led(6) <= uc_alusrc;
     led(7) <= uc_memwrite;
     led(8) <= uc_memtoreg;
     led(9) <= uc_regwrite;
     
                
end architecture Behavioral;
