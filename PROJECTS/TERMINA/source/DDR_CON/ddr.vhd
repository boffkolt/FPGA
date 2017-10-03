

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.lib_ddr.all;


entity ddr is

	port
	(
		
		in_std_clk : in std_logic;
		in_std_ena : in std_logic;
		out_std_ready : out std_logic;
		
		in_std256_data : in std_logic_vector(255 downto 0);
		out_std256_data : out std_logic_vector(255 downto 0);
		in_std_str_wr : in std_logic;
		in_std_str_rd : in std_logic;
		out_std_valid_data : out std_logic;
		in_std27_adr:	in std_logic_vector(26 downto 0);
		
		out_std27_adr:	out std_logic_vector(26 downto 0);
		in_std_waitrq:	in std_logic;
		in_std256_read_data: in std_logic_vector(255 downto 0);
		out_std256_write_data: out std_logic_vector(255 downto 0);		
		out_std_wr:	out std_logic;
		out_std_rd: out std_logic;
		out_std8_burstcount	:	out std_logic_vector (7 downto 0);
		out_std32_byteenable	:	out std_logic_vector (31 downto 0);
		in_std_valid	:	in	std_logic
	);
end ddr;

architecture arch_ddr of ddr is


--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование сигналов архитектуры									  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////

signal sig_int_cnt 		: integer := 0;
signal sig_std_read_ok 	: std_logic := '0';
signal sig_std_write_ok	: std_logic := '0';
signal sig_std_read		: std_logic := '0';
signal sig_std_write	: std_logic := '0';
signal sig_std_str_rd_t1: std_logic := '0';
signal sig_std_str_wr_t1: std_logic := '0';
signal sig_std_read_ok_t1: std_logic := '0';
signal sig_std_write_ok_t1: std_logic := '0';
signal sig_std_str_wr: std_logic := '0';
signal sig_std_str_rd: std_logic := '0';
signal sig_std_waitrq: std_logic ;
signal sig_std_valid_t1: std_logic:='0';
signal sig_std_ready : std_logic := '0';
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
begin

out_std256_data <= 	in_std256_read_data; --(  7 downto   0) &
--							in_std256_read_data ( 15 downto   8) &
--							in_std256_read_data ( 23 downto  16) &
--							in_std256_read_data ( 31 downto  24) &
--							in_std256_read_data ( 39 downto  32) &
--							in_std256_read_data ( 47 downto  40) &
--							in_std256_read_data ( 55 downto  48) &
--							in_std256_read_data ( 63 downto  56) &
--							in_std256_read_data ( 71 downto  64) &
--							in_std256_read_data ( 79 downto  72) &
--							in_std256_read_data ( 87 downto  80) &
--							in_std256_read_data ( 95 downto  88) &
--							in_std256_read_data (103 downto  96) &
--							in_std256_read_data (111 downto 104) &
--							in_std256_read_data (119 downto 112) &
--							in_std256_read_data (127 downto 120) &
--							in_std256_read_data (135 downto 128) &
--							in_std256_read_data (143 downto 136) &
--							in_std256_read_data (151 downto 144) &
--							in_std256_read_data (159 downto 152) &
--							in_std256_read_data (167 downto 160) &
--							in_std256_read_data (175 downto 168) &
--							in_std256_read_data (183 downto 176) &
--							in_std256_read_data (191 downto 184) &
--							in_std256_read_data (199 downto 192) &
--							in_std256_read_data (207 downto 200) &
--							in_std256_read_data (215 downto 208) &
--							in_std256_read_data (223 downto 216) &
--							in_std256_read_data (231 downto 224) &
--							in_std256_read_data (239 downto 232) &
--							in_std256_read_data (247 downto 240) &
--							in_std256_read_data (255 downto 248) ;

--////////////////////////////////////////////////////////////////////////
--		Процесс 										
--////////////////////////////////////////////////////////////////////////
RD_WR: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
			out_std8_burstcount <= X"00";
			out_std32_byteenable	<= (others => '0');
			sig_int_cnt<= 0;	
			out_std_rd <= '0';
			out_std_wr <= '0';
			sig_std_write_ok <= '0';
			sig_std_read_ok <= '0';		
			out_std_valid_data <= '0';			
		elsif in_std_clk'event and in_std_clk = '1' then
			out_std8_burstcount <= X"01";
			out_std32_byteenable	<= (others => '1');
			if (sig_std_read = '1') then
				read_ddr(	sig_int_cnt,
							in_std27_adr,
							out_std27_adr,
							in_std256_read_data,
							out_std256_data,
							in_std_waitrq,
							out_std_rd,
							sig_std_read_ok,
							out_std_valid_data);
			elsif (sig_std_write = '1') then
				write_ddr(	sig_int_cnt,
							in_std27_adr,
							out_std27_adr,
							in_std256_data,
							out_std256_write_data,
							in_std_waitrq,
							out_std_wr,
							sig_std_write_ok);	
			else
				out_std_rd <= '0';
				out_std_wr <= '0';
				sig_std_write_ok <= '0';
				sig_std_read_ok <= '0';
				sig_int_cnt <= 0;
				out_std_valid_data <= '0';	
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

STROBE_RD: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_std_read <= '0';						
		elsif in_std_clk'event and in_std_clk = '1' then
			
			if ((sig_std_str_rd = '1' and sig_std_str_rd_t1 = '0') and sig_std_write = '0') then
				sig_std_read <= '1';
			elsif (sig_std_read_ok = '1' and in_std_valid = '1'  ) then
				sig_std_read <= '0';
			end if;
		end if;
	end process;
	
STROBE_WR: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
			sig_std_write <= '0';						
		elsif in_std_clk'event and in_std_clk = '1' then
			if ((sig_std_str_wr = '1' and sig_std_str_wr_t1 ='0') and sig_std_read = '0') then
				sig_std_write <= '1';
			elsif (sig_std_write_ok = '1' and in_std_waitrq = '0'  ) then
				sig_std_write <= '0';
			end if;
		end if;
	end process;




STROBE: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
									
		elsif in_std_clk'event and in_std_clk = '1' then
			sig_std_str_wr <= in_std_str_wr;
			sig_std_str_rd <= in_std_str_rd;
			sig_std_str_wr_t1 <= sig_std_str_wr;
			sig_std_str_rd_t1 <= sig_std_str_rd;
			sig_std_read_ok_t1 <= sig_std_read_ok;
			sig_std_write_ok_t1 <= sig_std_write_ok;
			sig_std_valid_t1 <= in_std_valid;

		end if;
	end process;

READY: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
									
		elsif in_std_clk'event and in_std_clk = '1' then
			if (sig_std_write = '1' or sig_std_read = '1') then
				sig_std_ready <= '1';
			elsif ((in_std_valid = '0' and sig_std_valid_t1 = '1' and sig_std_read = '0') or (sig_std_write = '0')) then
				sig_std_ready <= '0';
			end if;
			

		end if;
	end process;
	
READYOUT: process (in_std_clk, in_std_ena)
	begin
		if in_std_ena = '0' then
									
		elsif in_std_clk'event and in_std_clk = '0' then
			if (sig_std_ready = '1') then
				out_std_ready <= '1';
			elsif (sig_std_ready = '0' and in_std_waitrq = '0') then
				out_std_ready <= '0';
			end if;
			

		end if;
	end process;
end arch_ddr;
