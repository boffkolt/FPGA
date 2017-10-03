// unnamed.v

// Generated using ACDS version 16.1 203

`timescale 1 ps / 1 ps
module unnamed (
		input  wire        clock,                   //    clk.clk
		input  wire        avmm_csr_addr,           //    csr.address
		input  wire        avmm_csr_read,           //       .read
		input  wire [31:0] avmm_csr_writedata,      //       .writedata
		input  wire        avmm_csr_write,          //       .write
		output wire [31:0] avmm_csr_readdata,       //       .readdata
		input  wire [14:0] avmm_data_addr,          //   data.address
		input  wire        avmm_data_read,          //       .read
		input  wire [31:0] avmm_data_writedata,     //       .writedata
		input  wire        avmm_data_write,         //       .write
		output wire [31:0] avmm_data_readdata,      //       .readdata
		output wire        avmm_data_waitrequest,   //       .waitrequest
		output wire        avmm_data_readdatavalid, //       .readdatavalid
		input  wire [3:0]  avmm_data_burstcount,    //       .burstcount
		input  wire        reset_n                  // nreset.reset_n
	);

	altera_onchip_flash #(
		.INIT_FILENAME                       (""),
		.INIT_FILENAME_SIM                   (""),
		.DEVICE_FAMILY                       ("MAX 10"),
		.PART_NAME                           ("10M08SAE144C8G"),
		.DEVICE_ID                           ("08"),
		.SECTOR1_START_ADDR                  (0),
		.SECTOR1_END_ADDR                    (4095),
		.SECTOR2_START_ADDR                  (4096),
		.SECTOR2_END_ADDR                    (8191),
		.SECTOR3_START_ADDR                  (8192),
		.SECTOR3_END_ADDR                    (29183),
		.SECTOR4_START_ADDR                  (0),
		.SECTOR4_END_ADDR                    (0),
		.SECTOR5_START_ADDR                  (0),
		.SECTOR5_END_ADDR                    (0),
		.MIN_VALID_ADDR                      (0),
		.MAX_VALID_ADDR                      (29183),
		.MIN_UFM_VALID_ADDR                  (0),
		.MAX_UFM_VALID_ADDR                  (29183),
		.SECTOR1_MAP                         (1),
		.SECTOR2_MAP                         (2),
		.SECTOR3_MAP                         (3),
		.SECTOR4_MAP                         (0),
		.SECTOR5_MAP                         (0),
		.ADDR_RANGE1_END_ADDR                (29183),
		.ADDR_RANGE1_OFFSET                  (512),
		.ADDR_RANGE2_OFFSET                  (0),
		.AVMM_DATA_ADDR_WIDTH                (15),
		.AVMM_DATA_DATA_WIDTH                (32),
		.AVMM_DATA_BURSTCOUNT_WIDTH          (4),
		.SECTOR_READ_PROTECTION_MODE         (28),
		.FLASH_SEQ_READ_DATA_COUNT           (2),
		.FLASH_ADDR_ALIGNMENT_BITS           (1),
		.FLASH_READ_CYCLE_MAX_INDEX          (4),
		.FLASH_RESET_CYCLE_MAX_INDEX         (29),
		.FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX  (139),
		.FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX (40600000),
		.FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX (35380),
		.PARALLEL_MODE                       (1),
		.READ_AND_WRITE_MODE                 (1),
		.WRAPPING_BURST_MODE                 (0),
		.IS_DUAL_BOOT                        ("False"),
		.IS_ERAM_SKIP                        ("True"),
		.IS_COMPRESSED_IMAGE                 ("False")
	) onchip_flash_0 (
		.clock                   (clock),                   //    clk.clk
		.reset_n                 (reset_n),                 // nreset.reset_n
		.avmm_data_addr          (avmm_data_addr),          //   data.address
		.avmm_data_read          (avmm_data_read),          //       .read
		.avmm_data_writedata     (avmm_data_writedata),     //       .writedata
		.avmm_data_write         (avmm_data_write),         //       .write
		.avmm_data_readdata      (avmm_data_readdata),      //       .readdata
		.avmm_data_waitrequest   (avmm_data_waitrequest),   //       .waitrequest
		.avmm_data_readdatavalid (avmm_data_readdatavalid), //       .readdatavalid
		.avmm_data_burstcount    (avmm_data_burstcount),    //       .burstcount
		.avmm_csr_addr           (avmm_csr_addr),           //    csr.address
		.avmm_csr_read           (avmm_csr_read),           //       .read
		.avmm_csr_writedata      (avmm_csr_writedata),      //       .writedata
		.avmm_csr_write          (avmm_csr_write),          //       .write
		.avmm_csr_readdata       (avmm_csr_readdata)        //       .readdata
	);

endmodule
