library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_updown_counter_dynamic is
end tb_updown_counter_dynamic;

architecture Behavioral of tb_updown_counter_dynamic is
    component updown_counter_dynamic
    Port (
        i_clk        : in  STD_LOGIC;
        i_reset      : in  STD_LOGIC;
        i_min        : in  STD_LOGIC_VECTOR(3 downto 0);
        i_max        : in  STD_LOGIC_VECTOR(3 downto 0);
        o_countup   : out STD_LOGIC_VECTOR(3 downto 0);
        o_countdown : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;
    signal tb_clk        : std_logic := '0';
    signal tb_reset      : std_logic := '0';
    signal tb_min        : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_max        : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_count_up   : std_logic_vector(3 downto 0);
    signal tb_count_down : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: updown_counter_dynamic Port Map (
        i_clk        => tb_clk,
        i_reset      => tb_reset,
        i_min        => tb_min,
        i_max        => tb_max,
        o_countup   => tb_count_up,
        o_countdown => tb_count_down
    );

    CLK_PROCESS : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;
    STIM_PROC: process
    begin
        tb_min <= "0010"; 
        tb_max <= "1001"; 
        tb_reset <= '1';
        wait for 40 ns; 
        tb_reset <= '0';
        wait for 150 ns; 
        wait until rising_edge(tb_clk);
        tb_min <= "0100"; 
        tb_max <= "0111"; 
        wait for 150 ns;

        tb_min <= "0000"; 
        tb_max <= "1111";
        
        wait for 200 ns;
        wait;
    end process;

end Behavioral;