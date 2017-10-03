
-----------------------------------------------------------------------------------
-- ШАБЛОН ТОП ПРОЕКТА VHDL 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use work.my_types.all; -- 	подключение пакета


entity vip is
	generic
	(
		time_pulse : integer range 0 to 10000000 := 500000;		
		time_total : integer range 0 to 10000000 := 5000000	
	);
	port
	(
		
		in_std_ena : in std_logic;
		in_std_clk : in std_logic;
		in_std6_data : in std_logic_vector(5 downto 0);
		out_std6_data : out std_logic_vector(5 downto 0);
		out_std_str : out std_logic
	);
end vip;

architecture ARCH_vip of vip is


--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование сигналов архитектуры									  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////

signal sig_std6_data	:	std_logic_vector(5 downto 0);

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
begin

--////////////////////////////////////////////////////////////////////////
--		Процесс 										//
--////////////////////////////////////////////////////////////////////////
strobe: process (in_std_clk, in_std_ena)
variable var_int_cnt : integer := 0;
	begin
		if in_std_ena = '0' then
			var_int_cnt := 0;						-- асинхронный сброс
		elsif in_std_clk'event and in_std_clk = '1' then
			if (var_int_cnt < 599000) then
				out_std_str <= '0';
				var_int_cnt := var_int_cnt + 1;
			else
				out_std_str <= '1';
				var_int_cnt := 0;
				sig_std6_data <= in_std6_data;
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////
g0:  for i in 4 to 5 generate

us_relay: process (in_std_clk, in_std_ena)

	begin
		if in_std_ena = '0' then
			out_std6_data(i) <= '1';-- асинхронный сброс
		elsif in_std_clk'event and in_std_clk = '1' then
			if (sig_std6_data(i) = '0') then
				out_std6_data(i) <= '0';
			else
				out_std6_data(i) <= '1';
			end if;	
		end if;
	end process;
end generate;


g1:  for i in 0 to 1 generate

pol_relay: process (in_std_clk, in_std_ena)
	variable var_int_cnt2 : integer := 0;
	begin
		if in_std_ena = '0' then
						-- асинхронный сброс
		elsif in_std_clk'event and in_std_clk = '1' then
			if ((in_std6_data(i*2) = '1' and in_std6_data((i*2 + 1)) = '1') or (in_std6_data(i*2) = '0' and in_std6_data((i*2 + 1)) = '0') ) then
				out_std6_data (i*2 + 1) <= '1';	
				out_std6_data (i*2) <= '1';
			elsif(sig_std6_data(i*2) = '0' and sig_std6_data((i*2) + 1) = '1') then
				if (var_int_cnt2 >= 0 and var_int_cnt2 <= (time_pulse)) then
					out_std6_data (i*2 + 1) <= '1';	
					out_std6_data (i*2) <= '0';
					var_int_cnt2 := var_int_cnt2 + 1;
				elsif (var_int_cnt2 > time_pulse and var_int_cnt2 <= (time_total - 1)) then
					out_std6_data (i*2) <= '1';
					var_int_cnt2 := var_int_cnt2 + 1;
				elsif (var_int_cnt2 = time_total) then
						var_int_cnt2 := 0;	
				end if;
			elsif (sig_std6_data((i*2) + 1) = '0' and sig_std6_data(i*2) = '1') then
				if (var_int_cnt2 >= 0 and var_int_cnt2 <= (time_pulse - 1)) then
					out_std6_data (i*2) <= '1';
					out_std6_data (i*2 + 1) <= '0';
					var_int_cnt2 := var_int_cnt2 + 1;
				elsif (var_int_cnt2 >= time_pulse and var_int_cnt2 <= (time_total - 1)) then
					out_std6_data (i*2 + 1) <= '1';
					var_int_cnt2 := var_int_cnt2 + 1;
				elsif (var_int_cnt2 = time_total) then
					var_int_cnt2 := 0;
				end if;
			end if;
		end if;	
	end process;
end generate;



end ARCH_vip;
