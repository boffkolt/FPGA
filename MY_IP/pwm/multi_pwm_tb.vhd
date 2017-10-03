
-----------------------------------------------------------------------------------
-- ШАБЛОН ТЕСТБЕНЧА VHDL 
------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;



entity dual_pwm_tb is
end dual_pwm_tb ;

		
architecture ARCH_dual_pwm_tb of dual_pwm_tb is
component dual_pwm
	generic (	freq_clock_hz_comp_ch1	:	integer		:= 50_000_000;	--50 Mhz by default 
				freq_pwm_hz_comp_ch1 	: 	integer 	:= 100_000; 	--100 khz by default
				type_pulse_comp_ch1 	: 	string 		:= "POSITIVE";	--POSITIVE - положительный импульс, NEGATIVE - отрицательный 
				duty_cycle_comp_ch1		: 	real		:=	30.0; 		-- duty cycle в процентах
				dead_time_comp_ch1		: 	real		:=	0.0;		-- dead time в наносекундах
				
				freq_clock_hz_ch2		:	integer		:= 100_000_000;	--50 Mhz by default 
				freq_pwm_hz_ch2			: 	integer 	:= 100_000; 	--100 khz by default
				type_pulse_ch2 			: 	string 		:= "POSITIVE";	--POSITIVE - положительный импульс, NEGATIVE -
				duty_cycle_ch2			: 	real		:=	70.0; 		-- duty cycle в процентах
				dead_time_ch2			: 	real		:=	0.0 		-- dead time в наносекундах
	
			);
	port
	(
		
		in_std_clk1 : in std_logic;
		in_std_clk2: in std_logic;
		in_std_ena : in std_logic;
		out_std_pwm_ch1 : out std_logic;
		out_std_pwm_ch1_n_ch2 : out std_logic
	);
end component;

for label_0: dual_pwm use entity work.dual_pwm(INDEP) ;

signal sig_std_clk1		: std_logic := '0';
signal sig_std_clk2		: std_logic := '0';
signal sig_std_ena		: std_logic := '0';
signal sig_std_pwm_ch	: std_logic := '0';
signal sig_std_pwm_ch_n	: std_logic := '0';


begin

label_0: dual_pwm port map 
(	in_std_clk1			=> sig_std_clk1		 , 
	in_std_clk2			=> sig_std_clk2		 , 
	in_std_ena			=> sig_std_ena		, 
	out_std_pwm_ch1		=> sig_std_pwm_ch	,
	out_std_pwm_ch1_n_ch2	=> sig_std_pwm_ch_n	
	);


-----------------------------------------------------------------------------------
-- ПРОЦЕСС ТАКТИРОВАНИЯ
------------------------------------------------------------------------------------


CLK: process
begin

       sig_std_clk1 <= not(sig_std_clk1);
       
       wait for 10 ns;
   
end process;


CLK2: process
begin

       sig_std_clk2 <= not(sig_std_clk2);
       
       wait for 5 ns;
   
end process;


ENA: process
begin

       
       
       wait for 35 ns;
		sig_std_ena <= '1';
end process;



-----------------------------------------------------------------------------------
-- ПРОЦЕСС ОСТАНОВКИ СИМУЛЯЦИИ
------------------------------------------------------------------------------------

STOP: process
begin
	assert false
		report "simulation started"
		severity warning;
	wait for 100 ms; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ;

end ARCH_dual_pwm_tb;	
