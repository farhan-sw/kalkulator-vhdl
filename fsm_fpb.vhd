library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fsm_fpb is 
    generic (N: INTEGER := 6);
    port (
        P, Q   : in std_logic_vector (N-1 downto 0);
        M    : in std_logic_vector (2 downto 0);
        St_Sub , comp : in std_logic_vector (1 downto 0);
        rst, clk : in std_logic;
        Psel, Qsel, CS  : out std_logic;
        St, Pld, Qld : out std_logic_vector (1 downto 0);
        --debug : out integer;
        Mode_sub : out std_logic_vector (2 downto 0)
    );
end fsm_fpb;

architecture fsm_fpb_arc of fsm_fpb is
    type states is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
    signal cstate, nstate : states;

begin 
    process (rst, clk, M)
    begin
        if (rst = '1' or M /= "111") then 
            cstate <= s0;
        elsif (clk'event and clk = '1') then
            cstate <= nstate;
        end if;
    end process;

    process (M, P, Q, St_Sub , comp, cstate, nstate)
    begin
    
    case cstate is 
    when s0 =>
        if (M = "111") then 
            nstate <= s1; 
        else 
            nstate <= s0;
        end if;
        
        Psel <= '0';
        Qsel <= '0';
        Pld <= "00";
        Qld <= "00"; 
        CS <= '0';
        St <= "00";
        Mode_sub <= "000";
        
    when s1 => --cek apakah ada bilangan negatif
        if (P(N-1) /= '1' and Q(N-1) /= '1' and P /= 0 and Q /= 0 ) then 
            nstate <= s2;
            St <= "00"; 
        else 

            St <= "10";       
            if (M = "111") then 
				nstate <= s1 ;
			else 
				nstate <= s0;
			end if; 
			
        end if;
        
        Psel <= '0';
        Qsel <= '0';
        Pld <= "00";
        Qld <= "00"; 
        CS <= '0';
        Mode_sub <= "000";
        
        --debug <= 1;
    when s2 =>  -- mulai operasi
        Psel <= '0';
        Qsel <= '0';
        Pld <= "00";
        Qld <= "00"; 
        CS <= '0';
        St <= "00";
        Mode_sub <= "000";
        nstate <= s3;
        --debug <= 2;
    when s3 => --isi reg
        Psel <= '0';
        Qsel <= '0';
        Pld <= "10";
        Qld <= "10"; 
        CS <= '0';
        St <= "00";
        Mode_sub <= "000";
        nstate <= s4;
       -- debug <= 3;
    when s4 => --keluar reg
        Psel <= '0';
        Qsel <= '0';
        Pld <= "01";
        Qld <= "01"; 
        CS <= '0';
        St <= "00";
        Mode_sub <= "000";
        nstate <= s5;
        --debug <= 4;
    when s5 => --komparasi
        Psel <= '0';
        Qsel <= '0';
        Pld <= "01";
        Qld <= "01"; 
        CS <= '0';
        St <= "00";
        Mode_sub <= "000";
        if (comp = "10") then 
            nstate <= s6;
        elsif (comp = "01") then
            nstate <= s8;
        elsif (comp = "11") then
			nstate <= s10;  
		elsif (comp = "00") then 
			nstate <= s5;
        end if;   
       -- debug <= 5;
    when s6 => --mux utk input pengurangan
        Psel <= '0';
        Qsel <= '0';
        Pld <= "01";
        Qld <= "01"; 
        CS <= '1';
        St <= "00";
        Mode_sub <= "000";
        nstate <= s7;
       -- debug <= 6;
        
    when s7 => --tunggu hasil pengurangan
        Psel <= '1';
        Qsel <= '0';
        Pld <= "10";
        Qld <= "01"; 
        CS <= '1';
        St <= "00";
        Mode_sub <= "010";
        if (St_Sub = "11" or St_Sub = "10") then 
			nstate <= s4;
		else 
			nstate <= s7;
		end if;
		--debug <= 7;
			
    when s8 => -- mux utk input pengurangan 
        Psel <= '0';
        Qsel <= '0';
        Pld <= "01";
        Qld <= "01"; 
        CS <= '0';
        St <= "00";
        Mode_sub <= "000";
        nstate <= s9;
       -- debug <= 8;
        
    when s9 =>
        Psel <= '0';
        Qsel <= '1';
        Pld <= "01";
        Qld <= "10"; 
        CS <= '1';
        St <= "00";
        Mode_sub <= "010";
        if (St_Sub = "11") then 
            nstate <= s4 ;
        else 
            nstate <= s9;
        end if;
        --debug <= 9;
        
    when s10 =>
        Psel <= '0';
        Qsel <= '0';
        Pld <= "01";
        Qld <= "01"; 
        CS <= '1';
        St <= "11";
        Mode_sub <= "000" ;
        
        if (M = "111") then 
            nstate <= s10 ;
        else 
            nstate <= s0;
        end if;
        
        --debug <= 10;
        
    end case;
    end process;
end fsm_fpb_arc;
    

        
             
