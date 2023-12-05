library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fsm_toplevel is 
	port (
		Mode 			: in std_logic_vector (2 downto 0);
		R 				: in std_logic;
		isPS			: in std_logic;
		isQS			: in std_logic;
		Statusoperasi 	: in std_logic_vector (1 downto 0);
		CS 				: out std_logic_vector (1 downto 0);
		MP, MQ 			: out std_logic;
		Mode_kalku		: out std_logic_vector (2 downto 0);
		S				: out std_logic_vector (1 downto 0);
		RST				: out std_logic ;
		--debug : out Integer ; 
		clk				: in std_logic
	);
end fsm_toplevel;

architecture fsm_toplevel_arc of fsm_toplevel is
		type states is (init, s1, s2A, s2B, s2C, s2D, s3, s4, s5A, s5B);
		signal cstate, nstate : states := init ;
		signal reset : std_logic := '0';
		
		
begin 
	process (clk, R)
	begin
		if (R = '0') then
			cstate <= init;
		elsif (rising_edge (clk)) then
			cstate <= nstate;
		end if;
	end process;
	
	process(clk, statusoperasi, isPS, isQS, R, Mode)
	begin 
		case cstate is
			when init => --init awal dan isi register
				if (R = '1') then 
					nstate <= s1;
				else 
					nstate <= init;
				end if;
			--CA <= "10";
			--CB <= "10";
			CS <= "00";
			MP <= '0';
			MQ <= '0';
			Mode_kalku <= "000";
			S <= "00";
			--Debug <= 0;
			
			when s1 => -- keluar register
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '0';
			MQ <= '0';
			Mode_kalku <= "000";
			S <= "00";
			if (isPS = '1' and isQS = '1') then
				nstate <= s2A ;
			elsif (isQS = '1') then
				nstate <= s2B;
			elsif (isPS = '1') then
				nstate <= s2C;
			else 
				nstate <= s2D;
			end if;
			--Debug <= 1;
			
			when s2A => --hasil operasi hasil
			--CA <= "00";
			--CB <= "00";
			--CS <= "00";
			MP <= '1';
			MQ <= '1';
			Mode_kalku <= "000";
			S <= "00";
			nstate <= s3;
			--Debug <= 2;
			
			when s2B => --hasil operasi input Q
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '1';
			MQ <= '0';
			Mode_kalku <= "000";
			S <= "00";
			nstate <= s3;
			--Debug <= 12;
			
			when s2C => --input P operasi hasil
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '1';
			MQ <= '0';
			Mode_kalku <= "000";
			S <= "00";
			nstate <= s3;
			---Debug <= 22;
			
			when s2D => --input operasi input
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '0';
			MQ <= '0';
			Mode_kalku <= "000";
			S <= "00";
			nstate <= s3;
			--Debug <= 32;
			
			when s3 => --operasi kalkulator 
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '0';
			MQ <= '0';
			Mode_kalku <= Mode;
			--Debug <= 3;
			S <= "00";
			if (statusoperasi = "11" or statusoperasi = "10") then
				nstate <= s4;
			else 
				nstate <= s3;
			end if;
			
			when s4 => -- input hasil operasi ke register
			--CA <= "00";
			--CB <= "00";
			CS <= "10";
			MP <= '0';
			MQ <= '0';
			Mode_kalku <= Mode;
			S <= "00";
			if (statusoperasi = "11") then
				nstate <= s5A;
			elsif (statusoperasi = "10") then
				nstate <= s5B; 
			end if;
			--Debug <= 4;
			
			when s5A => -- output hasil berhasil
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '0';
			MQ <= '0';
			--Debug <= 5;
			Mode_kalku <= Mode;
			S <= "11";
			if (R = '0') then
				nstate <= s1;
			else 
				nstate <= s5A;
			end if;
			
			when s5B => -- output hasil eror
			--CA <= "00";
			--CB <= "00";
			CS <= "00";
			MP <= '0';
			MQ <= '0';
			--Debug <= 15;
			Mode_kalku <= Mode;
			S <= "10";
			if (R = '0') then
				nstate <= s1;
			else 
				nstate <= s5B;
			end if;
		end case;
	end process;
end fsm_toplevel_arc ;
			
			
			
			
			
			
		
		
		