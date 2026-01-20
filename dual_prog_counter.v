library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity updown_counter is
    Generic (
        g_DIV_RATIO : integer := 50000000 
    );
    Port (
        i_clk       : in  STD_LOGIC;
        i_reset     : in  STD_LOGIC;
        i_min       : in  STD_LOGIC_VECTOR(3 downto 0);
        i_max       : in  STD_LOGIC_VECTOR(3 downto 0); 
        o_countup   : out STD_LOGIC_VECTOR(3 downto 0);
        o_countdown : out STD_LOGIC_VECTOR(3 downto 0)
    );
end updown_counter;

architecture Behavioral of updown_counter is
    
    signal cntup     : unsigned(3 downto 0) := (others => '0');
    signal cntdown   : unsigned(3 downto 0) := (others => '0');
    signal r_div_cnt : integer range 0 to g_DIV_RATIO - 1 := 0;
    signal f_clk     : std_logic := '0';

begin

    frequency_divider: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_div_cnt <= 0;
            f_clk     <= '0';
        elsif rising_edge(i_clk) then
            if r_div_cnt = g_DIV_RATIO - 1 then
                r_div_cnt <= 0;
                f_clk     <= not f_clk;
            else
                r_div_cnt <= r_div_cnt + 1;
            end if;
        end if;
    end process frequency_divider;

    up_counter: process(f_clk, i_reset)
    begin
        if i_reset = '1' then
            cntup <= i_min;
        elsif rising_edge(f_clk) then
            if cntup >= i_max then
                cntup <= i_min;
            else
                cntup <= cntup + 1;
            end if;
        end if;
    end process up_counter;

    down_counter: process(f_clk, i_reset)
    begin
        if i_reset = '1' then
            cntdown <= i_max;
        elsif rising_edge(f_clk) then
            if cntdown <= i_min then
                cntdown <=(i_max;
            else
                cntdown <= cntdown - 1;
            end if;
        end if;
    end process down_counter;

    o_countup   <= std_logic_vector(cntup);
    o_countdown <= std_logic_vector(cntdown);
end Behavioral;


