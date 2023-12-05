library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity 	FSM_Multi is 
	generic ( N : integer := 41);
	port (
		Mode			: in std_logic_vector (2 downto 0) ;
		StatusAdder		: in std_logic_vector (1 downto 0) ;
		QMSB, PMSB		: in std_logic ;
		Qprev			: in std_logic ;
		QLSB			: in std_logic ;
		clk				: in std_logic ;
		Rst				: in std_logic ;
		SelectorQ		: out std_logic ;
		SelectorP		: out std_logic ;
		SelectorAcc		: out std_logic ;
		ModeAdder		: out std_logic_vector (2 downto 0) ;
		EnArs			: out std_logic ;
		CtP, CtQ, CtA, Ct2s	: out std_logic_vector (1 downto 0) ;
		EnOutFinal		: out std_logic; 
		signout			: out std_logic ;
		debug			: out integer
		
	);
end FSM_Multi ;

architecture FSM_arc of FSM_Multi is
	type states is (awal, A1, A2,B1,B2,C,D,E,F,G,H,I,J,K,L,M,S,O,P,Q,R) ;
	signal nState, cState: states;

	Signal count : integer range 0 to N ;

begin
	process (Mode, StatusAdder, Qprev, QLSB, clk, Rst)
	begin
	if (Mode /= "011" or rst = '1') then 
		cstate <= Awal;
	elsif (rising_edge(clk)) then
		cstate <= nState;
	end if;
		case cState is
			
			when Awal => --isi MSB P dan MSB Q
				if (Mode = "011" ) then
					nState <= A1 ;
				else 
					nstate <= Awal;
				end if;
				
			when A1 => --Mengisi Reg P dan MuxQ <- 0
				nState <= B1 ;
			
			when A2 => --isi Reg P dan Mux Q <-1
				nstate <= B2;
					
			when B1 => -- Mengisi Reg Q dengan MuxQ <- 0
			
				nState <= C ;
			
			when B2 => -- Mengisi Reg Q dengan MuxQ <- 1
				nState <= C ;
			
			when C => -- keluarin nilai reg
				nstate <= D;
			
			when D => -- Melakukan Komparasi Q-1 dan Qlsb
				if (QLSB = '0' and Qprev = '0') or (QLSB = '1' and Qprev = '1') then
					nState <= K ; 
				elsif (QLSB = '1' and Qprev = '0') then 
					nState <= E ;
				else
					nState <= H ; 
				end if ;
				
			when E => -- lakuin pengurangan
				if ( StatusAdder = "11" or StatusAdder = "10") then 				
					nState <= F ;
				else 
					nState <= E ;
				end if ;
			
			when F => --operasi penambahan 
				nstate <= G;
			
			when G => -- untuk masukin nilai subtraction ke accumulator
				nstate <= M;
								
			when H => -- lakuin addition 
				if ( StatusAdder = "00" or StatusAdder = "01") then 				
					nState <= H ;
				else 
					nState <= I ;
				end if ;
				
			when I => -- masukin nilai addition ke mux
				nstate <= J;
			
			when J => -- masukin nilai addition ke accumulator
				nstate <= M;
				
			when K => -- mux untuk nilai langsung dari ars (ke acc)
				nState <= L ;
				
			when L => -- masukin nilai ars ke accumulator
				nState <= M ;
			
			when M => -- keluarin nilai accumulator
				nstate <= S;
			
			when S => --lakuin shifter
				if (count = 0) then 
					if (QMSB = '0' and PMSB = '0') or (QMSB = '1' and PMSB = '1') then
						nstate <= O;
					else 
						nstate <= Q;
					end if;
				else 
					nState <= A2 ;
				end if ;					
				
			when O => -- hasil perkalian positif
				nstate <= P;
			
			when P => -- en out
				if (Mode = "011") then 
					nState <= P ;
				else 
					nState <= Awal ;
				end if ;
			
			when Q =>
				nstate <= R;
				
			when R => -- hasil perkalian negatif
				if (Mode = "011") then 
					nState <= R ;
				else 
					nState <= Awal ;
				end if ;
	
			end case ;	
	end process ; 
	
	Combinational : process (cState, clk)
	begin
		if (clk'event and clk = '1') then
			if (cstate = awal) then 
				count <= N ; 
			elsif (cstate = M) then 
				count <= (count - 1);
			else 
				count <= count;
			end if; 
		end if;
		
		case cState is 
			when Awal => -- Mengisi MSB P & Q
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "00"; 
				CtQ <= "00" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				debug <= 1;
				selectorP <= '0';
				Ct2s <= "00";
				
			when A1 => -- Mengisi req P, Mux Q dan input ke 2scomp
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "10"; 
				CtQ <= "00" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				debug <= 2;
				selectorP <= '0';
				Ct2s <= "00";
			
			when A2 => -- Pemilihan Mux Q	
				SelectorQ <= '1' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "10"; 
				CtQ <= "00" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 3;
			
			when B1 => -- Mengisi Reg Q dan Req P dan Reg2scomp
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "10"; 
				CtQ <= "10" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "10";
				debug <= 4;
				
				
			when B2 => -- Mengisi Reg Q
				SelectorQ <= '1' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "10"; 
				CtQ <= "10" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 5;
			
			when C => -- Keluar Register
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 6;
			
			when D => -- komparasi QLSB dan Qprev
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 7;
					
			when E => -- operasi pengurangan
				SelectorQ <= '0' ;
				SelectorAcc <= '1' ;
				ModeAdder <= "010";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '1';
				Ct2s <= "01";
				debug <= 8;
				
			when F => -- tunggu mux
				SelectorQ <= '0' ;
				SelectorAcc <= '1' ;
				ModeAdder <= "010";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '1';
				Ct2s <= "01";
				debug <= 9;
				
			when G => --hasil pengurangan ke acc
				SelectorQ <= '0' ;
				SelectorAcc <= '1' ;
				ModeAdder <= "010";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "10" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '1';
				Ct2s <= "01";
				debug <= 10;
						
			when H => -- penjumlahan
				SelectorQ <= '0' ;
				SelectorAcc <= '1' ;
				ModeAdder <= "001";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 11;
				
			when I => -- pilih mux
				SelectorQ <= '0' ;
				SelectorAcc <= '1' ;
				ModeAdder <= "001";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 12;

			when J => -- hasil penjumlahan ke Acc
				SelectorQ <= '0' ;
				SelectorAcc <= '1' ;
				ModeAdder <= "001";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "10" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 13;
				
			when K => -- pilih mux jika langsung shift
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 14;
				
			when L =>  -- input nilai ars ke acc
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "10" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 15;
				
			when M => -- keluar nilai acc
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "01" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 16;
				
			when S => -- lakuin shifter
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '1' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "01" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 17;
				
			when O => -- input sign hasil (positif)  dan finalisasi output
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "00"; 
				CtQ <= "00" ;
				CtA <= "00" ;
				EnOutFinal <= '0';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 18;
				
			when P => -- enable output
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "00"; 
				CtQ <= "00" ;
				CtA <= "00" ;
				EnOutFinal <= '1';
				signout <= '0';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 19;
			
			when Q => -- input sign hasil (negatif)  dan finalisasi output
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "01" ;
				EnOutFinal <= '0';
				signout <= '1';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 20;
			
			when R => 
				SelectorQ <= '0' ;
				SelectorAcc <= '0' ;
				ModeAdder <= "000";
				EnArs <= '0' ;
				CtP <= "01"; 
				CtQ <= "01" ;
				CtA <= "01" ;
				EnOutFinal <= '1';
				signout <= '1';
				selectorP <= '0';
				Ct2s <= "01";
				debug <= 21;
				
			end case ;
	end process Combinational ;

end FSM_arc ;

