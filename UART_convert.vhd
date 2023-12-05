-- library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  

-- entity
entity UART_convert is
	generic ( 
        biner : INTEGER := 41;
        bcd_char : INTEGER := 12
        );

	port(
		clk 			: in std_logic;
		rst_n 			: in std_logic;

		-- OUTPUT HASIL
		REG_A			: buffer std_logic_vector(biner-1 downto 0) ;
		REG_B			: buffer std_logic_vector(biner-1 downto 0) ;
		REG_M			: buffer std_logic_vector(2 downto 0) ;
		isP_s			: out std_logic;
		isQ_s			: out std_logic;
		R_out			: out std_logic;

		Status			: in std_logic_vector(1 downto 0);

		-- paralel part
		Seven_Segment	: out std_logic_vector(7 downto 0) ;
		Digit_SS		: out std_logic_vector(3 downto 0) ;

		led1		: out std_logic;
		led2 		: out std_logic;
		led3 		: out std_logic;
		led4 		: buffer std_logic;

		-- -------------------- Untuk Mengirim -------------------------
		send 		 : in std_logic;
		REG_IN_Biner : in std_logic_vector(biner-1 downto 0); -- ntar ubah jai IN
		
		-- serial part
		rs232_rx 		: in std_logic;
		rs232_tx 		: out std_logic
	
	);
End entity;


Architecture RTL of UART_convert is

	Component my_uart_top is
	port(
			clk 			: in std_logic;
			rst_n 			: in std_logic;
			send 			: in std_logic;
			send_data		: in std_logic_vector(7 downto 0) ;
			receive 		: out std_logic;
			receive_data	: out std_logic_vector(7 downto 0) ;
			rs232_rx 		: in std_logic;
			rs232_tx 		: out std_logic
	);
	end Component;

	Component ascii_to_bcd is
		port(
			ascii : in std_logic_vector(7 downto 0);
			bcd     : out std_logic_vector(3 downto 0);
			mode     : out std_logic_vector(2 downto 0)
			
		);
	end Component;	
	
	Component bcd_to_ascii is
		port(
			bcd : in std_logic_vector(3 downto 0);
			ascii : out std_logic_vector(7 downto 0)
		);
	end Component;

	Component CLOCKDIV is
		port(
			CLK: IN std_logic;
			pulse_div: buffer std_logic);
	end Component;	
	
	-- UNTUK PROSES PENERIMAAN DATA UART
	signal send_data,receive_data	: std_logic_vector(7 downto 0);
	signal receive		: std_logic;
	signal receive_c	: std_logic;

	-- UTNTUK PENYIMPNAN HASIL KONVERSI BLOK
	signal BCD			: std_logic_vector(3 downto 0);
	signal conv_mode	: std_logic_vector(2 downto 0);

	-- UNTUK PROSES 7S LED
	type states_7s is (s1, s2, s3, s4);
    SIGNAL state_7s 		: states_7s := s1;

	-- UNTUK DEKLARASI PENYIMPANAN REGISTER
	signal REGA_BCD, REGB_BCD : std_logic_vector(((4*bcd_char)-1) downto 0);
	signal REG_B_TMP : std_logic_vector(biner-1 downto 0) := (OTHERS => '0');

	-- UNTUK PROSES PENGISIAN REGISTER
	type states is (init, RA, RB, final);
	SIGNAL state 			: states := init;

	-- UNTUK OUTPUT
	type states_out is (init, wait_mp, final);
	SIGNAL state_output 	: states_out := init;
	signal is_receive_done	: std_logic := '0';
	signal isA_negative		:  std_logic;
	signal isB_negative		:  std_logic;

	-- UNTUK LOGIKA OUTPUT
	signal isSignedBit	: std_logic;

	SIGNAL  clk_7s 			: STD_LOGIC;

	-- ------------------------------------- UNTUK PENGIRIMAN DATA --------------------------------
	SIGNAL	clk_send		: STD_LOGIC;
	SIGNAL  send_signal 	: STD_LOGIC;
	SIGNAL  SignChar		: STD_LOGIC;

	SIGNAL REG_IN_BINER_SHIFT :  std_logic_vector(biner-1 downto 0);
	SIGNAL REG_OUT_BCD	:  std_logic_vector(((4*bcd_char)-1) downto 0)  ; --INPUT HARUSNYA BCD

	-- UNTUK PROSES PENGIRIMAN
	type states_send is (init, start, shift, adder,  prepare, sendBCD, switch, done );
    SIGNAL state_send 		: states_send := init;
	SIGNAL isNegatif : std_logic;
	
begin


	UART: my_uart_top 
	port map (
		clk 			=> clk,
		rst_n 			=> rst_n,
		send 			=> send_signal,
		send_data		=> send_data,
		receive 		=> receive,
		receive_data	=> receive_data,
		rs232_rx 		=> rs232_rx,
		rs232_tx 		=> rs232_tx
	);

	CONVERT: ascii_to_bcd
	port map (
		ascii 		=> receive_data,
		bcd     	=> BCD,
		mode     	=> conv_mode
	);

	CONVERT_TO_ASCII: bcd_to_ascii
	port map (
		bcd 		=> REG_OUT_BCD(((4*bcd_char)-1) downto ((4*bcd_char)-1)- 3), 
		ascii     => send_data
	);

	CLOCK7S: CLOCKDIV
	port map (
		CLK 		=> clk,
		pulse_div 	=> clk_7s
	);


	OUTPUT7S : Process(clk_7s)
	begin
		IF rising_edge(clk_7s) THEN
		case state_7s is
			when s1 =>
				Digit_SS <= "1110";
				--Seven_Segment <= not("10000000");
				case REG_M is    -- display hasil operasi
				when "000" => Seven_Segment <= not("01000000");    -- --
				when "001" => Seven_Segment <= not("00111111");    -- D (adder)
				when "010" => Seven_Segment <= not("01111111");    -- B (subtractor)
				when "011" => Seven_Segment <= not("00100111");    -- L (Multiplication)
				when "100" => Seven_Segment <= not("00000110");    -- V (Division)
				when "101" => Seven_Segment <= not("00100111");    -- O (Modulo)
				when "110" => Seven_Segment <= not("00110111");    -- N (Pangkat)
				when "111" => Seven_Segment <= not("01110011");    -- B (FPB)
				when others => Seven_Segment <= not("01111001"); -- Error
				end case;

				-- case REG_A(3 downto 0) is    -- display hasil operasi
				-- when "0000" => Seven_Segment <= not("00111111");    -- '0'
				-- when "0001" => Seven_Segment <= not("00000110");    -- '1'
				-- when "0010" => Seven_Segment <= not("01011011");    -- '2'
				-- when "0011" => Seven_Segment <= not("01001111");    -- '3'
				-- when "0100" => Seven_Segment <= not("01100110");    -- '4'
				-- when "0101" => Seven_Segment <= not("01101101");    -- '5'
				-- when "0110" => Seven_Segment <= not("01111101");    -- '6'
				-- when "0111" => Seven_Segment <= not("00000111");    -- '7'
				-- when "1000" => Seven_Segment <= not("01111111");    -- '8'
				-- when "1001" => Seven_Segment <= not("01101111");    -- '9'
				-- when others => Seven_Segment <= not("11111111");
				-- end case;

				state_7s <= s2;
		
			when s2 =>
				Digit_SS <= "1101";
				--Seven_Segment <= not("10000000");
				case REG_M is    -- display hasil operasi
				when "000" => Seven_Segment <= not("01000000");    -- --
				when "001" => Seven_Segment <= not("00111111");    -- D (adder)
				when "010" => Seven_Segment <= not("01111111");    -- B (subtractor)
				when "011" => Seven_Segment <= not("00100111");    -- L (Multiplication)
				when "100" => Seven_Segment <= not("00000110");    -- V (Division)
				when "101" => Seven_Segment <= not("00100111");    -- O (Modulo)
				when "110" => Seven_Segment <= not("00110111");    -- N (Pangkat)
				when "111" => Seven_Segment <= not("01110011");    -- B (FPB)
				when others => Seven_Segment <= not("01111001"); -- Error
				end case;
				state_7s <= s3;
			
			when s3 =>
				Digit_SS <= "1011";
				--Seven_Segment <= not("10000000");
				case REG_M is    -- display hasil operasi
				when "000" => Seven_Segment <= not("01000000");    -- --
				when "001" => Seven_Segment <= not("00111111");    -- D (adder)
				when "010" => Seven_Segment <= not("00111110");    -- U (subtractor)
				when "011" => Seven_Segment <= not("00100111");    -- M (Multiplication)
				when "100" => Seven_Segment <= not("00000110");    -- i (Division)
				when "101" => Seven_Segment <= not("00100111");    -- M (Modulo)
				when "110" => Seven_Segment <= not("00110111");    -- A (Pangkat)
				when "111" => Seven_Segment <= not("01110011");    -- P (FPB)
				when others => Seven_Segment <= not("01111001"); -- Error
				end case;
				state_7s <= s4;
			
			when s4 =>
				Digit_SS <= "0111";
				case REG_M is    -- display hasil operasi
				when "000" => Seven_Segment <= not("01000000");    -- --
				when "001" => Seven_Segment <= not("01110111");    -- A (adder)
				when "010" => Seven_Segment <= not("01101101");    -- S (subtractor)
				when "011" => Seven_Segment <= not("00110011");    -- M (Multiplication)
				when "100" => Seven_Segment <= not("00111111");    -- D (Division)
				when "101" => Seven_Segment <= not("00110011");    -- M (Modulo)
				when "110" => Seven_Segment <= not("01110011");    -- P (Pangkat)
				when "111" => Seven_Segment <= not("01110001");    -- F (FPB)
				when others => Seven_Segment <= not("01111001"); -- Error
				end case;
				state_7s <= s1;
		end case;
		end if;
	end process OUTPUT7S;
	
	PengisianRegister : Process(clk)
	begin
		if ((clk = '1') and clk'event) then

			-- ________________________________ JIKA PENERIMAAN DATA SELESAI ______________________________
			if (is_receive_done = '1') then
				case state_output is
					when init => 
						-- LAKUKAN KONVERSI BCD KE BINER

						REG_A <= (REGA_BCD(3 downto 0) * "000000000000000000000000000000000001")  --multiply by 1
						+ (REGA_BCD(7 downto 4) * 		"0000000000000000000000000000000001010") --multiply by 10
						+ (REGA_BCD(11 downto 8) * 		"0000000000000000000000000000001100100") --multiply by 100
						+ (REGA_BCD(15 downto 12) * 	"0000000000000000000000000001111101000") --multiply by 1000
						+ (REGA_BCD(19 downto 16) * 	"0000000000000000000000000011111010000") --multiply by 10000
						+ (REGA_BCD(23 downto 20) * 	"0000000000000000000000000111110100000") --multiply by 100000
						+ (REGA_BCD(27 downto 24) * 	"0000000000000000000000001111101000000") --multiply by 1000000
						+ (REGA_BCD(31 downto 28) * 	"0000000000000000000000011111010000000") --multiply by 10000000
						+ (REGA_BCD(35 downto 32) * 	"0000000000000000000000111110100000000") --multiply by 100000000
						+ (REGA_BCD(39 downto 36) * 	"0000000000000000000001111101000000000") --multiply by 1000000000
						+ (REGA_BCD(43 downto 40) * 	"0000000000000000000011111010000000000") --multiply by 10000000000
						+ (REGA_BCD(47 downto 44) * 	"0000000000000000000111110100000000000"); --multiply by 100000000000
					

						REG_B <= (REGB_BCD(3 downto 0) * "000000000000000000000000000000000001")  --multiply by 1
						+ (REGB_BCD(7 downto 4) * 		"0000000000000000000000000000000001010") --multiply by 10
						+ (REGB_BCD(11 downto 8) * 		"0000000000000000000000000000001100100") --multiply by 100
						+ (REGB_BCD(15 downto 12) * 	"0000000000000000000000000001111101000") --multiply by 1000
						+ (REGB_BCD(19 downto 16) * 	"0000000000000000000000000011111010000") --multiply by 10000
						+ (REGB_BCD(23 downto 20) * 	"0000000000000000000000000111110100000") --multiply by 100000
						+ (REGB_BCD(27 downto 24) * 	"0000000000000000000000001111101000000") --multiply by 1000000
						+ (REGB_BCD(31 downto 28) * 	"0000000000000000000000011111010000000") --multiply by 10000000
						+ (REGB_BCD(35 downto 32) * 	"0000000000000000000000111110100000000") --multiply by 100000000
						+ (REGB_BCD(39 downto 36) * 	"0000000000000000000001111101000000000") --multiply by 1000000000
						+ (REGB_BCD(43 downto 40) * 	"0000000000000000000011111010000000000") --multiply by 10000000000
						+ (REGB_BCD(47 downto 44) * 	"0000000000000000000111110100000000000"); --multiply by 100000000000
						
						REG_B_TMP <= (OTHERS => '0');

						
						
						state_output <= wait_mp;

					when wait_mp => 
						if (REG_B_TMP /= REG_B) then
							REG_B_TMP <= REG_B;

							-- LAKUKAN KONVERSI BCD KE BINER
							REG_A <= (REGA_BCD(3 downto 0) * "000000000000000000000000000000000001")  --multiply by 1
						+ (REGA_BCD(7 downto 4) * 		"0000000000000000000000000000000001010") --multiply by 10
						+ (REGA_BCD(11 downto 8) * 		"0000000000000000000000000000001100100") --multiply by 100
						+ (REGA_BCD(15 downto 12) * 	"0000000000000000000000000001111101000") --multiply by 1000
						+ (REGA_BCD(19 downto 16) * 	"0000000000000000000000000011111010000") --multiply by 10000
						+ (REGA_BCD(23 downto 20) * 	"0000000000000000000000000111110100000") --multiply by 100000
						+ (REGA_BCD(27 downto 24) * 	"0000000000000000000000001111101000000") --multiply by 1000000
						+ (REGA_BCD(31 downto 28) * 	"0000000000000000000000011111010000000") --multiply by 10000000
						+ (REGA_BCD(35 downto 32) * 	"0000000000000000000000111110100000000") --multiply by 100000000
						+ (REGA_BCD(39 downto 36) * 	"0000000000000000000001111101000000000") --multiply by 1000000000
						+ (REGA_BCD(43 downto 40) * 	"0000000000000000000011111010000000000") --multiply by 10000000000
						+ (REGA_BCD(47 downto 44) * 	"0000000000000000000111110100000000000"); --multiply by 100000000000
					

						REG_B <= (REGB_BCD(3 downto 0) * "000000000000000000000000000000000001")  --multiply by 1
						+ (REGB_BCD(7 downto 4) * 		"0000000000000000000000000000000001010") --multiply by 10
						+ (REGB_BCD(11 downto 8) * 		"0000000000000000000000000000001100100") --multiply by 100
						+ (REGB_BCD(15 downto 12) * 	"0000000000000000000000000001111101000") --multiply by 1000
						+ (REGB_BCD(19 downto 16) * 	"0000000000000000000000000011111010000") --multiply by 10000
						+ (REGB_BCD(23 downto 20) * 	"0000000000000000000000000111110100000") --multiply by 100000
						+ (REGB_BCD(27 downto 24) * 	"0000000000000000000000001111101000000") --multiply by 1000000
						+ (REGB_BCD(31 downto 28) * 	"0000000000000000000000011111010000000") --multiply by 10000000
						+ (REGB_BCD(35 downto 32) * 	"0000000000000000000000111110100000000") --multiply by 100000000
						+ (REGB_BCD(39 downto 36) * 	"0000000000000000000001111101000000000") --multiply by 1000000000
						+ (REGB_BCD(43 downto 40) * 	"0000000000000000000011111010000000000") --multiply by 10000000000
						+ (REGB_BCD(47 downto 44) * 	"0000000000000000000111110100000000000"); --multiply by 100000000000

							state_output <= wait_mp;	
						else 
							state_output <= final;
						end if;

					when final =>
						-- LAKUKAN KONVERSI BCD KE BINER TAMBAHKAN SIGNED BIT
						REG_A <= (REGA_BCD(3 downto 0) * "000000000000000000000000000000000001")  --multiply by 1
						+ (REGA_BCD(7 downto 4) * 		"0000000000000000000000000000000001010") --multiply by 10
						+ (REGA_BCD(11 downto 8) * 		"0000000000000000000000000000001100100") --multiply by 100
						+ (REGA_BCD(15 downto 12) * 	"0000000000000000000000000001111101000") --multiply by 1000
						+ (REGA_BCD(19 downto 16) * 	"0000000000000000000000000011111010000") --multiply by 10000
						+ (REGA_BCD(23 downto 20) * 	"0000000000000000000000000111110100000") --multiply by 100000
						+ (REGA_BCD(27 downto 24) * 	"0000000000000000000000001111101000000") --multiply by 1000000
						+ (REGA_BCD(31 downto 28) * 	"0000000000000000000000011111010000000") --multiply by 10000000
						+ (REGA_BCD(35 downto 32) * 	"0000000000000000000000111110100000000") --multiply by 100000000
						+ (REGA_BCD(39 downto 36) * 	"0000000000000000000001111101000000000") --multiply by 1000000000
						+ (REGA_BCD(43 downto 40) * 	"0000000000000000000011111010000000000") --multiply by 10000000000
						+ (REGA_BCD(47 downto 44) * 	"0000000000000000000111110100000000000"); --multiply by 100000000000
					

						REG_B <= (REGB_BCD(3 downto 0) * "000000000000000000000000000000000001")  --multiply by 1
						+ (REGB_BCD(7 downto 4) * 		"0000000000000000000000000000000001010") --multiply by 10
						+ (REGB_BCD(11 downto 8) * 		"0000000000000000000000000000001100100") --multiply by 100
						+ (REGB_BCD(15 downto 12) * 	"0000000000000000000000000001111101000") --multiply by 1000
						+ (REGB_BCD(19 downto 16) * 	"0000000000000000000000000011111010000") --multiply by 10000
						+ (REGB_BCD(23 downto 20) * 	"0000000000000000000000000111110100000") --multiply by 100000
						+ (REGB_BCD(27 downto 24) * 	"0000000000000000000000001111101000000") --multiply by 1000000
						+ (REGB_BCD(31 downto 28) * 	"0000000000000000000000011111010000000") --multiply by 10000000
						+ (REGB_BCD(35 downto 32) * 	"0000000000000000000000111110100000000") --multiply by 100000000
						+ (REGB_BCD(39 downto 36) * 	"0000000000000000000001111101000000000") --multiply by 1000000000
						+ (REGB_BCD(43 downto 40) * 	"0000000000000000000011111010000000000") --multiply by 10000000000
						+ (REGB_BCD(47 downto 44) * 	"0000000000000000000111110100000000000"); --multiply by 100000000000
						
						if (isA_negative = '1') then
							REG_A(biner-1) <= '1';
						else
							REG_A(biner-1) <= '0';
						end if;

						if (isB_negative = '1') then
							REG_B(biner-1) <= '1';
						else
							REG_B(biner-1) <= '0';
						end if;

						R_out <= '1';
						
						state_output <= final;

				end case;
			else 

				R_out <= '0';
				state_output <= init;

			end if;
			-- ________________________________ JIKA PENERIMAAN DATA SELESAI ______________________________


			-- ----------------------------- JIKA MENERIMA DATA ---------------------------------------------
			receive_c <= receive;
			if ((receive = '0') and (receive_c = '1'))then
			case state is
				when init =>

					-- RSET SEMUA NILAI
					REG_A 		<= (OTHERS => '0');
					REG_B 		<= (OTHERS => '0');
					REGA_BCD 	<= (OTHERS => '0');
					REGB_BCD 	<= (OTHERS => '0');
					REG_M 		<= (OTHERS => '0');

					isP_s <= '0';
					isQ_s <= '0';

					isSignedBit <= '1';
					isA_negative <= '0';
					isB_negative <= '0';
					is_receive_done <= '0';

					-- PERPINDAHAN STATE
					if (receive_data = "00100011") then		-- Kalau Nerima #, mulai masuk ke pengisian REG
						state <= RA;
					else
						state <= init;						-- Belum nerima # tetap disini
					end if;


				When RA =>	-- PENGISIAN REGISTER A
					if(isSignedBit = '1' and receive_data = "00101101") then	-- PENGECEKAN TANDA, jika nemu - maka negatif, sebaliknya itu bilangan
						isA_negative 	<= '1';
						isSignedBit 	<= '0';

						state 			<= RA;

					elsif (receive_data = "01010011") then -- NERIMA S
						isP_s <= '1';
							
					elsif(conv_mode /= "000") then								-- KALAU MENEMUKAN TANDA PINDAH STATE
						REG_M 			<= conv_mode;
						isSignedBit 	<= '1';

						state 			<= RB;
					
					else														-- MENEMUKAN ANGKA, PINDAH ISI REG berikutnya
						-- PENGISIAN REGISTER A BCD
						REGA_BCD 		<= REGA_BCD(((4*bcd_char)-1) - 4 downto 0) & BCD;
						isSignedBit 	<= '0';

						state 			<= RA;

					end if;
	
				
				When RB =>	-- PENGISIAN REGISTER B
					if(isSignedBit = '1' and receive_data = "00101101") then	
						isB_negative 	<= '1';
						isSignedBit 	<= '0';		
						
						state 			<= RB;

					elsif (receive_data = "01010011") then
						isQ_s <= '1';
						
					elsif(receive_data = "00111101") then						-- KALAU MISALKAN MENEMUKAN TANDA = PINDAH STATE
						is_receive_done <= '1';

						state 			<= final;

					else														-- MENEMUKAN ANGKA, PINDAH ISI REG berikutnya
						-- PENGISIAN REGISTER B BCD
						REGB_BCD 		<= REGA_BCD(((4*bcd_char)-1) - 4 downto 0) & BCD;
						state 			<= RB;
					end if;


				When final =>	-- MEMPERTAHANKAN NILAI SAMPAI RESET (R)
					is_receive_done <= '1';

					-- PERPINDAHAN STATE
					if (receive_data = "01010010") then		-- Kalau Nerima R, mulai masuk ke pengisian REG
						state <= init;

						-- RSET SEMUA NILAI
						REG_A 		<= (OTHERS => '0');
						REG_B 		<= (OTHERS => '0');
						REGA_BCD 	<= (OTHERS => '0');
						REGB_BCD 	<= (OTHERS => '0');
						REG_M 		<= (OTHERS => '0');
						isSignedBit <= '1';
						isA_negative <= '0';
						isB_negative <= '0';
					else
						state <= final;
					end if;
			end case;
			end if;
			------------------------------- JIKA MENERIMA DATA ---------------------------------------------

		end if;
	end process PengisianRegister;

	------------------------------- JIKA MENGIRIM DATA ---------------------------------------------
	SendClock : PROCESS(clk)
		VARIABLE sendCount : INTEGER:= 0;
		BEGIN
			IF rising_edge(clk) THEN
				IF sendCount > (800000) THEN
					clk_send <= NOT clk_send;
					sendCount := 0;
				ELSE
					sendCount := sendCount + 1;
				END IF;
			END IF;
	END PROCESS SendClock;


	SendData : PROCESS(clk, send)
		VARIABLE bcdCount : INTEGER:= 0;
		VARIABLE convert : INTEGER:= 0;
		
		BEGIN
			
			IF rising_edge(clk_send) THEN

				case state_send is
					when init =>

						-- REG_OUT_BCD <= ("0101000101110101"); --5175
						-- REG_IN_Biner <= "00000100001000000100100000000011000110101";
						bcdCount := 0;

						IF(send = '0' or Status = "11" or Status = "10") then -- harunya kalau dikasih '1' baru ngirim, tp ini karena button jadi '0'
							state_send <= start;
						else
							state_send <= init;
						end if;

					when start =>
						IF (Status = "11") THEN
							convert := 1;

							IF (REG_IN_Biner(biner - 1) = '1') then
								isNegatif <= '1';
							else
								isNegatif <= '0';
							end if;

							REG_IN_BINER_SHIFT <= '0' & REG_IN_Biner(biner - 2 downto 0);
							REG_OUT_BCD <= (OTHERS => '0');

							state_send <= adder;

						ELSE
							REG_OUT_BCD <= "111111111111111111111111111111111111111111111111";
							state_send <= prepare;
						END IF;

					when shift =>
						if (convert > biner) then
							state_send <= prepare;
						else

							REG_OUT_BCD <= REG_OUT_BCD((((4*bcd_char)-1) - 1) downto 0) & REG_IN_BINER_SHIFT(biner-1);

							REG_IN_BINER_SHIFT <= REG_IN_BINER_SHIFT((biner - 1) - 1 downto 0) & '0';

							convert := convert + 1;

							if (convert <= biner) then
								state_send <= adder;
							end if;

						end if;

					
					when adder =>

							if REG_OUT_BCD(47 downto 44) > 4 then
								REG_OUT_BCD(15 downto 12) <= REG_OUT_BCD(15 downto 12) + 3;
							end if;
							
							if REG_OUT_BCD(43 downto 40) > 4 then
								REG_OUT_BCD(11 downto 8) <= REG_OUT_BCD(11 downto 8) + 3;
							end if;
							
							if REG_OUT_BCD(39 downto 36) > 4 then
								REG_OUT_BCD(7 downto 4) <= REG_OUT_BCD(7 downto 4) + 3;
							end if;

							if REG_OUT_BCD(35 downto 32) > 4 then
								REG_OUT_BCD(15 downto 12) <= REG_OUT_BCD(15 downto 12) + 3;
							end if;

							if REG_OUT_BCD(31 downto 28) > 4 then
								REG_OUT_BCD(15 downto 12) <= REG_OUT_BCD(15 downto 12) + 3;
							end if;
							
							if REG_OUT_BCD(27 downto 24) > 4 then
								REG_OUT_BCD(11 downto 8) <= REG_OUT_BCD(11 downto 8) + 3;
							end if;
							
							if REG_OUT_BCD(23 downto 20) > 4 then
								REG_OUT_BCD(7 downto 4) <= REG_OUT_BCD(7 downto 4) + 3;
							end if;		
							
							if REG_OUT_BCD(19 downto 16) > 4 then
								REG_OUT_BCD(15 downto 12) <= REG_OUT_BCD(15 downto 12) + 3;
							end if;

							if REG_OUT_BCD(15 downto 12) > 4 then
								REG_OUT_BCD(15 downto 12) <= REG_OUT_BCD(15 downto 12) + 3;
							end if;
							
							if REG_OUT_BCD(11 downto 8) > 4 then
								REG_OUT_BCD(11 downto 8) <= REG_OUT_BCD(11 downto 8) + 3;
							end if;
							
							if REG_OUT_BCD(7 downto 4) > 4 then
								REG_OUT_BCD(7 downto 4) <= REG_OUT_BCD(7 downto 4) + 3;
							end if;
							
							if REG_OUT_BCD(3 downto 0) > 4 then
								REG_OUT_BCD(3 downto 0) <= REG_OUT_BCD(3 downto 0) + 3;
							end if;


							state_send <= shift;
						
						
					
					when prepare =>
						led4 <= '0';
						send_signal <= '1';
						SignChar <= '1';
						
						state_send <= sendBCD;

					when sendBCD =>
						SignChar <= '0';
						led4 <= '1';
						send_signal <= '0';
						

						state_send <= switch;

					when switch =>
						send_signal <= '1';
						led4 <= '0';

						if (isNegatif = '1') then
							REG_OUT_BCD <= REG_OUT_BCD((((4*bcd_char)-1)- 4) downto 0) & "1010";
						else
							REG_OUT_BCD <= REG_OUT_BCD((((4*bcd_char)-1)- 4) downto 0) & "1011";
						end if;
						

						bcdCount := bcdCount + 1;

						if(bcdCount >= bcd_char + 1 ) then
							state_send <= done;
						else
							state_send <= sendBCD;
						end if;
					
					when done =>
						send_signal <= '1';

						IF(send = '0') then -- harunya kalau dikasih '1' baru ngirim, tp ini karena button jadi '0'
							state_send <= done;
						else
							state_send <= init;
						end if;
					
						

				end case;
				
			END IF;	
	END PROCESS SendData;

	------------------------------- JIKA MENGIRIM DATA ---------------------------------------------

end architecture;


