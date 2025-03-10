-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : binary_to_gray.vhdl
-- Purpose   : A Binary to Gray converter
--           :
-- Autore - ' ' ' ' ' ' ' '  ' ' ' '  ' ' '  '
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity binary_to_gray is
    generic(N : positive := 4);
    port(clk   : in  std_logic;
         reset : in  std_logic;         -- Active low
         b     : in  std_logic_vector(N - 1 downto 0);
         g     : out std_logic_vector(N - 1 downto 0)
    );
end;

architecture BEHAVIOURAL of binary_to_gray is
begin
    process(clk, reset)
    begin
        -- If reset is active, force the output to all-zero
        if (reset = '0') then
            g <= (others => '0');

        elsif (rising_edge(clk)) then
            g(N - 1) <= b(N - 1);
            for i in N - 2 downto 0 loop
                g(i) <= b(i + 1) xor b(i);
            end loop;
        end if;
    end process;
end;
