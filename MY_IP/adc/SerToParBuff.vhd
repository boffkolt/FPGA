Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.numeric_std.all;

Entity SerToParBuff is
	generic
	(
		WIDTH_DATA : integer range 2 to 32 := 16											-- Разрядность буфера
	);
	port
	(
		in_std_clk_100MHz : in std_logic;													-- Входная тактовая частота
		in_std_sclk : in std_logic;															-- Частота сдвига
		in_std_start_strob : in std_logic;													-- Сигнал начала преобразования
		in_std_ser_data : in std_logic;														-- Вход последовательных данных
		out_stdX_par_data : out std_logic_vector (WIDTH_DATA-1 downto 0);			-- Выход параллельных данных
		out_std_ready_data : out std_logic;													-- Сигнал завершения преобразования
		in_std_ena : in std_logic																-- Разрешение работы блока
	);
end SerToParBuff;

Architecture behave of SerToParBuff is

signal sig_std_start_strob : std_logic;
signal sig_std_sclk : std_logic;
signal sig_std_start_block : std_logic;
signal sig_int_counter_data_bit : integer range 0 to WIDTH_DATA := 0;
signal sig_stdX_par_data : std_logic_vector (WIDTH_DATA-1 downto 0);

begin

--////////////////////////////////////////////////////////////////////////
--		Процесс тактирования входных данных											//
--////////////////////////////////////////////////////////////////////////
CLOCKING: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_std_start_strob <= '0';
			sig_std_sclk <= '0';
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			sig_std_start_strob <= in_std_start_strob;
			sig_std_sclk <= in_std_sclk;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////////////
--		Процесс формирования счетчика бит и преобразования данных			//
--////////////////////////////////////////////////////////////////////////
CREATE_COUNTER: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_int_counter_data_bit <= 0;
			out_std_ready_data <= '0';
			sig_stdX_par_data <= std_logic_vector(to_unsigned(0, WIDTH_DATA));
			sig_std_start_block <= '0';
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			if sig_std_start_block = '0' then
				sig_int_counter_data_bit <= WIDTH_DATA;
				sig_std_start_block <= '1';
			else
				if sig_int_counter_data_bit = WIDTH_DATA then
					if in_std_start_strob = '1' and sig_std_start_strob = '0' then
						sig_int_counter_data_bit <= 0;
					end if;
					out_std_ready_data <= '1';
					out_stdX_par_data <= sig_stdX_par_data;
				else
					if in_std_sclk = '1' and sig_std_sclk = '0' then
						sig_int_counter_data_bit <= sig_int_counter_data_bit + 1;
						sig_stdX_par_data(WIDTH_DATA-sig_int_counter_data_bit-1) <= in_std_ser_data;
					end if;
					out_std_ready_data <= '0';
				end if;
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////


end behave;