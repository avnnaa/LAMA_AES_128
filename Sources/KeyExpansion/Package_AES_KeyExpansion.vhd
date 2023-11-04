--	  ________  ________  ________  ___  __    ________  ________  _______           ________  _______   ________      
--	 |\   __  \|\   __  \|\   ____\|\  \|\  \ |\   __  \|\   ____\|\  ___ \         |\   __  \|\  ___ \ |\   ____\     
--	 \ \  \|\  \ \  \|\  \ \  \___|\ \  \/  /|\ \  \|\  \ \  \___|\ \   __/|        \ \  \|\  \ \   __/|\ \  \___|_    
--	  \ \   ____\ \   __  \ \  \    \ \   ___  \ \   __  \ \  \  __\ \  \_|/__       \ \   __  \ \  \_|/_\ \_____  \   
--	   \ \  \___|\ \  \ \  \ \  \____\ \  \\ \  \ \  \ \  \ \  \|\  \ \  \_|\ \       \ \  \ \  \ \  \_|\ \|____|\  \  
--	    \ \__\    \ \__\ \__\ \_______\ \__\\ \__\ \__\ \__\ \_______\ \_______\       \ \__\ \__\ \_______\____\_\  \ 
--	     \|__|     \|__|\|__|\|_______|\|__| \|__|\|__|\|__|\|_______|\|_______|        \|__|\|__|\|_______|\_________\
--	                                                                                                      \|_________|
-- 	Package pour le binôme K : Génération des sous clés
library ieee;
use ieee.std_logic_1164.all;

package my_package_2 is

	subtype Word_type is std_logic_vector (31 downto 0);						-- 32 bits
	
	function RotWord (a : Word_type) return Word_type;
	
	type Key_Gen_type is array (0 to 10) of std_logic_vector(127 downto 0);
	signal Key_gen: Key_Gen_type := (others => (others => '0'));
	
end my_package_2;

package body my_package_2 is

-- Fonction RotWord :
function RotWord (a : Word_type) return Word_type is	
	begin
	return a(23 downto 0)&a(31 downto 24);
end function RotWord ;

end my_package_2;