
-----------------------------------------------------------------------------------
-- ШАБЛОН ТОП ПРОЕКТА VHDL 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity dual_pwm is
	generic (	freq_clock_hz_comp_ch1	:	integer		:= 50_000_000;	--50 Mhz by default 
				freq_pwm_hz_comp_ch1 	: 	integer 	:= 100_000; 	--100 khz by default
				type_pulse_comp_ch1 	: 	std_logic	:= '1';			--'1' - положительный импульс, '0'- отрицательный 
				duty_cycle_comp_ch1		: 	integer		:=	3000; 		-- duty cycle в процентах
				dead_time_comp_ch1		: 	integer		:=	40;			-- dead time в наносекундах
				freq_clock_hz_ch2		:	integer		:= 50_000_000;	--50 Mhz by default 
				freq_pwm_hz_ch2			: 	integer 	:= 100_000; 	--100 khz by default
				type_pulse_ch2 			: 	std_logic 	:= '1';			--'1' - положительный импульс, '0' -
				duty_cycle_ch2			: 	integer		:=	3000; 		-- duty cycle в процентах
				dead_time_ch2			: 	integer		:=	40			-- dead time в наносекундах
	
			);
	port
	(
		
		in_std_clk1 : in std_logic;
		in_std_clk2 : in std_logic;
		in_std_ena1 : in std_logic;
		in_std_ena2 : in std_logic;
		out_std_pwm_ch1 : out std_logic;
		out_std_pwm_ch1_n_ch2 : out std_logic
	);
end dual_pwm;

architecture COMP of dual_pwm is



begin






ch1: entity work.pwm(ch) generic map (freq_clock_hz_comp_ch1,freq_pwm_hz_comp_ch1,type_pulse_comp_ch1,duty_cycle_comp_ch1,dead_time_comp_ch1 ) port map (in_std_clk1, in_std_ena1, out_std_pwm_ch1);
ch1_n: entity work.pwm(ch_n) generic map (freq_clock_hz_comp_ch1,freq_pwm_hz_comp_ch1,type_pulse_comp_ch1,duty_cycle_comp_ch1,dead_time_comp_ch1) port map (in_std_clk1, in_std_ena1, out_std_pwm_ch1_n_ch2);




end COMP;

architecture INDEP of dual_pwm is



begin






ch1: entity work.pwm(ch) generic map (freq_clock_hz_comp_ch1,freq_pwm_hz_comp_ch1,type_pulse_comp_ch1,duty_cycle_comp_ch1,dead_time_comp_ch1) port map (in_std_clk1, in_std_ena1, out_std_pwm_ch1);
ch2: entity work.pwm(ch) generic map (freq_clock_hz_ch2,freq_pwm_hz_ch2,type_pulse_ch2,duty_cycle_ch2,dead_time_ch2) port map (in_std_clk2, in_std_ena2, out_std_pwm_ch1_n_ch2);




end INDEP;
