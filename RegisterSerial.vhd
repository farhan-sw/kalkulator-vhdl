library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity RegisterSerial is
    generic ( N : INTEGER := 4);
    port (
        IN_REG          : in std_logic_vector (N - 1 downto 0);
        L, W, EN        : in std_logic;

        Q               : buffer std_logic_vector (N - 1 downto 0);

        clk             : in std_logic
    );
end RegisterSerial;

architecture register_arc of RegisterSerial is

begin
    process (clk)
    begin
        IF (rising_edge(clk)) THEN
            IF (EN = '1') THEN
                if (L = '1') then
                    Q <= IN_REG;
                else
                    Genbits: FOR i IN 0 TO N-2 LOOP
                        Q(i) <= Q(i+1);
                    end loop;
                    Q(N-1) <= W;
                end if;
            END IF;
        END IF;    
        
    end process;
end register_arc;
