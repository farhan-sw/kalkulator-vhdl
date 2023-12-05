library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity function_S is
    generic ( N : INTEGER := 41);
    port (
        input_vector            : in std_logic_vector (N - 1 downto 0);
        output_result : out std_logic_vector(N+N-2 downto 0)
        );
end function_S;
architecture behavorial of function_S is
begin
    process(input_vector)
    begin
        if input_vector(0) = '1' then
            output_result(40) <= '1';
        else
            output_result(40) <= '0';
        end if;

        if input_vector(1) = '1' then
            output_result(41) <= '1';
        else
            output_result(41) <= '0';
        end if;

        if input_vector(2) = '1' then
            output_result(42) <= '1';
        else
            output_result(42) <= '0';
        end if;

        if input_vector(3) = '1' then
            output_result(43) <= '1';
        else
            output_result(43) <= '0';
        end if;

        if input_vector(4) = '1' then
            output_result(44) <= '1';
        else
            output_result(44) <= '0';
        end if;

        if input_vector(5) = '1' then
            output_result(45) <= '1';
        else
            output_result(45) <= '0';
        end if;

        if input_vector(6) = '1' then
            output_result(46) <= '1';
        else
            output_result(46) <= '0';
        end if;

        if input_vector(7) = '1' then
            output_result(47) <= '1';
        else
            output_result(47) <= '0';
        end if;

        if input_vector(8) = '1' then
            output_result(48) <= '1';
        else
            output_result(48) <= '0';
        end if;

        if input_vector(9) = '1' then
            output_result(49) <= '1';
        else
            output_result(49) <= '0';
        end if;

        if input_vector(10) = '1' then
            output_result(50) <= '1';
        else
            output_result(50) <= '0';
        end if;

        if input_vector(11) = '1' then
            output_result(51) <= '1';
        else
            output_result(51) <= '0';
        end if;

        if input_vector(12) = '1' then
            output_result(52) <= '1';
        else
            output_result(52) <= '0';
        end if;

        if input_vector(13) = '1' then
            output_result(53) <= '1';
        else
            output_result(53) <= '0';
        end if;

        if input_vector(14) = '1' then
            output_result(54) <= '1';
        else
            output_result(54) <= '0';
        end if;

        if input_vector(15) = '1' then
            output_result(55) <= '1';
        else
            output_result(55) <= '0';
        end if;

        if input_vector(16) = '1' then
            output_result(56) <= '1';
        else
            output_result(56) <= '0';
        end if;

        if input_vector(17) = '1' then
            output_result(57) <= '1';
        else
            output_result(57) <= '0';
        end if;

        if input_vector(18) = '1' then
            output_result(58) <= '1';
        else
            output_result(58) <= '0';
        end if;

        if input_vector(19) = '1' then
            output_result(59) <= '1';
        else
            output_result(59) <= '0';
        end if;

        if input_vector(20) = '1' then
            output_result(60) <= '1';
        else
            output_result(60) <= '0';
        end if;

        if input_vector(21) = '1' then
            output_result(61) <= '1';
        else
            output_result(61) <= '0';
        end if;

        if input_vector(22) = '1' then
            output_result(62) <= '1';
        else
            output_result(62) <= '0';
        end if;

        if input_vector(23) = '1' then
            output_result(63) <= '1';
        else
            output_result(63) <= '0';
        end if;

        if input_vector(24) = '1' then
            output_result(64) <= '1';
        else
            output_result(64) <= '0';
        end if;

        if input_vector(25) = '1' then
            output_result(65) <= '1';
        else
            output_result(65) <= '0';
        end if;

        if input_vector(26) = '1' then
            output_result(66) <= '1';
        else
            output_result(66) <= '0';
        end if;

        if input_vector(27) = '1' then
            output_result(67) <= '1';
        else
            output_result(67) <= '0';
        end if;

        if input_vector(28) = '1' then
            output_result(68) <= '1';
        else
            output_result(68) <= '0';
        end if;

        if input_vector(29) = '1' then
            output_result(69) <= '1';
        else
            output_result(69) <= '0';
        end if;

        if input_vector(30) = '1' then
            output_result(70) <= '1';
        else
            output_result(70) <= '0';
        end if;

        if input_vector(31) = '1' then
            output_result(71) <= '1';
        else
            output_result(71) <= '0';
        end if;

        if input_vector(32) = '1' then
            output_result(72) <= '1';
        else
            output_result(72) <= '0';
        end if;

        if input_vector(33) = '1' then
            output_result(73) <= '1';
        else
            output_result(73) <= '0';
        end if;

        if input_vector(34) = '1' then
            output_result(74) <= '1';
        else
            output_result(74) <= '0';
        end if;

        if input_vector(35) = '1' then
            output_result(75) <= '1';
        else
            output_result(75) <= '0';
        end if;

        if input_vector(36) = '1' then
            output_result(76) <= '1';
        else
            output_result(76) <= '0';
        end if;

        if input_vector(37) = '1' then
            output_result(77) <= '1';
        else
            output_result(77) <= '0';
        end if;

        
        if input_vector(38) = '1' then
            output_result(78) <= '1';
        else
            output_result(78) <= '0';
        end if;

        if input_vector(39) = '1' then
            output_result(79) <= '1';
        else
            output_result(79) <= '0';
        end if;

        output_result(40 downto 0) <= (others => '0');
    end process;
end behavorial;

