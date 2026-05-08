/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once

/*
 * based on:
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
 * Legacy extension
 */
#define SBI_EID_LEGACY							0
#define SBI_FID_sbi_set_timer					0
#define SBI_FID_sbi_console_putchar				1
#define SBI_FID_sbi_console_getchar				2
#define SBI_FID_sbi_clear_ipi					3
#define SBI_FID_sbi_send_ipi					4
#define SBI_FID_sbi_remote_fence_i				5
#define SBI_FID_sbi_remote_sfence_vma			6
#define SBI_FID_sbi_remote_sfence_vma_asid		7
#define SBI_FID_sbi_shutdown					8


/*
 * Base extension
 */
#define SBI_EID_BASE					0x10
#define SBI_FID_sbi_get_spec_version	0
#define SBI_FID_sbi_get_impl_id			1
#define SBI_FID_sbi_get_impl_version	2
#define SBI_FID_sbi_probe_extension		3
#define SBI_FID_sbi_get_mvendorid		4
#define SBI_FID_sbi_get_marchid			5
#define SBI_FID_sbi_get_mimpid			6

#define SBI_EID_TIME	0x54494D45


#define SBI_EID_IPI		0x735049

#define SBI_EID_RFENCE	0x52464E43

#define SBI_EID_HSM		0x48534D

#define SBI_EID_SRST	0x53525354

#define SBI_EID_SUSP	0x53555350

#define SBI_EID_PMU		0x504D55

/*
 * Debug console extension
 */
#define SBI_EID_DBCN							0x4442434E
#define SBI_FID_sbi_debug_console_write			0
#define SBI_FID_sbi_debug_console_read			1
#define SBI_FID_sbi_debug_console_write_byte	2

#define SBI_EID_STA		0x535441

#define SBI_EID_NACL	0x4E41434C

#define SBI_EID_FWFT	0x46574654

#define SBI_EID_MPXY	0x4D505859

#define SBI_EID_DBTR	0x44425452


#ifndef __ASSEMBLER__
	# include "libsbi/types.h"

	struct sbiret {
		u64 error;			// a0
		u64 val;			// a1
	};

	struct sbiret sbi_call(u64 arg0, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5, u64 fid, u64 eid);

	struct sbiret sbi_set_timer(u64 stime_value);
	struct sbiret sbi_console_putchar(char c);
	struct sbiret sbi_console_getchar(void);
	struct sbiret sbi_clear_ipi(void);
	struct sbiret sbi_send_ipi(u64 hart_mask);
	struct sbiret sbi_remote_fence_i(u64 hart_mask);
	struct sbiret sbi_remote_sfence_vma(u64 hart_mask, u64 start, u64 size);
	struct sbiret sbi_remote_sfence_vma_asid(u64 hart_mask, u64 start, u64 size, u64 asid);

	struct sbiret sbi_get_spec_version(void);
	struct sbiret sbi_get_impl_id(void);
	struct sbiret sbi_get_impl_version(void);
	struct sbiret sbi_probe_extension(u64 extension_id);
	struct sbiret sbi_get_mvendorid(void);
	struct sbiret sbi_get_marchid(void);
	struct sbiret sbi_get_mimpid(void);

	struct sbiret sbi_debug_console_write(char c);
	struct sbiret sbi_debug_console_read(char c);
	struct sbiret sbi_debug_console_write_byte(char c);
#endif
