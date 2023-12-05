library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ParalelRegisterQ is
    generic ( N : INTEGER := 4 );
    port (
        IN_REG          : in std_logic_vector (N -1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N -1 downto 0);
        QLSB 			: out std_logic;

        clk             : in std_logic
    );
end ParalelRegisterQ;

architecture registerQ_arc of ParalelRegisterQ is
    signal REG : std_logic_vector (N -1 downto 0) := (OTHERS => '0');
    signal Qlsbb : std_logic := '0';

begin
    process (CT, clk)
    begin

        if (CT = "10") then
            REG <= IN_REG;
            Qlsbb <= IN_REG(0);
        end if;

        OUT_REG <= REG;
        QLSB <= Qlsbb;

    end process;
end registerQ_arc;
