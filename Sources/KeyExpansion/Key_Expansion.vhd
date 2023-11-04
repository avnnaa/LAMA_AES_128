
--  ________  _______   ________   _______   ________  ________  _________  ___  ________  ________           ________  _______   ________           ________  ________  ___  ___  ________                 ________  ___       _______   ________      
-- |\   ____\|\  ___ \ |\   ___  \|\  ___ \ |\   __  \|\   __  \|\___   ___\\  \|\   __  \|\   ___  \        |\   ___ \|\  ___ \ |\   ____\         |\   ____\|\   __  \|\  \|\  \|\   ____\               |\   ____\|\  \     |\  ___ \ |\   ____\     
--  \ \  \___|\ \   __/|\ \  \\ \  \ \   __/|\ \  \|\  \ \  \|\  \|___ \  \_\ \  \ \  \|\  \ \  \\ \  \       \ \  \_|\ \ \   __/|\ \  \___|_        \ \  \___|\ \  \|\  \ \  \\\  \ \  \___|_  ____________\ \  \___|\ \  \    \ \   __/|\ \  \___|_    
--   \ \  \  __\ \  \_|/_\ \  \\ \  \ \  \_|/_\ \   _  _\ \   __  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \ \\ \ \  \_|/_\ \_____  \        \ \_____  \ \  \\\  \ \  \\\  \ \_____  \|\____________\ \  \    \ \  \    \ \  \_|/_\ \_____  \   
--    \ \  \|\  \ \  \_|\ \ \  \\ \  \ \  \_|\ \ \  \\  \\ \  \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \       \ \  \_\\ \ \  \_|\ \|____|\  \        \|____|\  \ \  \\\  \ \  \\\  \|____|\  \|____________|\ \  \____\ \  \____\ \  \_|\ \|____|\  \  
--     \ \_______\ \_______\ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\   \ \__\ \ \__\ \_______\ \__\\ \__\       \ \_______\ \_______\____\_\  \         ____\_\  \ \_______\ \_______\____\_\  \              \ \_______\ \_______\ \_______\____\_\  \ 
--      \|_______|\|_______|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|  \|__|\|_______|\|__| \|__|        \|_______|\|_______|\_________\       |\_________\|_______|\|_______|\_________\              \|_______|\|_______|\|_______|\_________\
--                                                                                                                                    \|_________|       \|_________|                  \|_________|                                           \|_________|                                                                                                                                                                                                                                  

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package_2.all; 
use work.my_package.all; 

entity Key_Expansion is   
  port(
    clk     	: in  std_logic;
    rstn    	: in  std_logic;
    key_in  	: in  std_logic_vector(127 downto 0);
    w0_sub  	: in  std_logic_vector(31  downto 0);
    adress  	: out std_logic_vector(31  downto 0);
    key_out 	: out std_logic_vector(128*11-1 downto 0);
	Gen_key 	: out std_logic 
	
  );       
end entity;       

architecture RTL of Key_Expansion is

signal w0, w1, w2, w3, w0_old, w1_old, w2_old, w3_old : std_logic_vector(31 downto 0);
signal w0_rotword, temp_w0, temp_w1, temp_w2, temp_w3, RconXORtemp : std_logic_vector(31 downto 0);
signal key_prev : std_logic_vector(127 downto 0) := (others => '0');
signal cpt, OK_CPT, OK_GEN : integer := 0;
 
type Rcon_type is array (0 to 10) of std_logic_vector(31 downto 0);
	signal Rcon: Rcon_type := (others => (others => '0'));

type Key_Gen_type is array (0 to 10) of std_logic_vector(127 downto 0);
	signal Key_out_temp: Key_Gen_type := (others => (others => '0'));
	
begin
-- Temp correspond au Word precedent :
temp_w0 <= w3;
temp_w1 <= w0;
temp_w2 <= w1;
temp_w3 <= w2;

-- Generation des Rcon :
RCON_GEN: process (clk, rstn)
variable current_Rcon: std_logic_vector(7 downto 0) := x"01";
begin
	if (rstn = '0') then 
		Rcon <= (others => (others => '0')); 
	elsif rising_edge(clk) then 
		Rcon(0) <= (x"00000000");
		Rcon(1) <= current_Rcon&(x"000000");
		for i in 2 to 10 loop
			current_Rcon := mult_X(current_Rcon);
			Rcon(i) <= current_Rcon&(x"000000");
		end loop;
		current_Rcon := x"01";
		OK_CPT  <= 1;
	end if;
end process;

-- Compteur etapes pour generation des sous clees / Autotisation d'écriture de clees :
CPT_CLK: process (clk, rstn)
begin
    if rstn = '0' then
        cpt <= 0;
    elsif rising_edge(clk) and (OK_CPT = 1) then
		if (key_in /= key_prev) then
			OK_GEN 	<= 0;
			cpt <= 0;
		elsif cpt = 10 then
            cpt <= 0;
			OK_GEN 	<= 1;
        else
			cpt <= cpt + 1;
        end if;
    end if;
		key_prev <= key_in;
end process;

-- Traitement de w0 :
w0_rotword 	<= rotword(temp_w0);
adress 		<= w0_rotword;

-- Attribution des valeurs a w1, w2 et w3 :
w1 <= (w1_old XOR temp_w1) when (cpt >= 1) and (cpt <= 10) else key_in(95 downto 64); 
w2 <= (w2_old XOR temp_w2) when (cpt >= 1) and (cpt <= 10) else key_in(63 downto 32);  
w3 <= (w3_old XOR temp_w3) when (cpt >= 1) and (cpt <= 10) else key_in(31 downto 0);	

-- Generation de W0, W1, W2 et W3 precedents :
WORDS_GEN: process (clk, rstn)
begin 
	if (rstn = '0') then 
		w0_old 	<= (others => '0'); 
		w1_old 	<= (others => '0'); 
		w2_old 	<= (others => '0'); 
		w3_old 	<= (others => '0'); 
	elsif rising_edge(clk) then 
		w0_old <= w0;
		w1_old <= w1;
		w2_old <= w2;
		w3_old <= w3;
	end if;
end process;

-- Attribution de la valeur à w0 :
RconXORtemp <= ((w0_sub XOR Rcon(cpt))) when (cpt <= 10) ;
w0 <= (RconXORtemp  XOR w0_old) when ((cpt >= 1)) and (cpt <= 10) else key_in(127 downto 96); --XOR w3_old; -- Etape 3: Lecture des datas des SBOXs  AND (OK_GEN = 1))
Gen_key <= '1' when OK_GEN = 1;

-- Sauvegarde des ss cles dans un tableau :
KEYGEN: process (clk, rstn)
begin
	if (rstn = '0') then 
		Key_out_temp <= (others => (others => '0')); 
		Key_out <= (others =>'0'); 
	elsif rising_edge(clk) and (OK_GEN = 0) and (cpt <= 10)  then 
		Key_out_temp(cpt) <= w0 & w1 & w2 & w3;
		Key_out(128*cpt+127 downto 128*cpt) <=  w0 & w1 & w2 & w3;
	
	end if;
end process;

end architecture;



