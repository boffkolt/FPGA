library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dual_ram is
	generic	
	(
		WIDTH_DATA	:	natural range 0 to 32	:=	16;
		WIDTH_ADR	:	natural range 6 to 32	:=	6
	);
	port 
	(	
		data_a	: in std_logic_vector(WIDTH_DATA-1 downto 0);
		data_b	: in std_logic_vector(WIDTH_DATA-1 downto 0);
		addr_a	: in std_logic_vector(WIDTH_ADR-1 downto 0);
		addr_b	: in std_logic_vector(WIDTH_ADR-1 downto 0);
		we_a		: in std_logic := '1';
		we_b		: in std_logic := '1';
		clk_a		: in std_logic;
		clk_b		: in std_logic;
		q_a		: out std_logic_vector(WIDTH_DATA-1 downto 0);
		q_b		: out std_logic_vector(WIDTH_DATA-1 downto 0)
	);
	
end dual_ram;

architecture rtl of dual_ram is
	constant NUM_WORDS	:	natural 	:= (2**WIDTH_ADR)-1;
	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(WIDTH_DATA-1 downto 0);
	type memory_t is array(NUM_WORDS downto 0) of word_t;
	
	-- Declare the RAM
	shared variable ram : memory_t;

begin

	-- Port A
	process(clk_a)
	begin
		if(rising_edge(clk_a)) then 
			if(we_a = '1') then
				ram(to_integer(unsigned(addr_a))) := data_a;
			end if;
			q_a <= ram(to_integer(unsigned(addr_a)));
		end if;
	end process;
	
	-- Port B
	process(clk_b)
	begin
		if(rising_edge(clk_b)) then
			if(we_b = '1') then
				ram(to_integer(unsigned(addr_b)))	:= data_b;
			end if;
			q_b <= ram(to_integer(unsigned(addr_b)));
		end if;
	end process;
end rtl;

