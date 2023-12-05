library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity mux8to1 is
	generic (N : INTEGER := 6);
    port (
        IN1                  : in std_logic_vector (N-1 downto 0);
        IN2                  : in std_logic_vector (N-1 downto 0);
        IN3                  : in std_logic_vector (N-1 downto 0);
        IN4                  : in std_logic_vector (N-1 downto 0);
        IN5                  : in std_logic_vector (N-1 downto 0);
        IN6                  : in std_logic_vector (N-1 downto 0);
        IN7                  : in std_logic_vector (N-1 downto 0);

        S                    : in std_logic_vector (2 downto 0);
        OUTMUX               : out std_logic_vector(N-1 downto 0);

        clk                  : in std_logic

    );
end mux8to1;

architecture mux8to1_arc of mux8to1 is
begin
    process (clk)
    begin
        IF rising_edge(clk) THEN
            if (S = "001") then
                OUTMUX <= IN1  ;
            elsif (S = "010") then
                OUTMUX <= IN2 ;
            elsif (S = "011") then
                OUTMUX <= IN3 ;
            elsif (s = "100") then
                OUTMUX <= IN4 ;
            elsif (s = "101") then
                OUTMUX <= IN5 ;
            elsif (s = "110") then
                OUTMUX <= IN6 ;
            elsif (s = "111") then
                OUTMUX <= IN7 ;
            else 
                OUTMUX <= (OTHERS => '0') ;

            end if;
        END IF;
    end process;
    
end mux8to1_arc;