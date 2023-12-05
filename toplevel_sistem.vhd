library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity toplevel_sistem is 
	generic ( N : integer := 41 );
	port (
		A				:in std_logic_vector (N-1 downto 0);
		B				:in std_logic_vector (N-1 downto 0);
		R				:in std_logic;
		isPS			:in std_logic;
		isQS			:in std_logic;
		Mode			:in std_logic_vector (2 downto 0);
		clk				:in std_logic;

		Sen				:out std_logic_vector (N-1 downto 0); 
		S				:out std_logic_vector (1 downto 0);

		rst 			: in std_logic
	);
end toplevel_sistem;

architecture sistem_arc of toplevel_sistem is

component KalkulatorTopLevel is 
    generic(N: INTEGER := 41);
    port(
        P, Q		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		M 			: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		CLK 		: IN STD_LOGIC;
		RST			: IN STD_LOGIC;
		OUT_OPERASI	: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		STATUS 		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
end component;

component ParalelRegister2 is
    generic ( N : INTEGER := 41 );
    port (
        IN_REG          : in std_logic_vector (N -1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N -1 downto 0);

        clk             : in std_logic
    );
end component ;

component fsm_toplevel is 
	port (
		Mode 			: in std_logic_vector (2 downto 0);
		R 				: in std_logic;
		isPS			: in std_logic;
		isQS			: in std_logic;
		Statusoperasi 	: in std_logic_vector (1 downto 0);
		CS		: out std_logic_vector (1 downto 0);
		MP, MQ 			: out std_logic;
		Mode_kalku		: out std_logic_vector (2 downto 0);
		S				: out std_logic_vector (1 downto 0);
		rst				: out std_logic ;
		--debug : out Integer ; 
		clk				: in std_logic
	);
end component;

component multiplexer IS
	generic ( N : INTEGER := 41);
	PORT (  P, Q   : IN STD_LOGIC_VECTOR (N-1 downto 0) ;
			S, clk      : IN std_logic;
			f     : OUT STD_LOGIC_VECTOR (N-1 downto 0)
			);
END component;

signal Ct_RegS, Ct_RegA, Ct_RegB, statusSend, StOutKalku : std_logic_vector (1 downto 0);
signal out_S, regSout, out_muxP, out_muxQ : std_logic_vector (N-1 downto 0);
signal SMuxP, SMuxQ : std_logic ;
signal ModeKalku : std_logic_vector (2 downto 0) ;

signal OUT_ADDER :  std_logic_vector (N-1 downto 0);
signal STATUS_ADDER: std_logic_vector (1 downto 0) ;

signal OUT_NON_ADDER :  std_logic_vector (N-1 downto 0);
signal STATUS_NON_ADDER: std_logic_vector (1 downto 0) ;

signal low : std_logic := '0';

begin
	control : fsm_toplevel port map (Mode, R, isPS, isQS, StOutKalku, Ct_RegS, SMuxP, SMuxQ, ModeKalku, STATUS_ADDER, low,clk);
	reg_S : ParalelRegister2 port map (out_S, Ct_RegS, OUT_ADDER, clk) ;
	MuxP : multiplexer port map (A, out_s, SMuxP, clk, out_muxP) ;
	MuxQ : multiplexer port map (B, out_S, SmuxQ, clk, out_muxQ) ;

	blokKalkulator : KalkulatorTopLevel port map (out_muxP, out_muxQ, ModeKalku,clk, low, out_S, StOutKalku); 

	blokKalkulatorNonAdder : KalkulatorTopLevel port map (
		P			=> A,
		Q			=> B,
		M 			=> Mode,
		CLK 		=> clk,
		RST			=> rst,
		OUT_OPERASI	=> OUT_NON_ADDER,
		STATUS 		=> STATUS_NON_ADDER
	); 

	process(clk, Mode)
	begin
		IF (Mode = "001" or Mode = "010") then
			Sen <= OUT_ADDER;
			S <=STATUS_ADDER;
		
		else
			Sen <= OUT_NON_ADDER;
			S <=STATUS_NON_ADDER;
			
		end if;
		 
	end process;

	
end sistem_arc;