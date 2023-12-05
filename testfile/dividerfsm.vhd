library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity dividerfsm is
    port (
        CT_IN, CT_R, SEN, R_Sel, SLOAD, OEN : out std_logic;
        SubtractON                          : out std_logic_vector(2 downto 0);
        Status                              : out std_logic_vector(1 downto 0);

        M                   : in std_logic_vector(2 downto 0);
        SubtractorStatus    : in std_logic_vector(1 downto 0);
        comp_res            : in std_logic;
        clk                 : in std_logic;
        reset               : in std_logic
    );
end entity;

architecture rtl of dividerfsm is
    type states is (sINIT, s2, s3, s4, scompare, s5, s6, s7, s8, sEND);
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
    
    process (all)
    begin
        if (M /= "100") then
            nState <= sINIT;
        else
            Case cState is
                when sINIT =>
                    if M = "100" then
                        nState <= s2;
                    else
                        nState <= sINIT;
                    end if;
                when s2 =>
                    nState <= s3;
                when s3 =>
                    nState <= s4;
                when s4 =>
                    nState <= scompare;
                    add_scount <= '1';
                when scompare =>
                    if (comp_res = '1') then
                        nState <= s6;
                    else
                        nState <= s5;
                    end if;
                when s6 =>
                    nState <= s7;
                when s7 =>
                    if (SubtractorStatus = "10") then
                        nState <= s8; 
                    else
                        nState <= s7;
                    end if;
                when s8 =>
                    if (scount = 40) then
                        nState <= sEND;
                    else
                        nState <= s4;
                    end if;
                when sEND => 
                    if M = "000" then
                        nState <= sINIT;
                    else
                        nState <= sEND;
                    end if;
                when s5 =>
                    if (scount = 40) then
                        nState <= sEND;
                    else
                        nState <= s4;
                    end if;
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
                    Status <= "00";
                when s2 =>
                    CT_IN <= '1';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "00";
                when s3 =>
                    CT_IN <= '0';
                    CT_R <= '1';
                    SEN <= '1';
                    R_Sel <= '0';
                    SLOAD <= '1';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "00";
                when s4 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '1';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "00";
                when scompare =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "00";
                when s5 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '1';
                    SubtractON <= "000";
                    Status <= "00";
                when s6 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '1';
                    SubtractON <= "000";
                    Status <= "00";
                when s7 =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "010";
                    Status <= "00";
                when s8 =>
                    CT_IN <= '0';
                    CT_R <= '1';
                    SEN <= '0';
                    R_Sel <= '1';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "00";
                when sEND =>
                    CT_IN <= '0';
                    CT_R <= '0';
                    SEN <= '0';
                    R_Sel <= '0';
                    SLOAD <= '0';
                    OEN <= '0';
                    SubtractON <= "000";
                    Status <= "11";     
            end case;
        end if;
    end process;
end architecture;