library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity BUT is
	
	port( 
		in_std_clk 					:	in std_logic; 	-- тактовая частота													
	
		in_std_ena					:	in std_logic := '1';														
		in_std5_col_in				: 	in std_logic_vector(4 downto 0) :="ZZZZZ" ;
		out_std5_row_out			: 	out std_logic_vector(4 downto 0) ;
		out_std25_data				: 	out	std_logic_vector(24 downto 0);
		out_std_str					:	out std_logic	);		
end BUT;
		
architecture BUT_ARCH of BUT is



type data is array (0 to 5) of std_logic_vector(255 downto 0);
type cnt is array (0 to 24) of integer;


	signal sig_std5_row_out : std_logic_vector(4 downto 0) := "11110";
signal counters : cnt;

signal sig_std8_start					: std_logic_vector(7 downto 0) := X"FF";




signal sig_std_change_row			:	std_logic							:='0';
signal sig_std_init			: std_logic	:= '0';
signal sig_std_comp	:	std_logic := '0';

signal sig_std_read_ok					: 	std_logic							:='0';

signal sig_int_count						: integer	:=	0;
signal sig_std25_test					: std_logic_vector(24 downto 0):= (others => '0');
signal sig_std25_data					: std_logic_vector(24 downto 0) := (others => '0');
signal sig_i 	:	integer range 0 to 100 := 4 ;



 
 begin


CHK_BUT_ST: process(in_std_ena,in_std_clk)

begin
		if (in_std_ena = '0') then
		
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (sig_std_change_row = '1' and sig_std_change_row'last_value = '0') then
				out_std5_row_out <= sig_std5_row_out;
				sig_std5_row_out <= sig_std5_row_out(3 downto 0) & sig_std5_row_out(4);
				sig_std25_data(sig_i downto (sig_i-4)) <= in_std5_col_in;
					if (sig_std5_row_out = "11110") then
						sig_i <= 4;
					else
						sig_i <= sig_i + 5;
					end if;
			end if;
		end if;
end process; 

g0: for i in 0 to 24 generate 

CHK_but: process(in_std_ena,in_std_clk)
variable var_int_counter : integer := 0;
begin
	if (in_std_ena = '0') then
		var_int_counter := 0;
	elsif (in_std_clk'event and in_std_clk='1') then 

		if (sig_std_comp = '1' and sig_std_comp'last_value = '0') then
			if (sig_std25_data(i) = '0') then
				if (var_int_counter > 49) then
					var_int_counter := 50;
					sig_std25_test (i) <= '1';
				else
					var_int_counter := var_int_counter + 1;
				end if;
			else
				if (var_int_counter < 1) then
					var_int_counter := 0;
					sig_std25_test (i) <= '0';
				else
					var_int_counter := var_int_counter - 1;
				end if;
			end if;
		end if;	
	end if;
end process; 
end generate;


CNT_con: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 25500000 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (var_int_counter < 14999009) then
				var_int_counter := var_int_counter + 1;
				out_std_str	 <= '0';
			else 
				var_int_counter := 0;
				out_std_str	 <= '1';
				out_std25_data <= sig_std25_test;
			end if;
		end if;
end process;
 
 
 
 
 

 

CNT_WRK: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 55500 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (var_int_counter < 9999) then
				var_int_counter := var_int_counter + 1;
				sig_std_change_row <= '0';
			else 
				var_int_counter := 0;
				sig_std_change_row <= '1';
			end if;
		end if;
end process;

CNT_CHNG: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 255000000 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (var_int_counter < 50000) then
				var_int_counter := var_int_counter + 1;
				sig_std_comp <= '0';
			else 
				var_int_counter := 0;
				sig_std_comp <= '1';
			end if;
		end if;
end process;










end BUT_ARCH;	
