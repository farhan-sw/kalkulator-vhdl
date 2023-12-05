library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity adderFSM is
    generic ( N : INTEGER := 41 );
    port (
        A, B            : in std_logic_vector(N - 1 downto 0);
        sum             : buffer std_logic_vector(N - 1 downto 0);

        EN              : in std_logic;
        ENS             : buffer std_logic;

        status          : out std_logic_vector(1 downto 0);
             
        clk             : in std_logic
    );
end adderFSM;

architecture adderFSM_arc of adderFSM is

    component RegisterSerial
        generic ( N : INTEGER := 41);
        port (
            IN_REG          : in std_logic_vector (N-1 downto 0);
            L, W, EN        : in std_logic;

            Q               : buffer std_logic_vector (N-1 downto 0);

            clk             : in std_logic
        );
    end component;

    SIGNAL QA, QB : std_logic_vector(N - 1 downto 0);

    type states is (init, G, H, done, doneWithCary);
    SIGNAL state : states;
    SIGNAL count : INTEGER range 0 to N;

    SIGNAL s   : std_logic;
    SIGNAL run   : std_logic := '1';

    SIGNAL high : std_logic := '1';
    SIGNAL low : std_logic := '0';
    SIGNAL reset: std_logic := '0';

begin

    -- DEKLARASI NILAI
    reset       <= not(ENS);

    RegA: RegisterSerial GENERIC MAP (N => N)
        PORT MAP (A, reset, low, high, QA, clk);
    
    RegB: RegisterSerial GENERIC MAP (N => N)
        PORT MAP (B, reset, low, high, QB, clk);


    Adder : process (EN, clk, run)
    begin
        -- JIka belum dinyalakan, berada di Init
        IF (EN = '0') THEN
            state <= init;
        ELSIF rising_edge(clk) THEN
            case state is
        
                when init =>
                    -- Jika Enabled dinyalakan, pindah ke G, Mulai adder
                    IF (EN = '1') then state <= G;
                    else state <= init;
                    end if;

                when G =>
                    -- Adder jalan jika masih ada perintah jalan
                    IF (run = '1') then
                        IF (QA(0) = '1' and QB(0) = '1') then state <= H;
                        else state <= G;
                        end if;
                    
                    -- Adder berhenti berjalan, count habis, pindah ke done
                    else
                        state <= done;
                    END IF;
                    
                when H =>
                    -- Adder jalan jika masih ada perintah jalan
                    IF (run = '1') then
                        IF (QA(0) = '0' and QB(0) = '0') then state <= G;
                        else state <= H;
                        end if;
                    
                    -- Adder berhenti berjalan, count habis, pindah ke done
                    else
                    
                        state <= doneWithCary;
                    END IF;

                when doneWithCary =>
                    -- Tetap berada di Done sampai EN menjadi 0
                    IF (EN = '0') then
                        state <= init;
                    else
                        state <= doneWithCary;
                    END IF;

                when done =>
                    -- Tetap berada di Done sampai EN menjadi 0
                    IF (EN = '0') then
                        state <= init;
                    else
                        state <= done;
                    END IF;
                

            end case;
        END IF;
    end process Adder;

    Stop : process (clk)
    begin
        IF (rising_edge(clk)) THEN

            -- Counter hanya akan menghitung ketika sudah nyala (EN = 1) dan REG S sudah siap (ENS = 1)
            IF (EN = '0') THEN
                count <= N;
            elsif (run = '1' and ENS = '1') then
                count <= (count - 1);
            else
                count <= count;
            end if;

        END IF;
        
        -- run akan dimatikan ketika count sudah mencapai 0
        IF(count = 0) THEN
                run <= '0';
            ELSE
                run <= '1';
        END IF;
    end process Stop;

    Combinational : process (state)
    begin
        case state is
        
            when init =>
                s <= '0';
                ENS <= '0';
                status <= "00";          -- Belum Dimulai

            when G =>
                s <= (QA(0) XOR QB(0));
                ENS <= '1';
                status <= "01";          -- Dalam Proses
                
            when H =>
                s <= NOT(QA(0) XOR QB(0));
                ENS <= '1';
                status <= "01";          -- Dalam Proses

            when doneWithCary =>
                s <= NOT(QA(0) XOR QB(0));
                ENS <= '0';
                status <= "11";          -- Selesai Perhitungan

            when done =>
                s <= NOT(QA(0) XOR QB(0));
                ENS <= '0';
                status <= "11";          -- Selesai Perhitungan

        end case;

    end process Combinational;

    RegS: RegisterSerial GENERIC MAP (N => N)
        PORT MAP ((OTHERS => '0'), reset, s, run, sum, clk);

    
end adderFSM_arc;
