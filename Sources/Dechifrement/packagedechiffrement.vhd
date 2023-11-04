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
use work.my_package.all;


package package_dechiffrement is

	
	constant Nbit : positive :=128;
	subtype vector_state is std_logic_vector(Nbit-1 downto 0);
	subtype byte is std_logic_vector(7 downto 0);
	type array_state is array (0 to 3,0 to 3) of std_logic_vector(7 downto 0);
	type regkey is array (0 to 10) of std_logic_vector(Nbit-1 downto 0);
	
	-- Definition de fonctions 
	function invShiftRow (a_state : array_state) return vector_state;
	--function invSubBytes (end_isr : std_logic_vector(Nbit-1 downto 0)) return std_logic_vector;
	function addRoundKey (end_isb : vector_state; skey : vector_state) return vector_state; 
	function invMixColumns (end_ark : array_state) return array_state;
	function create_array_state (state :vector_state) return array_state;
	function create_vector_state (state :array_state) return vector_state;	


end package_dechiffrement;

package body package_dechiffrement is



--Fonction create_array_state :
function create_array_state (state :vector_state) return array_state is
	variable u,v: integer;
	variable a_state : array_state;
	begin
	for j in 0 to 3 loop
		for i in 0 to 3 loop
			u := 127-8*(i+j*4);
			v := 120-8*(i+j*4);			
			a_state(i,j):= state(u downto v);
		end loop;
	end loop;
	return a_state;
end create_array_state;

--Fonction create_vector_state :
function create_vector_state (state : array_state) return vector_state is
	variable u,v: integer;
	variable a_state : vector_state;
	begin
	for j in 0 to 3 loop
		for i in 0 to 3 loop
			u := 127-8*(i+j*4);
			v := 120-8*(i+j*4);			
			a_state(u downto v):= state(i,j);
		end loop;
	end loop;
	return a_state;
end create_vector_state;


--Fonction invShiftRow :
function invShiftRow (a_state : array_state) return vector_state is
	--variable u,v :positive;
	variable b_state : vector_state;
	begin
	b_state(127 downto 96) :=a_state(0,0)&a_state(1,3)&a_state(2,2)&a_state(3,1);
	b_state(95 downto 64)  :=a_state(0,1)&a_state(1,0)&a_state(2,3)&a_state(3,2);
	b_state(63 downto 32)  :=a_state(0,2)&a_state(1,1)&a_state(2,0)&a_state(3,3);
	b_state(31 downto 0)  :=a_state(0,3)&a_state(1,2)&a_state(2,1)&a_state(3,0);	
	return b_state;
end function;

--Function addRoundKey :
--function addRoundKey (end_isb : vector_state; skey : vector_state) return vector_state is
--        variable a : vector_state;
--	a := end_isb xor skey;
--	return end_isb xor skey;
--end function;

function addRoundKey (end_isb : vector_state; skey : vector_state) return vector_state is
        variable a_state : vector_state;
	begin
		a_state:= end_isb xor skey;
	return a_state;
end function;



function invMixColumns (end_ark : array_state) return array_state is
	variable u,v :positive;
	variable a_state : array_state;
	begin
	for i in 0 to 3 loop
		a_state(0,i) :=mult_2_elem((x"0E"),end_ark(0,i)) xor mult_2_elem((x"0B"),end_ark(1,i)) xor mult_2_elem((x"0D"),end_ark(2,i)) xor mult_2_elem((x"09"),end_ark(3,i));
		a_state(1,i) :=mult_2_elem((x"09"),end_ark(0,i)) xor mult_2_elem((x"0E"),end_ark(1,i)) xor mult_2_elem((x"0B"),end_ark(2,i)) xor mult_2_elem((x"0D"),end_ark(3,i));
		a_state(2,i) :=mult_2_elem((x"0D"),end_ark(0,i)) xor mult_2_elem((x"09"),end_ark(1,i)) xor mult_2_elem((x"0E"),end_ark(2,i)) xor mult_2_elem((x"0B"),end_ark(3,i));
		a_state(3,i) :=mult_2_elem((x"0B"),end_ark(0,i)) xor mult_2_elem((x"0D"),end_ark(1,i)) xor mult_2_elem((x"09"),end_ark(2,i)) xor mult_2_elem((x"0E"),end_ark(3,i));
	end loop;	
	return a_state;
	
	
end function;




end package_dechiffrement;
