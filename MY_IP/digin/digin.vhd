
-----------------------------------------------------------------------------------
-- ШАБЛОН ТОП ПРОЕКТА VHDL 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use work.my_types.all; -- 	подключение пакета


entity digin is
	generic
	(
		SYSTEM_CLOCK_Hz: natural range 0 to 300_000_000 := 50_000_000;		
		DEBOUNCE_us: natural  := 100;
	);
	port
	(
		
		in_std_clk : in std_logic;
		in_std_digin : in std_logic;
		out_std_digin : out std_logic
	);
end digin;

architecture ARCH_digin of digin is

constant con_int_1usperiod : integer := SYSTEM_CLOCK_Hz/1_000_000;
signal sig_int_cnt1us	:	integer	:=0;
--///////////////////////////////////////////////////////////////////////////////////////////////////////////

CNT_1ms: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_int_cnt1ms <= 0;						-- асинхронный сброс
		elsif in_std_clk'event and in_std_clk = '1' then
			if (sig_int_cnt1us < con_int_1usperiod) then
				sig_int_cnt1us <= sig_int_cnt1us + 1;
			else
				sig_int_cnt1us <= 0;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование сигналов архитектуры									  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////

signal sig_std_test : std_logic := '0';

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
begin

--////////////////////////////////////////////////////////////////////////
--		Процесс 										//
--////////////////////////////////////////////////////////////////////////
LABEL0: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
									-- асинхронный сброс
		elsif in_std_clk'event and in_std_clk = '1' then
			if(DEBOUNCE_us /= 0) then
			
			else
				out_std_digin <= in_std_digin;
			-- выполнение процесса
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////


--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 			Генерирование компонентов											  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
-- LABEL1: for i in 0 to NUM generate LABEL2: component_name
--	generic map (WIDTH_DATA)
--	port map	(
--				in_std : in std_logic;
--				inout_std : inout std_logic;
--				out_std : out std_logic	);
--	end generate;

end ARCH_digin;
