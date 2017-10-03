library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package my_function is

-----------------------------------------------------------------------
-- Линейная функции data= Mul/Div*(K*Code+B)        				 --
-----------------------------------------------------------------------
	function calculate_line_point (D1, D0, C1, C0, Code, Mul, Div, Max, Min :integer) return integer;
-----------------------------------------------------------------------
-----------------------------------------------------------------------

end package my_function;

package body my_function is

	function calculate_line_point (D1, D0, C1, C0, Code, Mul, Div, Max, Min :integer) return integer is
	variable Ks, Bs, temp, data : integer;
	constant S : integer := 100000;
	begin
		if C1 = C0 then return 0;
		else 
			Ks := ((D1-D0)*S)/(C1-C0);
			Bs := ((D0*S)+(-1)*(Ks*C0));
			temp := ((Ks*Code)+Bs)/S;
			data := (temp*Mul)/Div;
			if data > Max then return Max;
			elsif data < Min then return Min;
			else return data;
			end if;
		end if;
	end function;
	
	
end package body my_function;
