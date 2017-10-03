library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


use work.my_types.all;


entity ADS8861 is
	generic
	(
		NUM_ADC 		: integer range 1 to 32 := 2;
		NUM_WORDS_BUF	: integer range 1 to 32 := 8;
		WIDTH_DATA 		: integer range 16 to 16 := 16;	-- Разрядность данных
		TIME_CONV 		: integer range 0 to 80 := 80;		-- Время паузы между стартом конверсии и считыванием данных
		CLK_DEVIDER 	: integer range 0 to 7 := 0		-- Делитель тактовой частоты clk / (2^(CLK_DEVIDER+1))
	);
	port
	(
		-- // Clock port
		in_std_clk_100MHz : in std_logic;												-- Входная тактовая частота
		-- // АЦП port
		in_std_adc_sdata : in std_logic_vector(0 to NUM_ADC-1);					-- Последовательные данные от АЦП
		out_std_adc_clk : out std_logic;													-- Тактовая частота для АЦП
		out_std_adc_cnv : out std_logic;													-- Запуск конвертирования АЦП
		
		-- // Other port
		in_std_start_strob : in std_logic;
		out_std_ready_data : out std_logic_vector(0 to NUM_ADC-1);
		out_std16_code_adc : out arr_par_data_std16(0 to NUM_ADC-1);
		in_std_ena : in std_logic															-- Разрешение работы блока
	);
end ADS8861;

architecture behave of ADS8861 is

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование компонента SerToParBuff														  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
component SerToParBuff
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
end component;
--///////////////////////////////////////////////////////////////////////////////////////////////////////////


component SignedBufferAverage
	generic
	(
		WIDTH_DATA 		: integer range 1 to 16 := 16;		-- Разрядность данных
		NUM_WORDS_BUF	: integer range 1 to 500 := 8		-- Количество слов
	);
	port
	(
		-- // Clock port
		in_std_clk_100MHz 	: 	in 	std_logic;												-- Входная тактовая частота
		in_stdX_data 		: 	in 	std_logic_vector(WIDTH_DATA-1 downto 0);
		out_stdX_data 		: 	out std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std_start_strob 	:	in 	std_logic;
		out_std_ready_data 	: 	out std_logic;
		in_std_ena 			: 	in 	std_logic															-- Разрешение работы блока
	);
end component;









signal sig_std_start_strob : std_logic;
signal sig_std_start_block : std_logic;
signal sig_std_sclk : std_logic;
signal sig_std_ASQ_state : std_logic;
signal sig_std_adc_cnv : std_logic;

--
signal sig_stdX_counter_sclk : std_logic_vector (CLK_DEVIDER+1 downto 0);
signal sig_uX_clk_devider : unsigned (CLK_DEVIDER+1 downto 0) := to_unsigned(0, CLK_DEVIDER+2);
signal sig_int_max_time_adc : integer := 0;
signal sig_int_counter_sample : integer := 0;
signal sig_int_time_ASQ : integer := 0;
--
signal sig_std16_code_adc : arr_par_data_std16(0 to NUM_ADC-1);
signal sig_std_ready_data : std_logic_vector(0 to NUM_ADC-1);

begin

sig_uX_clk_devider(CLK_DEVIDER+1) <= '1';										-- Значение делителя тактовой частоты
sig_int_time_ASQ <= (to_integer(sig_uX_clk_devider))*(WIDTH_DATA+1);	-- Количество тактов на считывание данных							
sig_int_max_time_adc <= TIME_CONV + sig_int_time_ASQ;						-- Максимальное количество тактов на одно измерение


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
--		Процесс тактирования АЦП														//
--////////////////////////////////////////////////////////////////////////
CREATING_SCLK: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			out_std_adc_clk <= '0';
			sig_stdX_counter_sclk <= std_logic_vector(to_unsigned(0, CLK_DEVIDER+2));
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			if sig_std_ASQ_state = '0' then
				out_std_adc_clk <= '0';
				sig_stdX_counter_sclk <= std_logic_vector(to_unsigned(0, CLK_DEVIDER+2));
			else
				sig_stdX_counter_sclk <= sig_stdX_counter_sclk + 1;
				out_std_adc_clk <= sig_stdX_counter_sclk(CLK_DEVIDER);
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////
--		Процесс формирования глобального счетчика									//
--////////////////////////////////////////////////////////////////////////
CREATE_COUNTER_SAMPLE: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_int_counter_sample <= 0;
			sig_std_start_block <= '0';
			out_std_adc_cnv <= '0';
			sig_std_ASQ_state <= '0';
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			if sig_std_start_block = '0' then
				sig_int_counter_sample <= sig_int_max_time_adc;
				sig_std_start_block <= '1';
				sig_std_adc_cnv <= '0';
				sig_std_ASQ_state <= '0';
			else
				if sig_int_counter_sample = sig_int_max_time_adc then
					if in_std_start_strob = '1' and sig_std_start_strob = '0' then
						sig_int_counter_sample <= 0;
					end if;
					sig_std_ASQ_state <= '0';
					sig_std_adc_cnv <= '0';
				else
					if sig_int_counter_sample < TIME_CONV then 
						sig_std_adc_cnv <= '1';
						sig_std_ASQ_state <= '0';
					elsif sig_int_counter_sample >= TIME_CONV and sig_int_counter_sample < (sig_int_max_time_adc - to_integer(sig_uX_clk_devider)) then
						sig_std_adc_cnv <= '1';
						sig_std_ASQ_state <= '1';
					else
						sig_std_adc_cnv <= '0';
						sig_std_ASQ_state <= '1';
					end if;
					sig_int_counter_sample <= sig_int_counter_sample + 1;
				end if;
			end if;
			out_std_adc_cnv <= sig_std_adc_cnv;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

S2PBUFF_ALL: for i in 0 to NUM_ADC-1 generate S2PBUFF: SerToParBuff
	generic map (WIDTH_DATA)
	port map	(
				in_std_clk_100MHz,
				sig_stdX_counter_sclk(CLK_DEVIDER),
				sig_std_ASQ_state,
				in_std_adc_sdata(i), 
				sig_std16_code_adc(i), 
				sig_std_ready_data(i), 
				in_std_ena);
	end generate;
	
	SIG_BUFF_ALL: for i in 0 to NUM_ADC-1 generate SIGBUFF: SignedBufferAverage
	generic map (	WIDTH_DATA,
					NUM_WORDS_BUF
				)
	port map	(
				in_std_clk_100MHz,
				sig_std16_code_adc(i),
				out_std16_code_adc(i),
				sig_std_ready_data(i), 
				out_std_ready_data(i), 
				in_std_ena);
	end generate;




end behave;


