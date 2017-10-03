library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY fsmc IS
	generic
	(
		WIDTH_DATA	:	natural range 0 to 32	:=	16;
		WIDTH_ADR	:	natural range 6 to 32	:=	6
	);
	PORT(	clk	: IN	std_logic;
			reset	: IN	std_logic;
			
			cs	: IN	std_logic;
			Data_adress : inout	std_logic_vector(WIDTH_ADR-1 downto 0) := (others => '0');
			NOE : in std_logic := '0';
			NWE : in std_logic := '0';
			Data_out	:	out std_logic_vector(WIDTH_DATA-1 downto 0);
			Data_in	:	in std_logic_vector(WIDTH_DATA-1 downto 0);
			Adress_out	:	out	std_logic_vector(WIDTH_ADR-1 downto 0);
			NOE_out : out std_logic := '0';
			NWE_out : out std_logic := '0'
		);
END ENTITY;

ARCHITECTURE rtl OF fsmc IS
	TYPE state_type IS (IDLE, GET_ADRESS, WRITE_RAM, READ_RAM);
	SIGNAL next_st, present_st: state_type;
BEGIN

state_proc:
PROCESS (clk, reset)
BEGIN
IF reset = '1' then
elsif (rising_edge(clk)) then
	CASE present_st IS
		WHEN IDLE => 
			NWE_out <= '1';
			IF cs = '0' 
				THEN present_st <= GET_ADRESS; 
			ELSE 
				present_st <= IDLE;
			END IF;
		WHEN GET_ADRESS => 
			Data_adress <= (others => 'Z');
			Adress_out <= Data_adress;
			if NOE = '0'  
				THEN present_st <= READ_RAM;
			elsif NwE = '0' 
				THEN present_st <= WRITE_RAM;
			ELSE 
				present_st <= GET_ADRESS;
			END IF;
		WHEN READ_RAM => 
			Data_adress(WIDTH_DATA-1 downto 0) <= Data_in;
			IF cs = '1' 
				THEN present_st <= IDLE; 
			ELSE 
				present_st <= READ_RAM;
			END IF;
		WHEN WRITE_RAM => 
			Data_adress <= (others => 'Z');
			Data_out <= Data_adress(WIDTH_DATA-1 downto 0);
			NWE_out <= '0';
			IF cs = '1' 
				THEN present_st <= IDLE; 
			ELSE 
				present_st <= WRITE_RAM;
			END IF;
	END CASE;
end if;
END PROCESS;



END rtl;