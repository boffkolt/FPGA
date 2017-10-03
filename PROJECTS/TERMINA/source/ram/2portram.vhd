library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.my_lib.all;

entity RAM is
	generic(
				MAX_TIME_DELAY				:	integer range 1 to 50000000			:= 250000);			-- время ожидания
	port( 
		in_std_clk 					:	in std_logic; 														-- один порт для сигнала с кварца
		inout_std16_data 			: 	inout std_logic_vector(15 downto 0)			; 				-- шина данных
		in_std_ena					:	in std_logic;														-- разрешение работы
		out_std_ext_dir 			:	out std_logic 								:= '1';				-- направление буфера
		out_std_ext_noe 			: 	out std_logic								:= '1';				-- разрешение на выход
		out_std_ext_nwe 			: 	out std_logic 								:= '1';				-- разрешение на запись
		out_std12_adr				: 	out std_logic_vector(10 downto 0)			;				-- шина адреса

	
		out_std8_nce				: 	out std_logic_vector(7 downto 0)	:=X"FF"	;
		
		out_std_dir					:	out std_logic								:= '1';		-- выбор модуля 
		out_std_oe					:	out std_logic								:= '1';						-- выбор модуля 
		
		
	
		
		
		out_std8_nce_str			:	out	std_logic_vector(5 downto 0)	:= (others => '0');
		
		out_std8_nce_buf			: 	out std_logic_vector(7 downto 0) 	:= X"FF";
		out_std11_adr_buf			: 	out std_logic_vector(10 downto 0)			;	
		inout_std16_data_buf		: 	inout std_logic_vector(15 downto 0)	:= (others => 'Z')		; 	
		out_std_noe_buf			:	out std_logic								:= '1';
		out_std_nwe_buf			:	out std_logic								:= '1');
		
		
end RAM;
		
architecture RW_RAM of RAM is



type adr is array (0 to 5) of integer;
type num is array (0 to 5) of integer range 1 to 127;

	
constant NUMBER_WRITE	: num := (	0 => 72,
												1 => 72,
												2 => 24,
												3 => 24,
												4 => 2,
												5 => 2);		
												
constant NUMBER_READ		: num := (	0 => 36,
												1 => 36,
												2 => 24,
												3 => 24,
												4 => 24,
												5 => 24);
												
constant END_ADRESS_WRITE	: adr := (	0 => 768,
													1 => 768,
													2 => 192,
													3 => 192,
													4 => 16,
													5 => 16);		
												
constant END_ADRESS_READ	: adr := (	0 => 1312,
													1 => 1312,
													2 => 1216,
													3 => 1216,
													4 => 1224,
													5 => 1224);									

	

constant START_ADRESS_WRITE 	: integer range 1 to 1023 := 8;
constant START_ADRESS_READ 	: integer range 1025 to 2048 := 1032;	

constant COUNTER_WRITE				:	integer range 1 to 10					:= 8;	
constant COUNTER_READ				:	integer range 1 to 10					:= 8;	

constant ADRESS_BUSY_READ				:  std_logic_vector (10 downto 0) :=std_logic_vector(to_unsigned(1024,11));
constant ADRESS_WRITE					:  std_logic_vector (10 downto 0) :=std_logic_vector(to_unsigned(0,11));
constant sig_s16_data_ready			:  std_logic_vector (15 downto 0):=X"BBBB";

constant sig_s16_data_busy				: 	std_logic_vector (15 downto 0):= X"AAAA";

--signal sig_u8_number_write				:	unsigned (7 downto 0)	;
--signal sig_u8_number_read				:	unsigned (7 downto 0);

signal sig_u4_counter_read				:	unsigned (3 downto 0)	;
signal sig_u4_counter_write			:	unsigned (3 downto 0)	;

signal sig_u12_start_adress_read		:	unsigned (10 downto 0)	;
signal sig_u12_start_adress_write	:	unsigned (10 downto 0)	;

signal sig_u27_max_time_delay			:	unsigned (26 downto 0)	;

Signal sig_u16_data 						: 	unsigned (15 downto 0)	:= (others => 'Z');
signal sig_std_ena						: 	std_logic					:= '0';

signal sig_u4_cnt							: 	unsigned (3 downto 0)	:= X"0";

signal sig_u12_adr_read					: 	unsigned (10 downto 0) 	:= to_unsigned(START_ADRESS_READ,11);
signal sig_u12_adr_write				: 	unsigned (10 downto 0) 	:= to_unsigned(START_ADRESS_WRITE,11);
signal sig_std_rdy						: 	std_logic 					:='0';
Signal sig_u16_data_rdy 				: 	std_logic_vector (15 downto 0)	:= (others => 'Z');

signal sig_std_strt 					:	std_logic := '0';

signal sig_u8_cnt							:	unsigned (7 downto 0)	:= (others => '0');
--signal sig_std_word_ok					: 	std_logic:='0';
--signal sig_std_word_write_ok			:	std_logic:='0';



signal sig_std_dir						:  std_logic							:='1';

signal sig_std_start						:  std_logic							:='0';
signal sig_std_stop						: 	std_logic							:='0';





signal sig_std_read_ok					: 	std_logic							:='0';
signal sig_std_write_ok					: 	std_logic							:='0';

signal sig_std_ok							: 	std_logic							:='0';




signal sig_int_cnt_num_read			: unsigned(7 downto 0) 				;
signal sig_int_cnt_num_write			: unsigned(7 downto 0) 				;

signal sig_std8_nce						:  std_logic_vector(7 downto 0)	:=X"FE";
signal sig_int_end_adr_read							:	integer		;
signal sig_int_end_adr_write							:	integer		;
signal sig_int_i							: integer	:=	0;
-- signal sig_int_fin_cnt					: integer	:= 0;
signal i										: integer;

signal sig_std8_chk_ce 					: std_logic_vector (7 downto 0) := X"00";
signal sig_std_chpnt						: std_logic := '0';
signal var_int_counter : integer := 0;
signal	int_i 				:integer:= 0;	
signal sig_int_time		: 	integer:=0;



 
 begin

i <= 	0	when (sig_std8_nce = X"FE") else
		1	when (sig_std8_nce = X"FD") else
		2	when (sig_std8_nce = X"FB") else
		3	when (sig_std8_nce = X"F7") else
		4	when (sig_std8_nce = X"EF") else
		5	when (sig_std8_nce = X"DF") else
		6	when (sig_std8_nce = X"BF") ;

 
 sig_u4_counter_read <= to_unsigned(COUNTER_READ,4);
 sig_u4_counter_write <= to_unsigned(COUNTER_WRITE,4);
 --sig_u8_number_read <= to_unsigned(NUMBER_READ(i),8);
 --sig_u8_number_write	<= to_unsigned(NUMBER_WRITE(i),8);
 
 sig_u12_start_adress_read <= to_unsigned(START_ADRESS_READ,11);

 sig_u12_start_adress_write <= to_unsigned(START_ADRESS_WRITE,11);

-- sig_int_fin_cnt 	<= 	11 when (sig_std_rdy = '0') else
--								11 when (sig_std_read_ok = '0' and sig_std_dir = '0') else
--								6;
--  



----------------------------------------------------------------
----------------------------------------------------------------
-------- ОЗУ-------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
RAM_READ : process(in_std_ena,in_std_clk)
	
	 
	begin
		if (in_std_ena = '0') then
		elsif(in_std_clk'event and in_std_clk = '1') then
			 
			if (sig_std_start = '1' ) then
			
				if (var_int_counter < 20) then
					
					if (sig_std_chpnt = '0') then	
					
						if(sig_std_rdy = '0' ) then
	
		
							read_1_adress (	sig_u16_data_rdy,
													sig_std_rdy,
													inout_std16_data,
													out_std12_adr,
													out_std_ext_nwe ,
													out_std_ext_dir,
													out_std_ext_noe,
													out_std8_nce,
													sig_std8_nce,
													sig_u4_cnt,
													ADRESS_BUSY_READ,
													out_std_dir,
													out_std_oe,
													sig_std8_chk_ce(i),
													var_int_counter,
													sig_std_chpnt,
													sig_int_time);
													
													
													
						
					
						
						
						
						elsif (sig_std_rdy = '1'  and sig_std_dir = '1' ) then
		
							write_1_adress (	sig_s16_data_ready,
													inout_std16_data,
													out_std12_adr,	
													out_std_ext_nwe ,
													out_std_ext_dir,
													out_std_ext_noe,
													out_std8_nce,
													sig_std8_nce,
													sig_u4_cnt,
													ADRESS_WRITE,
													sig_std_dir,
													out_std_dir,
													out_std_oe);
													
													
						elsif (sig_std_read_ok = '0' and sig_std_dir = '0') then
							
							read_ram (	inout_std16_data_buf,
											inout_std16_data,
											out_std12_adr,	
											out_std_ext_nwe ,
											out_std_ext_dir,
											out_std_ext_noe,
											out_std8_nce,
											sig_std8_nce,
											sig_u4_cnt,
											sig_u12_adr_read,
											sig_u12_start_adress_read,
											sig_std_read_ok,
											out_std_dir,
											out_std_oe,
											END_ADRESS_READ(i),
											sig_u4_counter_read,
											sig_int_i);
			
						elsif (sig_std_read_ok = '1' and sig_std_write_ok = '0')  then
							
							write_all_adress (inout_std16_data_buf,
													inout_std16_data,
													out_std12_adr,
													out_std_ext_nwe ,
													out_std_ext_dir,
													out_std_ext_noe,
													out_std8_nce,
													sig_std8_nce,
													sig_u4_cnt,
													sig_u12_adr_write,
													sig_u12_start_adress_write,
													sig_std_write_ok,
													out_std_dir,
													out_std_oe,
													END_ADRESS_WRITE(i),
													sig_u4_counter_write,
													sig_int_i);
								
						elsif (sig_std_read_ok = '1' and sig_std_write_ok = '1') then
												
							write_1_adress_final (	sig_s16_data_busy,
															inout_std16_data,
															out_std12_adr,	
															out_std_ext_nwe ,
															out_std_ext_dir,
															out_std_ext_noe,
															out_std8_nce,
															sig_u4_cnt,
															ADRESS_WRITE,
															sig_std_dir,
															sig_std_rdy,
															sig_std_write_ok,
															sig_std_read_ok,
															sig_std_stop,
															sig_std8_nce,
															out_std_dir,
															out_std_oe,
															var_int_counter,
															sig_std8_chk_ce,
															sig_std_chpnt,
															sig_int_time);
						end if;
					elsif (sig_std_chpnt = '1' and sig_std8_chk_ce(int_i) = '1' ) then
							sig_std8_nce <= (others => '1');
							sig_std8_nce(int_i) <= '0';
						--	sig_std8_chk_ce(int_i) <= '0';
							int_i <= int_i +1;
							out_std_oe <= '1';
							out_std_ext_dir <= '1';
							out_std_dir <= '0';
							sig_std_dir <= '1';
							sig_std_rdy <= '0'; 
							sig_std_read_ok <= '0'; 
							sig_std_write_ok <= '0';
							sig_std_chpnt <= '0';
							sig_u4_cnt <= X"0";
					
					
					elsif (sig_std_chpnt = '1' and sig_std8_chk_ce(int_i) = '0' ) then 
						
							int_i <= int_i +1;
					
							
					end if;
				else 
					sig_std_stop <= '1';
					var_int_counter <= 0;
				end if;									
	
			else
				if (sig_std_start = '0' and sig_std_ok = '0') then
					write_1_adress_init (sig_s16_data_busy,
												inout_std16_data,
												out_std12_adr,	
												out_std_ext_nwe ,
												out_std_ext_dir,
												out_std_ext_noe,
												out_std8_nce,
												sig_std8_nce,
												sig_u4_cnt,
												ADRESS_WRITE,
												sig_std_dir,
												out_std_dir,
												out_std_oe,
												sig_std_ok);
				else 
			
					sig_std_dir <= '1';
					sig_std_rdy <= '0'; 
					sig_std_write_ok <= '0'; 
					sig_std_read_ok <= '0';
					out_std8_nce <= X"FF";
					sig_std8_nce <= X"FE";
					sig_std_stop <= '0';
					--sig_std_word_write_ok <= '0';
					--sig_std_word_ok <= '0';
					sig_int_i <= 0;
					sig_std_chpnt <= '0';
					int_i <= 0;
					sig_std8_chk_ce <= X"00";
					var_int_counter <= 0;
					sig_u4_cnt <= X"0";
				
				end if;
			end if;

		end if;
	end process;
	
	

	
	
	
RW_BUF: process(in_std_ena,in_std_clk)	
begin
	if (in_std_ena = '0') then
		
			
	elsif(in_std_clk'event and in_std_clk = '1') then
		if (sig_std_start = '1') then
			if (sig_std_read_ok = '0' and sig_std_dir = '0') then
				if (sig_u4_cnt = X"0") then
					out_std_noe_buf <= '1';
					out_std_nwe_buf <= '1';
					out_std8_nce_buf <= X"FF";
					out_std11_adr_buf	<= std_logic_vector(sig_u12_adr_read);
				elsif (sig_u4_cnt = X"1") then	
					out_std8_nce_buf <= sig_std8_nce;
				elsif (sig_u4_cnt = X"B") then
					out_std_nwe_buf <= '0';
				end if;
			elsif (sig_std_read_ok = '1' and sig_std_write_ok = '0')  then
				if (sig_u4_cnt = X"0") then
					out_std11_adr_buf	<= std_logic_vector(sig_u12_adr_write);
					out_std_nwe_buf <= '1';
					out_std_noe_buf <= '0';
					out_std8_nce_buf <= sig_std8_nce;
					
				elsif (sig_u4_cnt = X"1") then	
					
				elsif (sig_u4_cnt = X"5") then
					out_std_noe_buf <= '1';
					out_std8_nce_buf <= X"FF";
				end if;
			end if;
		end if;	
	end if;
end process;
		
		
START: process(in_std_ena,in_std_clk)		
begin
	if (in_std_ena = '0') then
			sig_std_start <= '0';
			
	elsif(in_std_clk'event and in_std_clk = '1') then
			
			if (sig_std_strt = '1' and sig_std_strt'last_value = '0') then
				sig_std_start <= '1';
			elsif (sig_std_stop = '1' and sig_std_stop'last_value = '0') then
				sig_std_start <= '0';
			else 
				sig_std_start <= sig_std_start;
			end if;
	end if;
		
end process;

CNT : process(in_std_clk,in_std_ena)
variable var_int_counter		:	integer range 0 to 51000000	:= 0;
	begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (var_int_counter < 5000) then
					var_int_counter:= var_int_counter + 1;
					sig_std_strt <= '0';
				else 

					var_int_counter := 0;
					sig_std_strt <= '1';
				end if;
		end if;
end process;

STROBE_CONTROL: process(in_std_ena,in_std_clk)		
begin
	if (in_std_ena = '0') then
			
			
	elsif(in_std_clk'event and in_std_clk = '1') then
			
			if (sig_std_read_ok = '1' and sig_std_write_ok = '1') then
				if (sig_u4_cnt = X"0") then
					out_std8_nce_str(i) <= '1'; 	
				end if;
			else 
				out_std8_nce_str <= (others => '0');
			end if;
	end if;
		
end process;

 end RW_RAM;
 
--  
