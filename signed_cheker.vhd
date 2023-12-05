library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity signed_cheker is
    port(
        P,Q : in std_logic;
        hasil : out std_logic
    );
end signed_cheker;
architecture behavorial of signed_cheker is
    begin
        process(P,Q)
        begin
        if ((P = '1' and Q = '0') or (P = '0' and Q = '1')) then
            hasil <= '1';
        else 
            hasil <= '0';
        end if;
        end process;
end behavorial; 