
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity key_array is   
  port(
    clk     : in  std_logic;
	Gen_Key : in integer;
    key_in  : in  std_logic_vector(127 downto 0);
    data    : out std_logic_vector(7 downto 0)
  );       
end entity;       

architecture RTL of key_array is
  subtype byte is std_logic_vector (7 downto 0);
  type memory  is array (255 downto 0) of byte;


begin 
  
  process(clk) is
  begin 
    if rising_edge(clk) then 
      data<= memory_values(to_integer(unsigned(address)));           
    end if;
  end process;
  
end architecture;
