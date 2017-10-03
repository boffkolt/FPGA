library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity VGA is
	
	port( 
		in_std_clk 					:	in std_logic; 												
	
		in_std_ena					:	in std_logic := '1';														
		
		out_std_R				:	out std_logic := '0';
		out_std_G				:	out std_logic := '1';
		out_std_B				:	out std_logic := '0';
		out_std_H_S				:	out std_logic := '1';
		out_std_V_S				:	out std_logic := '1');
		
		
end VGA;
		
architecture VGA_ARCH of VGA is


--signal sig_std8_start					: std_logic_vector(7 downto 0) := X"FF";                                                                                       
--signal sig_std256_data					: std_logic_vector(255 downto 0);
--signal sig_std256_data_t1					: std_logic_vector(255 downto 0);
--signal sig_std_start					:  std_logic							:='0';
signal sig_std_line_ok						: 	std_logic							:='0';
signal sig_std_str_ok						: 	std_logic							:='0';
--signal sig_std_strt						:  std_logic							:='0';
--signal sig_std_change_bit			:	std_logic							:='0';
--signal sig_std_init			: std_logic	:= '0';
--signal sig_std_change_data	:	std_logic := '0';
--
--signal sig_std_read_ok					: 	std_logic							:='0';
--
--signal sig_int_count						: integer	:=	0;
--
begin
--
--
--WRK: process(in_std_ena,in_std_clk)
--
--begin
--		if (in_std_ena = '0') then
--		
--		elsif (in_std_clk'event and in_std_clk='1') then 
--		end if;
--end process; 
-- 
 
 
CNT_hor: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 5000 := 0;
begin
	if (in_std_ena = '0') then
		var_int_counter := 0;
	elsif (in_std_clk'event and in_std_clk='1') then 
		if (sig_std_line_ok = '0') then 
			if (var_int_counter >= 0 and  var_int_counter <= 855) then
				var_int_counter := var_int_counter + 1;
				out_std_H_S <= '1';
			elsif (var_int_counter > 855 and  var_int_counter < 976) then  
				var_int_counter := var_int_counter + 1;
				out_std_H_S <= '0';
			elsif (var_int_counter >= 976 and  var_int_counter < 1040) then  
				var_int_counter := var_int_counter + 1;
				out_std_H_S <= '1';	
			elsif (var_int_counter = 1040) then  
				var_int_counter := 0;
				out_std_H_S <= '1';	
				sig_std_line_ok <= '1';
			end if;
		else
			if (sig_std_str_ok = '1') then
				sig_std_line_ok <= '0';
			end if;
		end if;
	end if;
end process;

CNT_ver: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 5000 := 0;
begin
		if (in_std_ena = '0') then
		var_int_counter := 0;
	elsif (in_std_clk'event and in_std_clk='1') then 
		if (sig_std_line_ok = '1') then 
			if (var_int_counter >= 0 and  var_int_counter <= 637) then
				var_int_counter := var_int_counter + 1;
				sig_std_str_ok <= '1';
				out_std_V_S <= '1';

			elsif (var_int_counter > 637 and  var_int_counter < 643) then  
				var_int_counter := var_int_counter + 1;
				out_std_V_S <= '0';
				sig_std_str_ok <= '1';
			elsif (var_int_counter >= 643 and  var_int_counter < 666) then  
				var_int_counter := var_int_counter + 1;
				out_std_V_S <= '1';
				sig_std_str_ok <= '1';	
			elsif (var_int_counter = 666) then  
				var_int_counter := 0;
				out_std_V_S <= '1';	
				sig_std_str_ok <= '1';
			end if;
		else
			sig_std_str_ok <= '0';
		end if;
	end if;
end process;





















end VGA_ARCH;	
