library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_rom is

	port
	(
		addr	: in natural range 0 to 255;
		clk		: in std_logic;
		q		: out std_logic_vector(7 downto 0)
	);
	
end entity;

architecture rtl of single_port_rom is

	-- Build a 2-D array type for the RoM
	subtype word_t is std_logic_vector(7 downto 0);
	type memory_t is array(255 downto 0) of word_t;
		
	
	-- Declare the ROM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t ;
	
begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			q <= rom(addr);
		end if;
	end process;
		
end rtl;
