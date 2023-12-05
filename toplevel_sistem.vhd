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

-- BENER? 

signal low : std_logic := '0';

begin
	blokKalkulator : KalkulatorTopLevel port map (
		P			=> A,
		Q			=> B,
		M 			=> Mode,
		CLK 		=> clk,
		RST			=> rst,
		OUT_OPERASI	=> Sen,
		STATUS 		=> S
	); 
	
end sistem_arc;