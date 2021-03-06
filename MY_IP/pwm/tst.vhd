
-----------------------------------------------------------------------------------
-- ШАБЛОН ТОП ПРОЕКТА VHDL 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use work.my_types.all; -- 	подключение пакета


entity entity_name is
	generic
	(
		GENERICN : integer range 0 to 32 := 16;		
	);
	port
	(
		
		in_std : in std_logic;
		inout_std : inout std_logic;
		out_std : out std_logic
	);
end entity_name;

architecture ARCH_entity_name of entity_name is

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование компонента 											  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--component component_name
	--generic
	--(
		--GENERIN : integer range 0 to 32 := 16	
	--);
	--port
	--(
		--in_std : in std_logic;
		--inout_std : inout std_logic;
		--out_std : out std_logic					
	--);
--end component;
--///////////////////////////////////////////////////////////////////////////////////////////////////////////


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
		elsif in_std_clk_100MHz'event and in_std_clk_100MHz = '1' then
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

end ARCH_entity_name;
