library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity universal_dual_counter is
    Port (
        i_clk     : in  STD_LOGIC;
        i_reset   : in  STD_LOGIC;

        i_min     : in  STD_LOGIC_VECTOR(3 downto 0);
        i_max     : in  STD_LOGIC_VECTOR(3 downto 0);
        
        i_dir_1   : in  STD_LOGIC; 
        i_dir_2   : in  STD_LOGIC;

        o_cnt_1   : out STD_LOGIC_VECTOR(3 downto 0);
        o_cnt_2   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end universal_dual_counter;

architecture Behavioral of universal_dual_counter is
    
    signal r_cnt_1 : unsigned(3 downto 0) := (others => '0');
    signal r_cnt_2 : unsigned(3 downto 0) := (others => '0');

begin

    COUNTER_1_PROC: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_cnt_1 <= unsigned(i_min);
        elsif rising_edge(i_clk) then

            if i_dir_1 = '1' then 
                if r_cnt_1 >= unsigned(i_max) then
                    r_cnt_1 <= unsigned(i_min);
                else
                    r_cnt_1 <= r_cnt_1 + 1;
                end if;
            else 
                if r_cnt_1 <= unsigned(i_min) then
                    r_cnt_1 <= unsigned(i_max);
                else
                    r_cnt_1 <= r_cnt_1 - 1;
                end if;
            end if;
            
        end if;
    end process COUNTER_1_PROC;

    COUNTER_2_PROC: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_cnt_2 <= unsigned(i_max);
        elsif rising_edge(i_clk) then
            if i_dir_2 = '1' then 
                if r_cnt_2 >= unsigned(i_max) then
                    r_cnt_2 <= unsigned(i_min);
                else
                    r_cnt_2 <= r_cnt_2 + 1;
                end if;
            else 
                if r_cnt_2 <= unsigned(i_min) then
                    r_cnt_2 <= unsigned(i_max);
                else
                    r_cnt_2 <= r_cnt_2 - 1;
                end if;
            end if;
            
        end if;
    end process COUNTER_2_PROC;

    o_cnt_1 <= std_logic_vector(r_cnt_1);
    o_cnt_2 <= std_logic_vector(r_cnt_2);

end Behavioral;