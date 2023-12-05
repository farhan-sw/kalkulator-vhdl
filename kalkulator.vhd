library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity kalkulator is 
    generic(N: INTEGER := 41);
    port(
        input_P, input_Q : in std_logic_vector (N - 1 downto 0);
        Mode : in  std_logic_vector(2 downto 0);
        status : out std_logic_vector(1 downto 0);
        hasil : out std_logic_vector(N-1 downto 0);
        clk             : in std_logic;
        rst             : in std_logic
    );
end kalkulator;

architecture behavorial of kalkulator is
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
    
    component FPB
	generic ( N: INTEGER := N);
	port (
		P_in, Q_in : IN STD_LOGIC_VECTOR (N-1 downto 0);
		Mode : IN STD_LOGIC_VECTOR (2 downto 0);
		St : OUT STD_LOGIC_VECTOR (1 downto 0); 
		OUT_FPB: OUT STD_LOGIC_VECTOR (N-1 downto 0); 
        clk, rst : IN STD_LOGIC );
        --tesmux2 : out std_logic;
        --tesoutsubtractor, Pinputsub, Qinputsub : out std_logic_vector (N-1 downto 0);
        
       -- debug : out integer;
        
		--tescomp, substatus : out std_logic_vector (1 downto 0)
    
	--);
	end component;
	
	--component modulo 
   -- generic (N : INTEGER := 41);
    --port(
    --    Pin, Qin : in std_logic_vector (N-1 downto 0);
   --     mode : in std_logic_vector (2 downto 0 );
    --    OUT_Operasi : out std_logic_vector (N-1 downto 0);
     --   status_out : out std_logic_vector (1 downto 0);
     --   clk : in std_logic

    --);
	--end component;
	
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
	
	--component Pangkat
    --generic ( N: INTEGER := 41); 
	--port ( 
	--	P_in   	    : in std_logic_vector (N-1 downto 0); 
	--	Q_in        : in std_logic_vector (N-1 downto 0); 
	--	Mode        : in std_logic_vector (2 downto 0); 

     --   clk         : in std_logic; 
       -- rst         : in std_logic; 

		--out_pangkat : out std_logic_vector (N-1 downto 0);  
		--status      : out std_logic_vector (1 downto 0)  
	--); 
	--end component; 

	

    signal output_S, output_D, output_F, output_P, output_pangkat  : std_logic_vector(N-1 downto 0);
    signal st_S,st_D,st_F, st_P, st_pangkat : std_logic_vector(1 downto 0);
    signal debug_fsm :  std_logic_vector(3 downto 0);
	signal debug_logic :  std_logic;
begin
    addersubs : AdderSubtractor
    generic map (N=>N)
    port map (input_P, input_Q, output_S, Mode, st_S, clk, rst);

    pembagian : divider
    generic map (N => N)
    port map (input_P, input_Q, output_D, Mode, st_D, clk, rst);
    
    FPBB : FPB
    generic map (N => N)
    port map(input_P,input_Q, Mode, st_F, output_F,clk, rst);
    
   -- modd : modulo
   -- generic map (N => N)
    --port map (input_P, input_Q, mode, output_M, st_M, clk );
    
    perkalian : Multiplication
    generic map (N => N)
    port map(input_P, input_Q, mode, clk, rst, output_P, st_P);
    
   --pangkat_coy : pangkat
  -- generic map (N => N)
  -- port map (input_p, input_Q, mode, clk, rst,output_pangkat, st_pangkat );
    
    
		process(Mode)
        begin
		if Mode = "010" or MODe = "001" then
            hasil <= output_S;
            status <= st_s;
        elsif Mode = "100" or Mode = "101" then
             hasil <= output_D;
             status <= st_D;
        elsif Mode = "111" then
             hasil <= output_F;
             status <= st_F;
        --elsif Mode = "101" then
          --   hasil <= output_M;
          --   status <= st_M;
        elsif Mode = "011" then
             hasil <= output_P;
             status <= st_P;
        --elsif mode = "110" then
		--	hasil <= output_pangkat;
			--status <= st_pangkat;
        else
            hasil <= (others => '0');
            status <= "00";
        end if;
        end process;
end behavorial;