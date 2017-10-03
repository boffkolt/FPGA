library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adram is

	port (
			--clk
			clk						: in std_logic;
			--read
			rd_req					: in std_logic;
			rd_adr					: in std_logic_vector(21 downto 0);
			rd_data					: out std_logic_vector(15 downto 0);
			rd_valid					: out std_logic;
			--write
			wr_req					: in std_logic;
			wr_adr					: in std_logic_vector(21 downto 0);
			wr_data					: in std_logic_vector(15 downto 0);
			--SDRAM interface
			sdram_wren_n			: out std_logic;
			sdram_cas_n				: out std_logic;
			sdram_ras_n				: out std_logic;
			sdram_a					: out std_logic_vector(11 downto 0);
			sdram_ba					: out std_logic_vector(1 downto 0);
			sdram_dqm				: out std_logic_vector(1 downto 0);
			sdram_dq					: inout std_logic_vector(15 downto 0);
			sdram_clk_n				: out std_logic
			);
end entity;

architecture rtl of adram is


	signal adr						: std_logic_vector(21 downto 0)	 := (others => '0'); 			--selected address
	signal adr_reg					: std_logic_vector(21 downto 0)	 := (others => '0');				--selected address register
	signal state					: std_logic_vector(1 downto 0)	 := (others => '0');				--state machine register
	signal sdram_cmd				: std_logic_vector(2 downto 0)	 := (others => '0');				--command register
	signal wr_data1				: std_logic_vector(15 downto 0)	 := (others => '0');				--write data pipe stage1
	signal wr_data2				: std_logic_vector(15 downto 0)	 := (others => '0'); 			--write data pipe stage2
	signal rd_pipe_valid			: std_logic_vector(3 downto 0)	 := (others => '0');	
	signal rd_now					: std_logic := '0';
	signal rd_selected			: std_logic := '0';
	signal wr_selected			: std_logic := '0';
	signal rd_cycle				: std_logic := '0';
	signal same_row_and_bank	: std_logic := '0';
	signal sdram_dq_oe			: std_logic := '0';					--output enable
	
	--sdram commands
	constant cmd_loadmode		: std_logic_vector(2 downto 0) := "000";
	constant cmd_refresh			: std_logic_vector(2 downto 0) := "001";
	constant cmd_prechardge		: std_logic_vector(2 downto 0) := "010";
	constant cmd_active 			: std_logic_vector(2 downto 0) := "011";
	constant cmd_write			: std_logic_vector(2 downto 0) := "100";
	constant cmd_read				: std_logic_vector(2 downto 0) := "101";
	constant cmd_nop				: std_logic_vector(2 downto 0) := "111";
	
begin

	state_machine:process(clk)
	begin
		if rising_edge(clk) then
			case state is
				when "00" =>	if ((rd_req = '1') or (wr_req = '1')) then	--if read or write request 
										sdram_cmd <= cmd_active;						--then activate sdram
										sdram_ba <= adr(21 downto 20);				--and open this bank
										sdram_a <= adr(19 downto 8);					--and this row
										sdram_dqm <= "11";
										state <= "01";										--go to "read or write" state after all
									else
										sdram_cmd <= cmd_nop;							--if no requests then no operation needed
										sdram_ba <= (others => '0');
										sdram_a <= (others => '0');
										sdram_dqm <= "11";
										state <= "00";
									end if;
									
				when "01" =>	if (rd_selected = '1') then
										sdram_cmd <= cmd_read;							--run read if read needed
									else
										sdram_cmd <= cmd_write;							--...or write
									end if;
									sdram_ba <= adr_reg(21 downto 20);
									sdram_a(9 downto 0) <= "00" & adr_reg(7 downto 0);
									sdram_a(10) <= '0';
									sdram_dqm <= "00";
									--if row address do not change, repeat prev operation
									if ((rd_selected = '1' and rd_req = '1' and same_row_and_bank = '1') or (rd_selected = '0' and wr_req = '1' and same_row_and_bank = '1')) then
										state <= "01";
									else --else open new bank and row
										state <= "10";
									end if;
									
				when "10" =>	sdram_cmd <= cmd_prechardge; --closing row
									sdram_ba <= (others => '0');
									sdram_a <= (10 => '1', others => '0');
									sdram_dqm <= "11";
									state <= "00";
									
				when "11" =>	sdram_cmd <= cmd_nop;
									sdram_ba <= (others => '0');
									sdram_a <= (others => '0');
									sdram_dqm <= "11";
									state <= "00";
				when others => null;
			end case;
		end if;
	end process state_machine;
	
	read_priority:process(rd_req, wr_req) --read requests have priority
	begin
		rd_now <= rd_req;
	end process read_priority;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if (state = "00") then
				rd_selected <= rd_now;
			end if;
		end if;
	end process;
	
	address_select:process(clk, rd_cycle)
	begin
		if rising_edge(clk) then
			adr_reg <= adr;
		end if;
	end process address_select;
	
	output_enable:process(clk)
	begin
		if rising_edge(clk) then
			if (state = "01") then
				sdram_dq_oe <= wr_selected;
			else
				sdram_dq_oe <= '0';
			end if;
		end if;
	end process output_enable;
	
	process(clk)
	begin
		if rising_edge(clk) then
			wr_data1 <= wr_data;
			wr_data2 <= wr_data1;
		end if;
	end process;
	
	read_valid:process(clk)
	begin
		if rising_edge(clk) then
			if (state = "01" and rd_selected = '1') then
				rd_pipe_valid <= rd_pipe_valid(2 downto 0) & '1';
			else
				rd_pipe_valid <= rd_pipe_valid(2 downto 0) & '0';
			end if;
		end if;
	end process read_valid;
	
	read_data:process(clk)
	begin
		if rising_edge(clk) then
			rd_data <= sdram_dq;
		end if;
	end process read_data;

	adr <= rd_adr when (rd_cycle = '1') else wr_adr;	--address select
	
	same_row_and_bank <= '1' when (adr(21 downto 8) = adr_reg(21 downto 8)) else '0';
	rd_cycle <= rd_now when (state = "00") else rd_selected;
	wr_selected <= not rd_selected;
	rd_valid <= rd_pipe_valid(3);
	
	--command set
	sdram_ras_n <= sdram_cmd(2);
	sdram_cas_n <= sdram_cmd(1);
	sdram_wren_n <= sdram_cmd(0);
	
	--write
	sdram_dq <= wr_data2 when sdram_dq_oe = '1' else (others => 'Z');
	
	--sdram_clock
	sdram_clk_n <= not clk;

end rtl;