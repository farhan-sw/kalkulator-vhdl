-- library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity
entity bcd_to_ascii is
port(
    bcd : in std_logic_vector(3 downto 0);
    ascii     : out std_logic_vector(7 downto 0)
	
);

end entity bcd_to_ascii;

architecture asciiBCD of bcd_to_ascii is


begin

----------------------------------------------------------------
	process(bcd)
	begin

        case bcd is
            -- 0
            when "0000" =>
                ascii <= "00110000";
            -- 1
            when "0001" =>
                ascii <= "00110001";
            -- 2
            when "0010" =>
                ascii <= "00110010";
            -- 3
            when "0011" =>
                ascii <= "00110011";
            -- 4
            when "0100" =>
                ascii <= "00110100";
            -- 5
            when "0101" =>
                ascii <= "00110101";
            -- 6
            when "0110" =>
                ascii <= "00110110";
            -- 7
            when "0111" =>
                ascii <= "00110111";
            -- 8
            when "1000" =>
                ascii <= "00111000";
            -- 9
            when "1001" =>
                ascii <= "00111001";

            -- -
            when "1010" =>
                ascii <= "00101101";

            -- +
            when "1011" =>
            ascii <= "00101011";

            -- S
            when "1100" =>
            ascii <= "01010011";

            -- ERROR
            when others =>
                ascii <= "01000101";

        end case;
		
	end process;
	
end architecture;
