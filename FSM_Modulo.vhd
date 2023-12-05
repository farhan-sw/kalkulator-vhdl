library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity FSM_Modulo is
		generic ( N : INTEGER := 41 );
			port (
				clk 		: in std_logic;

				ST, CMP 	: in std_logic_vector (1 downto 0);
				M 			: in std_logic_vector (2 downto 0);

				CT_P 		: out std_logic_vector (1 downto 0);
				CT_Q 		: out std_logic_vector (1 downto 0);

				 -- stats		: out integer; BUAT DEBUGGIN

				mode_out 	: out std_logic_vector (2 downto 0);
				status 		: out std_logic_vector (1 downto 0);

				selector	: out std_logic
	 ); 

end FSM_modulo;

architecture FSM_Modulo_arc of FSM_Modulo is
	type states is (A,B,C,D,E, F);
	signal nState, cState: states;
	 -- signal stats : integer := 0;

begin 
	process(M,clk,ST,CMP)
	begin
		if (M /= "101") then
			cState <= A;

		elsif(rising_edge(clk)) then
			cState <= Nstate;

			case cState is

				when A => -- Mengisi Reg

					if M = "101" then
						nState <= B;
					else
						nSTate <= A;
					end if;
					
					 -- stats <= 1;

				when B =>	-- Mengeluarkan REG

					nState <= C;

					-- stats <= 2;
				
				when C =>	-- Melakukan Komparasi

					if (CMP = "10") or (CMP = "11") then
						nState <= D;
					elsif (CMP = "01") then
						nState <= F;
					else
						nState <= C;
					end if;

					-- stats <= 3;
				
				-- Melakukan Pengurangan
				when D =>

					if ST = "11" or ST = "10" then
						nState <= E; -- Isi REG
					else
						nState <= D;
					end if;

					-- stats <= 4;

				when E =>	-- Isi reg dr pengurangan

					nState <= B;

					-- stats <= 5;

				when F =>

					if (M = "101") then
						nState <= F;
					else
						nState <= A;
					end if;

					-- stats <= 6;
				end case;

		end if;
	end process;

	Combinational : process (cState)
    begin
        
        case cState is

			when A => -- Mengisi Reg
				status 		<= "00";
				CT_P 		<= "10";
				CT_Q 		<= "10";
				mode_out	<= "000";
				selector 	<= '0';

			when B =>	-- Mengeluarkan REG
				status 		<= "01";
				CT_P 		<= "01";
				CT_Q 		<= "01";
				mode_out	<= "000";
				selector 	<= '0';
			
			when C =>	-- Melakukan Komparasi
				status 		<= "01";
				CT_P 		<= "01";
				CT_Q 		<= "01";
				mode_out	<= "000";
				selector 	<= '1';
			
			-- Melakukan Pengurangan
			when D =>
				status 		<= "01";
				CT_P 		<= "01";
				CT_Q 		<= "01";
				mode_out 	<= "010";
				selector 	<= '1';

			when E =>	-- Isi reg dr pengurangan
				status 		<= "01";
				CT_P 		<= "10";
				CT_Q 		<= "10";
				mode_out 	<= "010";
				selector 	<= '1';

			when F =>
				status <= "11";
				CT_P <= "01";
				CT_Q <= "01";
				mode_out 	<= "010";
				selector 	<= '1';
			end case;

    end process Combinational;

end FSM_Modulo_arc; 		
							 