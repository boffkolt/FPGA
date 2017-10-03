library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


package lib_lcd is


			---------------------------------------------------------------											
procedure write_cmd_data	(	signal 		port_out_data 		:	out	std_logic_vector(7 downto 0);
								constant 		sig_data 			:	in		std_logic_vector(7 downto 0);		
								signal 		port_out_a 			: 	out 	std_logic;
								signal 		port_out_wr 		: 	out 	std_logic;
								signal 		port_out_cs 		: 	out 	std_logic;
								signal 		i						:	inout integer;
								constant	i_arr				: in integer;
								signal 		cnt					: 	inout 	integer;
								signal		cmd	: inout std_logic;
								signal 		init				:	out	std_logic);

			---------------------------------------------------------------	

			---------------------------------------------------------------											
										

end lib_lcd;

			---------------------------------------------------------------	
			---------------------------------------------------------------	
			---------------------------------------------------------------				
package body lib_lcd is 


			---------------------------------------------------------------
procedure write_cmd_data				(	signal 		port_out_data 		:	out		std_logic_vector(7 downto 0);
											constant 	sig_data 			:	in		std_logic_vector(7 downto 0);		
											signal 		port_out_a 			: 	out 	std_logic;
											signal 		port_out_wr 		: 	out 	std_logic;
											signal 		port_out_cs 		: 	out 	std_logic;
											signal 		i					:	inout 	integer;
											constant		i_arr				:	in 		integer;
											signal 		cnt					: 	inout 	integer;
											signal		cmd					: 	inout 	std_logic;
											signal 		init				:	out		std_logic) is
begin
if (cmd = '0') then
	port_out_data <= sig_data;
	
	if (cnt >= 0 and cnt <= 2) then
		
		cnt <= cnt + 1;
	elsif (cnt >= 3 and cnt <= 5 ) then
		port_out_a <= '1';
		cnt <= cnt + 1;
	elsif (cnt >= 6 and cnt <= 8 ) then
		port_out_cs <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= 9 and cnt <= 13 ) then
		port_out_wr <= '0';
		cnt <= cnt + 1;
	elsif (cnt = 14) then
		port_out_wr <= '1';
		cnt <= cnt + 1;
	elsif (cnt = 15) then
		port_out_cs <= '1';
	
		cnt <= 0;
		if (i = i_arr) then
			i <= 0;
			init <= '1';
			cmd <= '0';
		else
			cmd <= '1';
			i <= i + 1;
		end if;
	end if;	
else
	port_out_data <= sig_data;
	if (cnt >= 0 and cnt <= 2) then
		
		cnt <= cnt + 1;
	elsif (cnt >= 3 and cnt <= 5  ) then
		port_out_a <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= 6 and cnt <= 8 ) then
		port_out_cs <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= 9 and cnt <= 13 ) then
		port_out_wr <= '0';
		cnt <= cnt + 1;
	elsif (cnt = 14) then
		port_out_wr <= '1';
		cnt <= cnt + 1;
	elsif (cnt = 15) then
		port_out_cs <= '1';
	
		cnt <= 0;		

		if (i = i_arr) then
			i <= 0;
			init <= '1';
			cmd <= '0';
		else
			i <= i + 1;
		end if;
	end if;		
end if;
end procedure;		


----------------------------------------
-----------------------------------------------------------------------------------------------
end lib_lcd;

