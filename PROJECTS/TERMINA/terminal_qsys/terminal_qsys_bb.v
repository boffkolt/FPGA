
module terminal_qsys (
	base_addr_ddr_out_export,
	clk_clk,
	control_out_export,
	hps_f2h_sdram0_data_address,
	hps_f2h_sdram0_data_burstcount,
	hps_f2h_sdram0_data_waitrequest,
	hps_f2h_sdram0_data_readdata,
	hps_f2h_sdram0_data_readdatavalid,
	hps_f2h_sdram0_data_read,
	hps_f2h_sdram0_data_writedata,
	hps_f2h_sdram0_data_byteenable,
	hps_f2h_sdram0_data_write,
	hps_f2h_stm_hw_events_stm_hwevents,
	hps_h2f_cold_reset_reset_n,
	hps_h2f_warm_reset_handshake_h2f_pending_rst_req_n,
	hps_h2f_warm_reset_handshake_f2h_pending_rst_ack_n,
	hps_hps_io_hps_io_emac1_inst_TX_CLK,
	hps_hps_io_hps_io_emac1_inst_TXD0,
	hps_hps_io_hps_io_emac1_inst_TXD1,
	hps_hps_io_hps_io_emac1_inst_TXD2,
	hps_hps_io_hps_io_emac1_inst_TXD3,
	hps_hps_io_hps_io_emac1_inst_RXD0,
	hps_hps_io_hps_io_emac1_inst_MDIO,
	hps_hps_io_hps_io_emac1_inst_MDC,
	hps_hps_io_hps_io_emac1_inst_RX_CTL,
	hps_hps_io_hps_io_emac1_inst_TX_CTL,
	hps_hps_io_hps_io_emac1_inst_RX_CLK,
	hps_hps_io_hps_io_emac1_inst_RXD1,
	hps_hps_io_hps_io_emac1_inst_RXD2,
	hps_hps_io_hps_io_emac1_inst_RXD3,
	hps_hps_io_hps_io_sdio_inst_CMD,
	hps_hps_io_hps_io_sdio_inst_D0,
	hps_hps_io_hps_io_sdio_inst_D1,
	hps_hps_io_hps_io_sdio_inst_CLK,
	hps_hps_io_hps_io_sdio_inst_D2,
	hps_hps_io_hps_io_sdio_inst_D3,
	hps_hps_io_hps_io_uart0_inst_RX,
	hps_hps_io_hps_io_uart0_inst_TX,
	leds_out_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	reset_reset_n,
	state_in_export,
	switches_in_export);	

	output	[31:0]	base_addr_ddr_out_export;
	input		clk_clk;
	output	[31:0]	control_out_export;
	input	[26:0]	hps_f2h_sdram0_data_address;
	input	[7:0]	hps_f2h_sdram0_data_burstcount;
	output		hps_f2h_sdram0_data_waitrequest;
	output	[255:0]	hps_f2h_sdram0_data_readdata;
	output		hps_f2h_sdram0_data_readdatavalid;
	input		hps_f2h_sdram0_data_read;
	input	[255:0]	hps_f2h_sdram0_data_writedata;
	input	[31:0]	hps_f2h_sdram0_data_byteenable;
	input		hps_f2h_sdram0_data_write;
	input	[27:0]	hps_f2h_stm_hw_events_stm_hwevents;
	output		hps_h2f_cold_reset_reset_n;
	output		hps_h2f_warm_reset_handshake_h2f_pending_rst_req_n;
	input		hps_h2f_warm_reset_handshake_f2h_pending_rst_ack_n;
	output		hps_hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_hps_io_hps_io_emac1_inst_TXD0;
	output		hps_hps_io_hps_io_emac1_inst_TXD1;
	output		hps_hps_io_hps_io_emac1_inst_TXD2;
	output		hps_hps_io_hps_io_emac1_inst_TXD3;
	input		hps_hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_hps_io_hps_io_emac1_inst_MDIO;
	output		hps_hps_io_hps_io_emac1_inst_MDC;
	input		hps_hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_hps_io_hps_io_emac1_inst_RXD1;
	input		hps_hps_io_hps_io_emac1_inst_RXD2;
	input		hps_hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_hps_io_hps_io_sdio_inst_CMD;
	inout		hps_hps_io_hps_io_sdio_inst_D0;
	inout		hps_hps_io_hps_io_sdio_inst_D1;
	output		hps_hps_io_hps_io_sdio_inst_CLK;
	inout		hps_hps_io_hps_io_sdio_inst_D2;
	inout		hps_hps_io_hps_io_sdio_inst_D3;
	input		hps_hps_io_hps_io_uart0_inst_RX;
	output		hps_hps_io_hps_io_uart0_inst_TX;
	output	[9:0]	leds_out_export;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input		reset_reset_n;
	input	[31:0]	state_in_export;
	input	[9:0]	switches_in_export;
endmodule
