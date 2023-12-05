library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity signed_transfer is
    generic(N: INTEGER := 5);
    port(input_vector : in std_logic_vector(N-1 downto 0);
         input_signed: in std_logic;
         --output_vector : buffer std_logic_vector (N-1 downto 0);
         output_fix : out std_logic_vector(N-1 downto 0)
    );
end signed_transfer;

architecture behavorial of signed_transfer is
    begin        
        process(input_vector, input_signed)
            begin
				if (input_signed = '1') then
					output_fix(n-1) <= '1';
					for i in 0 to n-2 loop
						output_fix(i) <= input_vector(i);
					end loop;
				else 
					output_fix <= input_vector;
				end if;
            end process;
        

		
 end behavorial;