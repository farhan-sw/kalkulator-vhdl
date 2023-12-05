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
    end Component;

    -- DDAWDAW
    SIGNAL REG_A, REG_B         : std_logic_vector(biner-1 downto 0) ;
    SIGNAL REG_M                : std_logic_vector(2 downto 0) ;
    SIGNAL isP_s, isQ_s, R_out  : std_logic;

    SIGNAL dump1, dump2                  : std_logic;


    -- INI HARUSNYA DARI FSM
    SIGNAL Status               : std_logic_vector(1 downto 0);
    SIGNAL REG_IN_Biner         : std_logic_vector(biner-1 downto 0);


begin

    Status <= "00";

    REG_IN_Biner <= "00000000000000000000000000000010000110101";

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

    Process (clk)
    begin
        if (REG_A = 123) then
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
