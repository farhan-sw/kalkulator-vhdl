library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity Transfer_M is
    generic ( N : INTEGER := 41);
    port (
        input_vector            : in std_logic_vector (N+N - 3 downto 0);
        output_result : out std_logic_vector(N-1 downto 0)
        );
end Transfer_M;
architecture behavorial of Transfer_M is
    begin
        process(input_vector)
        begin
            genbits: for i in 0 to (N -1) loop
				output_result(i) <= input_vector(i);
            end loop;
    end process; 
end behavorial;