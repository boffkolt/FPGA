library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	generic(
	WIDTH_ADR	:	integer range 0 to 100 := 15;
	WIDTH_DATA	:	integer range 0 to 100:= 1);
	port
	(
		addr	: in std_logic_vector(WIDTH_ADR-1 downto 0);
	--	str	: in std_logic_vector(WIDTH_STR-1 downto 0);
		clk		: in std_logic;
		q		: out std_logic_vector (WIDTH_DATA-1 downto 0)
	);
	
end entity;

architecture rtl of rom is
constant NUM_WORDS : integer := (2**WIDTH_ADR)-1;
--constant NUM_STR : integer := (2**WIDTH_STR)-1;
	-- Build a 2-D array type for the RoM
	subtype word_t is std_logic_vector(WIDTH_DATA-1 downto 0);
	type memory_t is array(NUM_WORDS downto 0) of word_t;

		
	

	-- Declare the ROM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t := (
										(others =>(others => '1')));
	
begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			q <= rom(to_integer(unsigned(addr)));
		end if;
	end process;
		
end rtl;
