library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity FPB is 
	generic ( N: INTEGER := 32);
	port (
		P_in, Q_in : IN STD_LOGIC_VECTOR (N-1 downto 0);
		Mode : IN STD_LOGIC_VECTOR (2 downto 0);
		St : OUT STD_LOGIC_VECTOR (1 downto 0); 
		OUT_FPB: OUT STD_LOGIC_VECTOR (N-1 downto 0); 
        clk, rst : IN STD_LOGIC );
        --tesmux2 : out std_logic;
        --tesoutsubtractor, Pinputsub, Qinputsub : out std_logic_vector (N-1 downto 0);
        
        --debug : out integer;
        
		--tescomp, substatus : out std_logic_vector (1 downto 0)
    
--	);
	end FPB;

architecture FPB_arc of FPB is 

component comparator is 
	generic ( N: INTEGER := N);
	port (
		P, Q : IN STD_LOGIC_VECTOR (N - 1 downto 0 );
		rst,clk : IN STD_LOGIC;
		comp : OUT STD_LOGIC_VECTOR (1 downto 0)
	);
end component;

component fsm_fpb is 
    generic (N: INTEGER := N);
    port (
        P, Q   : in std_logic_vector (N-1 downto 0);
        M    : in std_logic_vector (2 downto 0);
        St_Sub , comp : in std_logic_vector (1 downto 0);
        rst, clk : in std_logic;
        Psel, Qsel, CS  : out std_logic;
        St, Pld, Qld: out std_logic_vector (1 downto 0);
        ---debug : out integer;
        Mode_sub : out std_logic_vector (2 downto 0)
    );
end component;

component ParalelRegister2 is
	generic ( N: INTEGER := N);
    port (
        IN_REG          : in std_logic_vector (N - 1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N - 1 downto 0);

        clk             : in std_logic
    );
end  component;
		
component AdderSubtractor is
    generic ( N : INTEGER := N);
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

component multiplexer IS
	generic (N : INTEGER := N);
	PORT (  P, Q   : IN STD_LOGIC_VECTOR (N-1 downto 0) ;
			S, clk      : IN std_logic;
			f     : OUT STD_LOGIC_VECTOR (N-1 downto 0)
			);
end component;


signal pcontrol, qcontrol, comp, Status_out, St_Sub, ct_hasil : STD_LOGIC_VECTOR (1 downto 0);
signal muxp, muxq, preg, qreg, inP_Sub, inQ_Sub, Out_Sub, out_asli : STD_LOGIC_VECTOR (N-1 downto 0);
signal pmuxsel, qmuxsel, Smux2 : STD_LOGIC;
signal M_Sub : STD_LOGIC_VECTOR (2 downto 0);

begin 
    --control
    Control : fsm_fpb port map (P_in, Q_in, Mode, St_Sub, comp, rst, clk, pmuxsel, qmuxsel, Smux2, Status_out, pcontrol, qcontrol, M_Sub);
    --eheh
    p_mux : multiplexer port map (P_in, Out_Sub, pmuxsel, clk, muxp );
    q_mux : multiplexer port map (Q_in, Out_Sub, qmuxsel, clk, muxq);
    p_reg : ParalelRegister2  port map (muxp, pcontrol, preg, clk );
    q_reg : ParalelRegister2 port map (muxq, qcontrol, qreg, clk );
    O_comp : comparator port map (preg, qreg, rst,clk, comp); 
    p_mux2 : multiplexer port map (qreg, preg, Smux2,clk, inP_Sub);
    q_mux2 : multiplexer port map (preg, qreg, Smux2, clk, inQ_Sub);
    Subtractor : AdderSubtractor port map (inP_Sub, inQ_Sub, Out_Sub, M_Sub, St_Sub, clk, rst);
    OUT_FPB <= preg;
    St <= Status_out;
    --tesmux2 <= Smux2;
   -- tesoutsubtractor <= Out_Sub;
   -- tescomp <= comp;
   -- Pinputsub <= inP_Sub;
   -- Qinputsub <= inQ_Sub;
    --substatus <= St_Sub;
    

end FPB_arc;




