-- library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity
entity ascii_to_bcd is
port(
    ascii : in std_logic_vector(7 downto 0);
    bcd     : out std_logic_vector(3 downto 0);
    mode     : out std_logic_vector(2 downto 0)
	
);

end entity ascii_to_bcd;

architecture asciiBCD of ascii_to_bcd is


begin

----------------------------------------------------------------
	process(ascii)
	begin
        case ascii is
            -- 1
            when "00110001" =>
                bcd <= "0001";
                mode <= "000";
            -- 2
            when "00110010" =>
                bcd <= "0010";
                mode <= "000";
            -- 3
            when "00110011" =>
                bcd <= "0011";
                mode <= "000";
            -- 4
            when "00110100" =>
                bcd <= "0100";
                mode <= "000";
            -- 5
            when "00110101" =>
                bcd <= "0101";
                mode <= "000";
            -- 6
            when "00110110" =>
                bcd <= "0110";
                mode <= "000";
            -- 7
            when "00110111" =>
                bcd <= "0111";
                mode <= "000";
            -- 8
            when "00111000" =>
                bcd <= "1000";
                mode <= "000";
            -- 9
            when "00111001" =>
                bcd <= "1001";
                mode <= "000";
            -- 0
            when "00110000" =>
                bcd <= "0000";
                mode <= "000";

            -- +
            when "00101011" =>
                bcd <= "0000";
                mode <= "001";

            -- -
            when "00101101" =>
                bcd <= "0000";
                mode <= "010";

            -- *
            when "00101010" =>
                bcd <= "0000";
                mode <= "011";
            
            -- /
            when "00101111" =>
                bcd <= "0000";
                mode <= "100";

            -- %
            when "00100101" =>
                bcd <= "0000";
                mode <= "101";

            -- ^
            when "01011110" =>
                bcd <= "0000";
                mode <= "110";

            -- F
            when "01000110" =>
                bcd <= "0000";
                mode <= "111";
                

            -- ERROR
            when others =>
                bcd <= "1111";
                mode <= "111";

        
        end case;
		
	end process;
	
end architecture;
