--	  ________  ________  ________  ___  __    ________  ________  _______           ________  _______   ________      
--	 |\   __  \|\   __  \|\   ____\|\  \|\  \ |\   __  \|\   ____\|\  ___ \         |\   __  \|\  ___ \ |\   ____\     
--	 \ \  \|\  \ \  \|\  \ \  \___|\ \  \/  /|\ \  \|\  \ \  \___|\ \   __/|        \ \  \|\  \ \   __/|\ \  \___|_    
--	  \ \   ____\ \   __  \ \  \    \ \   ___  \ \   __  \ \  \  __\ \  \_|/__       \ \   __  \ \  \_|/_\ \_____  \   
--	   \ \  \___|\ \  \ \  \ \  \____\ \  \\ \  \ \  \ \  \ \  \|\  \ \  \_|\ \       \ \  \ \  \ \  \_|\ \|____|\  \  
--	    \ \__\    \ \__\ \__\ \_______\ \__\\ \__\ \__\ \__\ \_______\ \_______\       \ \__\ \__\ \_______\____\_\  \ 
--	     \|__|     \|__|\|__|\|_______|\|__| \|__|\|__|\|__|\|_______|\|_______|        \|__|\|__|\|_______|\_________\
--	                                                                                                      \|_________|                                                                                                     \|_________|                             
                                                                                                                                          
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;
use work.package_dechiffrement.all;

entity dechiffrement_pipeline is 
	
	generic (
		constant Nbit : positive :=128
	);
	
	port(
	
		resetn  : in std_logic;
		clk		: in std_logic;
		state   : in std_logic_vector (Nbit-1 downto 0);
		flag    : in std_logic;
		key 	: in std_logic_vector ((Nbit)*11-1 downto 0);
		out_data: out std_logic_vector (Nbit-1 downto 0)
	);
	

end entity;

architecture arch of dechiffrement_pipeline is

	type regkey is array  (0 to 10) of std_logic_vector (Nbit-1 downto 0);
	type romAddr is array (0 to 9,0 to 15) of std_logic_vector (7 downto 0);
	type romData is array (0 to 9,0 to 15) of std_logic_vector (7 downto 0);
	type varRound   is array (natural range <>) of std_logic_vector(Nbit-1 downto 0);
	signal cpt : natural range 0 to 9;
	
	signal reg_key : regKey;
	constant zero_byte : std_logic_vector(7 downto 0) :=(others =>'0');
	constant zero_state : vector_state := (others =>'0');--std_logic_vector(Nbit-1 downto 0) :=(others =>'0');
	signal reg_state : vector_state;--std_logic_vector(Nbit-1 downto 0);

	signal data_out : romData;	
	signal addr     : romAddr;
	signal en 	    : std_logic;

	signal end_xor_sig, vector_state_debut_sig, vector_state_i_sig, vector_state_end_sig, rom_data_out_i_sig,rom_data_out_end_sig : vector_state;
	signal array_state_i_sig, end_round_sig,array_state_end_sig : array_state;										 
									  
	--Approche avec batterie registre
	signal reg_end_xor : varRound(0 to 8); --9
	signal end_invShiftRow : varRound (0 to 9); --10
	signal end_addRoundKey : varRound(0 to 9);  --10
	signal reg_end_round : varRound(0 to 8); --9
	signal round_final : std_logic_vector(Nbit-1 downto 0);
	signal reg_out_data : std_logic_vector(Nbit-1 downto 0);
	begin
	
	
	MEMO_KEY_STATE : process(clk,resetn,flag) is 
	begin
	
		if resetn ='0' then
			reg_state <= zero_state;
			
			for i in 10 downto 0 loop
			
				reg_key(i) <= zero_state;
				
				
			end loop;
			
			
		elsif rising_edge(clk) then
		
			reg_state <= state;
			
			for i in 10 downto 0 loop
				reg_key(i) <= key((Nbit*(i)+Nbit-1) downto Nbit*i);
			end loop;
			
		end if;
	end process;
	
	--compteur: process (clk,resetn) is
	--begin 
	--	
	--	if resetn ='0' then
	--		cpt <= 8;
	--		
	--	elsif rising_edge(clk) then
	--		
	--		if cpt =< 0 then
	--			cpt <= 8;
	--		else
	--			cpt <= cpt-1;
	--		end if;
	--	
	--	end if;
	--
	--end process;
	
	
	ROUNDS: process(clk,flag) is
	variable u,v: integer;
	variable varVectorState, var_end_Round : vector_state;
	variable varArrayState : array_state;
	begin
	

		--Pour chaque tour on definit la valeur de end_xor à partir du end_round precedent
		--#####################################
			--Tour 9
		reg_end_xor(8) <= addRoundKey(reg_state,reg_key(10));
		
			--Tour intermediaires
		
		for round in 7 downto 0 loop -- Round = 7 <=> tour 8
		
				reg_end_xor(round)  <=  reg_end_round(round+1);			
			
		end loop;
		
			--Tour 0
		round_final <= reg_end_round(0);
		--#############################################
		
		
		
		
		--Insertion de l'adresse pour la invSbox 10 du round 10




		--On ecrit sur toutes les addr (pour les 10 derniers rounds) les valeurs voulues
		for round in 9 downto 0 loop
		
			--Tour 9
			if round = 9 then 
				end_invShiftRow(round) <= invShiftRow(create_array_state(reg_end_xor(8)));
			
			elsif round <9 and round > 0 then
				end_invShiftRow(round) <= invShiftRow(create_array_state(reg_end_xor(round-1)));
				
			else
				end_invShiftRow(round) <= invShiftRow(create_array_state(round_final));
			end if;
			for byte in 15 downto 0 loop 
				addr(round,byte) <= end_invShiftRow(round)(8*Nbit-1 downto 8*Nbit);
			end loop;
		end loop;
		
		
		if rising_edge(clk) then
		
			
			
				--Pour chaque invSbox on recupere la donnee, on la traite puis on l'envoi au round suivant
			for round in 9 downto 0 loop
			
				--On recupère les 16 valeurs du state pour un round dans une variable car process synchrone
				for i in 15 downto 0 loop
				
					varVectorState(8*(i+1)-1 downto i*8) :=data_out(round,i);
				end loop;
				
				
				
				if round /= 0 then
				
					
					if flag = '1' then
						varVectorState:=addRoundKey(varVectorState,reg_key(round));
					else
						varVectorState:=addRoundKey(varVectorState,zero_state);
					end if;
					varArrayState:= invMixColumns(create_array_state(varVectorState));
					
					--end_round_sig <= varArrayState;
					reg_end_round(round) <= create_vector_state(varArrayState);
				
				else 
				
					if flag ='1' then
					
						varVectorState := addRoundKey(varVectorState,reg_key(round));
					else	
						varVectorState := addRoundKey(varVectorState,zero_state);
					end if;
						reg_out_data <= varVectorState;
				end if;
				
			end loop;
			
			out_data <= reg_out_data;
		
		end if;
		
	end process;
	
--	in : process (
--		for i in 7 downto 0 loop 
--		
--			reg_end_xor((i+1)*Nbit-1 downto i*Nbit) <= reg_end_round((i+1)*Nbit
--		
--		end loop
--		
--		
--		if cpt /=0 then
--			varArrayState:=invMixColumns(create_array_state(varVectorState));
--			end_xor := create_vector_state(varArrayState);
--		else
--			varVectorState := invShiftRow(end_xor);
--			for i in 15 downto 0 loop
--				addr(i) <= varVectorState(8*(i+1)-1 downto 8*i);
--			end loop;
--		end if;
--		for i in 15 downto 0 loop
--			addr(i) <= vector_state_i_sig(8*(i+1)-1 downto 8*i);
--		end loop;
--		
--		if rising_edge(clk) then
--			
--			--if cpt /= 0 then
--				for i in 15 downto 0 loop
--					vector_state_i_sig(8*(i+1)-1 downto 8*i) <= data_out(i);
--				end loop;
--				
--				if flag ='1' then
--					
--					varVectorState:=addRoundKey(vector_state_i_sig,reg_key(cpt));
--				else
--					varVectorState:=addRoundKey(vector_state_i_sig,zero_state);
--					
--				end if;
--				
--				out_data <= varVectorState
--			
--			else
--			
--				
--			
--			
--			
--			
--		end if;
--		
--		
--		
--		
--		
--	
--	
--	end process;
	
--	process (clk, resetn, flag) is 
--	
--	--DÃ©claration de variable
--	variable end_xor, vector_state_i, vector_state_end, rom_data_out_i,rom_data_out_end : vector_state;
--	variable array_state_i, end_round,array_state_end : array_state;
--	variable u,v: integer;
--	variable i : natural range 0 to 15;
--	
--	begin
--		if resetn = '0' then 
--			reg_state <= zero_state;
--			out_data <= zero_state;
--			en <= '0';
--			i := 15;
--			for i in 10 downto 0 loop
--				reg_key(i) <= zero_state;
--				addr(i) <= (others => '0');
--			end loop;
--		elsif rising_edge(clk) then
--			if flag ='1' then
--				-- Memorisation
--				reg_state <= state; -- OK
--				en <= '1';
--				for round in 10 downto 0 loop
--					reg_key(round) <= key((Nbit*(round)+Nbit-1) downto Nbit*round); -- OK
--							
--				-- Round 10 (initial)
--					if round = 10 then
--						end_xor := addRoundKey(reg_state,reg_key(round));
--						end_xor_sig <= end_xor;
--						vector_state_i := end_xor;
--	
--				-- Round 9 au  1 (intermediaires)
--					elsif round< 10 and round > 0 then
--						array_state_i := create_array_state(vector_state_i);
--						array_state_i_sig <= array_state_i;
--						
--						--invShiftRow
--						vector_state_i:=invShiftRow(array_state_i);
--	
--						--invSubByte
--						
--						for i in  15 downto 0 loop
--							addr(i)  <= vector_state_i(8*(i)+7 downto 8*i);
--							rom_data_out_i(8*(i)+7 downto 8*i) := data_out(i);
--						end loop;
--						
--	
--				
--						--Fonction addRoundKey
--						if flag='1' then 
--							vector_state_i := addRoundKey(rom_data_out_i,reg_key(round));
--						else 
--							vector_state_i := addRoundKey(rom_data_out_i,(others=>'0'));
--						end if;
--						--Fonction invMixColumns
--						array_state_i  := create_array_state(vector_state_i);
--						array_state_i  := invMixColumns(array_state_i);
--						vector_state_i := create_vector_state(array_state_i);
--					
--					else 
--					
--					-- Dernier round
--						end_round := create_array_state(vector_state_i);
--						
--						--Fonctionn invShiftRow
--						vector_state_end:=invShiftRow(end_round);
--						
--						
--						for i in  15 downto 0 loop
--							addr(i)  <= vector_state_i(8*(i)+7 downto 8*i);
--							rom_data_out_i(8*(i)+7 downto 8*i) := data_out(i);
--						end loop;
--						
--						
--						
--						--Fonction addRoundKey
--						out_data <= addRoundKey(rom_data_out_end,reg_key(round));
--						
--						
--					
--					end if;
--					
--				
--				end loop;	
--				
--			end if;
--		end if;
--		
--	
--	end process;
--	
--	
	tableau_round_invsbox: for round in 9 downto 0 generate
		invsbox: for i in 15 downto 0 generate
		rom_inSbox: entity work.rom_invsbox 
						port map(
						
							clk => clk,
							addr =>addr(round,i),
							en  => flag,
							data_out => data_out(round,i)
							);
		end generate;
	end generate;
						
						
	
	


end architecture;


-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use work.my_package.all;
-- use work.my_package_2.all; 
-- use work.package_dechiffrement.all;

-- entity dechiffrement is
  -- generic (
    -- constant Nbit : positive := 128
  -- );
  -- port(
    -- resetn   : in std_logic;
    -- clk      : in std_logic;
    -- state    : in std_logic_vector(Nbit-1 downto 0);
    -- flag     : in integer;
    -- key      : in std_logic_vector((Nbit*11)-1 downto 0);
    -- out_data : out std_logic_vector(Nbit-1 downto 0)
  -- );
-- end entity;

-- architecture arch of dechiffrement is
  -- type regkey is array (0 to 10) of std_logic_vector(Nbit-1 downto 0);
  -- signal reg_key : regkey;
  -- constant zero_byte : std_logic_vector(Nbit-1 downto 0) := (others =>'0');
  -- signal reg_state : std_logic_vector(Nbit-1 downto 0);
  -- signal data_out : std_logic_vector((16*Nbit)-1 downto 0);
  -- signal addr : std_logic_vector((16*Nbit)-1 downto 0);
  -- signal en : std_logic;

-- begin

  -- process (clk, resetn, flag) is
    -- variable end_xor, vector_state_i, vector_state_end, rom_data_out_i, rom_data_out_end : std_logic_vector(Nbit-1 downto 0);
    -- variable array_state_i, end_round, array_state_end : array_state;
  -- begin
    -- if resetn = '0' then
      -- reg_state <= zero_byte;
      -- for i in 10 downto 0 loop
        -- reg_key(i) <= zero_byte;
      -- end loop;
    -- elsif rising_edge(clk) then
      -- reg_state <= state;
      -- for round in 10 downto 0 loop
        -- reg_key(round) <= key((Nbit*(round+1)) downto Nbit*round);
        -- if round = 10 then
          -- if flag = 1 then
            -- end_xor := addRoundKey(reg_state,reg_key(round));
          -- else
            -- end_xor := addRoundKey(reg_state,zero_byte);
          -- end if;
          -- vector_state_i := end_xor;
        -- elsif round < 10 and round > 0 then
          -- array_state_i := create_array_state(vector_state_i);                  	 --
          -- vector_state_i := invShiftRow(array_state_i);
          -- en <= '1';
          -- addr <= vector_state_i;
          -- rom_data_out_i := data_out;
          -- en <= '0';
          -- if flag=1 then
            -- vector_state_i := addRoundKey(rom_data_out_i,reg_key(round));
          -- else
            -- vector_state_i := addRoundKey(rom_data_out_i,(others=>'0'));
          -- end if;
          -- array_state_i  := create_array_state(vector_state_i);				--
          -- array_state_i  := invMixColumns(array_state_i);
          -- vector_state_i := create_vector_state(array_state_i);				--
        -- else
          -- end_round := create_array_state(vector_state_i);				--
          -- vector_state_end := invShiftRow(end_round);
          -- en <= '1';
          -- addr <= vector_state_end;
          -- rom_data_out_end := data_out;
          -- en <= '0';
          -- if flag=1 then
            -- out_data <= addRoundKey(rom_data_out_end,reg_key(round));
          -- else
            -- out_data <= addRoundKey(rom_data_out_end,(others=>'0'));
          -- end if;
        -- end if;
      -- end loop;
    -- end if;
  -- end process;

  -- invsbox: for i in 15 downto 0 generate
    -- rom_inSbox: entity work.rom_invsbox
      -- port map(
        -- clk => clk,
        -- addr => addr(8*(i+1)-1 downto 8*i),
        -- en => en,
        -- data_out => data_out(8*(i+1)-1 downto 8*i)
      -- );
  -- end generate;
-- end architecture;

