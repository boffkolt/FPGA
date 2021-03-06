	terminal_qsys u0 (
		.base_addr_ddr_out_export                           (<connected-to-base_addr_ddr_out_export>),                           //            base_addr_ddr_out.export
		.clk_clk                                            (<connected-to-clk_clk>),                                            //                          clk.clk
		.control_out_export                                 (<connected-to-control_out_export>),                                 //                  control_out.export
		.hps_f2h_sdram0_data_address                        (<connected-to-hps_f2h_sdram0_data_address>),                        //          hps_f2h_sdram0_data.address
		.hps_f2h_sdram0_data_burstcount                     (<connected-to-hps_f2h_sdram0_data_burstcount>),                     //                             .burstcount
		.hps_f2h_sdram0_data_waitrequest                    (<connected-to-hps_f2h_sdram0_data_waitrequest>),                    //                             .waitrequest
		.hps_f2h_sdram0_data_readdata                       (<connected-to-hps_f2h_sdram0_data_readdata>),                       //                             .readdata
		.hps_f2h_sdram0_data_readdatavalid                  (<connected-to-hps_f2h_sdram0_data_readdatavalid>),                  //                             .readdatavalid
		.hps_f2h_sdram0_data_read                           (<connected-to-hps_f2h_sdram0_data_read>),                           //                             .read
		.hps_f2h_sdram0_data_writedata                      (<connected-to-hps_f2h_sdram0_data_writedata>),                      //                             .writedata
		.hps_f2h_sdram0_data_byteenable                     (<connected-to-hps_f2h_sdram0_data_byteenable>),                     //                             .byteenable
		.hps_f2h_sdram0_data_write                          (<connected-to-hps_f2h_sdram0_data_write>),                          //                             .write
		.hps_f2h_stm_hw_events_stm_hwevents                 (<connected-to-hps_f2h_stm_hw_events_stm_hwevents>),                 //        hps_f2h_stm_hw_events.stm_hwevents
		.hps_h2f_cold_reset_reset_n                         (<connected-to-hps_h2f_cold_reset_reset_n>),                         //           hps_h2f_cold_reset.reset_n
		.hps_h2f_warm_reset_handshake_h2f_pending_rst_req_n (<connected-to-hps_h2f_warm_reset_handshake_h2f_pending_rst_req_n>), // hps_h2f_warm_reset_handshake.h2f_pending_rst_req_n
		.hps_h2f_warm_reset_handshake_f2h_pending_rst_ack_n (<connected-to-hps_h2f_warm_reset_handshake_f2h_pending_rst_ack_n>), //                             .f2h_pending_rst_ack_n
		.hps_hps_io_hps_io_emac1_inst_TX_CLK                (<connected-to-hps_hps_io_hps_io_emac1_inst_TX_CLK>),                //                   hps_hps_io.hps_io_emac1_inst_TX_CLK
		.hps_hps_io_hps_io_emac1_inst_TXD0                  (<connected-to-hps_hps_io_hps_io_emac1_inst_TXD0>),                  //                             .hps_io_emac1_inst_TXD0
		.hps_hps_io_hps_io_emac1_inst_TXD1                  (<connected-to-hps_hps_io_hps_io_emac1_inst_TXD1>),                  //                             .hps_io_emac1_inst_TXD1
		.hps_hps_io_hps_io_emac1_inst_TXD2                  (<connected-to-hps_hps_io_hps_io_emac1_inst_TXD2>),                  //                             .hps_io_emac1_inst_TXD2
		.hps_hps_io_hps_io_emac1_inst_TXD3                  (<connected-to-hps_hps_io_hps_io_emac1_inst_TXD3>),                  //                             .hps_io_emac1_inst_TXD3
		.hps_hps_io_hps_io_emac1_inst_RXD0                  (<connected-to-hps_hps_io_hps_io_emac1_inst_RXD0>),                  //                             .hps_io_emac1_inst_RXD0
		.hps_hps_io_hps_io_emac1_inst_MDIO                  (<connected-to-hps_hps_io_hps_io_emac1_inst_MDIO>),                  //                             .hps_io_emac1_inst_MDIO
		.hps_hps_io_hps_io_emac1_inst_MDC                   (<connected-to-hps_hps_io_hps_io_emac1_inst_MDC>),                   //                             .hps_io_emac1_inst_MDC
		.hps_hps_io_hps_io_emac1_inst_RX_CTL                (<connected-to-hps_hps_io_hps_io_emac1_inst_RX_CTL>),                //                             .hps_io_emac1_inst_RX_CTL
		.hps_hps_io_hps_io_emac1_inst_TX_CTL                (<connected-to-hps_hps_io_hps_io_emac1_inst_TX_CTL>),                //                             .hps_io_emac1_inst_TX_CTL
		.hps_hps_io_hps_io_emac1_inst_RX_CLK                (<connected-to-hps_hps_io_hps_io_emac1_inst_RX_CLK>),                //                             .hps_io_emac1_inst_RX_CLK
		.hps_hps_io_hps_io_emac1_inst_RXD1                  (<connected-to-hps_hps_io_hps_io_emac1_inst_RXD1>),                  //                             .hps_io_emac1_inst_RXD1
		.hps_hps_io_hps_io_emac1_inst_RXD2                  (<connected-to-hps_hps_io_hps_io_emac1_inst_RXD2>),                  //                             .hps_io_emac1_inst_RXD2
		.hps_hps_io_hps_io_emac1_inst_RXD3                  (<connected-to-hps_hps_io_hps_io_emac1_inst_RXD3>),                  //                             .hps_io_emac1_inst_RXD3
		.hps_hps_io_hps_io_sdio_inst_CMD                    (<connected-to-hps_hps_io_hps_io_sdio_inst_CMD>),                    //                             .hps_io_sdio_inst_CMD
		.hps_hps_io_hps_io_sdio_inst_D0                     (<connected-to-hps_hps_io_hps_io_sdio_inst_D0>),                     //                             .hps_io_sdio_inst_D0
		.hps_hps_io_hps_io_sdio_inst_D1                     (<connected-to-hps_hps_io_hps_io_sdio_inst_D1>),                     //                             .hps_io_sdio_inst_D1
		.hps_hps_io_hps_io_sdio_inst_CLK                    (<connected-to-hps_hps_io_hps_io_sdio_inst_CLK>),                    //                             .hps_io_sdio_inst_CLK
		.hps_hps_io_hps_io_sdio_inst_D2                     (<connected-to-hps_hps_io_hps_io_sdio_inst_D2>),                     //                             .hps_io_sdio_inst_D2
		.hps_hps_io_hps_io_sdio_inst_D3                     (<connected-to-hps_hps_io_hps_io_sdio_inst_D3>),                     //                             .hps_io_sdio_inst_D3
		.hps_hps_io_hps_io_uart0_inst_RX                    (<connected-to-hps_hps_io_hps_io_uart0_inst_RX>),                    //                             .hps_io_uart0_inst_RX
		.hps_hps_io_hps_io_uart0_inst_TX                    (<connected-to-hps_hps_io_hps_io_uart0_inst_TX>),                    //                             .hps_io_uart0_inst_TX
		.leds_out_export                                    (<connected-to-leds_out_export>),                                    //                     leds_out.export
		.memory_mem_a                                       (<connected-to-memory_mem_a>),                                       //                       memory.mem_a
		.memory_mem_ba                                      (<connected-to-memory_mem_ba>),                                      //                             .mem_ba
		.memory_mem_ck                                      (<connected-to-memory_mem_ck>),                                      //                             .mem_ck
		.memory_mem_ck_n                                    (<connected-to-memory_mem_ck_n>),                                    //                             .mem_ck_n
		.memory_mem_cke                                     (<connected-to-memory_mem_cke>),                                     //                             .mem_cke
		.memory_mem_cs_n                                    (<connected-to-memory_mem_cs_n>),                                    //                             .mem_cs_n
		.memory_mem_ras_n                                   (<connected-to-memory_mem_ras_n>),                                   //                             .mem_ras_n
		.memory_mem_cas_n                                   (<connected-to-memory_mem_cas_n>),                                   //                             .mem_cas_n
		.memory_mem_we_n                                    (<connected-to-memory_mem_we_n>),                                    //                             .mem_we_n
		.memory_mem_reset_n                                 (<connected-to-memory_mem_reset_n>),                                 //                             .mem_reset_n
		.memory_mem_dq                                      (<connected-to-memory_mem_dq>),                                      //                             .mem_dq
		.memory_mem_dqs                                     (<connected-to-memory_mem_dqs>),                                     //                             .mem_dqs
		.memory_mem_dqs_n                                   (<connected-to-memory_mem_dqs_n>),                                   //                             .mem_dqs_n
		.memory_mem_odt                                     (<connected-to-memory_mem_odt>),                                     //                             .mem_odt
		.memory_mem_dm                                      (<connected-to-memory_mem_dm>),                                      //                             .mem_dm
		.memory_oct_rzqin                                   (<connected-to-memory_oct_rzqin>),                                   //                             .oct_rzqin
		.reset_reset_n                                      (<connected-to-reset_reset_n>),                                      //                        reset.reset_n
		.state_in_export                                    (<connected-to-state_in_export>),                                    //                     state_in.export
		.switches_in_export                                 (<connected-to-switches_in_export>)                                  //                  switches_in.export
	);

