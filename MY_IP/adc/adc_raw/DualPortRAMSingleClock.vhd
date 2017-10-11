library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity DualPortRAMSingleClock is
	generic
	(
		WIDTH_DATA : integer range 1 to 256 := 8;	-- Разрядность данных
		WIDTH_ADDR : integer range 1 to 256 := 8;	-- Разрядность адреса
		NUM_DATA : integer range 1 to 65536 := 256	-- Количество слов
	);
	port 
	(	
		in_std_clk : in std_logic;
		
		-- Порт A
		in_stdX_data_a	: in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_stdY_addr_a	: in std_logic_vector (WIDTH_ADDR-1 downto 0);
		in_std_we_a	: in std_logic := '0';
		out_stdX_q_a		: out std_logic_vector(WIDTH_DATA-1 downto 0);
		
		-- Порт B
		in_stdX_data_b	: in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_stdY_addr_b	: in std_logic_vector (WIDTH_ADDR-1 downto 0);
		in_std_we_b	: in std_logic := '0';
		out_stdX_q_b : out std_logic_vector(WIDTH_DATA-1 downto 0)
	);
	
end DualPortRAMSingleClock;

architecture rtl of DualPortRAMSingleClock is
	
	-- Определение типов данных массива памяти
	subtype word_t is std_logic_vector(WIDTH_DATA-1 downto 0);
	type memory_t is array(0 to NUM_DATA-1) of word_t;
	
	-- Объявление массива памяти типа RAM
	shared variable var_memory_t_ram : memory_t;
	
	signal sig_n_addr_a : integer range 0 to NUM_DATA-1;
	signal sig_n_addr_b : integer range 0 to NUM_DATA-1;

begin

	sig_n_addr_a <= to_integer(unsigned(in_stdY_addr_a));
	sig_n_addr_b <= to_integer(unsigned(in_stdY_addr_b));

	-- Порт A
	process(in_std_clk)
	begin
		if in_std_clk'event and in_std_clk = '1' then 
			if in_std_we_a = '1' then
				var_memory_t_ram(sig_n_addr_a) := in_stdX_data_a;
			end if;
			out_stdX_q_a <= var_memory_t_ram(sig_n_addr_a);
		end if;
	end process;
	
	-- Порт B
	process(in_std_clk)
	begin
		if in_std_clk'event and in_std_clk = '1' then
			if in_std_we_b = '1' then
				var_memory_t_ram(sig_n_addr_b) := in_stdX_data_b;
			end if;
			out_stdX_q_b <= var_memory_t_ram(sig_n_addr_b);
		end if;
	end process;
end rtl;
