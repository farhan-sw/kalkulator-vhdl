library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity get_signed is
    generic (N: INTEGER := 5);
    port(
        input_vector : in std_logic_vector( N-1 downto 0);
        hasil : out std_logic
    );
end get_signed;
architecture behavorial of get_signed is
    begin
        process(input_vector)
        begin
            if ((input_vector(N-1) = '0') or (input_vector(N-1) = '1')) then
                hasil <= input_vector(N-1);
            else
                hasil <= input_vector(N-1);
            end if;
            
        end process;
end behavorial;
