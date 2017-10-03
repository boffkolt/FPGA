library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity pwm is
	generic (	freq_clock_hz	:	integer		:= 50_000_000;	--50 Mhz by default 
				freq_pwm_hz 	: 	integer 	:= 100_000; 	--100 khz by default
				type_pulse 		: 	std_logic 	:= '1';	--POSITIVE - положительный импульс, NEGATIVE - отрицательный 
				duty_cycle		: 	integer		:=	3000; 		-- duty cycle в процентах * 100 (3000 = 30.00 %)
				dead_time		: 	integer		:=	40 			-- dead time в наносекундах
			);
	port( 
		in_std_clk 					:	in std_logic; 												
		in_std_ena					:	in std_logic := '1';													
		out_std_data				:	out std_logic
		);
		
		
end pwm;
----------------------------------------------------------------------------------------		
architecture CH of pwm is
-----------------------------------------------------------------------------------------
signal con_int_period		: integer := freq_clock_hz/freq_pwm_hz; 				-- период ШИМ
signal con_int_dlit_pulse	: integer := con_int_period*duty_cycle/10000; 			-- длительность импульса
signal con_int_dead_time	: integer := freq_clock_hz*dead_time/1_000_000_000; 	-- dead_time в нс 
--------------------------------------------------------------------------------------------------
signal sig_int_count						: integer	:=	0;
signal sig_int_count_t1						: integer	:=	0;
signal sig_int_count_t2						: integer	:=	0;
begin


	
 
	COUNTER: process(in_std_ena,in_std_clk)
	begin
		if (in_std_ena = '0') then
			sig_int_count <= 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (sig_int_count < con_int_period-1) then
				sig_int_count <= sig_int_count + 1;
			else
				sig_int_count <= 0;
			end if;
		end if;
	end process;
		
	WRK: process(in_std_ena,in_std_clk)
	begin
		if (in_std_ena = '0') then
			if (type_pulse = '0') then
				out_std_data <= '1';
			else
				out_std_data <= '0';
			end if;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (type_pulse = '0') then
				if (sig_int_count_t1 > (0 + (con_int_dead_time-2)) and sig_int_count_t1 < ((con_int_dlit_pulse-1)-(con_int_dead_time))) then
					out_std_data <= '0';
				else
					out_std_data <= '1';
				end if;
			else
				if ((sig_int_count_t1 > (0 + (con_int_dead_time-2)) and sig_int_count_t1 < ((con_int_dlit_pulse-1)-(con_int_dead_time))) or sig_int_count_t1 = ((con_int_period-1) + (con_int_dead_time)))then
					out_std_data <= '1';
				else
					out_std_data <= '0';
				end if;
			end if;
		end if;	
	end process; 
	
	STROBES: process(in_std_ena,in_std_clk)
	begin
		if (in_std_ena = '0') then
			sig_int_count_t1 <= 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			sig_int_count_t1 <= sig_int_count;
		end if;
	end process;
end CH;	
----------------------------------------------------------------------------
architecture CH_N of pwm is
-----------------------------------------------------------------------------------------
signal con_int_period		: integer := freq_clock_hz/freq_pwm_hz; 				-- период ШИМ
signal con_int_dlit_pulse	: integer := con_int_period*duty_cycle/10000; 			-- длительность импульса
signal con_int_dead_time	: integer := freq_clock_hz*dead_time/1_000_000_000; 	-- dead_time в нс 
--------------------------------------------------------------------------------------------------
signal sig_int_count						: integer	:=	0;
signal sig_int_count_t1						: integer	:=	0;


begin
 
	COUNTER: process(in_std_ena,in_std_clk)
	begin
		if (in_std_ena = '0') then
			sig_int_count <= 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (sig_int_count < con_int_period-1) then
				sig_int_count <= sig_int_count + 1;
			else
				sig_int_count <= 0;
			end if;
		end if;
	end process;
		
	WRK: process(in_std_ena,in_std_clk)
	begin
		if (in_std_ena = '0') then
			if (type_pulse = '0') then
				out_std_data <= '1';
			else
				out_std_data <= '0';
			end if;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (type_pulse = '0') then
				if (sig_int_count_t1 > ((con_int_dlit_pulse-1) + (con_int_dead_time-1)) and sig_int_count_t1 < ((con_int_period-1) - (con_int_dead_time))) then
					out_std_data <= '0';
				else
					out_std_data <= '1';
				end if;
			else
				if (sig_int_count_t1 > ((con_int_dlit_pulse-1) + (con_int_dead_time-1)) and sig_int_count_t1 < ((con_int_period-1) - (con_int_dead_time))) then
					out_std_data <= '1';
				else
					out_std_data <= '0';
				end if;
			end if;
		end if;	
	end process; 
	
	STROBES: process(in_std_ena,in_std_clk)
	begin
		if (in_std_ena = '0') then
			sig_int_count_t1 <= 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			sig_int_count_t1 <= sig_int_count;
		end if;
	end process;
end CH_N;	
