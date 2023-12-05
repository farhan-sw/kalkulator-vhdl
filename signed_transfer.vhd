library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity signed_transfer is
    generic(N: INTEGER := 5);
    port(input_vector : in std_logic_vector(N-1 downto 0);
         input_signed, EN: in std_logic;
         output_vector : buffer std_logic_vector (N-1 downto 0);
         output_fix : out std_logic_vector(N-1 downto 0)
    );
end signed_transfer;

architecture behavorial of signed_transfer is
    begin
        process(input_signed, EN)
        begin
            if (EN = '1') then
                if (input_signed = '1') then
                  genbits : for i in 0 to N-1 loop
							    if input_vector(i) = '1' then
                                    output_vector(i) <= '0';
                                else
                                    output_vector(i) <= '1';
                                end if;
                            end loop;
            else
                output_vector <= input_vector - 1;
            end if;
        end if;
        end process;
        process(input_vector)
            begin
                output_fix <= output_vector + 1;
            end process;
        

		
 end behavorial;