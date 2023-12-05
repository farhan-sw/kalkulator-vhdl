library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Multiplication is 
	generic ( N: INTEGER := 41);
	port (
		P			: in std_logic_vector (N-1 downto 0) ;
		Q			: in std_logic_vector (N-1 downto 0) ;
		Mode		: in std_logic_vector (2 downto 0) ;
		Clk, Rst	: in std_logic ;
		Multi_Out	: out std_logic_vector (N-1 downto 0) ;
		Status_Out	: out std_logic_vector (1 downto 0) ;
		debugout 	: out integer 
	);
end Multiplication;

architecture Multi_arc of Multiplication is 

component ParalelRegister2 is
	generic ( N: INTEGER := N);
    port (
        IN_REG          : in std_logic_vector (N - 1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N - 1 downto 0);

        clk             : in std_logic
    );
end  component;

component ParalelRegisterQ is
    generic ( N : INTEGER := N );
    port (
        IN_REG          : in std_logic_vector (N -1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N -1 downto 0);
        QLSB 			: out std_logic;

        clk             : in std_logic
    );
end component;

component AdderSubtractor_M is
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

component FSM_Multi is 
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
		EnOutFinal		: out std_logic ;
		signout			: out std_logic ;
		debug			: out integer
	);
end component ;

component arsShifter is
	generic (N : INTEGER := N);
    port (
        A                   : in std_logic_vector (N-1 downto 0);
        Q					: in std_logic_vector (N-1 downto 0) ;
        En					: in std_logic ;
        clk					: in std_logic ;
        Aout				: out std_logic_vector (N-1 downto 0) ;
        Qout				: out std_logic_vector (N-1 downto 0) ;
        Qprev				: out std_logic  
        );
end component ;

component outFinal is 
	generic (N : Integer := N) ;
	port (
		Aout			: in std_logic_vector (N-1 downto 0) ;
		Qout			: in std_logic_vector (N-1 downto 0) ;
		signout			: in std_logic;
		clk, En			: in std_logic ;
		finalOut		: out std_logic_vector (N-1 downto 0) ;
		Status			: out std_logic_vector (1 downto 0)
	);
end component;

component MSB is 
	generic ( N : INTEGER := N);
	port (
	input		: in std_logic_vector (N-1 downto 0);
	output		: out std_logic_vector (N - 1 downto 0);
	outmsb		: out std_logic;
	clk			: in std_logic
	);
end component;

component S2Comp is
    generic ( N : INTEGER := N);
    port (
        IN_COMP          : in std_logic_vector (N-1 downto 0);
        OUT_COMP          : buffer std_logic_vector (N-1 downto 0);

        clk             : in std_logic
    );
end component;

signal St_Add, Ct_P, Ct_Q, Ct_Acc, StatusOutFinal, Ct_comp : std_logic_vector (1 downto 0) ;
signal AddSub_Out, Ars_Out, Out_Mux_Acc, Out_Mux_RegQ, Out_RegP, Out_RegQ, Acc_Out, Qrs_Out, Out_Final, posP, posQ, compP, out_comp, InP_Add : std_logic_vector (N-1 downto 0) ;
signal Qprev, QLSB, selectorQ, selectorAcc, En_Ars, EnOutFinal, PMSB, QMSB, signout, selectorP : std_logic ;
signal Mode_Add: std_logic_vector (2 downto 0);
signal debug : Integer ;

begin
	control : FSM_Multi port map (Mode, St_Add,QMSB, PMSB, Qprev, QLSB, clk, rst, selectorQ, selectorP , selectorAcc, Mode_Add, En_Ars, Ct_P, Ct_Q,Ct_Acc, Ct_comp, EnOutFinal, signout, debug);
	MSBP	: MSB port map (P, posP, PMSB, clk);
	MSBQ	: MSB port map (Q, posQ, QMSB, clk);
	reg_p 	: ParalelRegister2 port map (PosP, Ct_P, Out_RegP, clk) ;
	MuxRegQ : multiplexer port map (posQ, Qrs_Out, selectorQ, clk, Out_Mux_RegQ) ;
	reg_q 	: ParalelRegisterQ port map (Out_Mux_RegQ , Ct_Q, Out_RegQ, QLSB, clk) ;
	AddSub 	: AdderSubtractor_m port map (Ars_Out, Out_RegP, AddSub_Out, Mode_Add, St_Add, clk, rst) ;
	MuxAcc 	: multiplexer port map (Ars_Out, AddSub_Out, selectorAcc, clk, Out_Mux_Acc) ;
	Acc		: ParalelRegister2 port map (Out_Mux_Acc, Ct_Acc, Acc_out, clk) ;
	ArsShift: arsShifter port map (Acc_Out, Out_RegQ, En_Ars, clk, Ars_Out, Qrs_Out, Qprev) ;
	OutputFinal : outFinal port map (Ars_Out, Qrs_Out,signout, clk, EnOutFinal, Out_Final, StatusOutFinal);
	Multi_Out <= Out_Final;
	Status_Out <= StatusOutFinal;
	debugout <= debug;
end Multi_arc;