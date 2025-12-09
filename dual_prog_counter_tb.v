library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_universal_dual_counter is
    -- Testbench 不需要 Port
end tb_universal_dual_counter;

architecture Behavioral of tb_universal_dual_counter is

    -- 1. 宣告元件 (必須與設計檔一致)
    component universal_dual_counter
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
    end component;

    -- 2. 宣告測試訊號
    signal tb_clk     : std_logic := '0';
    signal tb_reset   : std_logic := '0';
    signal tb_min     : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_max     : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_dir_1   : std_logic := '0';
    signal tb_dir_2   : std_logic := '0';
    
    -- 觀察輸出用
    signal tb_cnt_1   : std_logic_vector(3 downto 0);
    signal tb_cnt_2   : std_logic_vector(3 downto 0);

    -- 定義時脈週期 (10 ns)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 3. 連接元件 (UUT: Unit Under Test)
    uut: universal_dual_counter Port Map (
        i_clk     => tb_clk,
        i_reset   => tb_reset,
        i_min     => tb_min,
        i_max     => tb_max,
        i_dir_1   => tb_dir_1,
        i_dir_2   => tb_dir_2,
        o_cnt_1   => tb_cnt_1,
        o_cnt_2   => tb_cnt_2
    );

    -- 4. 產生時脈 Process
    CLK_PROCESS : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- 5. 測試劇本 Process
    STIM_PROC: process
    begin
        -- ==========================================================
        -- 階段 1: 初始化與 Reset
        -- 設定範圍：2 ("0010") 到 9 ("1001")
        -- 設定方向：Cnt1 上數 ('1'), Cnt2 下數 ('0')
        -- ==========================================================
        tb_min   <= "0010"; -- 2
        tb_max   <= "1001"; -- 9
        tb_dir_1 <= '1';    -- 1號上數
        tb_dir_2 <= '0';    -- 2號下數
        
        tb_reset <= '1';    -- 按下 Reset
        wait for 40 ns;
        tb_reset <= '0';    -- 放開 Reset，開始跑
        
        -- 讓它跑一段時間 (約 15 個週期)，觀察是否在 2~9 之間循環
        wait for 150 ns; 

        -- ==========================================================
        -- 階段 2: 動態切換方向
        -- Cnt1 改為下數, Cnt2 改為上數
        -- ==========================================================
        tb_dir_1 <= '0';
        tb_dir_2 <= '1';
        
        -- 讓它跑一段時間，觀察計數方向是否反轉
        wait for 150 ns;

        -- ==========================================================
        -- 階段 3: 動態修改範圍
        -- 將範圍縮小為：4 ("0100") 到 7 ("0111")
        -- ==========================================================
        tb_min <= "0100"; -- 4
        tb_max <= "0111"; -- 7
        
        -- 觀察計數器是否自動修正到新範圍內 (例如原本在 9，應該會跳回來)
        wait for 150 ns;

        -- 測試結束
        wait;
    end process;

end Behavioral;