
-----------------------------------------------------------------------------------
-- ШАБЛОН ТЕСТБЕНЧА VHDL 
------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use work.my_types.all;


entity sig_buf_tb is
	generic
	(
		WIDTH_DATA : integer range 1 to 16 := 16;	-- Разрядность данных
		NUM_DATA : integer range 1 to 500 := 8		-- Количество слов
		
	);
end sig_buf_tb ;

		
architecture ARCH_sig_buf_tb of sig_buf_tb is
component SignedBufferAverage
	generic
	(
		WIDTH_DATA 	: integer range 1 to 16 := 16;	-- Разрядность данных
		NUM_DATA 	: integer range 1 to 500 := 8		-- Количество слов
	);
	port
	(
		-- // Clock port
		in_std_clk_100MHz 	: 	in 	std_logic;												-- Входная тактовая частота
		in_stdX_data 		: 	in 	std_logic_vector(WIDTH_DATA-1 downto 0);
		out_stdX_data 		: 	out std_logic_vector(WIDTH_DATA-1 downto 0);
		in_std_start_strob 	:	in 	std_logic;
		out_std_ready_data 	: 	out std_logic;
		in_std_ena 			: 	in 	std_logic															-- Разрешение работы блока
	);
end component;

for label_0: SignedBufferAverage use entity work.SignedBufferAverage ;
		
signal 	in_std_clk_100MHz 		: std_logic								 	:= '0';
signal 	in_stdX_data 			: std_logic_vector(WIDTH_DATA-1 downto 0)	:= (others => '1');
signal 	out_stdX_data 			: std_logic_vector(WIDTH_DATA-1 downto 0) 		;
signal 	in_std_start_strob 		: std_logic	:= '0';
signal 	out_std_ready_data 		: std_logic	:= '0';
signal 	in_std_ena 				: std_logic		:='0'						 		;

begin

label_0: SignedBufferAverage 

generic map (			
			WIDTH_DATA 	=>	WIDTH_DATA ,				
			NUM_DATA 	=>	NUM_DATA 	 					

)
port map (		
					in_std_clk_100MHz 	=>		in_std_clk_100MHz 	,					
					in_stdX_data 		=> 		in_stdX_data 		,		
					out_stdX_data 		=> 		out_stdX_data 		,				
					in_std_start_strob 	=> 		in_std_start_strob 	,					
					out_std_ready_data 	=> 		out_std_ready_data 		,					
					in_std_ena 			=> 		in_std_ena 								
											
							);



-----------------------------------------------------------------------------------
-- ПРОЦЕСС ТАКТИРОВАНИЯ
------------------------------------------------------------------------------------


CLK: process
begin

       in_std_clk_100MHz <= not(in_std_clk_100MHz);
       
       wait for 5 ns;
   
end process;



ENA: process
begin
		wait for 32 ns;
		in_std_ena <= '1';
       
       
   
end process;

ENA2: process
begin
		wait for 100 ns;
		in_std_start_strob <= '1';
		wait for 100 ns;
		in_std_start_strob <= '0';
		wait for 10 us;
end process;

DAT: process
begin
		wait for 19900 ns;
		in_stdX_data  <= X"DEAD";
		wait for 19900 ns;
		in_stdX_data  <= X"BEFF";
end process;
-----------------------------------------------------------------------------------
-- ПРОЦЕСС ОСТАНОВКИ СИМУЛЯЦИИ
------------------------------------------------------------------------------------

STOP: process
begin
	assert false
		report "simulation started"
		severity warning;
	wait for 100 ms; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ;

end ARCH_sig_buf_tb;	
