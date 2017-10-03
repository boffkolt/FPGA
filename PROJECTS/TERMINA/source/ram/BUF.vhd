library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity BUF is

	
	port( 
		in_std_clk 					:	in std_logic; 													-- один порт для сигнала с кварца
		inout_std16_data_a		: 	inout std_logic_vector(15 downto 0)		:= (others => 'Z'); 
		in_std_noe_a 				: 	in std_logic									:= 'Z';						-- разрешение на выход
		in_std_nwe_a 				: 	in std_logic 									:= 'Z';						-- разрешение на запись
		in_std12_adr_a				: 	in std_logic_vector(10 downto 0)			:= (others => 'Z');					-- шина адреса
		in_std8_nce_a				: 	in std_logic_vector(7 downto 0)			:= (others => 'Z');

		inout_std16_data_b		: 	inout std_logic_vector(15 downto 0)		:= (others => 'Z'); 
		in_std_noe_b				: 	in std_logic									:= 'Z';						-- разрешение на выход
		in_std_nwe_b 				: 	in std_logic 									:= 'Z';						-- разрешение на запись
		in_std12_adr_b				: 	in std_logic_vector(10 downto 0)			:= (others => 'Z');					-- шина адреса
		in_std8_nce_b				: 	in std_logic_vector(7 downto 0)			:= (others => 'Z');
		in_std_ena					:	in std_logic);
								
end BUF;
		
architecture RW_BUF of BUF is

type mem_wr is array (1024 to 1408) of std_logic_vector (15 downto 0);
type mem_rd is array (0 to 800) of std_logic_vector (15 downto 0);
type all_mem_wr is array (0 to 5) of mem_wr;
type all_mem_rd is array (0 to 5) of mem_rd;


signal	data_read 		: all_mem_rd ;
signal	data_write 		: all_mem_wr;


signal sig_int_ind_a : integer;
signal sig_int_ind_b : integer;

signal i_a : integer;
signal i_b : integer;

 begin
 
i_a <= 	0	when (in_std8_nce_a = X"FE") else
			1	when (in_std8_nce_a = X"FD") else
			2	when (in_std8_nce_a = X"FB") else
			3	when (in_std8_nce_a = X"F7") else
			4	when (in_std8_nce_a = X"EF") else
			5	when (in_std8_nce_a = X"DF") else
			6	when (in_std8_nce_a = X"BF") else
			i_a;
 
i_b <= 	0	when (in_std8_nce_b = X"FE") else
			1	when (in_std8_nce_b = X"FD") else
			2	when (in_std8_nce_b = X"FB") else
			3	when (in_std8_nce_b = X"F7") else
			4	when (in_std8_nce_b = X"EF") else
			5	when (in_std8_nce_b = X"DF") else
			6	when (in_std8_nce_b = X"BF") else
			i_b;
			
sig_int_ind_a <= to_integer(unsigned(in_std12_adr_a));
sig_int_ind_b <= to_integer(unsigned(in_std12_adr_b));



----------------------------------------------------------------
----------------------------------------------------------------
-------- БУФФЕР-------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
RW_SRAM : process(in_std_clk, in_std_ena)
	begin
	if (in_std_ena = '0') then
		inout_std16_data_a <= (others => 'Z');
	elsif (in_std_clk'event and in_std_clk='1') then 	
		if (in_std8_nce_a /= X"FF") then
			if (in_std_noe_a = '1' and in_std_nwe_a = '1' ) then
				inout_std16_data_a <= (others => 'Z');
			elsif (in_std_nwe_a = '0' and in_std_nwe_a'last_value = '1' and in_std_noe_a = '1') then
				inout_std16_data_a <= (others => 'Z');
				data_write(i_a)(sig_int_ind_a) <= inout_std16_data_a;
			elsif (in_std_noe_a = '0' and in_std_nwe_a = '1') then
				inout_std16_data_a <= data_read(i_a)(sig_int_ind_a);
			end if;
		end if;
	end if;	
end process;

RW_DDR : process(in_std_clk,in_std_ena)
	begin
	if (in_std_ena = '0') then
		inout_std16_data_b <= (others => 'Z');
	elsif (in_std_clk'event and in_std_clk='1') then 	
		if (in_std8_nce_b /= X"FF") then
			if (in_std_noe_b = '1' and in_std_nwe_b = '1' ) then
				inout_std16_data_b <= (others => 'Z');
			elsif (in_std_nwe_b = '0' and in_std_nwe_b'last_value = '1' and in_std_noe_b = '1') then
				inout_std16_data_b <= (others => 'Z');
				data_read(i_b)(sig_int_ind_b) <= inout_std16_data_b;
			elsif (in_std_noe_b = '0' and in_std_nwe_b = '1') then
				inout_std16_data_b <= data_write(i_b)(sig_int_ind_b);
			end if;
		end if;
	end if;	
end process;



 end RW_BUF;
 
--  