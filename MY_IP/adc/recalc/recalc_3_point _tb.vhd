library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.my_function.all;


entity ADC_CONVERTER is
	generic
	(
		WIDTH_DATA : integer range 1 to 16 := 16	-- Разрядность данных
	);
	port
	(
		-- // Clock port
		in_std_clk_100MHz : in std_logic;												-- Входная тактовая частота
		-- // Convertion port
		in_std16_data_point_0 : in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std16_data_point_1 : in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std16_data_point_2 : in std_logic_vector(WIDTH_DATA-1 downto 0);
		
		in_std16_code_point_0 : in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std16_code_point_1 : in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std16_code_point_2 : in std_logic_vector(WIDTH_DATA-1 downto 0);
		
		in_std16_coef_mul : in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std16_coef_div : in std_logic_vector(WIDTH_DATA-1 downto 0);
		
		in_std16_code_adc : in std_logic_vector(WIDTH_DATA-1 downto 0);
		out_std16_data_adc : out std_logic_vector(WIDTH_DATA-1 downto 0);
		
		-- // Control alarm port
		in_std16_data_ovf : in std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std16_data_unf : in std_logic_vector(WIDTH_DATA-1 downto 0);
		
		in_std_reset_alarm : in std_logic;
		out_std_alarm_ovf : out std_logic;
		out_std_alarm_unf : out std_logic;
		
		-- // Other port
		in_std_start_strob : in std_logic;
		out_std_ready_data : out std_logic;
		in_std_ena : in std_logic															-- Разрешение работы блока
	);
end ADC_CONVERTER;

architecture behave of ADC_CONVERTER is

signal sig_int_data_point_0 : integer range -32768 to 32767 := 0;
signal sig_int_data_point_1 : integer range -32768 to 32767 := 0;
signal sig_int_data_point_2 : integer range -32768 to 32767 := 0;

signal sig_int_code_point_0 : integer range -32768 to 32767 := 0;
signal sig_int_code_point_1 : integer range -32768 to 32767 := 0;
signal sig_int_code_point_2 : integer range -32768 to 32767 := 0;

signal sig_int_coef_mul : integer range -1000 to 1000 := 1;
signal sig_int_coef_div : integer range -1000 to 1000 := 1;

signal sig_int_data_ovf : integer range -32768 to 32767 := 32767;
signal sig_int_data_unf : integer range -32768 to 32767 := -32768;

signal sig_int_code_adc : integer := 0;

signal sig_std_start_strob : std_logic;
signal sig_std_start_strob_t1 : std_logic;
signal sig_std_reset_alarm : std_logic;
signal sig_int_data_adc : integer;


begin

--////////////////////////////////////////////////////////////////////////
--		Процесс тактирования входных данных								//
--////////////////////////////////////////////////////////////////////////
CLOCKING: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_std_start_strob <= '0';
			sig_std_start_strob_t1 <= '0';
			sig_std_reset_alarm <= '0';
			
			sig_int_data_point_0 <= 0;
			sig_int_data_point_1 <= 0;
			sig_int_data_point_2 <= 0;

			sig_int_code_point_0 <= 0;
			sig_int_code_point_1 <= 0;
			sig_int_code_point_2 <= 0;
			
			sig_int_coef_mul <= 1;
			sig_int_coef_div <= 1;

			sig_int_data_ovf <= 0;
			sig_int_data_unf <= 0;
			
			sig_int_code_adc <= 0;
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			sig_std_start_strob <= in_std_start_strob;
			sig_std_start_strob_t1 <= sig_std_start_strob;
			sig_std_reset_alarm <= in_std_reset_alarm;
			
			sig_int_data_point_0 <= to_integer(signed(in_std16_data_point_0));
			sig_int_data_point_1 <= to_integer(signed(in_std16_data_point_1));
			sig_int_data_point_2 <= to_integer(signed(in_std16_data_point_2));
			
			sig_int_code_point_0 <= to_integer(signed(in_std16_code_point_0));
			sig_int_code_point_1 <= to_integer(signed(in_std16_code_point_1));
			sig_int_code_point_2 <= to_integer(signed(in_std16_code_point_2));
			
			sig_int_coef_mul <= to_integer(signed(in_std16_coef_mul));
			
			if in_std16_coef_div = std_logic_vector(to_signed(0, WIDTH_DATA)) then
				sig_int_coef_div <= 1;
			else
				sig_int_coef_div <= to_integer(signed(in_std16_coef_div));
			end if;
			
			sig_int_data_ovf <= to_integer(signed(in_std16_data_ovf));
			sig_int_data_unf <= to_integer(signed(in_std16_data_unf));
			
			if in_std_start_strob = '1' and sig_std_start_strob = '0' then
				sig_int_code_adc <= to_integer(signed(in_std16_code_adc));
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////
--		Процесс конвертирования кода в данные							//
--////////////////////////////////////////////////////////////////////////
CONVERT_C2D: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_int_data_adc <= 0;
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
			if sig_int_code_adc < sig_int_code_point_1 then
			---------------------------------------------------------------
			--	Расчет значения по нижнему участку линейной ломаной
			---------------------------------------------------------------
				sig_int_data_adc <= calculate_line_point (	sig_int_data_point_1, 
															sig_int_data_point_0, 
															sig_int_code_point_1, 
															sig_int_code_point_0, 
															sig_int_code_adc, 
															sig_int_coef_mul, 
															sig_int_coef_div);
			else
			---------------------------------------------------------------
			--	Расчет значения по верхнему участку линейной ломаной
			---------------------------------------------------------------
			
				sig_int_data_adc <= calculate_line_point (	sig_int_data_point_2, 
															sig_int_data_point_1, 
															sig_int_code_point_2, 
															sig_int_code_point_1, 
															sig_int_code_adc, 
															sig_int_coef_mul, 
															sig_int_coef_div);
			end if;
			out_std16_data_adc <= std_logic_vector(to_signed(sig_int_data_adc, WIDTH_DATA));
			out_std_ready_data <= sig_std_start_strob_t1;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////////////
--		Процесс контроля аварийных значений								//
--////////////////////////////////////////////////////////////////////////
CONTROL_ALARM: process (in_std_clk_100MHz, in_std_ena)
	begin
		if in_std_ena = '0' then
			out_std_alarm_ovf <= '0';
			out_std_alarm_unf <= '0';
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
		
		---------------------------------------------------------------
		--	Контроль верхнего аварийного значения
		---------------------------------------------------------------
			if sig_int_data_adc > sig_int_data_ovf then
				out_std_alarm_ovf <= '1';
			else
				if in_std_reset_alarm = '1' and sig_std_reset_alarm = '0' then
					out_std_alarm_ovf <= '0';
				end if;
			end if;
		---------------------------------------------------------------
		
		---------------------------------------------------------------
		--	Контроль нижнего аварийного значения
		---------------------------------------------------------------	
			if sig_int_data_adc < sig_int_data_unf then
				out_std_alarm_unf <= '1';
			else
				if in_std_reset_alarm = '1' and sig_std_reset_alarm = '0' then
					out_std_alarm_unf <= '0';
				end if;
			end if;
		---------------------------------------------------------------
			
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

end behave;
