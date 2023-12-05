library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shift_checker is
	generic ( N: INTEGER := 6);
	port ( P, Q : in std_logic_vector (N - 1 downto 0);
			rst, clk : in std_logic ;
			comp : out std_logic
			);
end shift_checker;


architecture shift_checker_arc of shift_checker is 
begin 
	process (P, Q, rst, clk)
	begin
		if (clk'EVENT) and (clk = '1')  then
			if (rst = '1') then 
				comp <= '0';
			elsif (P = Q) then 
				comp <= '1';
			else
				comp <= '0';
			end if;
		end if;
	end process;
end shift_checker_arc;