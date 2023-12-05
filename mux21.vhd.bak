LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mux21 IS
	generic ( N : INTEGER := 41);
	PORT (  P, Q   		: IN STD_LOGIC_VECTOR (N-1 downto 0) ;
			S, clk      : IN std_logic;
			f      		: OUT STD_LOGIC_VECTOR (N-1 downto 0)
			);
END mux21;

ARCHITECTURE Behavior OF mux21 IS 
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