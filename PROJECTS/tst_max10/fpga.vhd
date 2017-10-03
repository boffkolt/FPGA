library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY fpga IS
	generic
	(
		WIDTH_DATA	:	natural range 0 to 32	:=	16;
		WIDTH_ADR	:	natural range 6 to 32	:=	6
	);
	PORT(	clk	: IN	std_logic;
			reset	: IN	std_logic;
			
			ADRESS_out	: out	std_logic_vector(WIDTH_ADR-1 downto 0);
			Data_IN : in	std_logic_vector(WIDTH_DATA-1 downto 0) := (others => '0');
			Data_OUT : out	std_logic_vector(WIDTH_DATA-1 downto 0) := (others => '0');

			NWE_out : out std_logic := '0'
			
		);
END ENTITY;

ARCHITECTURE rtl OF fpga IS
	TYPE state_type IS (INIT, READ_RAM);
	SIGNAL state: state_type;
	signal sig_adress : std_logic_vector (WIDTH_ADR - 1 downto 0);
	signal sig_init : std_logic :='0';
	constant max_adress : std_logic_vector (WIDTH_ADR - 1 downto 0) := (others => '1');
BEGIN
ADRESS_out <= sig_adress;
Data_OUT<= sig_adress(WIDTH_DATA-1 downto 0);
state_proc:
PROCESS (clk, reset)
BEGIN

IF reset = '0' then
state <= INIT;
elsif (rising_edge(clk)) then
	CASE state IS
		WHEN INIT => 
			IF sig_init = '1' 
				THEN state <= READ_RAM; 
			ELSE 
				state <= INIT;
			END IF;
		WHEN READ_RAM => 
			state <= READ_RAM;

	END CASE;
end if;
END PROCESS;

work_proc:
PROCESS (clk, reset)
BEGIN

IF reset = '0' then
NWE_out <= '0';
elsif (rising_edge(clk)) then
	if state = INIT then
		NWE_out <= '1';
	end if;
end if;
END PROCESS;

cnt_proc:
PROCESS (clk, reset)
BEGIN
IF reset = '0' then
sig_adress <= (others => '0');
elsif (rising_edge(clk)) then
	if sig_adress = max_adress then
		sig_adress <= (others => '0');
		sig_init <= '1';
	else
		sig_adress <= sig_adress + 1;
	end if;
end if;
END PROCESS;

END rtl;