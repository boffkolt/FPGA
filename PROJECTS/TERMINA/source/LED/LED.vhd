library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity LED is
	
	port( 
		in_std_clk 					:	in std_logic; 												
	
		in_std_ena					:	in std_logic := '1';														
		
		out_std_data				:	out std_logic;
		out_std_str					:	out std_logic;
		in_std256_data				: 	in std_logic_vector(255 downto 0));
		
		
end LED;
		
architecture LED_ARCH of LED is


signal sig_std8_start					: std_logic_vector(7 downto 0) := X"FF";                                                                                       
signal sig_std256_data					: std_logic_vector(255 downto 0);
signal sig_std256_data_t1					: std_logic_vector(255 downto 0);
signal sig_std_start					:  std_logic							:='0';
signal sig_std_stop						: 	std_logic							:='0';
signal sig_std_strt						:  std_logic							:='0';
signal sig_std_change_bit			:	std_logic							:='0';
signal sig_std_init			: std_logic	:= '0';
signal sig_std_change_data	:	std_logic := '0';

signal sig_std_read_ok					: 	std_logic							:='0';

signal sig_int_count						: integer	:=	0;

begin


WRK: process(in_std_ena,in_std_clk)

begin
		if (in_std_ena = '0') then
			sig_std_stop <= '0';
			sig_std_init <= '0';
		--	out_std_data <= '0';
			sig_std8_start <= X"FF";
			sig_std_read_ok <= '0';
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (sig_std_strt = '1' ) then
				if (sig_std_change_bit = '1' and sig_std_change_bit'last_value = '0') then
					if (sig_std_init = '0') then
						sig_std_read_ok <= '0';
						out_std_data <= sig_std8_start(0);
						sig_std8_start <= sig_std8_start(0) & sig_std8_start(7 downto 1);
						if(sig_int_count < 7) then
							sig_int_count <= sig_int_count + 1;
						else
							sig_std_init <= '1';
							sig_int_count <= 0;
						end if;

					else
						if(sig_int_count < 256) then
							out_std_data <= sig_std256_data(0);
							sig_std256_data <= sig_std256_data(0) & sig_std256_data(255 downto 1);
							sig_int_count <= sig_int_count + 1;
						else
							sig_int_count <= 0;
							out_std_data <= '0';
							sig_std_stop <= '1';
							sig_std8_start <= X"FF";
						end if;
						
					end if;
				end if;
			else
				sig_std_stop <= '0';
				sig_std_init <= '0';
				out_std_data <= '0';
				sig_std8_start <= X"FF";
				
				if (sig_std_read_ok = '0') then
					sig_std256_data <= 	in_std256_data(248) & in_std256_data(249) & in_std256_data(250) & in_std256_data(251) & in_std256_data(255 downto 252) &
										in_std256_data(240) & in_std256_data(241) & in_std256_data(242) & in_std256_data(243) & in_std256_data(247 downto 244) &		
										in_std256_data(232) & in_std256_data(233) & in_std256_data(234) & in_std256_data(235) & in_std256_data(239 downto 236) &			
										in_std256_data(224) & in_std256_data(225) & in_std256_data(226) & in_std256_data(227) & in_std256_data(231 downto 228) &			
										in_std256_data(216) & in_std256_data(217) & in_std256_data(218) & in_std256_data(219) & in_std256_data(223 downto 220) &			
										in_std256_data(208) & in_std256_data(209) & in_std256_data(210) & in_std256_data(211) & in_std256_data(215 downto 212) &			
										in_std256_data(200) & in_std256_data(201) & in_std256_data(202) & in_std256_data(203) & in_std256_data(207 downto 204) &			
										in_std256_data(192) & in_std256_data(193) & in_std256_data(194) & in_std256_data(195) & in_std256_data(199 downto 196) &			
										in_std256_data(184) & in_std256_data(185) & in_std256_data(186) & in_std256_data(187) & in_std256_data(191 downto 188) &
										in_std256_data(176) & in_std256_data(177) & in_std256_data(178) & in_std256_data(179) & in_std256_data(183 downto 180) &		
										in_std256_data(168) & in_std256_data(169) & in_std256_data(170) & in_std256_data(171) & in_std256_data(175 downto 172) &			
										in_std256_data(160) & in_std256_data(161) & in_std256_data(162) & in_std256_data(163) & in_std256_data(167 downto 164) &			
										in_std256_data(152) & in_std256_data(153) & in_std256_data(154) & in_std256_data(155) & in_std256_data(159 downto 156) &			
										in_std256_data(144) & in_std256_data(145) & in_std256_data(146) & in_std256_data(147) & in_std256_data(151 downto 148) &			
										in_std256_data(136) & in_std256_data(137) & in_std256_data(138) & in_std256_data(139) & in_std256_data(143 downto 140) &			
										in_std256_data(128) & in_std256_data(129) & in_std256_data(130) & in_std256_data(131) & in_std256_data(135 downto 132) &			
										in_std256_data(120) & in_std256_data(121) & in_std256_data(122) & in_std256_data(123) & in_std256_data(127 downto 124) &
										in_std256_data(112) & in_std256_data(113) & in_std256_data(114) & in_std256_data(115) & in_std256_data(119 downto 116) &		
										in_std256_data(104) & in_std256_data(105) & in_std256_data(106) & in_std256_data(107) & in_std256_data(111 downto 108) &			
										in_std256_data( 96) & in_std256_data( 97) & in_std256_data( 98) & in_std256_data( 99) & in_std256_data(103 downto 100) &			
										in_std256_data( 88) & in_std256_data( 89) & in_std256_data( 90) & in_std256_data( 91) & in_std256_data( 95 downto  92) &			
										in_std256_data( 80) & in_std256_data( 81) & in_std256_data( 82) & in_std256_data( 83) & in_std256_data( 87 downto  84) &			
										in_std256_data( 72) & in_std256_data( 73) & in_std256_data( 74) & in_std256_data( 75) & in_std256_data( 79 downto  76) &			
										in_std256_data( 64) & in_std256_data( 65) & in_std256_data( 66) & in_std256_data( 67) & in_std256_data( 71 downto  68) &			
										in_std256_data( 56) & in_std256_data( 57) & in_std256_data( 58) & in_std256_data( 59) & in_std256_data( 63 downto  60) &
										in_std256_data( 48) & in_std256_data( 49) & in_std256_data( 50) & in_std256_data( 51) & in_std256_data( 55 downto  52) &		
										in_std256_data( 40) & in_std256_data( 41) & in_std256_data( 42) & in_std256_data( 43) & in_std256_data( 47 downto  44) &			
										in_std256_data( 32) & in_std256_data( 33) & in_std256_data( 34) & in_std256_data( 35) & in_std256_data( 39 downto  36) &			
										in_std256_data( 24) & in_std256_data( 25) & in_std256_data( 26) & in_std256_data( 27) & in_std256_data( 31 downto  28) &			
										in_std256_data( 16) & in_std256_data( 17) & in_std256_data( 18) & in_std256_data( 19) & in_std256_data( 23 downto  20) &			
										in_std256_data(  8) & in_std256_data(  9) & in_std256_data( 10) & in_std256_data( 11) & in_std256_data( 15 downto  12) &			
										in_std256_data(  0) & in_std256_data(  1) & in_std256_data(  2) & in_std256_data(  3) & in_std256_data(  7 downto   4) ;
					sig_std_read_ok <= '1';
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
			if (var_int_counter < 14999996) then
				var_int_counter := var_int_counter + 1;
				sig_std_start <= '0';
			else 
				var_int_counter := 0;
				sig_std_start <= '1';
			end if;
		end if;
end process;

CNT_con: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 25500000 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (var_int_counter < 14999905) then
				var_int_counter := var_int_counter + 1;
				out_std_str	 <= '0';
			else 
				var_int_counter := 0;
				out_std_str	 <= '1';
			end if;
		end if;
end process;

CNT_WRK: process(in_std_ena,in_std_clk)
variable var_int_counter : integer range 0 to 55500 := 0;
begin
		if (in_std_ena = '0') then
			var_int_counter := 0;
		elsif (in_std_clk'event and in_std_clk='1') then 
			if (var_int_counter < 49999) then
				var_int_counter := var_int_counter + 1;
				sig_std_change_bit <= '0';
			else 
				var_int_counter := 0;
				sig_std_change_bit <= '1';
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



STROBEss: process(in_std_ena,in_std_clk)

begin
		if (in_std_ena = '0') then
			
		elsif (in_std_clk'event and in_std_clk='1') then 
			sig_std256_data_t1 <= sig_std256_data;
		end if;
end process;





end LED_ARCH;	
