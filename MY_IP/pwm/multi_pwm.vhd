
-----------------------------------------------------------------------------------
-- ШАБЛОН ТОП ПРОЕКТА VHDL 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.my_types.all;



entity multi_pwm is
	generic 
	(	
		freq_clock_comp_Hz			:		array_int(0 to quantity_comp_pwm-1)		:= 	(50_000_000,others=>50_000_000);	--50 Mhz by default 
		freq_pwm_hz_comp_Hz			: 		array_int(0 to quantity_comp_pwm-1)	 	:= 	(100_000,	others=>100_000); 		--100 khz by default
		type_pulse_comp		 		: 		array_std(0 to quantity_comp_pwm-1)		:= 	('1',		others=>'1');			--'1'- положительный импульс, '0' - отрицательный 
		duty_cycle_comp				: 		array_int(0 to quantity_comp_pwm-1)		:=	(3000,		others=>3000); 			-- duty cycle в процентах
		dead_time_comp				: 		array_int(0 to quantity_comp_pwm-1)		:=	(40,		others=>20);			-- dead time в наносекундах
		
		freq_clock_indep_ch1_Hz		:		array_int(0 to quantity_indep_pwm-1)	:= 	(50_000_000,others=>100_000_000);	--50 Mhz by default 
		freq_clock_indep_ch2_Hz		:		array_int(0 to quantity_indep_pwm-1)	:= 	(50_000_000,others=>100_000_000);	--50 Mhz by default 
		freq_pwm_indep_ch1_Hz		: 		array_int(0 to quantity_indep_pwm-1) 	:= 	(100_000,	others=>100_000); 		--100 khz by default
		freq_pwm_indep_ch2_Hz		: 		array_int(0 to quantity_indep_pwm-1) 	:= 	(100_000,	others=>100_000); 		--100 khz by default
		type_pulse_indep_ch1 		: 		array_std(0 to quantity_indep_pwm-1)	:= 	('1',		others=>'1');			--'1' - положительный импульс, '0'- отрицательный 
		type_pulse_indep_ch2 		: 		array_std(0 to quantity_indep_pwm-1)	:= 	('1',		others=>'1');			--'1'- положительный импульс, '0' - отрицательный 
		duty_cycle_indep_ch1		: 		array_int(0 to quantity_indep_pwm-1)	:=	(3000,		others=>3000); 			-- duty cycle в процентах
		duty_cycle_indep_ch2		: 		array_int(0 to quantity_indep_pwm-1)	:=	(3000,		others=>3000); 			-- duty cycle в процентах
		dead_time_indep_ch1			: 		array_int(0 to quantity_indep_pwm-1)	:=	(0,			others=>0);				-- dead time в наносекундах
		dead_time_indep_ch2			: 		array_int(0 to quantity_indep_pwm-1)	:=	(0,			others=>0)				-- dead time в наносекундах
	);
	port
	(
		in_std_clk_comp				: 	in	array_std(0 to quantity_comp_pwm-1);
		in_std_ena_comp 			: 	in	array_std(0 to quantity_comp_pwm-1);
		out_std_pwm_comp_ch1 		: 	out array_std(0 to quantity_comp_pwm-1);
		out_std_pwm_comp_ch1_n 		: 	out array_std(0 to quantity_comp_pwm-1);
		
		in_std_clk_ind_ch1 			: 	in 	array_std(0 to quantity_indep_pwm-1);
		in_std_clk_ind_ch2 			: 	in 	array_std(0 to quantity_indep_pwm-1);
		in_std_ena_ind_ch1 			: 	in 	array_std(0 to quantity_indep_pwm-1);
		in_std_ena_ind_ch2 			: 	in 	array_std(0 to quantity_indep_pwm-1);
		out_std_pwm_ind_ch1 		: 	out array_std(0 to quantity_indep_pwm-1);
		out_std_pwm_ind_ch2 		: 	out	array_std(0 to quantity_indep_pwm-1)
	);
end multi_pwm;


architecture PWM of multi_pwm is


begin

 COMP: for i in 0 to quantity_comp_pwm-1 generate comp_pwm: entity work.dual_pwm(COMP)
	generic map
	(		
		freq_clock_hz_comp_ch1	=>	freq_clock_comp_Hz(i),		--50 Mhz by default 
		freq_pwm_hz_comp_ch1 	=>	freq_pwm_hz_comp_Hz(i), 	--100 khz by default
		type_pulse_comp_ch1 	=>	type_pulse_comp(i),			--'1' - положительный импульс, '0'- отрицательный 
		duty_cycle_comp_ch1		=>	duty_cycle_comp(i), 		-- duty cycle в процентах
		dead_time_comp_ch1		=>	dead_time_comp(i),			-- dead time в наносекундах
		freq_clock_hz_ch2		=>	freq_clock_comp_Hz(i),		--50 Mhz by default 
		freq_pwm_hz_ch2			=>	freq_pwm_hz_comp_Hz(i), 	--100 khz by default
		type_pulse_ch2 			=>	type_pulse_comp(i),			--'1' - положительный импульс, '0'- отрицательный 
		duty_cycle_ch2			=>	duty_cycle_comp(i), 		-- duty cycle в процентах
		dead_time_ch2			=>	dead_time_comp(i)			-- dead time в наносекундах	-- dead time в наносекундах
	)
	
	port map
	(
		in_std_clk1 			=>	in_std_clk_comp(i), 
		in_std_clk2				=>	'1',
		in_std_ena1				=>	in_std_ena_comp(i),
		in_std_ena2				=>	'1',
		out_std_pwm_ch1 		=>	out_std_pwm_comp_ch1(i),
		out_std_pwm_ch1_n_ch2 	=>	out_std_pwm_comp_ch1_n(i)
	);
	
	end generate;
	
 INDEP: for i in 0 to quantity_indep_pwm-1 generate indep_pwm: entity work.dual_pwm(INDEP)
	generic map
	(		
		freq_clock_hz_comp_ch1	=>	freq_clock_indep_ch1_Hz(i),		--50 Mhz by default 
		freq_pwm_hz_comp_ch1 	=>	freq_pwm_indep_ch1_Hz(i), 		--100 khz by default
		type_pulse_comp_ch1 	=>	type_pulse_indep_ch1(i),		--'1' - положительный импульс, '0'- отрицательный 
		duty_cycle_comp_ch1		=>	duty_cycle_indep_ch1(i), 		-- duty cycle в процентах
		dead_time_comp_ch1		=>	dead_time_indep_ch1(i),			-- dead time в наносекундах
	 	freq_clock_hz_ch2		=>	freq_clock_indep_ch2_Hz(i),		--50 Mhz by default 
		freq_pwm_hz_ch2			=>	freq_pwm_indep_ch2_Hz(i), 		--100 khz by default
		type_pulse_ch2 			=>	type_pulse_indep_ch2(i),		--'1' - положительный импульс, '0'- отрицательный 
		duty_cycle_ch2			=>	duty_cycle_indep_ch2(i), 		-- duty cycle в процентах
		dead_time_ch2			=>	dead_time_indep_ch2(i)			-- dead time в наносекундах	-- dead time в наносекундах
	)
	
	port map
	(
		in_std_clk1 			=>	in_std_clk_ind_ch1(i), 					 
		in_std_clk2				=>	in_std_clk_ind_ch2(i),                            
		in_std_ena1				=>	in_std_ena_ind_ch1(i),              
		in_std_ena2				=>	in_std_ena_ind_ch2(i),                             
		out_std_pwm_ch1 		=>	out_std_pwm_ind_ch1(i),        
		out_std_pwm_ch1_n_ch2 	=>	out_std_pwm_ind_ch2(i)      
	);
	
	end generate;

end PWM;

