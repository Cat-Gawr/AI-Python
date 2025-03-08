-------------------------------------------------------------------------------
-- TestBench(binary_to_gray)
--
-- File name : binary_to_gray_test.vhdl
-- Purpose   : Generates stimuli for a binary to Gray converter
--           :
-- Author(s) : Antonio Macrì
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity binary_to_gray_tb is
end binary_to_gray_tb;

architecture binary_to_gray_test of binary_to_gray_tb is
    component binary_to_gray
        generic(N : positive);
        port(clk   : in  std_logic;
             reset : in  std_logic;
             b     : in  std_logic_vector(N - 1 downto 0);
             g     : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    -- Input bits
    constant N           : integer := 4;
    -- Clock period
    constant ClockPeriod : time    := 100 ns;

    -- Clock
    signal clk : std_logic := '0';

    -- Input signals
    signal counter : integer                          := 0;
    signal binary  : std_logic_vector(N - 1 downto 0) := (others => '0');

    -- Output signals
    signal gray         : std_logic_vector(N - 1 downto 0);
    signal gray_delayed : std_logic_vector(N - 1 downto 0);
    signal gray_xored   : std_logic_vector(N - 1 downto 0);
    signal zero_bits    : std_logic_vector(N - 1 downto 0);
    signal result       : std_logic;

begin
    B2G : binary_to_gray
        generic map(N)
        port map(clk, '1', binary, gray);

    -- Generate the clock
    clk <= not clk after ClockPeriod / 2;

    -- Wire the input signal of the converter to the binary value of counter
    binary <= std_logic_vector(to_unsigned(counter, binary'length));

    -- Compute the XOR between two consecutive gray codes produced by the
    -- converter
    gray_xored <= gray xor gray_delayed;

    -- Check that the resulting XOR is a power of two (it includes zero!)
    zero_bits <= gray_xored and std_logic_vector(unsigned(gray_xored) - 1);

    process(clk)
    begin
        if (rising_edge(clk)) then
            counter      <= counter + 1;
            gray_delayed <= gray;
        end if;
    end process;

    process(gray_xored, zero_bits)
    begin
        -- If the XOR is a power of two, but different than zero, set result
        -- to 1
        if unsigned(zero_bits) = 0 and unsigned(gray_xored) /= 0 then
            -- It works!
            result <= '1';
        else
            -- Something wrong!
            result <= '0';
        end if;
    end process;

end binary_to_gray_test;
