library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider is
    generic ( N : INTEGER := 11);
    port (
        P_in            : in std_logic_vector (N - 1 downto 0);
        Q_in            : in std_logic_vector (N - 1 downto 0);

        ---OUT_Operasi     : buffer std_logic_vector (N - 1 downto 0);
        out_operasi_fix : out std_logic_vector (N - 1 downto 0);

        M               : in std_logic_vector(2 downto 0);
        status          : out std_logic_vector(1 downto 0);

		debug_fsm : out std_logic_vector(3 downto 0);
		debug_m1, debug_m2 : out std_logic_vector (N-1 downto 0);
        clk             : in std_logic;
        rst             : in std_logic
    );
end divider;

architecture divider_component of divider is
    component dividerfsm is
        port (
            CT_IN, CT_R, SEN, R_Sel, SLOAD, OEN : out std_logic;
            SubtractON,add_ON                    : out std_logic_vector(2 downto 0);
            Status                              : out std_logic_vector(1 downto 0);
            
            debugfsm : out std_logic_vector(3 downto 0);
    
            M                   : in std_logic_vector(2 downto 0);
            SubtractorStatus, adder_st    : in std_logic_vector(1 downto 0);
            comp_res            : in std_logic;
            clk                 : in std_logic;
            reset               : in std_logic;
            shift_cek : in std_logic
        );
    end component;

    component ParalelRegister is
        generic ( N : INTEGER := N);
        port (
            IN_REG          : in std_logic_vector (N -1 downto 0);
            CT              : in std_logic;
            OUT_REG         : out std_logic_vector(N -1 downto 0);
    
            clk             : in std_logic
        );
    end component;

    component func_R is
        generic ( N : INTEGER := N);
        port (
            input_vector    : in std_logic_vector (N - 1 downto 0);
            output_result   : out std_logic_vector(N+N-3 downto 0)
            );
    end component;

    component func_S is
        generic ( N : INTEGER := N);
        port (
            input_vector            : in std_logic_vector (N - 1 downto 0);
            output_result : out std_logic_vector(N+N-3 downto 0)
            );
    end component;

    component mux21 IS
	generic ( N : INTEGER := N);
	PORT ( P, Q   		: IN STD_LOGIC_VECTOR (N-1 downto 0) ;
			S, clk      : IN std_logic;
			f      		: OUT STD_LOGIC_VECTOR (N-1 downto 0)
			);
    END component;

    component RegisterSerial is
        generic ( N : INTEGER := N);
        port (
            IN_REG          : in std_logic_vector (N - 1 downto 0);
            L, W, EN        : in std_logic;
    
            Q               : buffer std_logic_vector (N - 1 downto 0);
    
            clk             : in std_logic
        );
    end component;

    component comparatorreal is
        generic ( N: INTEGER := N);
        port ( P, Q : in std_logic_vector (N - 1 downto 0);
                rst, clk : in std_logic ;
                comp : out std_logic
                );
    end component;

    component RegisterSerialkekiri is
        generic ( N : INTEGER := N);
        port (
            IN_REG          : in std_logic_vector (N - 1 downto 0);
            L, W, EN        : in std_logic;
    
            Q               : buffer std_logic_vector (N - 1 downto 0);
    
            clk             : in std_logic
        );
    end component;

    component AdderSubtractor is
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
    
    component shift_checker is
		generic(N : INTEGER := N );
        port ( P, Q : in std_logic_vector (N - 1 downto 0);
                rst, clk : in std_logic ;
                comp : out std_logic
                );
    end component;
    
    component signed_transfer is
    Generic( N : INTEGER := N );
    port(input_vector : in std_logic_vector(N-1 downto 0);
         input_signed: in std_logic;
         --output_vector : buffer std_logic_vector (N-1 downto 0);
         output_fix : out std_logic_vector(N-1 downto 0)
    );
	end component;
	
	component signed_cheker is
     port(
        P,Q : in std_logic;
        hasil : out std_logic
    );
	end component;
	
	component get_Signed is
    generic(N : INTEGER := N);
    port(
        input_vector : in std_logic_vector( N-1 downto 0);
        hasil : out std_logic
    );
    end component;
    component transfer_m is
    generic(N: integer := N);
    port (
        input_vector            : in std_logic_vector (N+N - 3 downto 0);
        output_result : out std_logic_vector(N-1 downto 0)
        );
	end component;
    
    
	
    signal CT_IN, CT_R : std_logic;
    signal PtransferR, QtransferS, UnsignedP, unsignedQ, hasil_pembagian, hasil_modulo, modulo_41, hasil_modulo_p_negatif  : std_logic_vector (N-1 downto 0);
    signal inputR, inputS, SubtractRS, toRegisterR, Rout, Sout, modulo_80: std_logic_vector (N+N-3 downto 0);
    signal R_Sel, SLOAD, SEN, comp_res, OEN, signed_check : std_logic;
    signal shift_final : std_logic_vector (N+N-3 downto 0);
    signal shift_status, signedP, SignedQ : std_logic;
    signal buffer_sinyal_1, buffer_sinyal_2, buffer_sinyal_3,buffer_sinyal_4, OUT_operasi : std_logic_vector(N-1 downto 0);
    --Subtractor ALL SIGNAL HERE
    signal SubtractON, adder : std_logic_vector (2 downto 0);
    signal SubtractorStatus,add_st_m, status_fsm : std_logic_vector (1 downto 0);
    signal nol : std_logic_vector (n-1 downto 0) := (others => '0');
    signal Q_add : std_logic_vector (N-1 downto 0) :=  (others => '0');

begin

    FSMDivider : dividerfsm
    port map (CT_IN, CT_R, SEN, R_Sel, SLOAD, OEN, SubtractON, adder,status_fsm,debug_fsm, M, SubtractorStatus,add_st_m,comp_res, clk, rst, shift_status);
    
    --unsigned_P :signed_transfer
    --generic map (N => N)
    --port map (P_in, P_in(N-1),'1',buffer_sinyal_1, UnsignedP );
    
   -- unsigned_Q: signed_transfer
    --generic map (N => N)
    --port map(Q_in,Q_in(N-1),'1', buffer_sinyal_2, UnsignedQ);
    
    get_signed_p : get_signed
    generic map (N => N)
    port map (P_in, SignedP);
    
    get_signed_q : get_signed
    generic map (N => N)
    port map (Q_in, signedQ);
    
    signed_ceker :signed_cheker
    port map(P_in(N-1), Q_in(N-1), signed_check);
    
    RegisterP : ParalelRegister
    generic map (N => N)
    PORT MAP (P_in, CT_IN, PtransferR, clk);

    RegisterQ : ParalelRegister
    generic map (N => N)
    PORT MAP (Q_in, CT_IN, QtransferS, clk);
    
    transferPtoR : func_R
    generic map (N => N)
    port map (PtransferR, inputR);

    transferQtoS : func_S
    generic map (N => N)
    port map (QtransferS, inputS);
    
    transfershif : func_R
    generic map (N => N)
    port map(QtransferS, shift_final);

    RInputSelector : mux21
    generic map (N => N+N-2)
    port map (inputR, SubtractRS, R_Sel, clk, toRegisterR);

    RegisterR : ParalelRegister
    generic map (N => N+N-2)
    port map (toRegisterR, CT_R, Rout, clk);
    
    RegisterM : ParalelRegister
    generic map (N => N+N-2)
    PORT MAP (SubtractRS, CT_IN, modulo_80, clk);
    
    transfer_modulo : Transfer_M
    generic map (N => N)
    port map (modulo_80, modulo_41);

    RegisterSerialS : RegisterSerial
    generic map (N => N+N-2)
    port map (inputS, SLOAD, '0', SEN, Sout, clk);

    ComparatorRS : comparatorreal
    generic map (N=> N+N-2)
    port map (Rout, Sout, rst, clk, comp_res);

    RegisterOutput : RegisterSerialkekiri
    generic map (N => N)
    port map (nol, '0', comp_res, OEN, OUT_Operasi, clk);
    
    shift_cek : shift_checker
    generic map (N => N+N-2)
    port map(shift_final, Sout, rst, clk, shift_status);

    Subtractor : AdderSubtractor
    generic map (N=>N+N-2)
    port map (Rout, Sout, SubtractRS, SubtractON, SubtractorStatus, clk, rst);
    
    hasil_divider : signed_transfer
    generic map (N => N)
    port map (OUT_operasi, signed_check, Hasil_pembagian);
    hasil_mod : signed_transfer
    generic map (N => N)
    port map (modulo_41, P_in(n-1), hasil_modulo);
    Process(Q_add, Q_in)
	begin 
		Q_add(n-1) <= '0';
		Q_add(N-2 downto 0) <= Q_in(N-2 downto 0);
	end process;
    
    hasil_mod_fix : AdderSubtractor
    generic map (N => N)
    port map (hasil_modulo, Q_add,hasil_modulo_p_negatif,adder, add_st_m, clk, rst );
    
    process(M)
    begin
		If M = "101" then
			if P_in(n-1) = '0' then
				out_operasi_fix <= modulo_41;
				status <= status_fsm;
			else 
				out_operasi_fix <= hasil_modulo_p_negatif;
				status <= status_fsm;
			end if;
		else
			out_operasi_fix <= hasil_pembagian;
			status <= status_fsm;
		end if;
	end process;
end divider_component;