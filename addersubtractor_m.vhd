library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity AdderSubtractor_M is
    generic ( N : INTEGER := 4);
    port (
        P_in            : in std_logic_vector (N - 1 downto 0);
        Q_in            : in std_logic_vector (N - 1 downto 0);

        OUT_Operasi     : out std_logic_vector (N - 1 downto 0);

        M               : in std_logic_vector(2 downto 0);
        status          : out std_logic_vector(1 downto 0);

        clk             : in std_logic;
        rst             : in std_logic
    );
end AdderSubtractor_M;

architecture AdderSubtractor_arc of AdderSubtractor_M is

    component adderFSM
        generic ( N : INTEGER := N );
        port (
            A, B            : in std_logic_vector(N - 1 downto 0);
            sum             : out std_logic_vector(N - 1 downto 0);

            EN              : in std_logic;
            ENS             : out std_logic;

            status          : out std_logic_vector(1 downto 0);
                
            clk             : in std_logic
        );
    end component;

    component FSM_M
        generic ( N : INTEGER := N);
        port (
            Pin, Qin        : in std_logic_vector (N - 1 downto 0);
            P_Out, Q_Out    : out std_logic_vector(N - 1 downto 0);
            M               : in std_logic_vector(2 downto 0);
            status          : in std_logic_vector(1 downto 0);

            EN              : out std_logic;

            clk             : in std_logic;
            rst             : in std_logic

        );
    end component;

    signal P, Q, Out_int : std_logic_vector(N - 1 downto 0);
    signal sum_int : std_logic_vector(N - 1 downto 0);
    signal status_int : std_logic_vector(1 downto 0);
    signal ENS_int : std_logic;
    signal SQ_int, SP_int, EN_int : std_logic;

begin

    FSM_AdderSubtractor :  FSM_M GENERIC MAP (N => N)
        PORT MAP (
            Pin         => P_in,
            Qin         => Q_in,
            P_Out       => P,
            Q_Out       => Q,

            M           => M,
            status      => status_int,

            EN          => EN_int,

            clk         => clk,
            rst         => rst  
        );
    
    AdderFSMBlok : adderFSM GENERIC MAP (N => N)
        PORT MAP (
            A           => P,
            B           => Q,
            sum         => Out_int,      
            EN          => EN_int,                

            status      => status_int,      
                
            clk         => clk      

        );

    process(P_in, Q_in, P, Q, status_int, M, clk, rst)
    begin
        OUT_Operasi <= Out_int;
        status <= status_int;
    end process;
    
end AdderSubtractor_arc;
