library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity pangkatFSM is 
    generic ( N : INTEGER := 41); 
    port ( 
		statP    : in std_logic_vector (1 downto 0);
		counter  : in std_logic_vector (N-1 downto 0);
		mode 	 : in std_logic_vector (2 downto 0);
        clk      : in std_logic;
        rst      : in std_logic;
        modeOut  : out std_logic_vector (2 downto 0);
		ctP1 	 : out std_logic_vector (1 downto 0);
		ctP2	 : out std_logic_vector (1 downto 0);
		stat 	 : out std_logic_vector (1 downto 0);
		selector : out std_logic;
		debug    : out integer
		--debug_multi : out integer
    ); 

end pangkatFSM; 

architecture pangkatFSM_arc of pangkatFSM is
	type states is (s0, s1a, s1b, s2, s3, s4, s6, s7); 
	signal cstate, nstate : states; 
	signal count : std_logic_vector (N-1 downto 0);
	signal isKurang : std_logic := '0';

begin 
	process (rst, clk, mode, count, statP, nstate, cstate) 
	begin  
		if (rst = '1' or mode /= "110") then 
			cstate <= s0; 

		elsif (rising_edge(clk)) then 
			cstate <= nstate;
			case cstate is 
				when s0 => -- mengisi register P2, mux, counter
					if (mode = "110") then
						nstate <= s1a;
					else
						nstate <= s0;
					end if;
					debug <= 0;
					
				when s1a => -- mengisi register P1
					if (mode = "110") then
						nstate <= s2;
					else
						nstate <= s1a;
					end if;
					debug <= 11;
				
				when s1b => -- mengisi register P1 dari hasil perkalian
					if (mode = "110") then
						nstate <= s2;
					else
						nstate <= s1b;
					end if;
					debug <= 12;

				when s2 =>  -- mengeluarkan register P1 & P2
					if count > 1 then 
						nstate <= s3;
					else 
						nstate <= s6;
					end if;
					debug <= 2;	
					
				when s3 => -- melakukan perkalian				
					if (statP = "11") then
						nstate <= s4; 
						debug <= 3;
					elsif (statp = "10") then
						debug <= 310;
						nstate <= s7;
					elsif (statp = "01") then
						debug <= 301;
					elsif statp = "00" then
						nstate <= s3;
						debug <= 300;
					end if;

				when s4 => -- mengisi register p1 dari hasil perkalian
					nstate <= s1b;
					debug <= 4;
					
				when s6 => -- mengeluarkan output
					nstate <= s6;
					debug <= 6;
					
				when s7 => -- mengeluarkan output
					nstate <= s7;
					debug <= 7;
			end case;
		end if; 
	end process; 
	
	combinational : process (cstate, nstate)
	begin
		if clk'event and clk = '1' then 
			if cstate = s0 then 
				count <= counter;
			elsif cstate = s1b then
				if isKurang = '1' then 
					count <= count - 1;
					isKurang <= '0';
				end if;
			else
				count <= count;
			end if;	
		end if;
		case cstate is
			when s0 => -- mengisi register P2, mux, counter
				stat <= "00";
				ctP1 <= "10";
				ctP2 <= "10";
				modeOut <= "000";
				selector <= '0';
			
			when s1a => -- mengisi register P1 untuk inputan pertama
				stat <= "01";
				ctP1 <= "10";
				ctP2 <= "10";
				modeOut <= "000";
				selector <= '0';
			
			when s1b => -- mengisi register P1 untuk inputan kedua dan seterusnya
				stat <= "01";
				ctP1 <= "10";
				ctP2 <= "10";
				modeOut <= "011";
				selector <= '1';
			
			when s2 => -- mengeluarkan register P1 & P2
				stat <= "01";
				ctP1 <= "00";
				ctP2 <= "00";
				modeOut <= "000";
				selector <= '1';
			
			when s3 => -- melakukan perkalian
				stat <= "01";
				ctP1 <= "00";
				ctP2 <= "00";
				modeOut <= "011";
				selector <= '1';	
				isKurang <= '1';			

			when s4 => -- mengisi register p dari hasil perkalian
				stat <= "01";
				ctP1 <= "10";
				ctP2 <= "10";
				modeOut <= "011";
				selector <= '1';
			
			when s6 => -- mengeluarkan output
				stat <= "11";
				ctP1 <= "01";
				ctP2 <= "01";
				modeOut <= "000";
				selector <= '1';	
				
			when s7 => -- mengeluarkan output error
				stat <= "11";
				ctP1 <= "01";
				ctP2 <= "01";
				modeOut <= "000";
				selector <= '1';	
			end case;
			
	end process combinational;

end pangkatFSM_arc;



