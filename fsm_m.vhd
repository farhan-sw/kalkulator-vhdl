library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity FSM_M is
    generic ( N : INTEGER := 41);
    port (
        Pin, Qin        : in std_logic_vector (N - 1 downto 0);
        P_Out, Q_Out    : out std_logic_vector(N - 1 downto 0);

        M               : in std_logic_vector(2 downto 0);
        status          : in std_logic_vector(1 downto 0);

        EN              : out std_logic;

        clk             : in std_logic;
        rst             : in std_logic

    );
end FSM_M;

architecture FSM_arc of FSM_M is

    component adderFSM
        generic ( N : INTEGER := N );
        port (
            A, B            : in std_logic_vector(N - 1 downto 0);
            sum             : buffer std_logic_vector(N - 1 downto 0);

            EN              : in std_logic;
            ENS             : buffer std_logic;

            status          : out std_logic_vector(1 downto 0);
                
            clk             : in std_logic
        );
    end component;

    component mux21
        generic ( N : INTEGER := N );
        PORT (  P, Q   		: IN STD_LOGIC_VECTOR (N-1 downto 0) ;
                S, clk      : IN std_logic;
                f      		: OUT STD_LOGIC_VECTOR (N-1 downto 0)
                );
    end component;

    component S2Comp
        generic ( N : INTEGER := N);
        port (
            IN_COMP          : in std_logic_vector (N-1 downto 0);
            OUT_COMP          : buffer std_logic_vector (N-1 downto 0);

            clk             : in std_logic
        );
    end component;

    SIGNAL P, Q : std_logic_vector(N - 1 downto 0);

    SIGNAL P_Comp, Q_Comp : std_logic_vector(N - 1 downto 0);
    SIGNAL SQ, SP : std_logic;

    type states is (init, compare, s1, s2, s3, s4, wait_adder, done);
    SIGNAL state : states;

begin

    OUTP : mux21  GENERIC MAP (N => N)
        PORT MAP (P, P_Comp, SP, clk, P_Out);
    OUTQ : mux21 GENERIC MAP (N => N)
        PORT MAP (Q, Q_Comp, SQ, clk, Q_Out);

    COMP_P : S2Comp GENERIC MAP (N => N)
        PORT MAP (P, P_Comp, clk);
    
    COMP_Q : S2Comp GENERIC MAP (N => N)
        PORT MAP (Q, Q_Comp, clk);
    
    -- Lakukan Inisiasi untuk setiap state
    AdderSubtractor : process (M, clk)
    begin
        -- JIka belum dinyalakan, berada di Init
        IF (M /= "001" and M /= "010") THEN
            state <= init;
            P <= Pin;
            Q <= Qin;
        ELSIF rising_edge(clk) THEN
            case state is

                when init =>
                    if (M = "001" or M = "010") then
                        state <= compare;
                    else
                        state <= init;
                    end if;

                when compare =>
                    if ((M = "001" and P(N-1) = '0' and Q(N-1) = '0') or (M = "010" and P(N-1) = '0' and Q(N-1) = '1')) then -- tambah biasa langsung
                        state <= s1;
                    elsif ((M = "001" and P(N-1) = '0' and Q(N-1) = '1') or (M = "010" and P(N-1) = '0' and Q(N-1) = '0')) then --P - Q
                        state <= s2;
                    else 
                        state <= s1;
                    end if;

                when s1 => 
                    state <= wait_adder;
                when s2 => 
                    state <= wait_adder;
                when s3 => 
                    state <= wait_adder;
                when s4 => 
                    state <= wait_adder;
                
                when wait_adder =>
                    if (status = "11" or status = "10") then
                        state <= done;
                        
                    else
                        state <= wait_adder;
                    end if;

                when done =>
                    if (M = "001" or M = "010") then
                        state <= done;
                    else
                        state <= init;
                    end if;

            end case;
        end if;
    end process AdderSubtractor;

    Combinational : process (clk)
    begin
        IF (rising_edge(clk)) THEN
        case state is

            when init =>
                SP <= '0';
                SQ <= '0';
                EN <= '0';  
                
            when compare =>
                SP <= '0';
                SQ <= '0';
                EN <= '0';  

            when s1 => 
                SP <= '0';
                SQ <= '0';
                EN <= '0';  
                
            when s2 => 
                SP <= '0';
                SQ <= '1';
                EN <= '0';  
                
            when s3 => 
                SP <= '1';
                SQ <= '0';
                EN <= '0'; 

            when s4 => 
                SP <= '1';
                SQ <= '1';
                EN <= '0';

            when wait_adder =>
                SP <= SP;
                SQ <= SQ;
                EN <= '1';

            when done =>
                SP <= SP;
                SQ <= SQ;
                EN <= '1';     

        end case;
        END IF;
    end process Combinational;
    

end FSM_arc;
