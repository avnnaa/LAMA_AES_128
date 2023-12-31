
--  _________  ________  ________        ________  _______   ________   _______   ________  ________  _________  ___  ________  ________           ________  _______   ________           ________  ________  ___  ___  ________                 ________  ___       _______   ________      
-- |\___   ___\\   __  \|\   __  \      |\   ____\|\  ___ \ |\   ___  \|\  ___ \ |\   __  \|\   __  \|\___   ___\\  \|\   __  \|\   ___  \        |\   ___ \|\  ___ \ |\   ____\         |\   ____\|\   __  \|\  \|\  \|\   ____\               |\   ____\|\  \     |\  ___ \ |\   ____\     
-- \|___ \  \_\ \  \|\  \ \  \|\  \     \ \  \___|\ \   __/|\ \  \\ \  \ \   __/|\ \  \|\  \ \  \|\  \|___ \  \_\ \  \ \  \|\  \ \  \\ \  \       \ \  \_|\ \ \   __/|\ \  \___|_        \ \  \___|\ \  \|\  \ \  \\\  \ \  \___|_  ____________\ \  \___|\ \  \    \ \   __/|\ \  \___|_    
--      \ \  \ \ \  \\\  \ \   ____\     \ \  \  __\ \  \_|/_\ \  \\ \  \ \  \_|/_\ \   _  _\ \   __  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \ \\ \ \  \_|/_\ \_____  \        \ \_____  \ \  \\\  \ \  \\\  \ \_____  \|\____________\ \  \    \ \  \    \ \  \_|/_\ \_____  \   
--       \ \  \ \ \  \\\  \ \  \___|      \ \  \|\  \ \  \_|\ \ \  \\ \  \ \  \_|\ \ \  \\  \\ \  \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \_\\ \ \  \_|\ \|____|\  \        \|____|\  \ \  \\\  \ \  \\\  \|____|\  \|____________|\ \  \____\ \  \____\ \  \_|\ \|____|\  \  
--        \ \__\ \ \_______\ \__\          \ \_______\ \_______\ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\   \ \__\ \ \__\ \_______\ \__\\ \__\       \ \_______\ \_______\____\_\  \         ____\_\  \ \_______\ \_______\____\_\  \              \ \_______\ \_______\ \_______\____\_\  \ 
--         \|__|  \|_______|\|__|           \|_______|\|_______|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|  \|__|\|_______|\|__| \|__|        \|_______|\|_______|\_________\       |\_________\|_______|\|_______|\_________\              \|_______|\|_______|\|_______|\_________\
--                                                                                                                                                                        \|_________|       \|_________|                  \|_________|                                           \|_________|																																																											  


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package_2.all; 
use work.my_package.all; 


entity aes_top_du_top is Port (
    clk     : in  std_logic;
	rstn    : in  std_logic;
    key_in  : in  std_logic_vector(127 downto 0);
    cipher  : in  std_logic_vector(127 downto 0);
	clear   : out std_logic_vector(127 downto 0)
    );
end aes_top_du_top;

architecture Behavioral of aes_top_du_top is
	signal key :  std_logic_vector((128*11)-1 downto 0);
	signal flag : std_logic;

begin
    aes_inst : entity work.aes_top
    port map (
		clk     => clk,
		rstn    => rstn,
		key_in  => key_in,
		key_out => key,
		flag 	=> flag
    );    
	
	
	dechiff_inst : entity work.dechiffrement_pipeline
    port map (
		resetn  => rstn,
		clk     => clk,
		state   => cipher,
		flag  	=> flag,
		key 	=> key,
		out_data=> clear
    );


end Behavioral;

