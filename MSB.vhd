library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity MSB is 
	generic ( N : INTEGER := 4);
	port (
	input		: in std_logic_vector (N-1 downto 0);
	output		: out std_logic_vector (N - 1 downto 0);
	outmsb		: out std_logic;
	clk			: in std_logic
	);
end MSB;

architecture MSB_arc of MSB is 
signal firstbit : std_logic;
signal otherbit : std_logic_vector (N-1 downto 0) := (others => '0');

begin 
process (clk) 
	begin
	if (rising_edge(clk)) then 
		firstbit <= INPUT(N-1);
		otherbit (N-2 downto 0) <= input (N-2 downto 0);
	end if;
	outmsb <= firstbit;
	output <= otherbit;
end process;
end MSB_arc;