library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity control is
	
	port( 
		in_std_clk 					:	in std_logic; 												--|
		in_std_ena 					:	in std_logic;                                               --|---Порты общие
		in_std32_base_ddr			:	in std_logic_vector (31 downto 0);	                        --|
		------------------------------------------------------
		out_std_str_wr				:	out std_logic	:=	'0';												--|
		out_std_str_rd				:	out std_logic	:=	'0';												--|
		in_std_ready				:	in std_logic;												--|
		out_std256_data_out			:	out std_logic_vector (255 downto 0);   			 			--|---Порты для DDR
		in_std256_data_in			:	in std_logic_vector (255 downto 0);     					--|
		in_std_data_valid			:	in std_logic;												--|
		out_std27_adr_ddr			:	out std_logic_vector(26 downto 0);      					--|
		------------------------------------------------------
		out_std11_adr_un_buf		: 	out std_logic_vector(10 downto 0);							--|
		inout_std16_data_un_buf		: 	inout std_logic_vector(15 downto 0)	:= (others => 'Z'); 	--|
		out_std_noe_un_buf			:	out std_logic						:= '1';         		--|
		out_std_nwe_un_buf			:	out std_logic						:= '1';			        --|
		out_std8_nce_buf			: 	out std_logic_vector(7 downto 0) 	:= X"FF";               --|
		out_std6_vip				:	out std_logic_vector(5 downto 0)	:=	"111111";                           --|
		out_std256_data_led			:	out std_logic_vector(255 downto 0);                         --|---Порты для модулей
		in_std25_data_key			: 	in std_logic_vector(24 downto 0);							--|
		out_std8_data_lcd_buf		:	out std_logic_vector(7 downto 0);                           --|
		out_std16_adr_lcd_buf		:	out std_logic_vector(15 downto 0);                          --|
		out_std_nwe_lcd_buf			:	out std_logic;                                              --|
		out_std_lcd_mode			:	out std_logic := '0';                                       --|
		out_std_chpnt			:	out std_logic := '0'; 
		in_std10_nce_strobe			: 	in std_logic_vector(9 downto 0)		:= "00" & X"00");     --|
		                                                                                          		
end control;
--		
architecture RW_RAM of control is
--
---------------------------------------------------------------
type mem is array (natural range <>) of std_logic_vector(255 downto 0);
type adr is array (0 to 5) of unsigned (10 downto 0);

constant END_ADRESS_WRITE	: adr := (		0 => to_unsigned(768,11),
											1 => to_unsigned(768,11),
											2 => to_unsigned(192,11),
											3 => to_unsigned(192,11),
											4 => to_unsigned(16,11),
											5 => to_unsigned(16,11));		
												
constant END_ADRESS_READ	: adr := (		0 => to_unsigned(1312,11),
											1 => to_unsigned(1312,11),
											2 => to_unsigned(1216,11),
											3 => to_unsigned(1216,11),
											4 => to_unsigned(1216,11),
											5 => to_unsigned(1216,11));	
signal temp : mem (0 to 17);
signal temp1 : mem (0 to 17);
--------------------------------------------------------------
signal i 					: 	integer range 0 to 10 := 10;
signal i_t1 					: 	integer range 0 to 10 := 10;
signal ind 					: 	integer range 0 to 10 := 0;



--------------------------------------
signal	sig_int_ind_0		:	integer range 0 to 20  := 1;
signal	ind_i0				:	integer range 0 to 255 	:= 255;

--------------------------------------
signal	sig_int_ind_1		:	integer range 0 to 20	:= 5;
--------------------------------------
--------------------------------------
signal	ind_i2				:	integer range 0 to 255 := 0;
--------------------------------------
--------------------------------------
signal	sig_int_ind_4		:	integer	range 0 to 20	:= 12;
signal	ind_i4				:	integer range 0 to 255:= 239;

--------------------------------------
signal	sig_int_ind_5		:	integer	range 0 to 20	:= 15;
--------------------------------------

signal ind_i8				:	integer range 0 to 255:= 255;

--------------------------------------
signal sig_std4_chk_buf 	: 	std_logic_vector(3 downto 0) := X"0";				
signal sig_std_valid_data 	: 	std_logic := '0';
signal sig_std10_nce_strobe	:	std_logic_vector(9 downto 0):= "00" & X"00";
signal sig_std10_nce_strobe_t1: std_logic_vector(9 downto 0):= "00" & X"00"; 

signal sig_std10_flag_chk	:	std_logic_vector(9 downto 0):= "11" & X"FF";
signal sig_std_stop_t1 		: 	std_logic					:= '0';
signal sig_std_start 		: 	std_logic 					:= '0';
signal sig_std_stop 		: 	std_logic 					:= '0';

signal sig_std10_flag		:	std_logic_vector(9 downto 0):= "00" & X"00";
signal sig_int_cnt_glob		: 	integer						:= 0;
signal sig_int_cnt_words	: 	integer						:= 0;

signal sig_int_cnt			:	integer range 0 to 10		:= 0;
signal sig_u11_cur_adr_rd	: 	unsigned(10 downto 0) 		:= to_unsigned(1032,11);
signal sig_u11_cur_adr_wr	: 	unsigned(10 downto 0) 		:= to_unsigned(8,11);
constant sig_u4_adr_cnt		: 	unsigned(3 downto 0) 		:= to_unsigned(8,4);
signal sig_std_read_ok		:	std_logic 					:= '0';
signal sig_std8_ce_chk		:  	std_logic_vector(7 downto 0):= X"00";
signal sig_std_chk_buf		: 	std_logic					:= '0';
signal sig_std_chk_buf_t1		: 	std_logic					:= '0';
signal sig_std16_adr_disp	:	std_logic_vector(15 downto 0) := X"0001";
signal sig_std32_base_ddr	: 	std_logic_vector (31 downto 0);		
signal sig_std8_test		:	std_logic_vector(7 downto 0);
--

signal flag					: 	std_logic:='0';
signal flag1				: 	std_logic:='0';
signal count				: 	integer:=0;	
--------------------------------
signal sig_int_adr_0		:	integer						:= 1;
signal sig_int_adr_1		:	integer						:= 5;
signal sig_int_adr_2		:	integer						:= 9;
signal sig_int_adr_3		:	integer						:= 11;
signal sig_int_adr_4		:	integer						:= 12;
signal sig_int_adr_5		:	integer						:= 15;
signal sig_int_adr_6		:	integer						:= 1;
signal sig_int_adr_7		:	integer						:= 1;
signal sig_int_adr_8		:	integer						:= 21;
signal cnt					:	integer						:= 0;
signal sig_std_256_read	:	std_logic					:= '0';
signal sig_std256_tmp_word	:	std_logic_vector(255 downto 0):= (others => '0');
signal sig_int_count		:	integer	:= 0;
signal temp_std256_data_led : std_logic_vector(255 downto 0):= (others => '0');
signal sig_std_init_ddr	: 	std_logic					:= '0';
signal sig_std_init_ddr1	: 	std_logic					:= '0';
signal sig_std_data_valid_t1	: std_logic := '0';
signal sig_std_ready_t1	: std_logic := '0'; 
signal sig_std_all_data_adc	: std_logic := '0'; 
		
 
 begin

sig_std32_base_ddr <= in_std32_base_ddr;



--------

				

----
STROBESS : process(in_std_clk, in_std_ena)
 
	begin
		if (in_std_ena = '0') then
			i <= 10;
		elsif(in_std_clk'event and in_std_clk = '1') then
			if (sig_std_start = '1') then
				if (sig_std_stop = '1') then
					sig_std_start <= '0';
				elsif (sig_std10_flag_chk(0) = '0') then
					i <= 0;
				elsif (sig_std10_flag_chk(1) = '0') then
					i <= 1;	
				elsif (sig_std10_flag_chk(2) = '0') then
					i <= 2;		
				elsif (sig_std10_flag_chk(3) = '0') then
					i <= 3;			
				elsif (sig_std10_flag_chk(4) = '0') then
					i <= 4;		
				elsif (sig_std10_flag_chk(5) = '0') then
					i <= 5;		
				elsif (sig_std10_flag_chk(6) = '0') then
					i <= 6;		
				elsif (sig_std10_flag_chk(7) = '0') then
					i <= 7;
				elsif (sig_std10_flag_chk(8) = '0') then
					i <= 8;	
				elsif (sig_std10_flag_chk(9) = '0') then
					i <= 9;	
				end if;							
			
			else
				if (sig_std10_nce_strobe(0) = '1' and sig_std10_nce_strobe_t1(0) = '0') then
					i <= 0;
					sig_std_start <= '1';
				elsif (sig_std10_nce_strobe(1) = '1' and sig_std10_nce_strobe_t1(1) = '0') then
					i <= 1;	
					sig_std_start <= '1';
				elsif (sig_std10_nce_strobe(2) = '1' and sig_std10_nce_strobe_t1(2) = '0') then
					i <= 2;	
					sig_std_start <= '1';	
				elsif (sig_std10_nce_strobe(3) = '1' and sig_std10_nce_strobe_t1(3) = '0') then
					i <= 3;
					sig_std_start <= '1';			
				elsif (sig_std10_nce_strobe(4) = '1' and sig_std10_nce_strobe_t1(4) = '0' ) then
					i <= 4;
					sig_std_start <= '1';
				elsif (sig_std10_nce_strobe(5) = '1' and sig_std10_nce_strobe_t1(5) = '0') then
					i <= 5;	
					sig_std_start <= '1';
				elsif (sig_std10_nce_strobe(6) = '1' and sig_std10_nce_strobe_t1(6) = '0') then
					i <= 6;	
					sig_std_start <= '1';
				elsif (sig_std10_nce_strobe(7) = '1' and sig_std10_nce_strobe_t1(7) = '0') then
					i <= 7;
					sig_std_start <= '1';
				elsif (sig_std10_nce_strobe(8) = '1' and sig_std10_nce_strobe_t1(8) = '0') then
					i <= 8;
					sig_std_start <= '1';	
				elsif (sig_std10_nce_strobe(9) = '1' and sig_std10_nce_strobe_t1(9) = '0') then
					i <= 9;		
					sig_std_start <= '1';
				end if;
			end if;
		end if;
	end process;	

g0: for i in 0 to 9 generate  
 FLAG_CE: process(in_std_clk, in_std_ena)
 
	begin
		if (in_std_ena = '0') then
			sig_std10_flag(i) <= '0';
		elsif(in_std_clk'event and in_std_clk = '1') then
			if (sig_std10_nce_strobe(i) = '1' and sig_std10_nce_strobe_t1(i) = '0' and sig_std_start = '1') then
				sig_std10_flag(i) <= '1';
			elsif (sig_std10_flag_chk(i) = '0') then
				sig_std10_flag(i) <= '0';
			end if;
		end if;
	end process;
end generate;	
	
	
	
	
 
 STROB: process(in_std_clk, in_std_ena)
 
	begin
		if (in_std_ena = '0') then
			sig_std10_nce_strobe <= (others => '0');
			sig_std10_nce_strobe_t1 <= (others => '0');
			sig_std_stop_t1 <= '0';
		elsif(in_std_clk'event and in_std_clk = '1') then
				sig_std10_nce_strobe <= in_std10_nce_strobe;
				sig_std10_nce_strobe_t1 <= sig_std10_nce_strobe;
				sig_std_stop_t1 <= sig_std_stop;
				i_t1 <= i;
				sig_std_data_valid_t1 <= in_std_data_valid;
				sig_std_ready_t1 <= in_std_ready;
				sig_std_chk_buf_t1 <= sig_std_chk_buf;
		end if;
	end process;	
	

	
	
------------------------------------------------------------------
------------------------------------------------------------------
---------- ОЗУ----------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
RW_UNITS : process(in_std_clk, in_std_ena)
	
	 
	begin
		if (in_std_ena = '0') then
			sig_std10_flag_chk <= "11" & X"FF";
			sig_int_cnt <= 0;
			sig_std_read_ok <= '0';
			sig_std_stop <= '0';
			ind <= 0;
			
			out_std_nwe_un_buf <= '1';
			out_std_noe_un_buf <= '1';
			out_std8_nce_buf <= (others => '1');
			out_std11_adr_un_buf <= std_logic_vector(to_unsigned(0,11));
			sig_u11_cur_adr_wr <= to_unsigned(8,11);
			sig_u11_cur_adr_rd <= to_unsigned(1032,11);
			ind_i0 <= 255;
		
			sig_int_ind_0 <= 1;
			sig_int_ind_1 <= 5;
			ind_i2 <= 224;
			sig_int_ind_4 <= 12;
			sig_int_ind_5 <= 15;
			ind_i4 <= 239 ;
			sig_std_all_data_adc <= '0';
			sig_std_read_ok <= '0';
			

		elsif(in_std_clk'event and in_std_clk = '1') then
			if (sig_std_start = '1' ) then
				if (sig_std10_flag_chk = "11" & X"FF") then
					if (i = 0) then
						if (sig_std_read_ok = '0') then
							if (sig_int_cnt = 0) then
								out_std8_nce_buf <= (others => '1');
								out_std8_nce_buf(i) <= '0';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
								out_std_noe_un_buf <= '0';
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
							elsif (sig_int_cnt = 1) then
								inout_std16_data_un_buf <= (others => 'Z');
								temp(0)(255 downto 228) <= (others => '0');
								temp(0)(191 downto 0) <= (others => '0');
								temp(0)(227 downto 192) <= inout_std16_data_un_buf(0) & temp(0)(227 downto 193);
								sig_int_cnt <= 0;
								if (sig_u11_cur_adr_rd = (END_ADRESS_READ(i) + X"8" )) then
									sig_std_read_ok <= '1';
								else
									sig_u11_cur_adr_rd <= sig_u11_cur_adr_rd + sig_u4_adr_cnt;
								end if;
							end if;	
						else

							if (sig_int_cnt = 0) then
								out_std_noe_un_buf <= '1';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_wr);
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
								inout_std16_data_un_buf <= "00000000" & temp1(sig_int_ind_0)(ind_i0 downto (ind_i0 - 7));
								if (ind_i0 = 7) then
									ind_i0 <= 255;
									
									sig_int_ind_0 <= sig_int_ind_0 + 1;
								else
									ind_i0 <= ind_i0 - 8;
								
								end if;
							elsif (sig_int_cnt = 1) then
								out_std_nwe_un_buf <= '0';
								if (sig_u11_cur_adr_wr = END_ADRESS_WRITE(i)) then
									if (sig_std_valid_data = '1' and in_std_ready = '0') then
										if (sig_std10_flag = "00" & X"00") then
											sig_std_stop <= '1';
										else
											if (sig_std10_flag(ind) = '0') then
												ind <= ind + 1;
											else
												sig_std10_flag_chk(ind) <= '0';
											end if;	
										end if;
									end if;
								else
									sig_u11_cur_adr_wr <= sig_u11_cur_adr_wr + sig_u4_adr_cnt;
									sig_int_cnt <= 0;
								end if;	
							end if;
						end if;	
					elsif (i = 1) then
						if (sig_std_read_ok = '0') then
							if (sig_int_cnt = 0) then
								out_std8_nce_buf <= (others => '1');
								out_std8_nce_buf(i) <= '0';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
								out_std_noe_un_buf <= '0';
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
							elsif (sig_int_cnt = 1) then
								inout_std16_data_un_buf <= (others => 'Z');
								temp(4)(255 downto 228) <= (others => '0');
								temp(4)(191 downto 0) <= (others => '0');
								temp(4)(227 downto 192) <= inout_std16_data_un_buf(0) & temp(4)(227 downto 193);
								sig_int_cnt <= 0;
								if (sig_u11_cur_adr_rd = (END_ADRESS_READ(i) + X"8" )) then
									sig_std_read_ok <= '1';
								else
									sig_u11_cur_adr_rd <= sig_u11_cur_adr_rd + sig_u4_adr_cnt;
								end if;
							end if;	
						else
							if (sig_int_cnt = 0) then
								out_std_noe_un_buf <= '1';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_wr);
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
								inout_std16_data_un_buf <= "00000000" & temp1(sig_int_ind_1)(ind_i0 downto (ind_i0 - 7));
								if (ind_i0 = 7) then
									ind_i0 <= 255;
									
									sig_int_ind_1 <= sig_int_ind_1 + 1;
								else
									ind_i0 <= ind_i0 - 8;
								
								end if;
							elsif (sig_int_cnt = 1) then
								out_std_nwe_un_buf <= '0';
								if (sig_u11_cur_adr_wr = END_ADRESS_WRITE(i)) then
									if (sig_std_valid_data = '1' and in_std_ready = '0') then
										if (sig_std10_flag = "00" & X"00") then
											sig_std_stop <= '1';
										else
											if (sig_std10_flag(ind) = '0') then
												ind <= ind + 1;
											else
												sig_std10_flag_chk(ind) <= '0';
											end if;	
										end if;
									end if;
								else
									sig_u11_cur_adr_wr <= sig_u11_cur_adr_wr + sig_u4_adr_cnt;
									sig_int_cnt <= 0;
								end if;	
							end if;
						end if;
					elsif (i = 2) then
						if (sig_std_read_ok = '0') then
							if (sig_int_cnt = 0) then
							
								out_std8_nce_buf <= (others => '1');
								out_std8_nce_buf(i) <= '0';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
								out_std_noe_un_buf <= '0';
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
							elsif (sig_int_cnt = 1) then
								inout_std16_data_un_buf <= (others => 'Z');
								temp(8)(255 downto 248) <= (others => '0');
								temp(8)(223 downto 0) <= (others => '0');
								temp(8)(247 downto 224) <= inout_std16_data_un_buf(0) & temp(8)(247 downto 225);
								sig_int_cnt <= 0;
								if (sig_u11_cur_adr_rd = (END_ADRESS_READ(i) + X"8")) then
									sig_std_read_ok <= '1';
								else
									sig_u11_cur_adr_rd <= sig_u11_cur_adr_rd + sig_u4_adr_cnt;
								end if;
							end if;	
						else
							if (sig_int_cnt = 0) then
								out_std_noe_un_buf <= '1';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_wr);
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
								inout_std16_data_un_buf <= X"000"  & "000" & temp1(9)(ind_i2);
								ind_i2 <= ind_i2 + 1;
							elsif (sig_int_cnt = 1) then
								out_std_nwe_un_buf <= '0';
								if (sig_u11_cur_adr_wr = END_ADRESS_WRITE(i)) then
									if (sig_std_valid_data = '1' and in_std_ready = '0') then
										if (sig_std10_flag = "00" & X"00") then
											sig_std_stop <= '1';
										else
											if (sig_std10_flag(ind) = '0') then
												ind <= ind + 1;
											else
												sig_std10_flag_chk(ind) <= '0';
											end if;	
										end if;
									end if;
								else
									sig_u11_cur_adr_wr <= sig_u11_cur_adr_wr + sig_u4_adr_cnt;
									sig_int_cnt <= 0;
								end if;	
							end if;
						end if;
					elsif (i = 3) then
						if (sig_std_read_ok = '0') then
							if (sig_int_cnt = 0) then
								out_std8_nce_buf <= (others => '1');
								out_std8_nce_buf(i) <= '0';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
								out_std_noe_un_buf <= '0';
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
							elsif (sig_int_cnt = 1) then
								inout_std16_data_un_buf <= (others => 'Z');
								temp(10)(255 downto 248) <= (others => '0');
								temp(10)(223 downto 0) <= (others => '0');
								temp(10)(247 downto 224) <= inout_std16_data_un_buf(0) & temp(10)(247 downto 225);
								sig_int_cnt <= 0;
								if (sig_u11_cur_adr_rd = (END_ADRESS_READ(i) + X"8") ) then
									sig_u11_cur_adr_rd <= to_unsigned(1032,11);
									sig_std_read_ok <= '1';
								else
									sig_u11_cur_adr_rd <= sig_u11_cur_adr_rd + sig_u4_adr_cnt;
								end if;
							end if;	
						else
							if (sig_int_cnt = 0) then
								out_std_noe_un_buf <= '1';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_wr);
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
								inout_std16_data_un_buf <= X"000"  & "000" & temp1(11)(ind_i2);
								ind_i2 <= ind_i2 + 1;
							elsif (sig_int_cnt = 1) then
								out_std_nwe_un_buf <= '0';
								if (sig_u11_cur_adr_wr = END_ADRESS_WRITE(i)) then
									if (sig_std_valid_data = '1' and in_std_ready = '0') then
										if (sig_std10_flag = "00" & X"00") then
											sig_std_stop <= '1';
										else
											if (sig_std10_flag(ind) = '0') then
												ind <= ind + 1;
											else
												sig_std10_flag_chk(ind) <= '0';
											end if;	
										end if;
									end if;
								else
									sig_u11_cur_adr_wr <= sig_u11_cur_adr_wr + sig_u4_adr_cnt;
									sig_int_cnt <= 0;
								end if;	
							end if;
						end if;
					elsif (i = 4) then
						if (sig_std_read_ok = '0') then
							if (sig_std_all_data_adc = '0') then
								if (sig_int_cnt = 0) then
									out_std8_nce_buf <= (others => '1');
									out_std8_nce_buf(i) <= '0';
									out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
									out_std_noe_un_buf <= '0';
									out_std_nwe_un_buf <= '1';
									sig_int_cnt <= sig_int_cnt + 1;
								elsif (sig_int_cnt = 1) then
									inout_std16_data_un_buf <= (others => 'Z');
									temp(sig_int_ind_4)(63 downto 0) <= (others => '0');
									temp(sig_int_ind_4)(255 downto 64) <= inout_std16_data_un_buf & temp(sig_int_ind_4)(255 downto 80);
									sig_int_cnt <= 0;
									if (sig_u11_cur_adr_rd = (END_ADRESS_READ(i) + X"8") ) then
										sig_std_all_data_adc <= '1';
										--sig_std_read_ok <= '1';
									else
										sig_u11_cur_adr_rd <= sig_u11_cur_adr_rd + sig_u4_adr_cnt;
										if (sig_u11_cur_adr_rd = to_unsigned(1128,11)) then
											sig_int_ind_4 <= sig_int_ind_4 + 1;
										end if;
									end if;
								end if;
							else
								if (sig_int_cnt = 0) then
									out_std8_nce_buf <= (others => '1');
									out_std8_nce_buf(i) <= '0';
									out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
									out_std_noe_un_buf <= '0';
									out_std_nwe_un_buf <= '1';
									sig_int_cnt <= sig_int_cnt + 1;
								elsif (sig_int_cnt = 1) then
									inout_std16_data_un_buf <= (others => 'Z');
									sig_int_cnt <= 0;
									temp(12)(15 downto 0) <= inout_std16_data_un_buf;
									sig_std_read_ok <= '1';
								end if;
							end if;
							
						else
							if (sig_int_cnt = 0) then
								out_std_noe_un_buf <= '1';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_wr);
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
								inout_std16_data_un_buf <= temp1(14)(ind_i4 downto (ind_i4 - 15));
								if ind_i4 = 255 then
									ind_i4 <= 239 ;
									
								else
									ind_i4 <= ind_i4 + 16;
									
								end if;
							elsif (sig_int_cnt = 1) then
								out_std_nwe_un_buf <= '0';
								if (sig_u11_cur_adr_wr = END_ADRESS_WRITE(i)) then
									if (sig_std_valid_data = '1' and in_std_ready = '0') then
										if (sig_std10_flag = "00" & X"00") then
											sig_std_stop <= '1';
										else
											if (sig_std10_flag(ind) = '0') then
												ind <= ind + 1;
											else
												sig_std10_flag_chk(ind) <= '0';
											end if;	
										end if;
									end if;
								else
									sig_u11_cur_adr_wr <= sig_u11_cur_adr_wr + sig_u4_adr_cnt;
									sig_int_cnt <= 0;
								end if;	
							end if;
						end if;
					elsif (i = 5) then
						if (sig_std_read_ok = '0') then
							if (sig_std_all_data_adc = '0') then
								if (sig_int_cnt = 0) then
									out_std8_nce_buf <= (others => '1');
									out_std8_nce_buf(i) <= '0';
									out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
									out_std_noe_un_buf <= '0';
									out_std_nwe_un_buf <= '1';
									sig_int_cnt <= sig_int_cnt + 1;
								elsif (sig_int_cnt = 1) then
									inout_std16_data_un_buf <= (others => 'Z');
									temp(sig_int_ind_5)(63 downto 0) <= (others => '0');
									temp(sig_int_ind_5)(255 downto 64) <= inout_std16_data_un_buf & temp(sig_int_ind_5)(255 downto 80);
									sig_int_cnt <= 0;
									if (sig_u11_cur_adr_rd = (END_ADRESS_READ(i) + X"8") ) then
										sig_std_all_data_adc <= '1';
									else
										sig_u11_cur_adr_rd <= sig_u11_cur_adr_rd + sig_u4_adr_cnt;
										if (sig_u11_cur_adr_rd = to_unsigned(1128,11)) then
											sig_int_ind_5 <= sig_int_ind_5 + 1;
										end if;
									end if;
								end if;
							else
								if (sig_int_cnt = 0) then
									out_std8_nce_buf <= (others => '1');
									out_std8_nce_buf(i) <= '0';
									out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_rd);
									out_std_noe_un_buf <= '0';
									out_std_nwe_un_buf <= '1';
									sig_int_cnt <= sig_int_cnt + 1;
								elsif (sig_int_cnt = 1) then
									inout_std16_data_un_buf <= (others => 'Z');
									sig_int_cnt <= 0;
									temp(15)(15 downto 0) <= inout_std16_data_un_buf;
									sig_std_read_ok <= '1';
								end if;
							end if;	
						else
							if (sig_int_cnt = 0) then
								out_std_noe_un_buf <= '1';
								out_std11_adr_un_buf <= std_logic_vector(sig_u11_cur_adr_wr);
								out_std_nwe_un_buf <= '1';
								sig_int_cnt <= sig_int_cnt + 1;
								inout_std16_data_un_buf <= temp1(17)(ind_i4 downto (ind_i4 - 15));
								if ind_i4 = 255 then
									ind_i4 <= 239 ;
								
								else
									ind_i4 <= ind_i4 + 16;
									
								end if;
							elsif (sig_int_cnt = 1) then
								out_std_nwe_un_buf <= '0';
								if (sig_u11_cur_adr_wr = END_ADRESS_WRITE(i)) then
									if (sig_std_valid_data = '1' and in_std_ready = '0') then
										if (sig_std10_flag = "00" & X"00") then
											sig_std_stop <= '1';
										else
											if (sig_std10_flag(ind) = '0') then
												ind <= ind + 1;
											else
												sig_std10_flag_chk(ind) <= '0';
											end if;	
										end if;
									end if;
								else
									sig_u11_cur_adr_wr <= sig_u11_cur_adr_wr + sig_u4_adr_cnt;
									sig_int_cnt <= 0;
								end if;	
							end if;
						end if;
					elsif (i = 6) then
						if (sig_std_valid_data = '1' and in_std_ready = '0') then
							if (sig_std10_flag = "00" & X"00") then
								sig_std_stop <= '1';
							else
								if (sig_std10_flag(ind) = '0') then
									ind <= ind + 1;
								else
									sig_std10_flag_chk(ind) <= '0';
								end if;	
							end if;
						end if;
					elsif (i = 7) then
						if (sig_std_valid_data = '1' and in_std_ready = '0') then
							out_std256_data_led <= temp_std256_data_led;
						
							if (sig_std10_flag = "00" & X"00") then
								sig_std_stop <= '1';
							else
								if (sig_std10_flag(ind) = '0') then
									ind <= ind + 1;
								else
									sig_std10_flag_chk(ind) <= '0';
								end if;	
							end if;
						end if;
					elsif (i = 8) then
						if (sig_std_valid_data ='1' and in_std_ready = '0') then
							if (sig_std10_flag = "00" & X"00") then
								sig_std_stop <= '1';	
							else
								if (sig_std10_flag(ind) = '0') then
									ind <= ind + 1;
								else
									sig_std10_flag_chk(ind) <= '0';					
								end if;
							end if;
						end if;
					elsif (i = 9) then
						if (sig_std_valid_data = '1' and in_std_ready = '0') then
							if (sig_std10_flag = "00" & X"00") then
								sig_std_stop <= '1';
							else
								if (sig_std10_flag(ind) = '0') then
									ind <= ind + 1;
								else
									sig_std10_flag_chk(ind) <= '0';
								end if;	
							end if;
						end if;
					end if;	
				else
					sig_std10_flag_chk(i) <= '1';
					sig_int_cnt <= 0;
					sig_std_read_ok <= '0';
					sig_std_stop <= '0';
					ind <= 0;
					
					out_std_nwe_un_buf <= '1';
					out_std_noe_un_buf <= '1';
					out_std8_nce_buf <= (others => '1');
					out_std11_adr_un_buf <= std_logic_vector(to_unsigned(0,11));
					sig_u11_cur_adr_wr <= to_unsigned(8,11);
					sig_u11_cur_adr_rd <= to_unsigned(1032,11);
					ind_i0 <= 255;
			
					sig_int_ind_0 <= 1;
					sig_int_ind_1 <= 5;
					ind_i2 <= 224;
					sig_int_ind_4 <= 12;
					sig_int_ind_5 <= 15;
					ind_i4 <= 239 ;
					sig_std_all_data_adc <= '0';
				end if;
			else
				sig_std_all_data_adc <= '0';
				sig_std10_flag_chk <= "11" & X"FF";
				sig_int_cnt <= 0;
				sig_std_read_ok <= '0';
				sig_std_stop <= '0';
				ind <= 0;
				
				out_std_nwe_un_buf <= '1';
				out_std_noe_un_buf <= '1';
				out_std8_nce_buf <= (others => '1');
				out_std11_adr_un_buf <= std_logic_vector(to_unsigned(0,11));
				sig_u11_cur_adr_wr <= to_unsigned(8,11);
				sig_u11_cur_adr_rd <= to_unsigned(1032,11);
				ind_i0 <= 255;

				sig_int_ind_0 <= 1;
				sig_int_ind_1 <= 5;
				ind_i2 <= 224;
				sig_int_ind_4 <= 12;
				sig_int_ind_5 <= 15;

				sig_std_read_ok <= '0';
				
			end if;

		end if;	
	end process;
	
	
	
RW_DDR : process(in_std_clk, in_std_ena)
	
	begin
		if (in_std_ena = '0') then
			out_std_str_rd <= '0';
			out_std_str_wr <= '0';
			sig_int_adr_0 <= 1;
			sig_int_adr_1 <= 5;
			sig_int_adr_4 <= 12;
			sig_int_adr_5 <= 15;
			sig_int_adr_8 <= 21;
			sig_int_count <= 0;
			ind_i8 <= 255;
			sig_std16_adr_disp <= X"0001";
			out_std_nwe_lcd_buf <= '0';
			sig_std_valid_data <= '0';
			sig_std_chk_buf <= '0';
			flag <= '0';
			flag1 <= '0';
			sig_std_init_ddr <= '0';
			sig_std_init_ddr1 <= '0';
			out_std27_adr_ddr <= std_logic_vector(to_unsigned(0,27));
			sig_std_256_read <= '0';
		elsif(in_std_clk'event and in_std_clk = '1') then
			if (sig_std_start = '1' ) then
				if (sig_std10_flag_chk = "11" & X"FF") then
					if (i = 0) then
						if (sig_std_valid_data = '0') then
							if (sig_std_read_ok = '0') then
							--if (in_std_ready = '0' or sig_std_init_ddr = '1') then
								--	sig_std_init_ddr <= '1';
									if (sig_int_adr_0 < 4 ) then
										
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											flag <= '0';
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(sig_int_adr_0,27));
											out_std_str_rd <= '1';
											out_std_str_wr <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
											out_std_str_rd <= '0';
											if (flag = '0') then
												--if (in_std_data_valid = '1') then
													temp1(sig_int_adr_0) <= in_std256_data_in;
													sig_int_adr_0 <= sig_int_adr_0 + 1;
													flag <= '1';
											--	end if;
											end if;	
										end if;
									end if;
								--end if;
							else
							--	if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
							--		sig_std_init_ddr1 <= '1';
									
									if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
										flag1 <= '0';
										out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(0,27));
										out_std256_data_out <= temp(0);
										out_std_str_wr <= '1';
										out_std_str_rd <= '0';
									elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
										if (flag1 = '0') then
											sig_std_valid_data <= '1';
											out_std_str_wr <= '0';
											flag1 <= '1';
										end if;
									end if;	
								--end if;	
							end if;
						end if;
					elsif (i = 1) then
						if (sig_std_valid_data = '0') then
							if (sig_std_read_ok = '0') then
						--		if (in_std_ready = '0' or sig_std_init_ddr = '1') then
						--			sig_std_init_ddr <= '1';
									if (sig_int_adr_1 < 8 ) then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											flag <= '0';
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(sig_int_adr_1,27));
											out_std_str_rd <= '1';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
											out_std_str_rd <= '0';
											if (flag = '0') then
												--if (in_std_data_valid = '1') then
													temp1(sig_int_adr_1) <= in_std256_data_in;
													sig_int_adr_1 <= sig_int_adr_1 + 1;
													flag <= '1';
											--	end if;
											end if;	
										end if;
									end if;
						--		end if;
							else
						--		if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
						--			sig_std_init_ddr1 <= '1';
									if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
										if flag1 = '0' then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(4,27));
											out_std256_data_out <= temp(4);
											out_std_str_wr <= '1';
										end if;
									elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
										out_std_str_wr <= '0';
										sig_std_valid_data <= '1';
										flag1 <= '1';
									end if;	
						--		end if;	
							end if;
						end if;
					elsif (i = 2) then
						if (sig_std_valid_data = '0') then
							if (sig_std_read_ok = '0') then
						--		if (in_std_ready = '0' or sig_std_init_ddr = '1') then
						--			sig_std_init_ddr <= '1';
									if (flag1 = '0') then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(9,27));
											out_std_str_rd <= '1';
											out_std_str_wr <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
											out_std_str_rd <= '0';
											--if (in_std_data_valid = '1') then
												temp1(9) <= in_std256_data_in;
												flag1 <= '1';
											--end if;
										end if;
									end if;
						--		end if;
							else
							--	if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
							--		sig_std_init_ddr1 <= '1';
									if (flag = '0') then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(8,27));
											out_std256_data_out <= temp(8);
											out_std_str_wr <= '1';
											out_std_str_rd <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
											out_std_str_wr <= '0';
											flag <= '1';
											sig_std_valid_data <= '1';
										end if;	
									end if;	
							--	end if;
							end if;
						end if;	
					elsif (i = 3) then
						if (sig_std_valid_data = '0') then
							if (sig_std_read_ok = '0') then
						--		if (in_std_ready = '0' or sig_std_init_ddr = '1') then
						--			sig_std_init_ddr <= '1';
									if (flag1 = '0') then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(11,27));
											out_std_str_rd <= '1';
											out_std_str_wr <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
											out_std_str_rd <= '0';
										--	if (in_std_data_valid = '1') then
												temp1(11) <= in_std256_data_in;
												flag1 <= '1';
										--	end if;
										end if;
									end if;
						--		end if;
							else
					--			if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
					--				sig_std_init_ddr1 <= '1';
									if (flag = '0') then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(10,27));
											out_std256_data_out <= temp(10);
											out_std_str_wr <= '1';
											out_std_str_rd <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
											out_std_str_wr <= '0';
											flag <= '1';
											sig_std_valid_data <= '1';
										end if;	
									end if;
					--			end if;
							end if;
						end if;
					elsif (i = 4) then
						if (sig_std_valid_data = '0') then
							if (sig_std_read_ok = '0') then
							--	if (in_std_ready = '0' or sig_std_init_ddr = '1') then
							--		sig_std_init_ddr <= '1';
									if (flag1 = '0') then
											if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
												out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(14,27));
												out_std_str_rd <= '1';
												out_std_str_wr <= '0';
											elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
												out_std_str_rd <= '0';
											--	if (in_std_data_valid = '1') then
													temp1(14) <= in_std256_data_in;
													flag1 <= '1';
											--	end if;
											end if;

									end if;
							--	end if;
							else
							--	if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
							--		sig_std_init_ddr1 <= '1';
									if sig_int_adr_4 < 14 then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(sig_int_adr_4,27));
											out_std256_data_out <= temp(sig_int_adr_4);
											out_std_str_wr <= '1';
											out_std_str_rd <= '0';
											flag <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then 
											out_std_str_wr <= '0';
											if flag = '0' then
												sig_int_adr_4 <= sig_int_adr_4 + 1;
												flag <= '1';
											end if;
										end if;	
									else
										sig_std_valid_data <= '1';
									end if;	
							--	end if;
							end if;
						end if;
					elsif (i = 5) then
						if (sig_std_valid_data = '0') then
							if (sig_std_read_ok = '0') then
							--	if (in_std_ready = '0' or sig_std_init_ddr = '1') then
							--		sig_std_init_ddr <= '1';
									if (flag1 = '0') then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(17,27));
											out_std_str_rd <= '1';
											out_std_str_wr <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then 
											out_std_str_rd <= '0';
										--	if (in_std_data_valid = '1') then
												temp1(17) <= in_std256_data_in;
												flag1 <= '1';
										--	end if;
										end if;
									else
										sig_std_init_ddr <= '0';
									end if;
							--	end if;
							else
							--	if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
							--		sig_std_init_ddr1 <= '1';
									if (sig_int_adr_5 < 17) then
										if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
											out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(sig_int_adr_5,27));
											out_std256_data_out <= temp(sig_int_adr_5);
											out_std_str_wr <= '1';
											out_std_str_rd <= '0';
											flag <= '0';
										elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then 
											out_std_str_wr <= '0';
											if flag = '0' then
												sig_int_adr_5 <= sig_int_adr_5 + 1;
												flag <= '1';
											end if;
										end if;	
									else
										sig_std_valid_data <= '1';
									end if;	
							--	end if;
							end if;
						end if;
					elsif (i = 6) then
						if (sig_std_valid_data = '0') then
						--	if (in_std_ready = '0' or sig_std_init_ddr = '1') then
						--		sig_std_init_ddr <= '1';
							
								if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
									out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(18,27));
									out_std_str_rd <= '1';
									out_std_str_wr <= '0';
								elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then 
									out_std_str_rd <= '0';
								--	if (in_std_data_valid = '1') then
										out_std6_vip <= in_std256_data_in(245 downto 240);
										sig_std_valid_data <= '1';
								--	end if;
								end if;
						--	end if;
						end if;
					elsif (i = 7) then
						if (sig_std_valid_data = '0') then
						--	if (in_std_ready = '0' or sig_std_init_ddr = '1') then
						--		sig_std_init_ddr <= '1';
							
								if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
									out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(19,27));
									out_std_str_rd <= '1';
									out_std_str_wr <= '0';
								elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then 
									out_std_str_rd <= '0';
								--	if (in_std_data_valid = '0' and sig_std_data_valid_t1 = '1') then
										temp_std256_data_led <= in_std256_data_in;
										sig_std_valid_data <= '1';
								--	end if;
								end if;
						--	end if;
						end if;
					elsif (i = 8) then
						if (sig_std_valid_data = '0') then

							if (sig_std_chk_buf = '0') then
							--	if (in_std_ready = '0' or sig_std_init_ddr = '1') then
							--		sig_std_init_ddr <= '1';
									if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
										out_std27_adr_ddr <= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(20,27));
										out_std_str_rd <= '1';
										out_std_str_wr <= '0';
									elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
										out_std_str_rd <= '0';
										--if (in_std_data_valid = '0' and sig_std_data_valid_t1 = '1') then
											sig_std4_chk_buf <= in_std256_data_in(243 downto 240);
											sig_std_chk_buf <= '1';
										--end if;
									end if;
							--	end if;	
							else
							--	if (in_std_ready = '0' or sig_std_init_ddr1 = '1') then
							--		sig_std_init_ddr1 <= '1';
									if (sig_std4_chk_buf = X"1") then
										if (sig_std_256_read = '0') then
											if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
												out_std27_adr_ddr <= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(sig_int_adr_8,27));
												out_std_str_rd <= '1';
												out_std_str_wr <= '0';
											elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
												out_std_str_rd <= '0';
												--if (in_std_data_valid = '0' and sig_std_data_valid_t1 = '1') then
													sig_std256_tmp_word <= in_std256_data_in;
													sig_std_256_read <= '1';
												--end if;
											end if;
										else
												
				-------------------------------------------------------------
												
											if (sig_int_count = 0) then
												out_std8_data_lcd_buf <= sig_std256_tmp_word (ind_i8 downto (ind_i8 - 7)) ;
												out_std16_adr_lcd_buf <= sig_std16_adr_disp;
												out_std_nwe_lcd_buf <= '0';
												sig_int_count <= sig_int_count + 1;
											elsif (sig_int_count = 1) then
												out_std_nwe_lcd_buf <= '1';
												sig_std16_adr_disp <= sig_std16_adr_disp + '1';
												if (ind_i8 = 7) then
													if (sig_int_adr_8 = 320) then
														sig_std_valid_data <= '1';
														out_std_lcd_mode <= '1';
														out_std_chpnt <= '0';
													else
														sig_int_adr_8 <= sig_int_adr_8 + 1;
														sig_std_256_read <= '0';
														sig_int_count <= 0;
														ind_i8 <= 255;
													end if;
												else
													ind_i8 <= ind_i8 - 8;
													sig_int_count <= 0;
												end if;
											end if;	
			
										end if;
									
									elsif (sig_std4_chk_buf = X"2") then
									
									
										if (sig_std_256_read = '0') then
											if (in_std_ready = '0' and sig_std_ready_t1 = '0') then
												out_std27_adr_ddr <= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(sig_int_adr_8,27)) + std_logic_vector(to_unsigned(300,27));
												out_std_str_rd <= '1';
												out_std_str_wr <= '0';
											elsif (in_std_ready = '0' and sig_std_ready_t1 = '1') then
												out_std_str_rd <= '0';
											--	if (in_std_data_valid = '1') then
													sig_std256_tmp_word <= in_std256_data_in;
													sig_std_256_read <= '1';
											--	end if;
											end if;
										else
												
											if (sig_int_count = 0) then
												out_std8_data_lcd_buf <= sig_std256_tmp_word (ind_i8 downto (ind_i8 - 7)) ;
												out_std16_adr_lcd_buf <= sig_std16_adr_disp;
												out_std_nwe_lcd_buf <= '0';
												sig_int_count <= sig_int_count + 1;
											elsif (sig_int_count = 1) then
												out_std_nwe_lcd_buf <= '1';
												sig_std16_adr_disp <= sig_std16_adr_disp + '1';
												if (ind_i8 = 7) then
													if (sig_int_adr_8 = 320) then
														sig_std_valid_data <= '1';	
														out_std_lcd_mode <= '1';
														out_std_chpnt <= '0';
													else
														sig_int_adr_8 <= sig_int_adr_8 + 1;
														sig_std_256_read <= '0';
														sig_int_count <= 0;
														ind_i8 <= 255;
													end if;
												else
													ind_i8 <= ind_i8 - 8;
													sig_int_count <= 0;
												end if; 
											end if;	
										end if;
									elsif (sig_std4_chk_buf = X"0") then
										out_std_lcd_mode <= '0';
										out_std_chpnt <= '0';
										sig_std_valid_data <= '1';
									else
										out_std_chpnt <= '1';
										sig_std_valid_data <= '1';
									end if;
								--end if;	
							end if;
						end if;
					elsif (i = 9) then
						if (sig_std_valid_data = '0') then	
						--	if (in_std_ready = '0' or sig_std_init_ddr = '1') then
						--		sig_std_init_ddr <= '1';
								if (in_std_ready = '0') then
								
									out_std27_adr_ddr<= sig_std32_base_ddr(26 downto 0) + std_logic_vector(to_unsigned(621,27));
									out_std256_data_out <= (others => '0');
									out_std256_data_out(248 downto 224) <= in_std25_data_key;
									out_std_str_wr <= '1';
									out_std_str_rd <= '0';
								else
									out_std_str_wr <= '0';
									sig_std_valid_data <= '1';
								end if;	
						--	end if;
						end if;
					end if;
				else
					out_std_str_rd <= '0';
					out_std_str_wr <= '0';
					sig_int_adr_0 <= 1;
					sig_int_adr_1 <= 5;
					sig_int_adr_4 <= 12;
					sig_int_adr_5 <= 15;
					sig_int_adr_8 <= 21;
					sig_std_valid_data <= '0';
					sig_std_chk_buf <= '0';
					flag <= '0';
					flag1 <= '0';
					out_std27_adr_ddr <= std_logic_vector(to_unsigned(0,27));
					ind_i8 <= 255;
					sig_std16_adr_disp <= X"0001";
					sig_int_count <= 0;
					out_std_nwe_lcd_buf <= '0';
					sig_std_init_ddr <= '0';
					sig_std_init_ddr1 <= '0';
					sig_std_256_read <= '0';
				end if;
				
			else
				out_std_str_rd <= '0';
				out_std_str_wr <= '0';
				sig_int_adr_0 <= 1;
				sig_int_adr_1 <= 5;
				sig_int_adr_4 <= 12;
				sig_int_adr_5 <= 15;
				sig_int_adr_8 <= 21;
				sig_std_valid_data <= '0';
				sig_std_chk_buf <= '0';
				flag <= '0';
				flag1 <= '0';
				out_std27_adr_ddr <= std_logic_vector(to_unsigned(0,27));
				ind_i8 <= 255;
				sig_std16_adr_disp <= X"0001";
				sig_int_count <= 0;
				out_std_nwe_lcd_buf <= '0';
				sig_std_init_ddr <= '0';
				sig_std_init_ddr1 <= '0';
				sig_std_256_read <= '0';
			end if;
		end if;	
					
				
	end process;
	
-----------------------------------------	
end RW_RAM;
-- 
