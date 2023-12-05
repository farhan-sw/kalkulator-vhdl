library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity FSM_Pangkat is 
    generic ( N : INTEGER := 4 ); 
    port ( 
		statP    : in std_logic_vector (1 downto 0);
		pangkat  : in std_logic_vector (N-1 downto 0);
		mode 	 : in std_logic_vector (2 downto 0);
        clk      : in std_logic;
        rst      : in std_logic;
        modeOut  : out std_logic_vector (2 downto 0);
		ctP 	 : out std_logic_vector (1 downto 0);
		ctQ, ctM 	 : out std_logic_vector (1 downto 0);
		stat 	 : out std_logic_vector (1 downto 0);
		selector : out std_logic;
		debug : out integer
    ); 

end FSM_Pangkat; 

architecture FSM_Pangkat_arc of FSM_Pangkat is
	type states is (s0, s1, s2, s3, s4, s5); 
	signal cstate, nstate : states; 
	signal count : std_logic_vector (N-1 downto 0) := (others => '0');

begin 
	process (rst, clk, mode, pangkat, count) 
	begin  
		if (rst = '1' or mode /= "110") then 
			cstate <= s0; 

		elsif (rising_edge(clk)) then 
			cstate <= nstate;
			case cstate is 

				when s0 => -- mengisi register P & Q
					if (mode = "110") then
						nstate <= s1;
					else
						nstate <= s0;
					end if;
					debug <= 0;
					
				when s1 => -- mengeluarkan register
					nstate <= s2;
					debug <= 1;

				when s2 => -- melakukan perkalian
					if ( StatP = "10" or StatP = "11") then
						count <= count + 1;
						nstate <= s3;
						
					else 
						nstate <= s2;
					end if;
					debug <= 2;
					
				when s3 => -- mengecek counter				
					if (count < pangkat) then
						nstate <= s4; 
					else 
						nstate <= s5;
					end if;
					debug <= 3;

				when s4 => -- mengisi register p dari hasil perkalian
					nstate <= s1;
					debug <= 4;
				when s5 => 
					if (mode = "110") then
						nstate <= s5;
					else
						nstate <= s0;
					end if;
					debug <= 5;
			end case;
		end if; 
	end process; 
	
	combinational : process (cstate)
	begin
		case cstate is
			when s0 => -- mengisi register
				stat <= "00";
				ctP <= "10";
				ctQ <= "10";
				ctM <= "10";
				modeOut <= "000";
				selector <= '0';
			
			when s1 => -- mengeluarkan register
				stat <= "01";
				ctP <= "01";
				ctQ <= "01";
				ctM <= "01";
				modeOut <= "000";
				selector <= '0';
			
			when s2 => -- melakukan perkalian
				stat <= "01";
				ctP <= "01";
				ctQ <= "01";
				ctM <= "01";
				modeOut <= "011";
				selector <= '0';
				
			
			when s3 => -- mengecek counter
				stat <= "01";
				ctP <= "01";
				ctQ <= "01";
				ctM <= "10";
				modeOut <= "011";
				selector <= '1';	
					
			when s4 => -- mengisi register p dari hasil perkalian
				stat <= "01";
				ctP <= "10";
				ctQ <= "10";
				ctM <= "01";
				modeOut <= "011";
				selector <= '1';			

			when s5 => 
				stat <= "11";
				ctP <= "01";
				ctQ <= "01";
				ctM <= "01";
				modeOut <= "000";
				selector <= '1';			
			end case;
	end process combinational;

end FSM_Pangkat_arc;