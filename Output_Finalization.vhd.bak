library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;
use IEEE.std_logic_unsigned.all;

entity outFinal is 
	generic (N : Integer := 41) ;
	port (
		Aout			: in std_logic_vector (N-1 downto 0) ;
		Qout			: in std_logic_vector (N-1 downto 0) ;
		signout			: in std_logic;
		clk, En  		: in std_logic ;
		finalOut		: out std_logic_vector (N-1 downto 0) ;
		Status			: out std_logic_vector (1 downto 0)
	);
end outFinal;

architecture outFinal_arc of outFinal is 

Signal Cek : std_logic_vector (N-2 downto 0) :=(others => '0');

begin 

	process (clk)
	begin
		if (clk'event and clk = '1') then
			if (En = '1') then
				finalOut(N-1) <= signout ;
				finalOut(N-2 downto 0) <= Qout(N-2 downto 0) ;
				if ((Qout(N-1) = '0') and (Aout (N-2 downto 0) = 0)) then
					Status  <= "11";
				else
					Status <= "10";
				end if;
			else 	
				Status <= "00"	;
			end if ;
		end if ;
	end process ;

end outFinal_arc ;
