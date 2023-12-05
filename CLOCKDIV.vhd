LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity CLOCKDIV is port(
	CLK: IN std_logic;
	pulse_div: buffer std_logic);
end CLOCKDIV;

architecture behavioural of CLOCKDIV is
	begin
		PROCESS(clk)
		VARIABLE count : INTEGER:= 0;
	
		BEGIN
			IF rising_edge(clk) THEN
				IF count > (16666) THEN
					pulse_div <= NOT pulse_div;
					count := 0;
				ELSE
					count := count + 1;
				END IF;
			END IF;
		END PROCESS;
end behavioural;
		
	
	
	