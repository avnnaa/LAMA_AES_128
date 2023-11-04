--	  ________  ________  ________  ___  __    ________  ________  _______           ________  _______   ________           _________  ________     
--	 |\   __  \|\   __  \|\   ____\|\  \|\  \ |\   __  \|\   ____\|\  ___ \         |\   __  \|\  ___ \ |\   ____\         |\___   ___\\   __  \    
--	 \ \  \|\  \ \  \|\  \ \  \___|\ \  \/  /|\ \  \|\  \ \  \___|\ \   __/|        \ \  \|\  \ \   __/|\ \  \___|_        \|___ \  \_\ \  \|\ /_   
--	  \ \   ____\ \   __  \ \  \    \ \   ___  \ \   __  \ \  \  __\ \  \_|/__       \ \   __  \ \  \_|/_\ \_____  \            \ \  \ \ \   __  \  
--	   \ \  \___|\ \  \ \  \ \  \____\ \  \\ \  \ \  \ \  \ \  \|\  \ \  \_|\ \       \ \  \ \  \ \  \_|\ \|____|\  \            \ \  \ \ \  \|\  \ 
--	    \ \__\    \ \__\ \__\ \_______\ \__\\ \__\ \__\ \__\ \_______\ \_______\       \ \__\ \__\ \_______\____\_\  \            \ \__\ \ \_______\
--	     \|__|     \|__|\|__|\|_______|\|__| \|__|\|__|\|__|\|_______|\|_______|        \|__|\|__|\|_______|\_________\            \|__|  \|_______|
--	                                                                                                       \|_________|                             
                                                                                                                                          
-----------------------------------------------------
-- testbench dechiffrement
-----------------------------------------------------
-- Auteur : Groupe LAMA
-- Date   : fevrier 2023
------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.my_package.all;
use work.package_dechiffrement.all;


entity tb_dechiffrement is
end tb_dechiffrement;

architecture arch of tb_dechiffrement is

  constant Nbit : positive :=128;
  constant byte : positive :=8;
  
  signal a_InvShiftRow, res_InvShiftRow : array_state;
  signal ok_InvShiftRow : array_state;
  signal test_InvShiftRow : std_logic;
  
  signal a_AddRoundKey, key_AddRoundKey,res_AddRoundKey, ok_AddRoundKey : vector_state;
  signal test_AddRoundKey : std_logic;

  signal a_InvMixColumns,res_InvMixColumns : array_state;
  signal ok_InvMixColumns : vector_state;
  signal test_InvMixColumns : std_logic;
  
  begin
	
	process
	begin

		test_InvShiftRow <= '0';
		wait for 10 ns;
		test_AddRoundKey <= '0';
		wait for 10 ns;
		test_InvMixColumns <= '0';
		wait for 10 ns;

		--Test InvShiftRow--
		
		-- Creation de la valeur qui contient le resultat attendu
		
		-----Matrice d'entree-------
		
		--  0  1  2  3
		--  3  0  1  2
		--  2  3  0  1
		--  1  2  3  0
		
		-------------------
		for i in 0 to  3 loop
			ok_InvShiftRow(0,i) <= std_logic_vector(to_unsigned(i,byte));
		end loop;
		wait for 10 ns;
		
		ok_InvShiftRow(1,0) <= std_logic_vector(to_unsigned(3,byte));
		ok_InvShiftRow(1,1) <= std_logic_vector(to_unsigned(0,byte));
		ok_InvShiftRow(1,2) <= std_logic_vector(to_unsigned(1,byte));
		ok_InvShiftRow(1,3) <= std_logic_vector(to_unsigned(2,byte));
		ok_InvShiftRow(2,0) <= std_logic_vector(to_unsigned(2,byte));
		ok_InvShiftRow(2,1) <= std_logic_vector(to_unsigned(3,byte));
		ok_InvShiftRow(2,2) <= std_logic_vector(to_unsigned(0,byte));
		ok_InvShiftRow(2,3) <= std_logic_vector(to_unsigned(1,byte));
		ok_InvShiftRow(3,0) <= std_logic_vector(to_unsigned(1,byte));
		ok_InvShiftRow(3,1) <= std_logic_vector(to_unsigned(2,byte));
		ok_InvShiftRow(3,2) <= std_logic_vector(to_unsigned(3,byte));
		ok_InvShiftRow(3,3) <= std_logic_vector(to_unsigned(0,byte));
		
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				a_InvShiftRow(i,j) <= std_logic_vector(to_unsigned(j,byte));  
			end loop;
		end loop;
		wait for 10 ns;
		
		res_InvShiftRow <= create_array_state(InvShiftRow(a_InvShiftRow));

		wait for 30 ns;
		
		--Verification du resultat
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				if ok_InvShiftRow(i,j) = res_InvShiftRow(i,j) then
					test_invShiftRow <= '1';
					wait for 10 ns;
				else 
					test_invShiftRow <= '0';
					wait for 10 ns;
					exit;
				end if;
			end loop;
			exit when test_invShiftRow = '0';
		end loop;
		
		
		
		
		--Test addRoundKey--
		
		-- Utilisation des valeurs de l'example dans la Spec (cf. p34)
		
		a_AddRoundKey <= X"3243F6A8885A308D313198A2E0370734";
		wait for 10 ns;
		key_AddRoundKey <= X"2B7E151628AED2A6ABF7158809CF4F3C";
		wait for 10 ns;
		res_AddRoundKey <= addRoundKey(a_AddRoundKey,key_AddRoundKey);
		wait for 10 ns;
		ok_AddRoundKey <= X"193DE3BEA0F4E22B9AC68D2AE9F84808";
		wait for 10 ns;
		
		--Verification du resultat
		if res_AddRoundKey = ok_AddRoundKey then 
			test_AddRoundKey <= '1';
		else 
			test_AddRoundKey <= '0';
		end if;
		wait for 10 ns;

		--Test invMixColumns--
		
		-- Test #1
		-- On prend comme entrée le state suivant
		
		-----Matrice d'entree-------
		
		--  0  1  2  3
		--  0  1  2  3
		--  0  1  2  3
		--  0  1  2  3
		
		----------------------------
		--for i in 0 to 3 loop
		--	for j in 0 to 3 loop
		--		a_InvMixColumns(i,j) <= std_logic_vector(to_unsigned(j,byte));  
		--	end loop;
		--end loop;
		--wait for 10 ns;
		
		--ok_InvMixColumns(0,0) <= mult_2_elem(x"0E",a_InvMixColumns(0,0) XOR mult_2_elem(x"0B",a_InvMixColumns(1,0) XOR mult_2_elem(x"0D",a_InvMixColumns(2,0) XOR mult_2_elem(x"09",a_InvMixColumns(3,0);
		--ok_InvMixColumns(0,1) <= mult_2_elem(x"0E",a_InvMixColumns(0,1) XOR mult_2_elem(x"0B",a_InvMixColumns(1,1) XOR mult_2_elem(x"0D",a_InvMixColumns(2,1) XOR mult_2_elem(x"09",a_InvMixColumns(3,1);
		--ok_InvMixColumns(0,2) <= mult_2_elem(x"0E",a_InvMixColumns(0,2) XOR mult_2_elem(x"0B",a_InvMixColumns(1,2) XOR mult_2_elem(x"0D",a_InvMixColumns(2,2) XOR mult_2_elem(x"09",a_InvMixColumns(3,2);
		--ok_InvMixColumns(0,3) <= mult_2_elem(x"0E",a_InvMixColumns(0,3) XOR mult_2_elem(x"0B",a_InvMixColumns(1,3) XOR mult_2_elem(x"0D",a_InvMixColumns(2,3) XOR mult_2_elem(x"09",a_InvMixColumns(3,3);
		--
		--ok_InvMixColumns(1,0) <= mult_2_elem(x"09",a_InvMixColumns(0,0) XOR mult_2_elem(x"0E",a_InvMixColumns(1,0) XOR mult_2_elem(x"0B",a_InvMixColumns(2,0) XOR mult_2_elem(x"0D",a_InvMixColumns(3,0);
		--ok_InvMixColumns(1,1) <= mult_2_elem(x"09",a_InvMixColumns(0,1) XOR mult_2_elem(x"0E",a_InvMixColumns(1,1) XOR mult_2_elem(x"0B",a_InvMixColumns(2,1) XOR mult_2_elem(x"0D",a_InvMixColumns(3,1);
		--ok_InvMixColumns(1,2) <= mult_2_elem(x"09",a_InvMixColumns(0,2) XOR mult_2_elem(x"0E",a_InvMixColumns(1,2) XOR mult_2_elem(x"0B",a_InvMixColumns(2,2) XOR mult_2_elem(x"0D",a_InvMixColumns(3,2);
		--ok_InvMixColumns(1,3) <= mult_2_elem(x"09",a_InvMixColumns(0,3) XOR mult_2_elem(x"0E",a_InvMixColumns(1,3) XOR mult_2_elem(x"0B",a_InvMixColumns(2,3) XOR mult_2_elem(x"0D",a_InvMixColumns(3,3);		
		--
		--ok_InvMixColumns(2,0) <= mult_2_elem(x"0D",a_InvMixColumns(0,0) XOR mult_2_elem(x"09",a_InvMixColumns(1,0) XOR mult_2_elem(x"0E",a_InvMixColumns(2,0) XOR mult_2_elem(x"0B",a_InvMixColumns(3,0);
		--ok_InvMixColumns(2,1) <= mult_2_elem(x"0D",a_InvMixColumns(0,1) XOR mult_2_elem(x"09",a_InvMixColumns(1,1) XOR mult_2_elem(x"0E",a_InvMixColumns(2,1) XOR mult_2_elem(x"0B",a_InvMixColumns(3,1);
		--ok_InvMixColumns(2,2) <= mult_2_elem(x"0D",a_InvMixColumns(0,2) XOR mult_2_elem(x"09",a_InvMixColumns(1,2) XOR mult_2_elem(x"0E",a_InvMixColumns(2,2) XOR mult_2_elem(x"0B",a_InvMixColumns(3,2);
		--ok_InvMixColumns(2,3) <= mult_2_elem(x"0D",a_InvMixColumns(0,3) XOR mult_2_elem(x"09",a_InvMixColumns(1,3) XOR mult_2_elem(x"0E",a_InvMixColumns(2,3) XOR mult_2_elem(x"0B",a_InvMixColumns(3,3);
		--
		--ok_InvMixColumns(3,0) <= mult_2_elem(x"0B",a_InvMixColumns(0,0) XOR mult_2_elem(x"0D",a_InvMixColumns(1,0) XOR mult_2_elem(x"09",a_InvMixColumns(2,0) XOR mult_2_elem(x"0E",a_InvMixColumns(3,0);
		--ok_InvMixColumns(3,1) <= mult_2_elem(x"0B",a_InvMixColumns(0,1) XOR mult_2_elem(x"0D",a_InvMixColumns(1,1) XOR mult_2_elem(x"09",a_InvMixColumns(2,1) XOR mult_2_elem(x"0E",a_InvMixColumns(3,1);
		--ok_InvMixColumns(3,2) <= mult_2_elem(x"0B",a_InvMixColumns(0,2) XOR mult_2_elem(x"0D",a_InvMixColumns(1,2) XOR mult_2_elem(x"09",a_InvMixColumns(2,2) XOR mult_2_elem(x"0E",a_InvMixColumns(3,2);
		--ok_InvMixColumns(3,3) <= mult_2_elem(x"0B",a_InvMixColumns(0,3) XOR mult_2_elem(x"0D",a_InvMixColumns(1,3) XOR mult_2_elem(x"09",a_InvMixColumns(2,3) XOR mult_2_elem(x"0E",a_InvMixColumns(3,3);
		
		--Test #2
		-- La matrice d'entree et le resultat attendu sont tires de la video de Chirag Bhalodia
		
		-----Matrice d'entrée------
		
		--  47 40 A3 4C
		--  37 D4 70 9F
		--  94 E4 3A 42
		--  ED A5 A6 BC

		----------------------------
		
		a_InvMixColumns <= create_array_state(x"473794ED40D4E4A5A3703AA64C9F42BC");
		wait for 10 ns;
		
		-- Resultat attendue 
		
		-----Matrice de sortie------
		
		--  87 F2 4D 97
		--  6E 4C 90 EC
		--  46 E7 4A C3
		--  A6 8C D8 95

		----------------------------
		ok_InvMixColumns <= x"876E46A6F24CE78C4D904AD897ECC395";
		wait for 10 ns;
		
		--Verification du resultat
		res_InvMixColumns <= invMixColumns(a_InvMixColumns);
		wait for 10 ns;
		if (ok_InvMixColumns = create_vector_state(res_InvMixColumns)) then 
			test_InvMixColumns <= '1';
		end if;
		
		wait for 10 ns;
		
		if (test_InvShiftRow ='1') then
			report "La fonction InvShiftRow fonctionne !" severity NOTE;
		else
			report "La fonction InvShiftRow ne fonctionne pas !" severity ERROR;
		end if;

		if (test_AddRoundKey ='1') then
			report "La fonction addRoundKey fonctionne !" severity NOTE;
		else
			report "La fonction addRoundKey ne fonctionne pas !" severity ERROR;
		end if;
		
		if (test_InvMixColumns ='1') then
			report "La fonction invMixColumns fonctionne !" severity NOTE;
		else
			report "La fonction invMixColumns ne fonctionne pas !" severity ERROR;
		end if;
		
		wait;
	end process;

end architecture arch;



