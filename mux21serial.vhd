LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mux21serial IS
	generic(N : INTEGER := 41);
	PORT (  P, Q   		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			S, clk      : IN std_logic;
			f      		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
			);
END mux21serial;

ARCHITECTURE Behavior OF mux21serial IS 
BEGIN
	PROCESS(clk)
	BEGIN
		IF rising_edge (clk) then
			IF S='0' THEN
				f <= P;
			ELSE
				f <= Q;
			end if;
		END IF;
    END PROCESS;
END Behavior ;