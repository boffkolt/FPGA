library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


package my_types is

type array_int is array (natural range <>) of integer;
type array_std is array (natural range <>) of std_logic;
constant quantity_indep_pwm		:	integer	:= 5;
constant quantity_comp_pwm		:	integer	:= 5;
			---------------------------------------------------------------										

end my_types;



