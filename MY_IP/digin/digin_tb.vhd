
-----------------------------------------------------------------------------------
-- ШАБЛОН ТЕСТБЕНЧА VHDL 
------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--use work.my_types.all;


entity digin_tb is
end digin_tb ;

		
architecture ARCH_digin_tb of digin_tb is
component testing_digin
	generic
	(
		GENERICN : integer range 1 to 32 := 2;
		
	);
	port( 
		in_std : in std_logic;
		inout_std : inout std_logic;
		out_std : out std_logic);
end component;

for label_0: digin use entity work.digin ;

signal sig_std_test1: std_logic := '0';
signal sig_std_test2: std_logic := '0';
signal sig_std_test3: std_logic := '0';


begin

label_0: testing_digin port map (in_std => sig_std_test1 , inout_std => sig_std_test2, out_std => sig_std_test3);



-----------------------------------------------------------------------------------
-- ПРОЦЕСС ТАКТИРОВАНИЯ
------------------------------------------------------------------------------------


CLK: process
begin

       sig_std_clk_100 <= not(sig_std_clk_100);
       
       wait for 5 ns;
   
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

end ARCH_digin_tb;	
