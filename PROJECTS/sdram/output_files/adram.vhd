library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity func is

	port (
			--clk
			clk						: in std_logic;
			--read
			rd_req					: out std_logic;
			rd_adr					: out std_logic_vector(21 downto 0);
			rd_data					: in std_logic_vector(15 downto 0);
			rd_valid					: in std_logic;
			--write
			wr_req					: out std_logic;
			wr_adr					: out std_logic_vector(21 downto 0);
			wr_data					: out std_logic_vector(15 downto 0)
		
			);
end entity;

architecture rtl of func is

signal sig_write : std_logic := '0';
	
	
begin

	state_machine:process(clk)
	begin
		if rising_edge(clk) then
		
			if sig_write = '1' then
				wr_req	<= '1';
				wr_adr	<= (others => '0');
				wr_data <= X"BEEF";
				rd_req <= '0';
			else
				rd_req <= '1';
				wr_req	<= '0';
				rd_adr <= (others => '0');
		end if;
		end if;
		end process;
		
		count:process(clk)
		variable cnt : integer := 0;
	begin
		if rising_edge(clk) then
		
			if cnt <  50 then
				cnt := cnt +1;
				
			else
				cnt:=0;
				sig_write <= '1';
		end if;
end if;
end process;
end rtl;