library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SignedBufferAverage is
	generic
	(
		WIDTH_DATA : integer range 1 to 16 := 16;	-- Разрядность данных
		NUM_WORDS_BUF : integer range 1 to 500 := 8		-- Количество слов
	);
	port
	(
		-- // Clock port
		in_std_clk_100MHz : in std_logic;												-- Входная тактовая частота
		in_stdX_data : in std_logic_vector(WIDTH_DATA-1 downto 0);
		out_stdX_data : out std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std_start_strob : in std_logic;
		out_std_ready_data : out std_logic;
		in_std_ena : in std_logic															-- Разрешение работы блока
	);
end SignedBufferAverage;

architecture behave of SignedBufferAverage is

-- Определение типов данных массива памяти
subtype word_t is std_logic_vector(WIDTH_DATA-1 downto 0);
type memory_t is array(0 to NUM_WORDS_BUF-1) of word_t;
	-- Объявление массива памяти типа RAM
	signal sig_memory_t_ram : memory_t;


signal sig_std_first_run : std_logic := '0';
signal sig_std_start_strob : std_logic := '0';
signal sig_std_ready : std_logic := '0';
signal sig_int_counter_addr : integer range 0 to NUM_WORDS_BUF := 0;
signal sig_int_counter_step : integer range 0 to 5 := 0;
signal sig_sX_data : signed (WIDTH_DATA-1 downto 0) := to_signed(0, WIDTH_DATA);
signal sig_stdX_data_a : std_logic_vector (WIDTH_DATA-1 downto 0) := std_logic_vector(to_signed(0, WIDTH_DATA));
signal sig_int_data_sum : integer := 0;
signal sig_int_data : integer := 0;

begin

out_std_ready_data <= sig_std_ready;

--////////////////////////////////////////////////////////////////////////
--		Процесс тактирования входных данных											//
--////////////////////////////////////////////////////////////////////////
CLOCKING: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_std_start_strob <= '0';
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			sig_std_start_strob <= in_std_start_strob;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////
--		Процесс формирования счетчика шагов											//
--////////////////////////////////////////////////////////////////////////
CREATE_COUNTER_STEP: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_int_counter_step <= 0;
			sig_stdX_data_a <= std_logic_vector(to_unsigned(0, WIDTH_DATA));
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			if sig_int_counter_step < 5 then
				sig_int_counter_step <= sig_int_counter_step + 1;
			else
				if in_std_start_strob = '1' and sig_std_start_strob = '0' and sig_std_first_run = '1' then
					sig_int_counter_step <= 0;
					sig_stdX_data_a <= in_stdX_data;
				end if;
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////
--		Процесс усреднения данных														//
--////////////////////////////////////////////////////////////////////////
LOADING_BUF: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_std_first_run <= '0';
			sig_int_counter_addr <= 0;
			sig_sX_data <= to_signed(0, WIDTH_DATA);
			sig_int_data_sum <= 0;
			sig_int_data <= 0;
			sig_std_ready <= '0';
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			if sig_std_first_run = '0' then
				if sig_int_counter_addr < NUM_WORDS_BUF then
					sig_memory_t_ram(sig_int_counter_addr) <= std_logic_vector(to_signed(0, WIDTH_DATA));
					sig_int_counter_addr <= sig_int_counter_addr + 1;
					sig_std_ready <= '0';
				else
					sig_std_first_run <= '1';
					sig_std_ready <= '1';
				end if;
			else
				if in_std_start_strob = '1' and sig_std_start_strob = '0' then
					if sig_int_counter_addr = NUM_WORDS_BUF then
						sig_int_counter_addr <= 0;
					end if;
						sig_std_ready <= '0';
				end if;
				if sig_int_counter_step = 0 then
					sig_int_data_sum <= sig_int_data_sum - to_integer(signed(sig_memory_t_ram(sig_int_counter_addr)));
					sig_std_ready <= '0';
				elsif sig_int_counter_step = 1 then
					sig_std_ready <= '0';
					sig_int_data_sum <= sig_int_data_sum + to_integer(signed(sig_stdX_data_a));
					sig_memory_t_ram(sig_int_counter_addr) <= sig_stdX_data_a;
				elsif sig_int_counter_step = 2 then
					sig_std_ready <= '0';
					sig_int_data <= sig_int_data_sum / NUM_WORDS_BUF;
					if sig_int_counter_addr < NUM_WORDS_BUF then
						sig_int_counter_addr <= sig_int_counter_addr + 1;
					end if;
				elsif sig_int_counter_step = 3 then
					sig_std_ready <= '0';
					sig_sX_data <= to_signed(sig_int_data, WIDTH_DATA);
				elsif sig_int_counter_step = 4 then
					sig_std_ready <= '1';
				end if;
			end if;
			out_stdX_data <= std_logic_vector(sig_sX_data);
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

end behave;
