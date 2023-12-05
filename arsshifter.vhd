library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity arsShifter is
	generic (N : INTEGER := 4);
    port (
        A                   : in std_logic_vector (N-1 downto 0);
        Q					: in std_logic_vector (N-1 downto 0) ;
        En					: in std_logic ;
        clk					: in std_logic ;
        Aout				: out std_logic_vector (N-1 downto 0) := (others => '0') ;
        Qout				: out std_logic_vector (N-1 downto 0) := (others => '0');
        Qprev				: out std_logic := '0'  
        );
end arsShifter;

architecture ars_arc of arsShifter is

begin
    process (clk)
    begin
        if (rising_edge(clk)) then
			if (En = '1') then
				if (A(N-1) = '0') then
					Aout(N-1) <= '0' ;
					Aout(N-2 downto 0) <= A(N-1 downto 1) ;
					Qout(N-1) <= A(0) ;
					Qout(N-2 downto 0) <= Q(N-1 downto 1) ;
					Qprev <= Q(0);
				else
					Aout(N-1) <= '1' ;
					Aout(N-2 downto 0) <= A(N-1 downto 1) ;
					Qout(N-1) <= A(0) ;
					Qout(N-2 downto 0) <= Q(N-1 downto 1) ;
					Qprev <= Q(0) ;
				end if;
			end if ;
		end if ;
    end process;
end ars_arc;