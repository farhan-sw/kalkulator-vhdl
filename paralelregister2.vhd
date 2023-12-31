library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ParalelRegister2 is
    generic ( N : INTEGER := 41 );
    port (
        IN_REG          : in std_logic_vector (N -1 downto 0);
        CT              : in std_logic_vector(1 downto 0);
        OUT_REG         : out std_logic_vector(N -1 downto 0);

        clk             : in std_logic
    );
end ParalelRegister2;

architecture register_arc of ParalelRegister2 is
    signal REG : std_logic_vector (N -1 downto 0) := (OTHERS => '0');

begin
    process (CT, clk)
    begin

        if (CT = "10") then
            REG <= IN_REG;
        end if;

        OUT_REG <= REG;

    end process;
end register_arc;
