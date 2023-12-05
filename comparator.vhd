library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity comparator is
	generic ( N: INTEGER := 6);
	port ( P, Q : in std_logic_vector (N - 1 downto 0);
			rst, clk : in std_logic ;
			comp : out std_logic_vector (1 downto 0)
			);
end comparator;

architecture comparator_arc of comparator is 
begin 
	process (P, Q, rst, clk)
	begin
		if (clk'EVENT) and (clk = '1')  then
			if (rst = '1') then 
				comp <= "00";
			elsif (P = Q) then 
				comp <= "11";
			elsif (P(N-1) = '1' and Q(N-1) = '0') then 
				comp <= "01";
			elsif (P(N-1) = '0' and Q(N-1) = '1') then 
				comp <= "10";
			elsif (P(N-1) = '0' and Q(N-1) = '0') then 
				if (P > Q) then 
					comp <= "10";
				else 
					comp <= "01";
				end if;
			elsif (P(N-1) = '1' and Q(N-1) = '1') then 
				if (P > Q) then 
					comp <= "01";
				else 
					comp <= "10";
				end if;
			end if;
		end if;
	end process;
end comparator_arc;