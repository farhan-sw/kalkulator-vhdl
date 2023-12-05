library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity S2Comp is
    generic ( N : INTEGER := 41);
    port (
        IN_COMP          : in std_logic_vector (N-1 downto 0);
        OUT_COMP          : buffer std_logic_vector (N-1 downto 0);

        clk             : in std_logic
    );
end S2Comp;

architecture S2Compp_arc of S2Comp is

begin

    process (clk)
    begin
        IF rising_edge(clk) THEN
        OUT_COMP <= NOT(IN_COMP) + 1;
        END IF;
    end process;
    
end S2Compp_arc;
