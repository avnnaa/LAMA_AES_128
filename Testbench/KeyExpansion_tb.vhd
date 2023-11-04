--  _________  ________          ________  _______   ________   _______   ________  ________  _________  ___  ________  ________           ________  _______   ________           ________  ________  ___  ___  ________                 ________  ___       _______   ________      
-- |\___   ___\\   __  \        |\   ____\|\  ___ \ |\   ___  \|\  ___ \ |\   __  \|\   __  \|\___   ___\\  \|\   __  \|\   ___  \        |\   ___ \|\  ___ \ |\   ____\         |\   ____\|\   __  \|\  \|\  \|\   ____\               |\   ____\|\  \     |\  ___ \ |\   ____\     
-- \|___ \  \_\ \  \|\ /_       \ \  \___|\ \   __/|\ \  \\ \  \ \   __/|\ \  \|\  \ \  \|\  \|___ \  \_\ \  \ \  \|\  \ \  \\ \  \       \ \  \_|\ \ \   __/|\ \  \___|_        \ \  \___|\ \  \|\  \ \  \\\  \ \  \___|_  ____________\ \  \___|\ \  \    \ \   __/|\ \  \___|_    
--      \ \  \ \ \   __  \       \ \  \  __\ \  \_|/_\ \  \\ \  \ \  \_|/_\ \   _  _\ \   __  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \ \\ \ \  \_|/_\ \_____  \        \ \_____  \ \  \\\  \ \  \\\  \ \_____  \|\____________\ \  \    \ \  \    \ \  \_|/_\ \_____  \   
--       \ \  \ \ \  \|\  \       \ \  \|\  \ \  \_|\ \ \  \\ \  \ \  \_|\ \ \  \\  \\ \  \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \_\\ \ \  \_|\ \|____|\  \        \|____|\  \ \  \\\  \ \  \\\  \|____|\  \|____________|\ \  \____\ \  \____\ \  \_|\ \|____|\  \  
--        \ \__\ \ \_______\       \ \_______\ \_______\ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\   \ \__\ \ \__\ \_______\ \__\\ \__\       \ \_______\ \_______\____\_\  \         ____\_\  \ \_______\ \_______\____\_\  \              \ \_______\ \_______\ \_______\____\_\  \ 
--         \|__|  \|_______|        \|_______|\|_______|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|  \|__|\|_______|\|__| \|__|        \|_______|\|_______|\_________\       |\_________\|_______|\|_______|\_________\              \|_______|\|_______|\|_______|\_________\
--                                                                                                                                                                \|_________|       \|_________|                  \|_________|                                           \|_________|
  
library ieee;                                                                                                                                          
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.my_package_2.all;  
use work.my_package.all; 

entity KeyExpansion_tb is
end KeyExpansion_tb;

architecture sim of KeyExpansion_tb is

    -- Instanciation de aes_top
    component aes_top
    Port (
        clk     : in std_logic;
		rstn    : in std_logic;
        key_in  : in std_logic_vector(127 downto 0);
        key_out : out std_logic_vector(128*11-1 downto 0);
		flag : out std_logic
    );
    end component;
	
    -- Signaux pour la simulation
    signal clk: std_logic := '0';
	signal round : integer;
	signal rstn: std_logic := '1';
    signal key_in: std_logic_vector(127 downto 0) := (others => '0');
    signal key_out: std_logic_vector(128*11-1 downto 0);
	signal clk_count : INTEGER range 0 to 1 := 0;
	signal key_select : integer := 0;

begin

    -- Instanciation de aes_top
    TOP_KEY: aes_top
    port map (
        clk     => clk,
		rstn 	=> rstn,
        key_in  => key_in,
        key_out => key_out
    );

-- process(clk, rstn) 
-- begin
	-- if rstn = '0' then 
		-- key_select <= 0;
	-- elsif rising_edge(clk) then
		-- if key_select = 10 then
            -- key_select <= 0;
		-- else
			-- key_select <= key_select + 1;
        -- end if;
-- end if;
-- end process;


    -- Génération d'une horloge
    clk_process: process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    -- Processus de simulation
    stim_proc: process
    begin
		rstn <= '0';
		wait for 5 ns;
		rstn <= '1';

		key_in <= x"2b7e151628aed2a6abf7158809cf4f3c";
		wait for 300 ns;

		key_in <= x"DEADBEEFDEADBEEFDEADBEEFDEADBEEF";
		wait for 300 ns;
		 
		key_in <= x"2b7e151628aed2a6abf7158809cf4f3c";
		wait for 300 ns;
		
		report "Simulation terminée";
		wait;
    end process;

end sim;


