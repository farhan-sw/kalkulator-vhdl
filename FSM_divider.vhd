library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity FSM_divider is 
    port (
        M               : in std_logic_vector(2 downto 0);
        Comp            : in std_logic;
        Sdone           : in std_logic_vector(1 downto 0);
        clk             : in std_logic;
        LP,LQ,LR,LS : out std_logic;
        st : out std_logic_vector(1 downto 0);
        sub : out std_logic_vector(2 downto 0);
        output : out std_logic;
        INEN, REN, SEN, OEN : out std_logic;
        SelR, SelS : out std_logic;
		debug : out std_logic_vector(3 downto 0);
		counter : out std_logic_vector(6 downto 0)
    );
end FSM_divider;

architecture FSM_divider_arc of FSM_Divider is
    type states is (s1,s2,s3,s4,s5,s6,s7,s8,sEND);
    signal cState, nState: states;
    signal count, scount: std_logic_vector (6 downto 0);
    signal rst, rst_c, rst_s , adding_scount : std_logic; 
begin 
    process
	begin
		wait until (rising_edge(clk));
		if rst = '1' then
			cState <= s1;
			count <= "0000000";
		else
			cState <= nState;
            if rst_c = '0' then
			    count <= count + 1;
            end if;
		end if;
		if rst_c = '1' then
			count <= "0000000";
		end if;
		if rst_s = '1' then
			scount <= "0000000";
		end if;
        if adding_scount = '1' then -- buat nambahin scountnya
            scount <= scount + 1;
        end if;	
	end process;
    process(M,Comp,Sdone,cState,clk, count)
        begin  
            if (M /= "100") then
                nState <= s1;
            else
                Case cState is -- buat perpindahan statenya dulu
                    when s1 =>
                        if M = "100" then
                            nState <= s2;
                        else
                            nState <= s1;
                        end if;
                    when s2 => 
                            nState <= s3;
							rst_c <= '1';
							rst_s <= '1';
                            --count <= "0000000"; -- buat reset counternya ke 0, soalnya dari awal counternya dah nambah setiap clk
                    when s3 =>
							rst_c <= '0';
							rst_s <= '0';
                            if count < "0101000" then
                                nstate <= s3;
                            else 
                                nState <= s4;
                            end if;
                          
                    when s4 =>
                            if count > "0101000" and count < "1010000" then
                                nState <= s4;
                            else
                                rst_c <= '1';
                                nState <= s5;
                            end if;
                            rst_s <= '1'; 
                    when s5 => 
                            adding_scount <= '1';
							rst_c <= '0';
							rst_s <= '0';
                            if Comp = '0' then
                                nState <= s8;
                            elsif Comp = '1' then
                                nState <= s6;
                            end if;
						
                            --count <= "0000000"; -- buat reset counternya ke 0, soalnya dari awal counternya dah nambah setiap clk
                    when s6 =>
							adding_scount <= '0';
                            if Sdone = "11" then
                                nState <= s7;
                            else
                                nState <= S6;
                            end if;
                    when s7 =>
                            if scount < "0101000" then
                                nState <= s5;
                            elsif scount = "0101000" then
                                nState <= sEND;
                            end if;
                    when s8 => 
                            if count < "0101000" then
                                nState <= s5;
                            elsif count = "0101000" then
                                nState <= sEND;
                            end if;
                    when sEND => 
							nState <= s1;
                end case;
            end if;
    end process;
    process (clk) -- ini buat outputnyaa
        begin 
        if (rising_edge(clk)) then
            case Cstate is
                when s1 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '0';
                    St <= "00";
                    sub <= "000";
                    output <= '0';
                    INEN <= '0';
                    REN <= '0';
                    SEN <= '0';
                    OEN <= '0';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "0001";
					counter <= scount;
                when s2 =>
                    LP <= '1';
                    LQ <= '1';
                    LR <= '0';
                    LS <= '0';
                    St <= "00";
                    sub <= "000";
                    output <= '0';
                    INEN <= '1';
                    REN <= '0';
                    SEN <= '0';
                    OEN <= '0';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "0010";
					counter <= scount;
                when s3 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '0';
                    St <= "00";
                    sub <= "000";
                    output <= '0';
                    INEN <= '0';
                    REN <= '1';
                    SEN <= '0';
                    OEN <= '0';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "0011";
					counter <= scount;
                when s4 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '1';
                    St <= "00";
                    sub <= "000";
                    output <= '0';
                    INEN <= '0';
                    REN <= '1';
                    SEN <= '1';
                    OEN <= '0';
                    SelR <= '1';
                    SelS <= '0';
					debug <= "0100";
					counter <= scount;
                when s5 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '0';
                    St <= "00";
                    sub <= "000";
                    output <= '0';
                    INEN <= '0';
                    REN <= '0';
                    SEN <= '1';
                    OEN <= '0';
                    SelR <= '0';
                    SelS <= '1';
					debug <= "0101";
					counter <= scount;
                when s6 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '0';
                    St <= "00";
                    sub <= "010";
                    output <= '0';
                    INEN <= '0';
                    REN <= '0';
                    SEN <= '0';
                    OEN <= '0';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "0110";
					counter <= scount;
                when s7 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '1';
                    LS <= '0';
                    St <= "00";
                    sub <= "000";
                    output <= '1';
                    INEN <= '0';
                    REN <= '1';
                    SEN <= '0';
                    OEN <= '1';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "0111";
					counter <= scount;
                when s8 =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '0';
                    St <= "00";
                    sub <= "000";
                    output <= '0';
                    INEN <= '0';
                    REN <= '0';
                    SEN <= '0';
                    OEN <= '1';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "1000";
					counter <= scount;
                when sEND =>
                    LP <= '0';
                    LQ <= '0';
                    LR <= '0';
                    LS <= '0';
                    St <= "11";
                    sub <= "000";
                    output <= '0';
                    INEN <= '0';
                    REN <= '0';
                    SEN <= '0';
                    OEN <= '0';
                    SelR <= '0';
                    SelS <= '0';
					debug <= "1001";
					counter <= scount;
            end case;
        end if;
    end process;
end FSM_Divider_arc;
                    
                    

