library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity modulo is
    generic (N : INTEGER := 41);
    port(
        Pin, Qin : in std_logic_vector (N-1 downto 0);
        mode : in std_logic_vector (2 downto 0 );
        OUT_Operasi : out std_logic_vector (N-1 downto 0);
        status_out : out std_logic_vector (1 downto 0);
        clk : in std_logic

    );
end modulo;

architecture modulo_arc of modulo is
    
    component FSM_Modulo is
        generic ( N : INTEGER := N );
        port (
            clk : in std_logic;
            ST, CMP : in std_logic_vector (1 downto 0);
            M : in std_logic_vector (2 downto 0);
            CT_P : out std_logic_vector (1 downto 0);
            CT_Q : out std_logic_vector (1 downto 0);

            -- stats		: out integer; BUAT DEBUG

            mode_out : out std_logic_vector (2 downto 0);
            status : out std_logic_vector (1 downto 0);
            selector : out std_logic
	 );
     end component;
    component mux21 is
        generic ( N : INTEGER := N);
	    PORT (  P, Q   		: IN STD_LOGIC_VECTOR (N-1 downto 0) ;
                S, clk      : IN std_logic;
                f      		: OUT STD_LOGIC_VECTOR (N-1 downto 0)
			);
    END component;
    component AdderSubtractor is
        generic ( N : INTEGER := N );
        port (
            P_in            : in std_logic_vector (N - 1 downto 0);
            Q_in            : in std_logic_vector (N - 1 downto 0);
    
            OUT_Operasi     : out std_logic_vector (N - 1 downto 0);
    
            M               : in std_logic_vector(2 downto 0);
            status          : out std_logic_vector(1 downto 0);
    
            clk             : in std_logic;
            rst             : in std_logic
        );
    end component;

    component comparator is
        generic ( N : INTEGER := N );
        port ( P, Q : in std_logic_vector (N - 1 downto 0);
			rst, clk : in std_logic ;
			comp : out std_logic_vector (1 downto 0)
			);
    end component;

    component ParalelRegister2 is
        generic ( N : INTEGER := N );
        port (
            IN_REG          : in std_logic_vector (N-1 downto 0);
            CT              : in std_logic_vector(1 downto 0);
            OUT_REG         : out std_logic_vector(N-1 downto 0);
    
            clk             : in std_logic
        );
    end component;

    signal P_signal, Q_signal, output_substractor, output_register_P:  std_logic_vector(N-1 downto 0);
    signal CMP_signal, status_signal, CT_P_signal, CT_Q_signal, status_fsm : std_logic_vector(1 downto 0);
    signal mode_signal : std_logic_vector (2 downto 0);
    signal selector_signal : std_logic;

    SIGNAL high : std_logic := '1';
    SIGNAL low : std_logic := '0';

    begin

		-- FSM
		FSM : FSM_modulo port map (clk, status_signal, CMP_signal, mode, CT_P_signal, CT_Q_signal,  mode_signal, status_fsm, selector_signal);
        
        -- portmap data path
        mux2to1 : mux21 port map (Pin, output_substractor, selector_signal ,clk , P_signal);

        Regis_P : ParalelRegister2 port map(P_signal ,CT_P_signal, output_register_P,clk);
        Regis_Q : ParalelRegister2 port map(Qin , CT_Q_signal, Q_signal, clk) ;

        substractor : AdderSubtractor port map(output_register_P, Q_signal, output_substractor, mode_signal, status_signal, clk, high);
        Blok_comparator : comparator port map (output_register_P, Q_signal, low , clk,CMP_signal);

        process (clk)
        begin
            OUT_Operasi <= output_register_P;
            status_out <= status_fsm;
        end process;
        

end modulo_arc;        