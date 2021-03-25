library ieee;
use ieee.std_logic_1164.all;

entity tb_autocarwash is
end tb_autocarwash;

architecture tb of tb_autocarwash is

    component autocarwash
        port (clk   : in std_logic;
              st    : in std_logic;
              tcr   : in std_logic;
              tcd   : in std_logic;
              water : out std_logic;
              brush : out std_logic;
              soap  : out std_logic);
    end component;

    signal clk   : std_logic;
    signal st    : std_logic;
    signal tcr   : std_logic;
    signal tcd   : std_logic;
    signal water : std_logic;
    signal brush : std_logic;
    signal soap  : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : autocarwash
    port map (clk   => clk,
              st    => st,
              tcr   => tcr,
              tcd   => tcd,
              water => water,
              brush => brush,
              soap  => soap);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        st <= '0';
        tcr <= '0';
        tcd <= '0';

        -- Reset generation
        --  EDIT: Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        YOURRESETSIGNAL <= '1';
        wait for 100 ns;
        YOURRESETSIGNAL <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
