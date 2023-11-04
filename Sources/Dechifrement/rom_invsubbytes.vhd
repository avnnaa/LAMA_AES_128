----------------------------------------------------
--    Rijndael : synchronous rom subbytes
----------------------------------------------------
-- ESIEE
-- creation     : A. Exertier, 12/2021
----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use work.galois_field.all;
-- use work.aes_package.all;

entity rom_invsbox is 	
  port(clk     : in  std_logic;
       address : in  std_logic_vector(7 downto 0);
       data    : out std_logic_vector(7 downto 0)
  );	     
end entity; 	    

architecture RTL of rom_invsbox is
  type t_memory   is array (0 to 2**gf_n-1) of t_gf_data;
  
  function table_invsubbytes  return t_memory is
    variable tmp       : t_memory;
    variable tmp_data  : t_gf_data;
  begin
    for i in 0 to 2**gf_n-1 loop
      tmp_data := std_logic_vector(to_unsigned(i,gf_n));
      tmp(i) := invsubbyte(tmp_data);
    end loop; 
    return tmp;
  end function;     
  
  constant memory_values : t_memory := table_invsubbytes;

begin   
  process(clk) is
  begin 
    if rising_edge(clk) then 
      data <= memory_values(to_integer(unsigned(address)));           
    end if;
  end process;
end architecture;
