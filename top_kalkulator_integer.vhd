-- library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- entity
entity top_kalkulator_integer is
    generic ( 
            biner : INTEGER := 41;
            bcd_char : INTEGER := 12 );
port(
    
    clk 			: in std_logic;
    rst_n 			: in std_logic;

    -- paralel part
    Seven_Segment	: out std_logic_vector(7 downto 0) ;
    Digit_SS		: out std_logic_vector(3 downto 0) ;

    led1		: out std_logic;
    led2 		: out std_logic;
    led3 		: out std_logic;
    led4 		: buffer std_logic;

    -- serial part
    send 		 : in std_logic;
    rs232_rx 		: in std_logic;
    rs232_tx 		: out std_logic
);
end entity top_kalkulator_integer;


architecture kalkulator of top_kalkulator_integer is

    Component UART_convert is
        generic ( 
            biner : INTEGER := 41;
            bcd_char : INTEGER := 12 );
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
            Digit_SS		: out std_logic_vector (3 downto 0) ;
    
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
    end Component;

    Component toplevel_sistem is
        generic ( N : integer := 41 );
            port (
                A				:in std_logic_vector (N-1 downto 0);
                B				:in std_logic_vector (N-1 downto 0);
                R				:in std_logic;
                isPS			:in std_logic;
                isQS			:in std_logic;
                Mode			:in std_logic_vector (2 downto 0);
                clk				:in std_logic;
                --debug_mode : out std_logic_vector(2 downto 0);
                Sen				:out std_logic_vector (N-1 downto 0); 
                S				:out std_logic_vector (1 downto 0);
                --debug_int : out integer;
                --debug_st : out std_logic_vector(1 downto 0);
                --debug_mux1, debug_mux2 : out std_logic_vector(N-1 downto 0);
                rst 			:in std_logic
            );
    end Component;


    -- DDAWDAW
    SIGNAL REG_A, REG_B         : std_logic_vector(biner-1 downto 0) ;
    SIGNAL REG_M                : std_logic_vector(2 downto 0) ;
    SIGNAL isP_s, isQ_s, R_out  : std_logic;

    SIGNAL dump1, dump2                  : std_logic;


    -- INI HARUSNYA DARI FSM
    SIGNAL Status               : std_logic_vector(1 downto 0);
    SIGNAL REG_IN_Biner         : std_logic_vector(biner-1 downto 0);

    SIGNAL CLOCK_ALL : std_logic;


begin

    --Status <= "00";

    --REG_IN_Biner <= "00000000000000000000000000000010000110101";

    UART : UART_convert
    port map (

        clk 			=> clk,
        rst_n 			=> rst_n,

        -- OUTPUT HASIL
        REG_A			=> REG_A,
        REG_B			=> REG_B,
        REG_M			=> REG_M,
        isP_s			=> isP_s,
        isQ_s			=> isQ_s,
        R_out			=> R_out,

        Status			=> Status,

        -- paralel part
        Seven_Segment	=> Seven_Segment,
        Digit_SS		=> Digit_SS,

        led1		=> led1,
        led2 		=> dump2,
        led3 		=> dump1,
        led4 		=> led4,

        -- -------------------- Untuk Mengirim -------------------------
        send 		 => send,
        REG_IN_Biner => REG_IN_Biner,
        
        -- serial part
        rs232_rx 		=> rs232_rx,
        rs232_tx 		=> rs232_tx


    );

    kalkulator : toplevel_sistem
    port map(

        A				=> REG_A,
        B				=> REG_B,
        R				=> R_out,
        isPS			=> isP_s,
        isQS			=> isQ_s,
        Mode			=> REG_M,
        clk				=> CLOCK_ALL,
        --debug_mode : out std_logic_vector(2 downto 0);
        Sen				=> REG_IN_Biner,
        S				=> Status,
        --debug_int : out integer;
        --debug_st : out std_logic_vector(1 downto 0);
        --debug_mux1, debug_mux2 : out std_logic_vector(N-1 downto 0);
        rst 			=> '0'

    );

    CLOCKSISTEM : PROCESS(clk)
		VARIABLE count : INTEGER:= 0;
		BEGIN
			IF rising_edge(clk) THEN
				IF count > (50000) THEN
                    CLOCK_ALL <= NOT CLOCK_ALL;
					count := 0;
				ELSE
					count := count + 1;
				END IF;
			END IF;
	END PROCESS CLOCKSISTEM;

    Process (clk)
    begin
        if (REG_M = "001") then
            led2 <= '0';
        else
            led2 <= '1'; 
        end if;

        if (REG_B = 7) then
            led3 <= '0';
        else
            led3 <= '1';
        end if;

    end Process;

	
end architecture;
