library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity updown_counter is
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

    signal cntup     : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal cntdown   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

    signal bin_cnt   : STD_LOGIC_VECTOR(25 downto 0) := (others => '0'); 
    signal f_clk     : std_logic := '0';

begin

    frequency_divider: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            bin_cnt <= (others => '0');
        elsif rising_edge(i_clk) then
            bin_cnt <= bin_cnt + 1;  
        end if;
    end process frequency_divider;
    f_clk <= bin_cnt(25); 
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
                cntdown <= i_max;
            else
                cntdown <= cntdown - 1;
            end if;
        end if;
    end process down_counter;

    o_countup   <= cntup;
    o_countdown <= cntdown;
    
end Behavioral;
