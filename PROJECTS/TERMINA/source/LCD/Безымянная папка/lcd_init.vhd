library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


package lcd_init is

type data is array (natural range <>) of std_logic_vector(7 downto 0);
type num_arr is array (0 to 8) of integer range 0 to 25000;



constant i_arr : num_arr := ( 	0	=> 	0,
								1	=>	1,
								2	=>	2,
								3	=>	5,
								4	=>	8,
								5	=>	9,
								6	=>	10,
								7	=>	9600,
								8 	=> 10800);


										


-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------										
										
end lcd_init;


