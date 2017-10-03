library ieee;
use ieee.std_logic_1164.all;

package my_types is
		type arr_par_data_std16 is array (integer range <>) of std_logic_vector(15 downto 0);
end package;
