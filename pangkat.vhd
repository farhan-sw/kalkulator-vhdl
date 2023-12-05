library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
use work.all; 

entity Pangkat is  
	generic ( N: INTEGER := 41); 
	port ( 
		P_in   	    : in std_logic_vector (N-1 downto 0); 
		Q_in        : in std_logic_vector (N-1 downto 0); 
		Mode        : in std_logic_vector (2 downto 0); 

        clk         : in std_logic; 
        rst         : in std_logic; 

		out_pangkat : out std_logic_vector (N-1 downto 0);  
		status      : out std_logic_vector (1 downto 0)  
	); 
end Pangkat; 

architecture Pangkat_arc of Pangkat is  

component ParalelRegister2 is 
    generic ( N : INTEGER := 41 ); 
    port ( 
        IN_REG          : in std_logic_vector (N -1 downto 0); 
        CT              : in std_logic_vector(1 downto 0); 
        OUT_REG         : out std_logic_vector(N -1 downto 0); 
        clk             : in std_logic 
    ); 
end component; 

component Multiplication is 
    generic ( N : INTEGER := 41 ); 
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

component FSM_Pangkat is 
    generic ( N : INTEGER := 41 ); 
    port ( 
		statP    : in std_logic_vector (1 downto 0);
		pangkat  : in std_logic_vector (N-1 downto 0);
		mode 	 : in std_logic_vector (2 downto 0);
        clk      : in std_logic;
        rst      : in std_logic;
        modeOut  : out std_logic_vector (2 downto 0);
		ctP 	 : out std_logic_vector (1 downto 0);
		ctQ, ctM 	 : out std_logic_vector (1 downto 0);
		stat 	 : out std_logic_vector (1 downto 0);
		selector : out std_logic;
		debug : out integer
    ); 

end component; 

component multiplexer is
	generic ( N : integer := 41);
	PORT (  P, Q   		: in std_logic_vector (N-1 downto 0) ;
			S, clk      : in std_logic;
			f     		: out std_logic_vector (N-1 downto 0)
			);
end component;

component signed_transfer is
    Generic( N : INTEGER := N );
    port(input_vector : in std_logic_vector(N-1 downto 0);
         input_signed, EN: in std_logic;
         output_vector : buffer std_logic_vector (N-1 downto 0);
         output_fix : out std_logic_vector(N-1 downto 0)
    );
	end component;
	component divider
    generic ( N : INTEGER := 41);
    port (
        P_in            : in std_logic_vector (N - 1 downto 0);
        Q_in            : in std_logic_vector (N - 1 downto 0);

        ---OUT_Operasi     : buffer std_logic_vector (N - 1 downto 0);
        out_operasi_fix : out std_logic_vector (N - 1 downto 0);

        M               : in std_logic_vector(2 downto 0);
        status          : out std_logic_vector(1 downto 0);

		--debug_fsm : out std_logic_vector(3 downto 0);
		--debug_logic : out std_logic;
        clk             : in std_logic;
        rst             : in std_logic
        );
    end component;


signal controlP, controlQ, ctP, ctQ,ctM, status_Out, stat, st_m : std_logic_vector (1 downto 0); 
signal pengkali, hasilSementara, outRegP, outRegQ, Multi_Out, outMux, out_reg_m, unsigned_p, buffer_P,buffer_hasil, hasil, out_modulo : std_logic_vector (N-1 downto 0);
signal modeOut : std_logic_vector (2 downto 0);
signal selector, signed_cek : std_logic;
signal debug_out , debugout: integer;
signal dua : std_logic_vector (N-1 downto 0) := "00000000000000000000000000000000000000010";
signal satu : std_logic_vector (N-1 downto 0) := "00000000000000000000000000000000000000001";
signal nol : std_logic_vector (N-1 downto 0) := "00000000000000000000000000000000000000000";

begin 
	unsig_P : signed_transfer port map (P_In, P_in(N-1),'1',buffer_P, unsigned_P); --ini tadinya buat ngakalin kalo input P negatif, dijadiin positif terus hasilnya berdasarkan pangkat dan signednya
	pengkali <= unsigned_p;
	--cek_signed : divider port map (Q_in, dua, out_modulo,"101",st_m, clk, rst  );
--smPangkat : FSM_Pangkat port map (Status_Out,outRegQ, mode, clk, rst, modeOut, ctP, ctQ, stat,selector, debug);
	req_P 	   : ParalelRegister2 port map (unsigned_p, ctP, outRegP, clk); 
	req_Q 	   : ParalelRegister2 port map (Q_in, ctQ, outRegQ, clk); 
	reg_M 		: ParalelRegister2 port map (Outmux, ctM, out_reg_M, clk); 
	mux21	   : multiplexer port map (outRegP, Multi_out, selector, clk, outMux);
	fsmPangkat : FSM_Pangkat port map (status_out, outRegQ,mode, clk, rst, modeOut, ctP, ctQ,ctM, stat, selector);
	multiply   : Multiplication port map (pengkali, out_reg_M, modeOut, clk, rst, Multi_Out, Status_Out, debugout);
	hasil_fix : signed_transfer port map(multi_out,out_modulo(0),'1', buffer_hasil, hasil );
	--hasilSementara <= Multi_Out;
	--debug_mux <= outMUX;
	--debug_P <= pengkali;
	--debug_input1M <= out_reg_M;
	--debug_input2M <= pengkali;
	--debug_mux <= multi_out;
--	debug <= debug_out;
	process(Q_in, P_in)
		begin
		--if(signed(Q_In) < 0 then)
		--	if()
			
		if (P_in = nol) then
			out_pangkat <= nol;
			status <= "11";
		elsif (Q_in = satu) then
			out_pangkat <= P_in;
			status <= "11";
		elsif (signed(Q_in) < 0) then
			if P_in = satu then
				out_pangkat <= satu;
				status <= "11";
			else
				out_pangkat <= nol;
				status <= "10";
			end if;
		elsif (P_in = satu) then
			out_Pangkat <= satu;
			status <= "11";
		elsif (Q_in = nol) then
			out_pangkat <= satu;
			status <= "11";
		else
			if(p_in(n-1)) = '1' then
				out_pangkat <= hasil;
				status <= "10";
			else
				out_pangkat <= multi_out;
				status <= stat;
			end if;
			status <= stat;
		end if;
	end process;
end Pangkat_arc;