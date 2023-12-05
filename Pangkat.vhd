library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
use work.all; 

entity Pangkat is  
	generic ( N: INTEGER := 41); 
	port ( 
		P_in   	      : in std_logic_vector (N-1 downto 0); 
		Q_in          : in std_logic_vector (N-1 downto 0); 
		Mode          : in std_logic_vector (2 downto 0); 

        clk           : in std_logic; 
        rst           : in std_logic; 

		out_pangkat   : out std_logic_vector (N-1 downto 0);  
		status        : out std_logic_vector (1 downto 0);  

        debug_pangkat : out integer 
	); 
end Pangkat; 

architecture Pangkat_arc of Pangkat is  

component ParalelRegister2 is 
    generic ( N : INTEGER := 41);
    port (
        IN_REG          : in std_logic_vector (N -1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N -1 downto 0);

        clk             : in std_logic
    );
end component; 

component Multiplication is 
    generic ( N : INTEGER := 41); 
    port ( 
		P			: in std_logic_vector (N-1 downto 0) ;
		Q			: in std_logic_vector (N-1 downto 0) ;
		Mode		: in std_logic_vector (2 downto 0) ;
		Clk, Rst	: in std_logic ;
		Multi_Out	: out std_logic_vector (N-1 downto 0) ;
		Status_Out	: out std_logic_vector (1 downto 0) ;
		debugout 	: out integer 
    ); 
end component; 

component pangkatFSM is 
    generic ( N : INTEGER := 41); 
    port ( 
		statP    : in std_logic_vector (1 downto 0);
		counter  : in std_logic_vector (N-1 downto 0);
		mode 	 : in std_logic_vector (2 downto 0);
        clk      : in std_logic;
        rst      : in std_logic;
        modeOut  : out std_logic_vector (2 downto 0);
		ctP1 	 : out std_logic_vector (1 downto 0);
		ctP2	 : out std_logic_vector (1 downto 0);
		stat 	 : out std_logic_vector (1 downto 0);
		selector : out std_logic;
		debug    : out integer
    ); 
end component; 

component multiplexer is
	generic ( N : integer := 41);
	PORT (  P, Q   		: in std_logic_vector (N-1 downto 0) ;
			S, clk      : in std_logic;
			f     		: out std_logic_vector (N-1 downto 0)
			);
end component;

signal controlP1, controlP2, Status_Out, stat : std_logic_vector (1 downto 0); 
signal outRegP1, outRegP2, Multi_Out, outMux : std_logic_vector (N-1 downto 0);
signal modeOut : std_logic_vector (2 downto 0);
signal selector : std_logic;
signal debugout,debug, debug_multip : integer;

begin 
	reg_P1 	   : ParalelRegister2 port map (outMux, controlP1, outRegP1, clk); 
	reg_P2 	   : ParalelRegister2 port map (P_in, controlP2, outRegP2, clk); 
	mux21	   : multiplexer port map (P_in, Multi_out, selector, clk, outMux);
	fsmPangkat : pangkatFSM port map (Status_Out,Q_in, mode, clk, rst, modeOut, controlP1, controlP2, stat, selector, debug);
	multiply   : Multiplication port map (outRegP1, outRegP2, modeOut, clk, rst, Multi_out, Status_Out, debugout);
	
	process (P_in, Q_in)
		begin
		if ((Q_in = 0 and P_in /= 0) or P_in = 1) then
			out_pangkat <= "00000000000000000000000000000000000000001";
			status <= "11";
		elsif (Q_in (n-1) = '1' and P_in /= 1) then
			out_pangkat <= "00000000000000000000000000000000000000000";
			status <= "11";
		elsif (Q_in = 0 and P_in = 0) then
			status <= "10";
			out_pangkat <= "00000000000000000000000000000000000000000";
		else 
			out_pangkat <= outRegP1;
			status <= stat;
		end if;
	end process;
	debug_pangkat <= debug;
	

end Pangkat_arc;
