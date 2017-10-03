library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


package lib_ddr is

procedure read_ddr	(	signal 	sig_int_cnt			:	inout integer;
						signal 	sig_std27_adr_in	:	in std_logic_vector(26 downto 0);
						signal 	sig_std27_adr_out	:	out std_logic_vector(26 downto 0);
						signal 	sig_std256_data_in	:	in std_logic_vector(255 downto 0);
						signal 	sig_std256_data_out	:	out std_logic_vector(255 downto 0);
						signal 	sig_std_waitrq		: 	in std_logic;
						signal 	sig_std_rd			:	out std_logic;
						signal 	sig_std_read_ok		:	out std_logic;
						signal	sig_std_valid_data	:	out	std_logic);
						
						
procedure write_ddr	(	signal 	sig_int_cnt			:	inout integer;
						signal 	sig_std27_adr_in	:	in std_logic_vector(26 downto 0);
						signal 	sig_std27_adr_out	:	out std_logic_vector(26 downto 0);
						signal 	sig_std256_data_in	:	in std_logic_vector(255 downto 0);
						signal 	sig_std256_data_out	:	out std_logic_vector(255 downto 0);
						signal 	sig_std_waitrq		: 	in std_logic;
						signal 	sig_std_wr			:	out std_logic;
						signal 	sig_std_write_ok	:	out std_logic);		

			---------------------------------------------------------------										

end lib_ddr;

			---------------------------------------------------------------	
			---------------------------------------------------------------	
			---------------------------------------------------------------				
package body lib_ddr is 

procedure read_ddr	(	signal 	sig_int_cnt			:	inout integer;
						signal 	sig_std27_adr_in	:	in std_logic_vector(26 downto 0);
						signal 	sig_std27_adr_out	:	out std_logic_vector(26 downto 0);
						signal 	sig_std256_data_in	:	in std_logic_vector(255 downto 0);
						signal 	sig_std256_data_out	:	out std_logic_vector(255 downto 0);
						signal 	sig_std_waitrq		: 	in std_logic;
						signal 	sig_std_rd			:	out std_logic;
						signal 	sig_std_read_ok		:	out std_logic;
						signal	sig_std_valid_data	:	out	std_logic) is
begin		
	sig_std27_adr_out <= sig_std27_adr_in;
	if (sig_int_cnt = 0) then
	sig_std_rd <= '1';
	sig_std_valid_data <= '0';
	sig_std_read_ok	<='0';
	sig_int_cnt <= sig_int_cnt + 1;
	elsif(sig_int_cnt >= 1 and sig_int_cnt <= 6) then
	
		if (sig_std_waitrq = '0') then
	--		sig_std_rd <= '0';
			
			
			sig_int_cnt <= sig_int_cnt + 1;

		end if;
	elsif (sig_int_cnt = 7 ) then
		if (sig_std_waitrq = '0') then
			sig_std_valid_data <= '1';
			
			sig_std_read_ok	<='1';
		end if;
	end if;	
end procedure;


procedure write_ddr	(	signal 	sig_int_cnt			:	inout integer;
						signal 	sig_std27_adr_in	:	in std_logic_vector(26 downto 0);
						signal 	sig_std27_adr_out	:	out std_logic_vector(26 downto 0);
						signal 	sig_std256_data_in	:	in std_logic_vector(255 downto 0);
						signal 	sig_std256_data_out	:	out std_logic_vector(255 downto 0);
						signal 	sig_std_waitrq		: 	in std_logic;
						signal 	sig_std_wr			:	out std_logic;
						signal 	sig_std_write_ok	:	out std_logic) is
begin		
	sig_std27_adr_out <= sig_std27_adr_in;
	sig_std256_data_out <= sig_std256_data_in;
	if (sig_int_cnt = 0) then
		sig_std_wr <= '1';
		sig_std_write_ok <='0';
		sig_int_cnt <= sig_int_cnt + 1;
	elsif(sig_int_cnt = 1 ) then
	
		if (sig_std_waitrq = '0') then
			sig_std_write_ok	<='1';
		end if;
		
	end if;	
end procedure;
			---------------------------------------------------------------		
------------------------------------------------------------------------------------
end lib_ddr;

