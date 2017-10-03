library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


package my_lib is

procedure read_1_adress	(	signal 	sig_data_rdy 		:	inout std_logic_vector(15 downto 0);
									signal 	sig_std_ready_rd 	: 	inout std_logic;
									signal 	port_in_data 		:	inout	std_logic_vector(15 downto 0);
									signal 	port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
									signal 	port_out_nwe 		: 	out 	std_logic;
									signal 	port_out_dir 		: 	out 	std_logic;
									signal 	port_out_noe 		: 	out 	std_logic;
									signal 	port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
									signal 	sig_std8_nce 		: 	inout	std_logic_vector(7 downto 0);
									signal 	cnt					: 	inout 	unsigned(3 downto 0);
									constant ADRESS_BUSY_READ	:  		std_logic_vector (10 downto 0);
									signal 	port_out_in_dir	:	out	std_logic;
									signal 	port_out_in_oe		:	out	std_logic;
									signal 	sig_chk				:	inout	std_logic;
									signal var_cnt				: 	inout	integer;
									signal sig_chpnt				: inout std_logic;
									signal	sig_timer			:	inout	integer);		
			---------------------------------------------------------------						
procedure read_ram	(	signal	sig_data_rdy 		: 	inout 	std_logic_vector(15 downto 0);
								signal 	port_in_data 		:	inout std_logic_vector(15 downto 0);
								signal 	port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
								signal 	port_out_nwe 		: 	out 	std_logic;
								signal 	port_out_dir 		: 	out 	std_logic;
								signal 	port_out_noe 		: 	out 	std_logic;
								signal 	port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
								signal 	sig_std8_nce 		: 	in 	std_logic_vector(7 downto 0);
								signal 	cnt					:	inout 	unsigned(3 downto 0);
								signal 	adress_cur 			: 	inout unsigned (10 downto 0) ;
								signal 	START_ADRESS_READ : 	in 	unsigned (10 downto 0);
								signal 	read_ok				:	out 	std_logic;
								signal 	port_out_in_dir	:	out	std_logic;
								signal 	port_out_in_oe		:	out	std_logic;
								constant 	end_adress			: 	in 	integer;
								signal 	count_read			:	in		unsigned (3 downto 0);
								signal 	i						: inout integer);
			---------------------------------------------------------------											
procedure write_1_adress	(	constant 	sig_data				:	in 	std_logic_vector(15 downto 0);
										signal 		port_in_data 		:	inout	std_logic_vector(15 downto 0);
										signal 		port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
										signal 		port_out_nwe 		: 	out 	std_logic;
										signal 		port_out_dir 		: 	out 	std_logic;
										signal 		port_out_noe 		: 	out 	std_logic;
										signal 		port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
										signal 		sig_std8_nce 		: 	in 	std_logic_vector(7 downto 0);
										signal 		cnt					: 	inout 	unsigned(3 downto 0);
										constant 	ADRESS_READY_READ :  		std_logic_vector (10 downto 0);
										signal 		sig_std_str 		: 	out 	std_logic;
										signal 		port_out_in_dir	:	out	std_logic;
										signal 		port_out_in_oe		:	out	std_logic);
------------------------------------------------------------------------------------------------------
procedure write_1_adress_init	(	constant 	sig_data				:	in 	std_logic_vector(15 downto 0);
											signal 		port_in_data 		:	inout	std_logic_vector(15 downto 0);
											signal 		port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
											signal 		port_out_nwe 		: 	out 	std_logic;
											signal 		port_out_dir 		: 	out 	std_logic;
											signal 		port_out_noe 		: 	out 	std_logic;
											signal 		port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
											signal 		sig_std8_nce 		: 	inout 	std_logic_vector(7 downto 0);
											signal 		cnt					: 	inout 	unsigned(3 downto 0);
											constant 	ADRESS_READY_READ :  		std_logic_vector (10 downto 0);
											signal 		sig_std_str 		: 	out 	std_logic;
											signal 		port_out_in_dir	:	out	std_logic;
											signal 		port_out_in_oe		:	out	std_logic;
											signal		sig_std_ok			: 	out	std_logic);
			---------------------------------------------------------------	
procedure write_all_adress	(	signal sig_data		:	in std_logic_vector(15 downto 0);
										signal port_in_data 	: 	out 	std_logic_vector(15 downto 0);
										signal port_out_adr 	: 	out 	std_logic_vector (10 downto 0);		
										signal port_out_nwe 	: 	out 	std_logic;
										signal port_out_dir 	: 	out 	std_logic;
										signal port_out_noe 	: 	out 	std_logic;
										signal port_out_nce : out std_logic_vector(7 downto 0);
										signal sig_std8_nce : in std_logic_vector(7 downto 0);
										signal cnt				: 	inout 	unsigned(3 downto 0);
										signal cur_adress 	:  inout 	unsigned (10 downto 0);
										signal START_ADRESS_WRITE : in unsigned (10 downto 0);
										signal write_ok			:	out 	std_logic;
										signal port_out_in_dir		:	out	std_logic;
										signal port_out_in_oe		:	out	std_logic;
										constant end_adress				:	in integer;
										signal count_write		:	in unsigned (3 downto 0);
										signal i						:inout integer); 										

			---------------------------------------------------------------										
procedure write_1_adress_final	(	constant 	sig_data			:	in 	std_logic_vector(15 downto 0);
												signal 	port_in_data 		:	inout std_logic_vector(15 downto 0);
												signal 	port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
												signal 	port_out_nwe 		: 	out 	std_logic;
												signal 	port_out_dir 		: 	out 	std_logic;
												signal 	port_out_noe 		: 	out 	std_logic;
												signal 	port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
												signal 	cnt					: 	inout 	unsigned(3 downto 0);
												constant	ADRESS_READY_READ	:  		std_logic_vector (10 downto 0);
												signal 	sig_std_dir 		:	out	std_logic;
												signal 	sig_std_rdy 		: 	out 	std_logic;
												signal 	write_ok 			: 	out 	std_logic;
												signal 	read_ok 				: 	out 	std_logic;
												signal 	sig_stop				:	out 	std_logic;
												signal 	sig_nce				: 	inout	std_logic_vector(7 downto 0);
												signal 	port_out_in_dir	:	out	std_logic;
												signal 	port_out_in_oe		:	out	std_logic;
												signal	global_count		:	inout integer;
												signal 	sig_nce_chk			: 	inout	std_logic_vector(7 downto 0);
												signal 	sig_chpnt			:	inout	std_logic;
												signal	sig_timer			:	inout	integer);
end my_lib;

			---------------------------------------------------------------	
			---------------------------------------------------------------	
			---------------------------------------------------------------				
package body my_lib is 

procedure read_1_adress	(	signal 	sig_data_rdy 		:	inout std_logic_vector(15 downto 0);
									signal 	sig_std_ready_rd 	: 	inout std_logic;
									signal 	port_in_data 		:	inout	std_logic_vector(15 downto 0);
									signal 	port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
									signal 	port_out_nwe 		: 	out 	std_logic;
									signal 	port_out_dir 		: 	out 	std_logic;
									signal 	port_out_noe 		: 	out 	std_logic;
									signal 	port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
									signal 	sig_std8_nce 		: 	inout 	std_logic_vector(7 downto 0);
									signal 	cnt					: 	inout 	unsigned(3 downto 0);
									constant ADRESS_BUSY_READ	:  		std_logic_vector (10 downto 0);
									signal 	port_out_in_dir	:	out	std_logic;
									signal 	port_out_in_oe		:	out	std_logic;
									signal 	sig_chk				:	inout	std_logic;
									signal var_cnt				: 	inout	integer;
									signal sig_chpnt				: inout std_logic;
									signal sig_timer	:	inout integer)	is
begin		


port_in_data <= (others => 'Z');
port_out_dir <= '1';
port_out_in_dir <= '0';
port_out_nwe <= '1';
port_out_adr<= ADRESS_BUSY_READ;

	
	if (cnt = x"0" ) then
		
		port_out_in_oe <= '0';
		cnt <= cnt + 1;
	elsif (cnt = x"1") then
		port_out_nce <= sig_std8_nce;
		port_out_noe <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= x"2" and cnt <=X"8" ) then
		cnt <= cnt + 1;
	elsif	(cnt >= x"9" and cnt <= x"A" ) then
		sig_data_rdy <= port_in_data;
		cnt <= cnt + 1;
	elsif (cnt = X"B") then	
			var_cnt <= var_cnt + 1;
			port_out_nce  <= X"FF";
			port_out_noe <= '1';
			port_out_in_oe <= '1';
			cnt <= X"0";
			if (sig_data_rdy = X"AAAA") then
				sig_std_ready_rd <= '1';
				port_out_dir <= '0';
				port_out_in_dir <= '1';
				sig_chk <= '0';
				if (var_cnt > 5) then
				sig_timer <= var_cnt + 1;
				end if;
				
			elsif (sig_data_rdy = X"BBBB") then
				
				sig_chk <= '1';
				sig_std_ready_rd <= '0';
				if (var_cnt < 5) then
					
					sig_std8_nce(5 downto 0) <= sig_std8_nce (4 downto 0) & sig_std8_nce(5);
				else
				
					sig_chpnt <= '1';
				end if;
			else
				
				sig_chk <= '1';
				sig_std_ready_rd <= '0';
				if (var_cnt < 5) then
					
					sig_std8_nce(5 downto 0) <= sig_std8_nce (4 downto 0) & sig_std8_nce(5);
				else 
					sig_chpnt <= '1';
				end if;
			end if;	
		
			
	end if;		
end procedure;
			---------------------------------------------------------------		
procedure read_ram	(	signal	sig_data_rdy 		: 	out 	std_logic_vector(15 downto 0);
								signal 	port_in_data 		:	inout std_logic_vector(15 downto 0);
								signal 	port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
								signal 	port_out_nwe 		: 	out 	std_logic;
								signal 	port_out_dir 		: 	out 	std_logic;
								signal 	port_out_noe 		: 	out 	std_logic;
								signal 	port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
								signal 	sig_std8_nce 		: 	in 	std_logic_vector(7 downto 0);
								signal 	cnt					:	inout 	unsigned(3 downto 0);
								signal 	adress_cur 			: 	inout unsigned (10 downto 0) ;
								signal 	START_ADRESS_READ : 	in 	unsigned (10 downto 0);
								signal 	read_ok				:	out 	std_logic;
								signal 	port_out_in_dir	:	out	std_logic;
								signal 	port_out_in_oe		:	out	std_logic;
								constant 	end_adress			: 	in 	integer;
								signal 	count_read			:	in		unsigned (3 downto 0);
								signal 	i							: inout integer) is
begin

port_in_data <= (others => 'Z');
port_out_dir <= '1';
port_out_in_dir <= '0';
port_out_nwe <= '1';
port_out_adr <= std_logic_vector(adress_cur);



	if (cnt = x"0") then
		
		port_out_nce <= sig_std8_nce;
		port_out_in_oe <= '0';
		cnt <= cnt + 1;
		
	elsif (cnt = x"1") then
		port_out_noe <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= x"2" and cnt <=X"9") then
		cnt <= cnt + 1;
		
	elsif (cnt = x"A" ) then
		sig_data_rdy <= port_in_data;
		cnt <= cnt + 1;		
	elsif (cnt = x"B") then
		cnt <= X"0";		
		if (adress_cur = to_unsigned(end_adress,11)) then
			port_out_in_oe <= '1';
			port_out_nce <= X"FF";
			port_out_noe <= '1';
			adress_cur <= START_ADRESS_READ;
			read_ok <= '1';
			port_out_dir <= '0';
			port_out_in_dir <= '1';
		else
			adress_cur <= adress_cur +	count_read;
			
		end if;
	end if;		
end procedure;
			---------------------------------------------------------------
procedure write_1_adress_init	(	constant 	sig_data				:	in 	std_logic_vector(15 downto 0);
											signal 		port_in_data 		:	inout	std_logic_vector(15 downto 0);
											signal 		port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
											signal 		port_out_nwe 		: 	out 	std_logic;
											signal 		port_out_dir 		: 	out 	std_logic;
											signal 		port_out_noe 		: 	out 	std_logic;
											signal 		port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
											signal 		sig_std8_nce 		: 	inout 	std_logic_vector(7 downto 0);
											signal 		cnt					: 	inout 	unsigned(3 downto 0);
											constant 	ADRESS_READY_READ :  		std_logic_vector (10 downto 0);
											signal 		sig_std_str 		: 	out 	std_logic;
											signal 		port_out_in_dir	:	out	std_logic;
											signal 		port_out_in_oe		:	out	std_logic;
											signal		sig_std_ok			: 	out	std_logic) is
begin
port_out_adr<= ADRESS_READY_READ;
port_out_dir <= '0';
port_out_noe <= '1';
port_out_in_dir <= '1';
port_in_data <= sig_data;
	if (cnt = x"0") then
		port_out_nwe <= '1';
		port_out_nce <= sig_std8_nce;
		port_out_in_oe <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= x"1" and cnt <= X"3") then
		port_out_nwe <= '0';
		cnt <= cnt + 1;
	elsif (cnt = X"4" or cnt = X"5") then
		port_out_nwe <= '1';
		cnt <= cnt + 1;
	elsif (cnt = x"6") then
		port_out_nce <= X"FF";
		port_out_in_oe <= '1';
		sig_std_str <= '0'	;
		port_out_dir <= '1';
		port_out_in_dir <= '0';
		cnt <= X"0";
		if (sig_std8_nce = X"DF" ) then
			sig_std8_nce <= X"FE";
			sig_std_ok <= '1';
		else 
			sig_std8_nce(5 downto 0) <= sig_std8_nce(4 downto 0) & sig_std8_nce(5);
		end if;
	end if;		
end procedure;		
			---------------------------------------------------------------
procedure write_1_adress	(	constant 	sig_data				:	in 	std_logic_vector(15 downto 0);
										signal 		port_in_data 		:	inout	std_logic_vector(15 downto 0);
										signal 		port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
										signal 		port_out_nwe 		: 	out 	std_logic;
										signal 		port_out_dir 		: 	out 	std_logic;
										signal 		port_out_noe 		: 	out 	std_logic;
										signal 		port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
										signal 		sig_std8_nce 		: 	in 	std_logic_vector(7 downto 0);
										signal 		cnt					: 	inout 	unsigned(3 downto 0);
										constant 	ADRESS_READY_READ :  		std_logic_vector (10 downto 0);
										signal 		sig_std_str 		: 	out 	std_logic;
										signal 		port_out_in_dir	:	out	std_logic;
										signal 		port_out_in_oe		:	out	std_logic) is
begin
port_out_adr<= ADRESS_READY_READ;
port_out_dir <= '0';
port_out_noe <= '1';
port_out_in_dir <= '1';
port_in_data <= sig_data;
	if (cnt = x"0") then
		port_out_nwe <= '1';
		port_out_nce <= sig_std8_nce;
		port_out_in_oe <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= x"1" and cnt <= X"4") then
		port_out_nwe <= '0';
		cnt <= cnt + 1;
	elsif (cnt = X"5") then
		port_out_nwe <= '1';
		cnt <= cnt + 1;
	elsif (cnt = x"6") then
		port_out_nce <= X"FF";
		port_out_in_oe <= '1';
		sig_std_str <= '0'	;
		port_out_dir <= '1';
		port_out_in_dir <= '0';
		cnt <= X"0";
	end if;		
end procedure;
			---------------------------------------------------------------		
	
procedure write_all_adress (	signal sig_data		:	inout std_logic_vector(15 downto 0);
										signal port_in_data 	: 	out 	std_logic_vector(15 downto 0);
										signal port_out_adr 	: 	out 	std_logic_vector (10 downto 0);		
										signal port_out_nwe 	: 	out 	std_logic;
										signal port_out_dir 	: 	out 	std_logic;
										signal port_out_noe 	: 	out 	std_logic;
										signal port_out_nce : out std_logic_vector(7 downto 0);
										signal sig_std8_nce : in std_logic_vector(7 downto 0);
										signal cnt				: 	inout 	unsigned(3 downto 0);
										signal cur_adress 	:  inout 	unsigned (10 downto 0);
										signal START_ADRESS_WRITE : in unsigned (10 downto 0);
										signal write_ok			:	out 	std_logic;
										signal port_out_in_dir		:	out	std_logic;
										signal port_out_in_oe		:	out	std_logic;
										constant end_adress				:integer;
										signal count_write		:unsigned (3 downto 0);
										signal i						: inout integer) is
begin
port_out_dir <= '0';
port_out_noe <= '1';
port_out_in_dir <= '1';
sig_data <= (others => 'Z');

port_out_adr <= std_logic_vector(cur_adress);
port_in_data <= sig_data;
	if (cnt = x"0") then

		port_out_nce <= sig_std8_nce;
		port_out_in_oe <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= x"1" and cnt <= x"3") then

		
		cnt <= cnt + 1;
	elsif (cnt >= x"4" and cnt <= X"6") then	
		port_out_nwe <= '0';
		cnt <= cnt + 1;
	elsif (cnt = X"7") then
		port_out_nwe <= '1';
		cnt <= cnt + 1;
	elsif (cnt = x"8") then
		cnt <= X"0";	
		if (cur_adress = to_unsigned(end_adress,11)) then
			cur_adress <= START_ADRESS_WRITE;
			write_ok <= '1';
			port_out_in_oe <= '1';
			port_out_nce <= X"FF";
		else
			cur_adress <= cur_adress + count_write;
			
		end if;
	end if;		
end procedure;
			---------------------------------------------------------------		
procedure write_1_adress_final	(	constant 	sig_data			:	in 	std_logic_vector(15 downto 0);
												signal 	port_in_data 		:	inout std_logic_vector(15 downto 0);
												signal 	port_out_adr 		: 	out 	std_logic_vector (10 downto 0);		
												signal 	port_out_nwe 		: 	out 	std_logic;
												signal 	port_out_dir 		: 	out 	std_logic;
												signal 	port_out_noe 		: 	out 	std_logic;
												signal 	port_out_nce 		: 	out 	std_logic_vector(7 downto 0);
												signal 	cnt					: 	inout 	unsigned(3 downto 0);
												constant	ADRESS_READY_READ	:  		std_logic_vector (10 downto 0);
												signal 	sig_std_dir 		:	out	std_logic;
												signal 	sig_std_rdy 		: 	out 	std_logic;
												signal 	write_ok 			: 	out 	std_logic;
												signal 	read_ok 				: 	out 	std_logic;
												signal 	sig_stop				:	out 	std_logic;
												signal 	sig_nce				: 	inout	std_logic_vector(7 downto 0);
												signal 	port_out_in_dir	:	out	std_logic;
												signal 	port_out_in_oe		:	out	std_logic;
												signal	global_count		:	inout integer;
												signal 	sig_nce_chk			: 	inout	std_logic_vector(7 downto 0);
												signal 	sig_chpnt			:	inout	std_logic;
												signal	sig_timer			:	inout	integer) is
begin
port_out_dir <= '0';
port_out_noe <= '1';
port_out_adr <= ADRESS_READY_READ;
port_out_in_dir <= '1';
port_in_data <= sig_data;
	if (cnt = x"0") then
		port_out_nce <= sig_nce;
		port_out_in_oe <= '0';
		cnt <= cnt + 1;
	elsif (cnt >= x"1" and cnt <=X"3") then
		port_out_nwe <= '0';
		cnt <= cnt + 1;
	elsif (cnt = x"4") then
		port_out_nwe <= '1';
		cnt <= cnt + 1;
		if (global_count > 5 and sig_nce_chk = X"00") then 
			sig_nce <= X"FE";
			sig_stop <= '1';
		end if;
	elsif (cnt = x"5") then
		port_out_nce <= X"FF";
		cnt <= cnt + 1;
	elsif (cnt = x"6") then
		cnt <= X"0";
		port_out_in_oe <= '1';
		port_out_dir <= '1';
		port_out_in_dir <= '0';
		sig_std_dir <= '1';
		sig_std_rdy <= '0'; 
		write_ok <= '0'; 
		read_ok <= '0';
		
		if (global_count > 5) then
			sig_chpnt <= '1';
		else
			sig_nce(5 downto 0) <= sig_nce(4 downto 0) & sig_nce(5);	
		end if;
		
	end if;		
end procedure;
end my_lib;

