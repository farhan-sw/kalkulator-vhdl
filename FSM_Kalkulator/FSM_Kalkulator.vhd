LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

entity FSM_kalkulator IS
	generic ( N : INTEGER := 7);
	port (
		REG_A			: in std_logic_vector (N-1 downto 0) ;
		REG_B			: in std_logic_vector (N-1 downto 0) ;
		ModeSistem		: in std_logic_vector (2 downto 0) ;
		clk				: in std_logic ;
		St_Kalkulator	: in std_logic_vector (1 downto 0) ;
		isP				: in std_logic ;
		isQ				: in std_logic ;
		S				: out std_logic ;
		rst				: out std_logic ;
		CA				: out std_logic (1 downto 0) ;
		CB				: out std_logic (1 downto 0) ;
		CS				: out std_logic (1 downto 0) ;
		MP, MQ 			: out std_logic (1 downto 0) ;
		);
end FSM_kalkulator;

architecture kalulator_arc of FSM_kalkulator is


begin
	process (REG_A, REG_B, ModeSistem, clk, St_Kalkulator)
	begin 
	if (R /= "0" or rst = '1') then
		cState <= A ;
	elsif (rising_edge(clk)) then
		cState <= nState ;
	end if ;
	
		case cState is
			
			when A => -- Mengisi Reg_A dan Reg_B
				if (R = "1") then
					nState <= B ;
				end if ;
			when B => -- Ubah Mux_A dan Mux_B menjadi 0
				
				nState <= C ;
				
			when C => -- Cek menggunakan output register S atau tidak
			
				if (isP = 1 or isQ = 1) then 
					nState <= D1 ;
				else
					nState <= D2 ;
				end if ;
			
			when D1 => -- Menentukan penggunaan register S
				
				if (isP = 1 and isQ = 0) then
					nState <= E1 ; 
				elsif (isP = 0 and isQ = 1) then
					nState <= E2 ; 
				elsif (isP = 1 and isQ = 1) then
					nState <= E3 ; 
				end if ;
			
			when D2 => -- Memakai Reg_A dan reg_B
			
				nState <= E4 ;
			
			when E1 => -- S (operasi) reg_A
				
				nState <= F ;
				
			when E2 => -- S (operasi) reg_B
			
				nState <= F ;
			
			when E3 => -- S (operasi) S
			
				nState <= F ;
			
			when E4 => -- A (operasi) B
				
				nState <= F ;
				
			when F => --  Menunggu Kalkulator Selesai
				
				if (St_Kalkulator /= 1) then
					nState <= F ;
				else 
					nState <= G ;
				end if ;
				
			when G => -- 
			
			
			when C => -- Memasukan Hasil ke Reg_S setleah St_Kalkulator = 11
			
				if (isP = 1 and St_Kalkulator = 1) then 
					nState <= D ;
				elsif (isQ = 1 and St_Kalkulator = 1) then 
					nState <= D2 ;
				else -- isP, isQ = 0, St_Kalkulator  = 0
					nState <= C ;
				end if ;
			
			when D1 => -- Mengubah MuxA menjadi 1, isP = 1
				
				nState <= E
				
			when D2 => -- Mengubah MuxB menjadi 1, isQ = 1
				
				nState <= E
			
			when 
				
			
			
		