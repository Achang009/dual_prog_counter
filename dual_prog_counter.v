library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updown_counter_dynamic is
    Port (
        i_clk        : in  STD_LOGIC;
        i_reset      : in  STD_LOGIC;
        i_min        : in  STD_LOGIC_VECTOR(3 downto 0);
        i_max        : in  STD_LOGIC_VECTOR(3 downto 0); 
        o_countup   : out STD_LOGIC_VECTOR(3 downto 0);
        o_countdown : out STD_LOGIC_VECTOR(3 downto 0)
    );
end updown_counter_dynamic;

architecture Behavioral of updown_counter_dynamic is
    
    signal r_cntup   : unsigned(3 downto 0) := (others => '0');
    signal r_cntdown : unsigned(3 downto 0) := (others => '0');

begin

    UP_COUNTER: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_cntup <= unsigned(i_min);
        elsif rising_edge(i_clk) then
            if r_cntup >= unsigned(i_max) then
                r_cntup <= unsigned(i_min);
            else
                r_cntup <= r_cntup + 1;
            end if;
        end if;
    end process UP_COUNTER;

    DOWN_COUNTER: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_cntdown <= unsigned(i_max);
        elsif rising_edge(i_clk) then
            if r_cntdown <= unsigned(i_min) then
                r_cntdown <= unsigned(i_max);
            else
                r_cntdown <= r_cntdown - 1;
            end if;
        end if;
    end process DOWN_COUNTER;
    OUTPUT: process(r_cntup, r_cntdown)
    begin
        o_countup   <= std_logic_vector(r_cntup);
        o_countdown <= std_logic_vector(r_cntdown);
    end process OUTPUT;
end Behavioral;