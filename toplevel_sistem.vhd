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
		--debug_mode : out std_logic_vector(2 downto 0);
		Sen				:out std_logic_vector (N-1 downto 0); 
		S				:out std_logic_vector (1 downto 0);
		--debug_int : out integer;
		--debug_st : out std_logic_vector(1 downto 0);
		--debug_mux1, debug_mux2 : out std_logic_vector(N-1 downto 0);
		rst 			: in std_logic
	);
end toplevel_sistem;

architecture sistem_arc of toplevel_sistem is

component kalkulator is 
    generic(N: INTEGER := 41);
    port(
        input_P, input_Q 	: in std_logic_vector (N - 1 downto 0);
        Mode 				: in  std_logic_vector(2 downto 0);
        status 				: out std_logic_vector(1 downto 0);
        hasil 				: out std_logic_vector(N-1 downto 0);
        clk   	            : in std_logic;
        rst        	        : in std_logic
    );
end component;

component AdderSubtractor
generic ( N : INTEGER := 41);
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

component Multiplication
    generic ( N: INTEGER := 41);
	port (
		P			: in std_logic_vector (N-1 downto 0) ;
		Q			: in std_logic_vector (N-1 downto 0) ;
		Mode		: in std_logic_vector (2 downto 0) ;
		Clk, Rst	: in std_logic ;
		Multi_Out	: out std_logic_vector (N-1 downto 0) ;
		Status_Out	: out std_logic_vector (1 downto 0)
		--debugout 	: out integer 
	);
	end component;

-- BENER?
signal P, Q : std_logic_vector (N-1 downto 0);
signal status : std_logic_vector (1 downto 0); 
signal reg_hasil : std_logic_vector (N-1 downto 0);

signal hasil_kalkulator : std_logic_vector (N-1 downto 0);
signal status_kalkulator : std_logic_vector (1 downto 0); 

signal hasil_adder : std_logic_vector (N-1 downto 0);
signal status_adder : std_logic_vector (1 downto 0); 


signal final_status : std_logic_vector (1 downto 0); 
signal final_send	: std_logic_vector (N-1 downto 0); 

signal low : std_logic := '0';

begin
	blokKalkulator : kalkulator port map (
		input_P		=> A, 
		input_Q 	=> B,
        Mode 		=> Mode,
        status 		=> status_kalkulator,
        hasil 		=> hasil_kalkulator,
        clk   	    => clk,
        rst        	=> rst
	); 

	addersubs : AdderSubtractor
    generic map (N=>N)
    port map (
		P_in            => A,
        Q_in            => B,

        OUT_Operasi     => hasil_adder,

        M               => Mode,
        status          => status_adder,

        clk             => clk,
        rst            => rst );

	
	process (clk, mode)
	begin
		if(mode = "001" or mode = "010") then
			Sen <= hasil_adder;
			S <= status_adder;
		else
			Sen <= hasil_kalkulator;
			S <= status_kalkulator;
		end if;
	
	end process;
	
end sistem_arc;