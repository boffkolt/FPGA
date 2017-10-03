
-----------------------------------------------------------------------------------
-- ШАБЛОН ТЕСТБЕНЧА VHDL 
------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all;


entity ADS8861_tb is
	generic
	(
		NUM_ADC : integer range 1 to 32 := 2;
		WIDTH_DATA : integer range 16 to 16 := 16;	-- Разрядность данных
		TIME_CONV : integer range 0 to 80 := 80;		-- Время паузы между стартом конверсии и считыванием данных
		CLK_DEVIDER : integer range 0 to 7 := 2	
		
	);
end ADS8861_tb ;

		
architecture ARCH_ADS8861_tb of ADS8861_tb is
component ADS8861
	generic
	(
		NUM_ADC : integer range 1 to 32 := 2;
		WIDTH_DATA : integer range 16 to 16 := 16;	-- Разрядность данных
		TIME_CONV : integer range 0 to 80 := 80;		-- Время паузы между стартом конверсии и считыванием данных
		CLK_DEVIDER : integer range 0 to 7 := 0	
		
	);
	port( 
		-- // Clock port
		in_std_clk_100MHz 	: in 	std_logic							;												-- Входная тактовая частота
		in_std_adc_sdata 	: in 	std_logic_vector(0 to NUM_ADC-1)	;					-- Последовательные данные от АЦП
		out_std_adc_clk 	: out 	std_logic							;													-- Тактовая частота для АЦП
		out_std_adc_cnv 	: out 	std_logic							;													-- Запуск конвертирования АЦП
		in_std_start_strob 	: in 	std_logic							;
		out_std_ready_data 	: out 	std_logic_vector(0 to NUM_ADC-1)	;
		out_std16_code_adc 	: out 	arr_par_data_std16(0 to NUM_ADC-1);
		in_std_ena 			: in 	std_logic										);
end component;

for label_0: ADS8861 use entity work.ADS8861 ;
		
signal 	in_std_clk_100MHz 		: std_logic							 	:= '0';
signal 	in_std_adc_sdata 		: std_logic_vector(0 to NUM_ADC-1)	 	:= "01";
signal 	out_std_adc_clk 		: std_logic							 	:= '0';
signal 	out_std_adc_cnv 		: std_logic								:= '0';
signal 	in_std_start_strob 		: std_logic								:= '0';
signal 	out_std_ready_data 		: std_logic_vector(0 to NUM_ADC-1)	 	:= (others => '0');
signal 	out_std16_code_adc 		: arr_par_data_std16(0 to NUM_ADC-1)	:= (others=>(others=>'1'));
signal 	in_std_ena 				: std_logic								:= '0';

begin

label_0: ADS8861 

generic map (			
			NUM_ADC 	=>	NUM_ADC ,			
			WIDTH_DATA 	=>	WIDTH_DATA ,		
			TIME_CONV 	=>	TIME_CONV ,			
			CLK_DEVIDER	=>	CLK_DEVIDER
						

)
port map (		
					in_std_clk_100MHz 	=>		in_std_clk_100MHz 	,					
					in_std_adc_sdata 	=> 		in_std_adc_sdata 	,		
					out_std_adc_clk 	=> 		out_std_adc_clk 	,				
					out_std_adc_cnv 	=> 		out_std_adc_cnv 	,					
					in_std_start_strob 	=> 		in_std_start_strob 	,					
					out_std_ready_data 	=> 		out_std_ready_data 	,				
					out_std16_code_adc 	=>		out_std16_code_adc 	,					
					in_std_ena 			=>		in_std_ena 										
							);



-----------------------------------------------------------------------------------
-- ПРОЦЕСС ТАКТИРОВАНИЯ
------------------------------------------------------------------------------------


CLK: process
begin

       in_std_clk_100MHz <= not(in_std_clk_100MHz);
       
       wait for 5 ns;
   
end process;



ENA: process
begin
		wait for 32 ns;
		in_std_ena <= '1';
       
       
   
end process;

ENA2: process
begin
		wait for 100 ns;
		in_std_start_strob <= '1';
		wait for 100 ns;
		in_std_start_strob <= '0';
		wait for 10 us;
end process;

DAT: process
begin
		wait for 50 ns;
		in_std_adc_sdata <= "10";
		wait for 30 ns;
		in_std_adc_sdata <= "11";
		wait for 80 ns;
		in_std_adc_sdata <= "00";
		wait for 60 ns;
		in_std_adc_sdata <= "01";
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

end ARCH_ADS8861_tb;	
