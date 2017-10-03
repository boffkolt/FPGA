library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.lib_lcd.all;
use work.lcd_init.all;
library altera_mf;
use altera_mf.altera_mf_components.all;
entity LCD is
	
	port( 
		in_std_clk 					:	in std_logic; 	-- тактовая частота	
		in_std_ena					:	in std_logic := '1';														
		out_std7_data				:	out std_logic_vector(7 downto 0) := X"11";
		out_std_cs					:	out std_logic	:= '1';
		out_std_wr					:	out std_logic	:= '1';
		out_std_res					:	out std_logic 	:= '1';
		out_std_a					:	out std_logic 	:= '1';
		out_std_oe_buf				:	out std_logic 	;
		
		out_std_str					:	out std_logic	:= '0';
		in_std_lcd_mode				:	in	std_logic;
		in_std8_data_in				:	in std_logic_vector(7 downto 0) ;
		in_std14_adress				: 	in std_logic_vector(13 downto 0);
		in_std_nwe					:	in	std_logic;
		in_std_chpnt				:	in std_logic
	);
		
		
end LCD;
		
architecture LCD_ARCH of LCD is
signal sig_std8_system_set : std_logic_vector(7 downto 0);

--								
signal sig_std8_scroll : std_logic_vector(7 downto 0);								

signal sig_std8_hdot_scr : std_logic_vector(7 downto 0);							
--signal hdot_scr : data (0 to 1)		:= (0	=>	X"5A",
--												1	=>	X"00");
signal sig_std8_ovlay : std_logic_vector(7 downto 0);								
--signal ovlay : data (0 to 1)			:= (0	=>	X"5B",
--											1	=>	X"01");
signal sig_std8_cgram : std_logic_vector(7 downto 0);
--signal cgram_adr : data (0 to 3)		:= (0	=>	X"5C",
--											1	=>	X"00",
--											2	=> X"F0",
--											others=> X"00");
signal sig_std8_disp_off : std_logic_vector(7 downto 0);										
--signal disp_off : data (0 to 1)		:= (0	=>	X"58",
--											1	=>	X"56");
signal sig_std8_disp_on : std_logic_vector(7 downto 0);											
--signal disp_on : data (0 to 1)		:= (0	=>	X"59",
--											1	=>	X"10");
signal sig_std8_set_start_clr : std_logic_vector(7 downto 0);										
--signal set_start_clr : data (0 to 3)	:= (0	=>	X"46",
--											1	=>	X"00",
--											2 	=>	X"00",
--											others=> X"00");
signal sig_std8_set_start : std_logic_vector(7 downto 0);										
--signal set_start : data (0 to 3)		:= (0	=>	X"46",
--											1	=>	X"B0",
--											2 	=>	X"04",
--											others=> X"00");
signal sig_std8_clr_disp : std_logic_vector(7 downto 0);											

signal sig_std8_logo : std_logic_vector(7 downto 0);											

									


signal sig_std_sys_set			:	std_logic := '0';
signal sig_std_scroll			:	std_logic := '0';
signal sig_std_hdot_scr			:	std_logic := '0';
signal sig_std_ovlay				:	std_logic := '0';

signal sig_std_disp_on			:	std_logic := '0';

signal sig_std_set_graph		:	std_logic := '0';
signal sig_std_clr_set_start	:	std_logic := '0';
signal sig_std_set_start		:	std_logic := '0';
signal sig_std_clr_disp			:	std_logic := '0';
signal sig_std_clr_graph		:	std_logic := '0';

signal sig_std_res				:	std_logic := '0';

signal sig_std_cgram_adr		:	std_logic := '0';
signal sig_std_draw_logo		: 	std_logic := '0';
signal sig_std_set_start_gr	:	std_logic := '0';



signal sig_std_init				: 	std_logic	:= '0';

signal sig_std8_start			: 	std_logic_vector(7 downto 0) := X"FF";
signal sig_test_data1			: 	std_logic_vector(255 downto 0);
signal sig_std_start				: 	std_logic							:='0';
signal sig_std_stop				: 	std_logic							:='0';
signal sig_std_strt				: 	std_logic							:='0';
signal sig_std_change_bit		:	std_logic							:='0';

signal sig_std_change_data		:	std_logic := '0';

signal sig_std_read_ok			: 	unsigned(11 downto 0);

signal sig_int_count				: 	integer	:=	0;
signal i 							: 	integer :=0;
signal sig_std_cmd 				: 	std_logic := '0';
signal sig_std_ready 			:	std_logic := '0';

signal sig_std_draw				:	std_logic	:=	'0';

signal sig_std8_work_data	:	std_logic_vector(7 downto 0);
signal sig_std8_chpnt		:	std_logic_vector(7 downto 0);

--signal sig_std8_set_start		:	std_logic_vector(7 downto 0);
signal sig_std_cnt 				:	integer := 0;
signal sig_int_numb_cnt			: 	integer := 0;


signal sig_std_lcd_mode				: std_logic	:=	'0';
signal var_int_cnt 				: integer := 0;

signal sig_std_chpnt			: std_logic := '0';
signal cur_arr : data (0 to 9600);
begin

out_std_oe_buf <= '1'	when (in_std_ena = '0') else
						'0';


WRK: process(in_std_ena,in_std_clk)

begin
	if (in_std_ena = '0') then
		sig_std_init	<=	'0';
		sig_std_res <= '0';
		var_int_cnt	<= 0;
		sig_std_sys_set <= '0';
		sig_std_scroll <= '0';
		sig_std_hdot_scr <= '0';
		sig_std_ovlay <= '0';
		sig_std_cgram_adr <= '0';
		sig_std_disp_on <= '0';
		sig_std_clr_disp <= '0';
		sig_std_clr_set_start <= '0';
		sig_std_draw <= '0';
		sig_std_set_start_gr <= '0';
		sig_std_set_start <= '0';
		sig_std_stop <= '0';
		
		
	elsif (in_std_clk'event and in_std_clk='1') then 
		if (sig_std_init= '0') then
			if (sig_std_res = '0') then
				if (var_int_cnt >= 0 and var_int_cnt <= 74) then
					var_int_cnt <= var_int_cnt + 1;
				elsif (var_int_cnt >= 75 and var_int_cnt <= 10149) then
					out_std_cs <= '0';
					out_std_wr <= '0';
					out_std_a <= '0';
					out_std7_data <= X"00";
					out_std_res <= '0';
					var_int_cnt <= var_int_cnt + 1;
				elsif (var_int_cnt >= 10150 and var_int_cnt <=20274) then
					out_std_res <= '1';
					out_std_cs <= '1';
					out_std_a <= '1';
					var_int_cnt <= var_int_cnt + 1;
				elsif (var_int_cnt = 20275) then
					var_int_cnt <= 0;
					sig_std_res <= '1';
				end if;
			elsif (sig_std_sys_set = '0') then
				write_cmd_data	(	out_std7_data,
									sig_std8_system_set,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(4),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_sys_set);

			elsif (sig_std_scroll = '0') then
				write_cmd_data	(	out_std7_data,
									sig_std8_scroll,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(6),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_scroll);
			elsif (sig_std_hdot_scr = '0') then
				write_cmd_data	(	out_std7_data,
									sig_std8_hdot_scr,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(1),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_hdot_scr);
			elsif (sig_std_ovlay = '0') then
				write_cmd_data	(	out_std7_data,
									sig_std8_ovlay,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(1),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_ovlay);
									
									
			elsif (sig_std_cgram_adr = '0') then
				write_cmd_data	(	out_std7_data,
									sig_std8_cgram,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(2),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_cgram_adr);
									

			
			elsif (sig_std_disp_on = '0') then
					write_cmd_data	(	out_std7_data,
									sig_std8_disp_on,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(1),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_disp_on);
			
			elsif (sig_std_clr_disp = '0') then
				if (sig_std_clr_set_start = '0') then
					write_cmd_data	(	out_std7_data,
									sig_std8_set_start_clr,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(2),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_clr_set_start);
				else
					write_cmd_data	(	out_std7_data,
									sig_std8_clr_disp,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(8),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_clr_disp);
				end if;

			elsif (sig_std_draw = '0') then
				if (sig_std_set_start_gr = '0') then
					write_cmd_data	(	out_std7_data,
									sig_std8_set_start,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(2),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_set_start_gr);
				else
					write_cmd_data	(	out_std7_data,
									sig_std8_logo,
									out_std_a,
									out_std_wr,
									out_std_cs,
									i,
									i_arr(7),
									sig_std_cnt,
									sig_std_cmd,
									sig_std_init);
				end if;
			end if;
			
		else
			if (sig_std_strt = '1') then
				if (sig_std_set_start = '0') then
						write_cmd_data	(	out_std7_data,
											sig_std8_set_start,
											out_std_a,
											out_std_wr,
											out_std_cs,
											i,
											i_arr(2),
											sig_std_cnt,
											sig_std_cmd,
											sig_std_set_start);
				else
					if (sig_std_chpnt = '0') then
						if (sig_std_lcd_mode = '1') then
							write_cmd_data	(	out_std7_data,
													sig_std8_work_data,
													out_std_a,
													out_std_wr,
													out_std_cs,
													i,
													i_arr(7),
													sig_std_cnt,
													sig_std_cmd,
													sig_std_stop);
						else
							write_cmd_data	(	out_std7_data,
													sig_std8_logo,
													out_std_a,
													out_std_wr,
													out_std_cs,
													i,
													i_arr(7),
													sig_std_cnt,
													sig_std_cmd,
													sig_std_stop);
						end if;
					else
						write_cmd_data	(	out_std7_data,
												sig_std8_chpnt,
												out_std_a,
												out_std_wr,
												out_std_cs,
												i,
												i_arr(7),
												sig_std_cnt,
												sig_std_cmd,
												sig_std_stop);
					end if;
				end if;
			else 
				sig_std_set_start <= '0';
				sig_std_draw <= '0';
				sig_std_stop <= '0';
				sig_std_lcd_mode <= in_std_lcd_mode;
				sig_std_chpnt <= in_std_chpnt;
			end if;
		end if;	
	end if;
end process; 
 
 
 



CNT_INT: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 25500000 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (sig_std_init= '1') then
				if (var_int_counter < 9999999) then
					var_int_counter := var_int_counter + 1;
					sig_std_start <= '0';
				else 
					var_int_counter := 0;
					sig_std_start <= '1';
				end if;
			else
				var_int_counter := 0;
			end if;
		end if;
end process;



STROBE_start: process(in_std_ena,in_std_clk)

begin
		if (in_std_ena = '0') then
			
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (sig_std_start = '1' and sig_std_start'last_value = '0') then
				sig_std_strt <= '1';
			elsif (sig_std_stop = '1' and sig_std_stop'last_value = '0') then
				sig_std_strt <= '0';
			end if;
		end if;
end process;


CON: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 25500000 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
				if (var_int_counter < 9999900) then
					var_int_counter := var_int_counter + 1;
					out_std_str <= '0';
				else 
					var_int_counter := 0;
					out_std_str <= '1';
				end if;
		end if;
end process;

--------------------------------------------
altsyncrom_system_set : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "system_set.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 16,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 4,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,4)),
		clock0 => in_std_clk,
		q_a => sig_std8_system_set
	);
-------------------------------------------------
altsyncrom_scroll : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "scroll.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 16,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 4,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,4)),
		clock0 => in_std_clk,
		q_a => sig_std8_scroll
	);
--------------------------------
altsyncrom_hdot : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "hdot.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 2,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 1,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,1)),
		clock0 => in_std_clk,
		q_a => sig_std8_hdot_scr
	);
	--------------------------------
	altsyncrom_ovlay : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "ovlay.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 2,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 1,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,1)),
		clock0 => in_std_clk,
		q_a => sig_std8_ovlay
	);
	--------------------------------
	altsyncrom_cgram : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "cgram.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 4,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 2,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,2)),
		clock0 => in_std_clk,
		q_a => sig_std8_cgram
		);
	--------------------------------
	altsyncrom_disp_on : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "disp_on.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 2,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 1,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,1)),
		clock0 => in_std_clk,
		q_a => sig_std8_disp_on
		);
	--------------------------------
		altsyncrom_set_start_clr : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "set_start_clr.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 4,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 2,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,2)),
		clock0 => in_std_clk,
		q_a => sig_std8_set_start_clr
		);
	
	----------------------------------
	altsyncrom_clr_disp : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "clr_disp.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 16384,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 14,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,14)),
		clock0 => in_std_clk,
		q_a => sig_std8_clr_disp
	);
	------------------------------------
			altsyncrom_set_start : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "set_start.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 4,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 2,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,2)),
		clock0 => in_std_clk,
		q_a => sig_std8_set_start
		);
--------------------------------
	altsyncrom_logo : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "logo.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 16384,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 14,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,14)),
		clock0 => in_std_clk,
		q_a => sig_std8_logo
	);
	
	----------------------------------
		altsyncrom_chpnt : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "chpnt.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 16384,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 14,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,14)),
		clock0 => in_std_clk,
		q_a => sig_std8_chpnt
	);
-------------------------------------
	altsyncram_work_ram : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK1",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK1",
		init_file => "logo.mif",
		intended_device_family => "Cyclone V",
		lpm_type => "altsyncram",
		numwords_a => 16384,
		numwords_b => 16384,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "CLOCK0",
		outdata_reg_b => "CLOCK1",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
		widthad_a => 14,
		widthad_b => 14,
		width_a => 8,
		width_b => 8,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK1"
	)
	PORT MAP (
		address_a => std_logic_vector(to_unsigned(i,14)),
		address_b => in_std14_adress,
		clock0 => in_std_clk,
		clock1 => in_std_clk,
		--data_a => ,
		data_b => in_std8_data_in,
		--wren_a => ,
		wren_b => in_std_nwe,
		q_a => sig_std8_work_data
		--q_b => 
	);

	--------------------------------------------
	
	
end LCD_ARCH;	
