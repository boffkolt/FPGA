

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--use work.my_types.all;


entity pwm_tb is
end pwm_tb ;


		
architecture ARCH_pwm_tb of pwm_tb is
component pwm
	generic (	freq_clock_hz	:	integer		:= 50_000_000;	--50 Mhz by default 
				freq_pwm_hz 	: 	integer 	:= 100_000; 	--100 khz by default
				type_pulse 		: 	string 		:= "POSITIVE";	--POSITIVE - положительный импульс, NEGATIVE - отрицательный 
				duty_cycle		: 	real		:=	60.0; 		-- duty cycle в процентах
				dead_time		: 	real		:=	40.0		-- dead time в наносекундах
			);
	port( 
		in_std_clk 					:	in std_logic; 												
		in_std_ena					:	in std_logic := '1';														
		out_std_data				:	out std_logic
		);
end component;

for label_0: pwm use entity work.pwm(CH) ;

signal sig_std_clk 	: std_logic := '0';
signal in_std_ena	: std_logic := '0';
signal out_std_data	: std_logic := '0';


begin

label_0: pwm port map (	in_std_clk 		=> 	sig_std_clk 	, 
						in_std_ena		=> 	in_std_ena	, 
						out_std_data	=> 	out_std_data
						);



-----------------------------------------------------------------------------------
-- ПРОЦЕСС ТАКТИРОВАНИЯ
------------------------------------------------------------------------------------


CLK: process
begin

       sig_std_clk <= not(sig_std_clk);
       
       wait for 10 ns;
   
end process;
------------------------------------------------

ENA: process
begin

       
       
       wait for 25 ns;
		in_std_ena <= '1';
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

end ARCH_pwm_tb;	
