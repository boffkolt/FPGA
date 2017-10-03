#ifndef _ALTERA_HPS_H_
#define _ALTERA_HPS_H_

/*
 * This file was automatically generated by the swinfo2header utility.
 * 
 * Created from SOPC Builder system 'terminal_qsys' in
 * file 'D:\TERMINA\terminal_qsys.swinfo'.
 */

/*
 * This file contains macros for module 'hps' and devices
 * connected to the following masters:
 *   h2f_axi_master
 *   h2f_lw_axi_master
 * 
 * Do not include this header file and another header file created for a
 * different module or master group at the same time.
 * Doing so may result in duplicate macro names.
 * Instead, use the system header file which has macros with unique names.
 */

/*
 * Macros for device 'onchip_memory2_0', class 'altera_avalon_onchip_memory2'
 * The macros are prefixed with 'ONCHIP_MEMORY2_0_'.
 * The prefix is the slave descriptor.
 */
#define ONCHIP_MEMORY2_0_COMPONENT_TYPE altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_COMPONENT_NAME onchip_memory2_0
#define ONCHIP_MEMORY2_0_BASE 0x0
#define ONCHIP_MEMORY2_0_SPAN 65535
#define ONCHIP_MEMORY2_0_END 0xfffe
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE AUTO
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE terminal_qsys_onchip_memory2_0
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID NONE
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE AUTO
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE DONT_CARE
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 65535
#define ONCHIP_MEMORY2_0_WRITABLE 1
#define ONCHIP_MEMORY2_0_MEMORY_INFO_DAT_SYM_INSTALL_DIR SIM_DIR
#define ONCHIP_MEMORY2_0_MEMORY_INFO_GENERATE_DAT_SYM 1
#define ONCHIP_MEMORY2_0_MEMORY_INFO_GENERATE_HEX 1
#define ONCHIP_MEMORY2_0_MEMORY_INFO_HAS_BYTE_LANE 0
#define ONCHIP_MEMORY2_0_MEMORY_INFO_HEX_INSTALL_DIR QPF_DIR
#define ONCHIP_MEMORY2_0_MEMORY_INFO_MEM_INIT_DATA_WIDTH 64
#define ONCHIP_MEMORY2_0_MEMORY_INFO_MEM_INIT_FILENAME terminal_qsys_onchip_memory2_0

/*
 * Macros for device 'switches', class 'altera_avalon_pio'
 * The macros are prefixed with 'SWITCHES_'.
 * The prefix is the slave descriptor.
 */
#define SWITCHES_COMPONENT_TYPE altera_avalon_pio
#define SWITCHES_COMPONENT_NAME switches
#define SWITCHES_BASE 0x0
#define SWITCHES_SPAN 16
#define SWITCHES_END 0xf
#define SWITCHES_BIT_CLEARING_EDGE_REGISTER 0
#define SWITCHES_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SWITCHES_CAPTURE 0
#define SWITCHES_DATA_WIDTH 10
#define SWITCHES_DO_TEST_BENCH_WIRING 1
#define SWITCHES_DRIVEN_SIM_VALUE 0
#define SWITCHES_EDGE_TYPE NONE
#define SWITCHES_FREQ 50000000
#define SWITCHES_HAS_IN 1
#define SWITCHES_HAS_OUT 0
#define SWITCHES_HAS_TRI 0
#define SWITCHES_IRQ_TYPE NONE
#define SWITCHES_RESET_VALUE 0

/*
 * Macros for device 'leds', class 'altera_avalon_pio'
 * The macros are prefixed with 'LEDS_'.
 * The prefix is the slave descriptor.
 */
#define LEDS_COMPONENT_TYPE altera_avalon_pio
#define LEDS_COMPONENT_NAME leds
#define LEDS_BASE 0x10
#define LEDS_SPAN 16
#define LEDS_END 0x1f
#define LEDS_BIT_CLEARING_EDGE_REGISTER 0
#define LEDS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LEDS_CAPTURE 0
#define LEDS_DATA_WIDTH 10
#define LEDS_DO_TEST_BENCH_WIRING 0
#define LEDS_DRIVEN_SIM_VALUE 0
#define LEDS_EDGE_TYPE NONE
#define LEDS_FREQ 50000000
#define LEDS_HAS_IN 0
#define LEDS_HAS_OUT 1
#define LEDS_HAS_TRI 0
#define LEDS_IRQ_TYPE NONE
#define LEDS_RESET_VALUE 0

/*
 * Macros for device 'base_address_ddr', class 'altera_avalon_pio'
 * The macros are prefixed with 'BASE_ADDRESS_DDR_'.
 * The prefix is the slave descriptor.
 */
#define BASE_ADDRESS_DDR_COMPONENT_TYPE altera_avalon_pio
#define BASE_ADDRESS_DDR_COMPONENT_NAME base_address_ddr
#define BASE_ADDRESS_DDR_BASE 0x20
#define BASE_ADDRESS_DDR_SPAN 16
#define BASE_ADDRESS_DDR_END 0x2f
#define BASE_ADDRESS_DDR_BIT_CLEARING_EDGE_REGISTER 0
#define BASE_ADDRESS_DDR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BASE_ADDRESS_DDR_CAPTURE 0
#define BASE_ADDRESS_DDR_DATA_WIDTH 32
#define BASE_ADDRESS_DDR_DO_TEST_BENCH_WIRING 0
#define BASE_ADDRESS_DDR_DRIVEN_SIM_VALUE 0
#define BASE_ADDRESS_DDR_EDGE_TYPE NONE
#define BASE_ADDRESS_DDR_FREQ 50000000
#define BASE_ADDRESS_DDR_HAS_IN 0
#define BASE_ADDRESS_DDR_HAS_OUT 1
#define BASE_ADDRESS_DDR_HAS_TRI 0
#define BASE_ADDRESS_DDR_IRQ_TYPE NONE
#define BASE_ADDRESS_DDR_RESET_VALUE 0

/*
 * Macros for device 'control', class 'altera_avalon_pio'
 * The macros are prefixed with 'CONTROL_'.
 * The prefix is the slave descriptor.
 */
#define CONTROL_COMPONENT_TYPE altera_avalon_pio
#define CONTROL_COMPONENT_NAME control
#define CONTROL_BASE 0x30
#define CONTROL_SPAN 16
#define CONTROL_END 0x3f
#define CONTROL_BIT_CLEARING_EDGE_REGISTER 0
#define CONTROL_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CONTROL_CAPTURE 0
#define CONTROL_DATA_WIDTH 32
#define CONTROL_DO_TEST_BENCH_WIRING 0
#define CONTROL_DRIVEN_SIM_VALUE 0
#define CONTROL_EDGE_TYPE NONE
#define CONTROL_FREQ 50000000
#define CONTROL_HAS_IN 0
#define CONTROL_HAS_OUT 1
#define CONTROL_HAS_TRI 0
#define CONTROL_IRQ_TYPE NONE
#define CONTROL_RESET_VALUE 0

/*
 * Macros for device 'state', class 'altera_avalon_pio'
 * The macros are prefixed with 'STATE_'.
 * The prefix is the slave descriptor.
 */
#define STATE_COMPONENT_TYPE altera_avalon_pio
#define STATE_COMPONENT_NAME state
#define STATE_BASE 0x40
#define STATE_SPAN 16
#define STATE_END 0x4f
#define STATE_BIT_CLEARING_EDGE_REGISTER 0
#define STATE_BIT_MODIFYING_OUTPUT_REGISTER 0
#define STATE_CAPTURE 0
#define STATE_DATA_WIDTH 32
#define STATE_DO_TEST_BENCH_WIRING 1
#define STATE_DRIVEN_SIM_VALUE 0
#define STATE_EDGE_TYPE NONE
#define STATE_FREQ 50000000
#define STATE_HAS_IN 1
#define STATE_HAS_OUT 0
#define STATE_HAS_TRI 0
#define STATE_IRQ_TYPE NONE
#define STATE_RESET_VALUE 0

/*
 * Macros for device 'rbf_id', class 'altera_avalon_sysid_qsys'
 * The macros are prefixed with 'RBF_ID_'.
 * The prefix is the slave descriptor.
 */
#define RBF_ID_COMPONENT_TYPE altera_avalon_sysid_qsys
#define RBF_ID_COMPONENT_NAME rbf_id
#define RBF_ID_BASE 0x10000
#define RBF_ID_SPAN 8
#define RBF_ID_END 0x10007
#define RBF_ID_ID 1152
#define RBF_ID_TIMESTAMP 1495466291


#endif /* _ALTERA_HPS_H_ */
