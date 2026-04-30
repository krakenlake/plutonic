/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef PLUTONIC_SBI_H
#define PLUTONIC_SBI_H

/*
 * RISC-V Supervisor Binary Interface Specification
 * Version v3.0, 2025-07-16: Ratified
 */

#define SBI_SUCCESS					0
#define SBI_ERR_FAILED				-1
#define SBI_ERR_NOT_SUPPORTED		-2
#define SBI_ERR_INVALID_PARAM		-3
#define SBI_ERR_DENIED				-4
#define SBI_ERR_INVALID_ADDRESS		-5
#define SBI_ERR_ALREADY_AVAILABLE	-6
#define SBI_ERR_ALREADY_STARTED		-7
#define SBI_ERR_ALREADY_STOPPED		-8
#define SBI_ERR_NO_SHMEM			-9
#define SBI_ERR_INVALID_STATE		-10
#define SBI_ERR_BAD_RANGE			-11
#define SBI_ERR_TIMEOUT				-12
#define SBI_ERR_IO					-13
#define SBI_ERR_DENIED_LOCKED		-14


/*
 * Base extension
 */
#define SBI_LEGACY					0
#define EID_sbi_console_putchar		1

 #define SBI_EXT_BASE				0x10
#define sbi_get_spec_version		0
#define sbi_get_impl_id				1
#define sbi_get_impl_version		2
#define sbi_probe_extension			3
#define sbi_get_mvendorid			4
#define sbi_get_marchid				5
#define sbi_get_mimpid				6

#define SBI_EXT_TIME	0x54494D45

#define SBI_EXT_IPI		0x735049

#define SBI_EXT_RFENCE	0x52464E43

#define SBI_EXT_HSM		0x48534D

#define SBI_EXT_SRST	0x53525354

#define SBI_EXT_SUSP	0x53555350

#define SBI_EXT_PMU		0x504D55

#define SBI_EXT_DBCN						0x4442434E
#define sbi_debug_console_write_byte	2

#define SBI_EXT_STA		0x535441

#define SBI_EXT_NACL	0x4E41434C

#define SBI_EXT_FWFT	0x46574654

#define SBI_EXT_MPXY	0x4D505859

#define SBI_EXT_DBTR	0x44425452



#endif /* PLUTONIC_SBI_H */
