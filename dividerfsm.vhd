library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity dividerfsm is
	generic ( N : INTEGER := 41);
    port (
        CT_IN, CT_R, SEN, R_Sel, SLOAD, OEN : out std_logic;
        SubtractON, add_ON                         : out std_logic_vector(2 downto 0);
        Status                              : out std_logic_vector(1 downto 0);
       debugfsm : out std_logic_vector(3 downto 0);
        M                   : in std_logic_vector(2 downto 0);
        SubtractorStatus, adder_st    : in std_logic_vector(1 downto 0);
        comp_res            : in std_logic;
        clk                 : in std_logic;
        reset               : in std_logic;
        shift_cek : in std_logic
    );
end dividerfsm;

architecture rtl of dividerfsm is
    type states is (sINIT, s2, s3, s4, swait,scompare,sw0, sw1, s5, s6, s7, s8, sEND, s10);
    signal cState, nState: states;
    signal scount: std_logic_vector (6 downto 0);
    signal add_scount : std_logic; 
begin
    process (clk)
    begin
        if rising_edge(clk) then

            if reset = '1' then
                cState <= sINIT;
                scount <= "0000000";
            else
                cState <= nState;
            end if;

            if add_scount = '1' then
                scount <= scount + 1;  
            end if;

        end if;
    end process;
    
    process (M, CState, SubtractorStatus, shift_cek, comp_res)
    begin
        if (M /= "101") and  (M /= "100") then
            nState <= sINIT;
        else
            Case cState is
                when sINIT =>
                    if M = "101" or M = "100" then
                        nState <= s2;
                    else
                        nState <= sINIT;
                    end if;
                    
                when s2 =>
                    nState <= s3;
                when s3 =>
                    nState <= swait;
                   -- debugscout <= scount;
                when swait =>
					nstate <= s4;
                when s4 =>
                    nState <= scompare;
                    add_scount <= '1';
                   -- debugscout <= scount;
                when scompare =>
                    nstate <= sw0;
                    --debugscout <= scount;
                when sw0 =>
					nstate <= sw1;
                
                when sw1 =>
					if (comp_res = '1') then
                        nState <= s6;
                    else
                        nState <= s5;
                    end if;
                when s5 =>
                    if (shift_cek = '1') then
                        nState <= sEND;
                    else
                        nState <= s4;
                    end if;
                    --debugscout <= scount;
                when s6 =>
                    nState <= s7;
                    --debugscout <= scount;
                when s7 =>
                    if (SubtractorStatus = "10") or (SubtractorStatus = "11") then
                        nState <= s8; 
                    else
                        nState <= s7;
                    end if;
                   -- debugscout <= scount;
                when s8 =>
                    if (shift_cek = '1') then
                        nState <= s10;
                    else
                        nState <= s4;
                    end if;
                    --debugscout <= scount;
                when s10 =>
					if adder_st = "10" or adder_st = "11" then
						nState <= sEND;
					else
						nState <= s10;
					end if;
                when sEND => 
                    if M = "000" then
                        nState <= sINIT;
                    else
                        nState <= sEND;
                    end if;
                    --debugscout <= scount;
            end case;
        end if;             
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            case cState is
                when sINIT =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                    debugfsm <= "0001";
                    
                when s2 =>
                    CT_IN <= '1';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                    debugfsm <= "0010";
                when s3 =>
                    CT_IN <= '0';
                    CT_R <= '1';
                    SEN <= '1';
                    R_Sel <= '0';
                    SLOAD <= '1';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "0011";
                when s4 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '1';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "0100";
                when swait =>
					CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "00";
                     debugfsm <= "1011";
					add_ON <= "000";
                when scompare =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "1111";
                when sw0 =>
					CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                   add_ON <= "000";
                    Status <= "00";
                    debugfsm <= "1010";
                when sw1 =>
					CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "1011";
                when s5 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '1';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "0101";
                when s6 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '1';
                    SubtractON <= "000";
                   add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "0110";
                when s7 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "010";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "0111";
                when s8 =>
                    CT_IN <= '1';
                    CT_R <= '1';
                    SEN <= '0';
                    R_Sel <= '1';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    add_ON <= "000";
                    Status <= "00";
                     debugfsm <= "1000";
                     debugfsm <= "1011";
               when s10 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                   add_ON <= "001";
                    Status <= "11";
                     debugfsm <= "1110"; 
                when sEND =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                   add_ON <= "010";
                    Status <= "11";
                     debugfsm <= "1001";     
            end case;
        end if;
    end process;
end rtl;