library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY top IS
	generic
	(
		WIDTH_DATA	:	natural range 0 to 32	:=	13;
		WIDTH_ADR	:	natural range 6 to 32	:=	13
	);
	PORT
	(	
		clk_a	: IN	std_logic;
		clk_b	: IN	std_logic;
		in_std_ena	: IN	std_logic;
		
		cs_b	: IN	std_logic;
		Data_adress_b : inout	std_logic_vector(WIDTH_ADR-1 downto 0) := (others => '0');
		NOE_b : in std_logic := '0';
		NWE_b : in std_logic := '0';
		
		Adress_a : out	std_logic_vector(WIDTH_ADR-1 downto 0) := (others => '0');
		--DATA_IN_a : in	std_logic_vector(WIDTH_DATA-1 downto 0) := (others => '0');
		DATA_OUT_a_port : out	std_logic_vector(WIDTH_DATA-1 downto 0) := (others => '0');
		--NOE_a : in std_logic := '0';
		NWE_a : in std_logic := '0'
	);
END ENTITY;

ARCHITECTURE rtl OF top IS

	signal data_out_b	:	std_logic_vector(WIDTH_DATA-1 downto 0);
	signal data_in_b 	:	std_logic_vector(WIDTH_DATA-1 downto 0);
	signal adr_out_b	:	std_logic_vector(WIDTH_ADR-1 downto 0);
	signal noe_out_b	:	std_logic;
	signal nwe_out_b	:	std_logic;
	
	
	signal data_out_a	:	std_logic_vector(WIDTH_DATA-1 downto 0);
	signal data_in_a 	:	std_logic_vector(WIDTH_DATA-1 downto 0);
	signal adr_out_a	:	std_logic_vector(WIDTH_ADR-1 downto 0);
	signal noe_out_a	:	std_logic;
	signal nwe_out_a	:	std_logic;
	
BEGIN
Adress_a <= adr_out_a ;
DATA_OUT_a_port<=data_in_a;

fsmc: entity work.fsmc 
		generic map
		(
			WIDTH_DATA,
			WIDTH_ADR
		)
		port map
		(
			clk_b,
			in_std_ena,
			
			cs_b,
			Data_adress_b,
			NOE_b,
			NWE_b,
			
			data_out_b,
			data_in_b,
			adr_out_b,
			noe_out_b,
			nwe_out_b
		);
dual_ram: 	entity work.dual_ram


				generic map
				(
					WIDTH_DATA,
					WIDTH_ADR
				)
				port map
				(
		data_out_a,
		data_out_b,
		adr_out_a,
		adr_out_b,
		nwe_out_a ,
		nwe_out_b,
		clk_a,
		clk_b,
		data_in_a,
		data_in_b
				);
				
	fpga: 	entity work.fpga


				generic map
				(
					WIDTH_DATA,
					WIDTH_ADR
				)
				port map
				(
	clk_a,
	in_std_ena,
			
			adr_out_a,
			data_in_a,
			data_out_a,

			nwe_out_a
				);			


END rtl;