library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity func_s is
    generic ( N : INTEGER := 41);
    port (
        input_vector            : in std_logic_vector (N - 1 downto 0);
        output_result : out std_logic_vector(N+N-3 downto 0)
        );
end func_s;
architecture behavorial of func_s is
    begin
        process(input_vector)
        begin
            genbits: for i in 0 to (N-2) loop
				output_result(i) <= '0';
            end loop;
           genbibits : for i in N-1 to N+N-3 loop
				output_result(i) <= input_vector(i-(N-1)); 
			end loop;
    end process; 
end behavorial;