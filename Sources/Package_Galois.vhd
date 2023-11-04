--	  ________  ________  ________  ___  __    ________  ________  _______           ________  _______   ________      
--	 |\   __  \|\   __  \|\   ____\|\  \|\  \ |\   __  \|\   ____\|\  ___ \         |\   __  \|\  ___ \ |\   ____\     
--	 \ \  \|\  \ \  \|\  \ \  \___|\ \  \/  /|\ \  \|\  \ \  \___|\ \   __/|        \ \  \|\  \ \   __/|\ \  \___|_    
--	  \ \   ____\ \   __  \ \  \    \ \   ___  \ \   __  \ \  \  __\ \  \_|/__       \ \   __  \ \  \_|/_\ \_____  \   
--	   \ \  \___|\ \  \ \  \ \  \____\ \  \\ \  \ \  \ \  \ \  \|\  \ \  \_|\ \       \ \  \ \  \ \  \_|\ \|____|\  \  
--	    \ \__\    \ \__\ \__\ \_______\ \__\\ \__\ \__\ \__\ \_______\ \_______\       \ \__\ \__\ \_______\____\_\  \ 
--	     \|__|     \|__|\|__|\|_______|\|__| \|__|\|__|\|__|\|_______|\|_______|        \|__|\|__|\|_______|\_________\
--	                                                                                                      \|_________|

library ieee;
use ieee.std_logic_1164.all;

package my_package is

	-- Polynome m(x) : 
	constant C_m: std_logic_vector (8 downto 0) := "100011011"; -- "100011011";
	-- Type polynom de la taille N-1 : 
	subtype polynom is std_logic_vector ((C_m'length-2) downto 0);
	-- Taille du polynome pour le standard utilise => N=8 dans le cas de l'AES 128 : 
	constant C_N : integer := (C_m'length)-1;

	-- Definition de fonctions :
	function add (a, b : polynom) return polynom;
	function mult_X (a : polynom) return polynom;
	function mult_2_elem (a, b : polynom) return polynom;
	function invers (a : polynom) return polynom;
	
end my_package;

package body my_package is

-- Fonction addition :
function add (a, b : polynom) return polynom is	
	begin
	return (a XOR b);
end function add ;

-- Fonction multiplication par X : (Permet aussi de réaliser un décalage/reduction)
function mult_X (a : polynom) return polynom is
	variable mult_X_result : polynom;								-- Initialisation du polynome retour
	begin
	mult_X_result := (others => '0');
	if a(C_N-1) = '1' then											-- SI le MSB du polynome vaut 1 c-a-d est-ce qu'un debordement peut avoir lieu lors du decalage a gauche ?
		mult_X_result := a(C_N-2 downto 0)&'0' XOR C_m(C_N-1 downto 0);	-- Decalage a gauche et Reduction du champs de Galois avec le poly irreductible (evite un depassement de N)
	else 															-- SI le MSB du polynome different de 1 ALORS
		mult_X_result := a(C_N-2 downto 0)&'0';						-- Décalage a gauche seulement car pas de overflow possible
	end if;
	return mult_X_result;
end function mult_X ;

-- Fonction multiplication de deux éléments quelconques du corps
function mult_2_elem (a, b : polynom) return polynom is
	variable mult_2_result : polynom;								-- Initialisation du polynome retour 
	variable temp_b : polynom;										-- Initialisation du polynome retour  
	begin
	mult_2_result := (others => '0');
	for i in (C_N-1) downto 1 loop
		if (a(i) = '1') then
			temp_b := b;
			for j in 1 to i loop
				temp_b := mult_X(temp_b);
			end loop;
			mult_2_result := add(mult_2_result, temp_b);
		end if;
	end loop;
	if (a(0) = '1') then
		mult_2_result := add(mult_2_result, b);
	end if;
		
	return mult_2_result;
end function mult_2_elem;


-- Fonction inverse
function invers (a : polynom) return polynom is
	variable inv_result : polynom;									-- Initialisation du polynome retour 
	begin
	inv_result := a;
	for i in 0 to (2**(C_N) - 4) loop								-- Multiplication bit a bit du poly a par le poly b 
		inv_result := mult_2_elem(inv_result, a);
	end loop;
	return inv_result;
end function invers;

end my_package;