/*
 * libsbicall - RISC-V SBI wrapper
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
 * BASE extension
 */
#define SBI_EID_BASE					0x10
#define SBI_FID_sbi_get_spec_version	0
#define SBI_FID_sbi_get_impl_id			1
#define SBI_FID_sbi_get_impl_version	2
#define SBI_FID_sbi_probe_extension		3
#define SBI_FID_sbi_get_mvendorid		4
#define SBI_FID_sbi_get_marchid			5
#define SBI_FID_sbi_get_mimpid			6

/*
 * LEGACY extensions
 */
#define SBI_EID_LEGACY								0
#define SBI_FID_legacy_sbi_set_timer				0
#define SBI_FID_legacy_sbi_console_putchar			1
#define SBI_FID_legacy_sbi_console_getchar			2
#define SBI_FID_legacy_sbi_clear_ipi				3
#define SBI_FID_legacy_sbi_send_ipi					4
#define SBI_FID_legacy_sbi_remote_fence_i			5
#define SBI_FID_legacy_sbi_remote_sfence_vma		6
#define SBI_FID_legacy_sbi_remote_sfence_vma_asid	7
#define SBI_FID_legacy_sbi_shutdown					8

/*
 * TIME extension
 */
#define SBI_EID_TIME				0x54494D45
#define SBI_FID_sbi_set_timer		0

/*
 * IPI extension
 */
#define SBI_EID_IPI					0x735049
#define SBI_FID_sbi_send_ipi		0

/*
 * RFENCE extension
 */
#define SBI_EID_RFENCE							0x52464E43
#define SBI_FID_sbi_remote_fence_i				0
#define SBI_FID_sbi_remote_sfence_vma			1
#define SBI_FID_sbi_remote_sfence_vma_asid		2
#define SBI_FID_sbi_remote_hfence_gvma_vmid		3
#define SBI_FID_sbi_remote_hfence_gvma			4
#define SBI_FID_sbi_remote_hfence_vvma_asid		5
#define SBI_FID_sbi_remote_hfence_vvma			6


/*
 * HSM extension
 */
#define SBI_EID_HSM						0x48534D
#define SBI_FID_sbi_hart_start			0
#define SBI_FID_sbi_hart_stop			1
#define SBI_FID_sbi_hart_get_status		2
#define SBI_FID_sbi_hart_suspend		3

#define SBI_HSM_STATE_STARTED			0
#define SBI_HSM_STOPPED					1
#define SBI_HSM_START_PENDING			2
#define SBI_HSM_STOP_PENDING			3
#define SBI_HSM_SUSPENDED				4
#define SBI_HSM_SUSPEND_PENDING			5
#define SBI_HSM_RESUME_PENDING			6

/*
 * SRST extension
 */
#define SBI_EID_SRST					0x53525354
#define SBI_FID_sbi_system_reset		0

#define SBI_SRST_TYPE_SHUTDOWN			0x00000000
#define SBI_SRST_TYPE_COLD_REBOOT		0x00000001
#define SBI_SRST_TYPE_WARM_REBOOT		0x00000002

#define SBI_SRST_REASON_NONE			0x00000000
#define SBI_SRST_REASON_SYSTEM_FAILURE	0x00000001

/*
 * SUSP extension
 */
#define SBI_EID_SUSP	0x53555350

/*
 * PMU extension
 */
#define SBI_EID_PMU		0x504D55

#define SBI_PMU_EVT_HW_GENERAL		0
#define SBI_PMU_EVT_HW_CACHE		1
#define SBI_PMU_EVT_HW_RAW_V1		2
#define SBI_PMU_EVT_HW_RAW_V2		3
#define SBI_PMU_EVT_FIRMWARE		4

#define SBI_PMU_HW_NO_EVENT					0
#define SBI_PMU_HW_CPU_CYCLES				1
#define SBI_PMU_HW_INSTRUCTIONS				2
#define SBI_PMU_HW_CACHE_REFERENCES			3
#define SBI_PMU_HW_CACHE_MISSES				4
#define SBI_PMU_HW_BRANCH_INSTRUCTIONS		5
#define SBI_PMU_HW_BRANCH_MISSES			6
#define SBI_PMU_HW_BUS_CYCLES				7
#define SBI_PMU_HW_STALLED_CYCLES_FRONTEND	8
#define SBI_PMU_HW_STALLED_CYCLES_BACKEND	9
#define SBI_PMU_HW_REF_CPU_CYCLES			10




/*
 * DBCN extension
 */
#define SBI_EID_DBCN							0x4442434E
#define SBI_FID_sbi_debug_console_write			0
#define SBI_FID_sbi_debug_console_read			1
#define SBI_FID_sbi_debug_console_write_byte	2

/*
 * STA extension
 */
#define SBI_EID_STA		0x535441

/*
 * NACL extension
 */
#define SBI_EID_NACL	0x4E41434C

/*
 * FWFT extension
 */
#define SBI_EID_FWFT	0x46574654

/*
 * MPXY extension
 */
#define SBI_EID_MPXY	0x4D505859

/*
 * DBTR extension
 */
#define SBI_EID_DBTR	0x44425452


#ifndef __ASSEMBLER__

    struct sbiret {
          long error;
          union {
              long value;
              unsigned long uvalue;
          };
	};

	long sbicall_legacy(unsigned long arg0, unsigned long arg1,
		  unsigned long arg2, unsigned long arg3,
		  unsigned long arg4, unsigned long arg5,
		  long fid, long eid);

	struct sbiret sbicall(unsigned long arg0, unsigned long arg1,
		  unsigned long arg2, unsigned long arg3,
		  unsigned long arg4, unsigned long arg5,
		  long fid, long eid);

		  // LEGACY extension
	long legacy_sbi_set_timer(unsigned long stime_value);
	long legacy_sbi_console_putchar(char c);
	long legacy_sbi_console_getchar(void);
	long legacy_sbi_clear_ipi(void);
	long legacy_sbi_send_ipi(const unsigned long *hart_mask);
	long legacy_sbi_remote_fence_i(const unsigned long *hart_mask);
	long legacy_sbi_remote_sfence_vma(const unsigned long *hart_mask,
			unsigned long start, unsigned long size);
	long legacy_sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
			unsigned long start, unsigned long size, unsigned long asid);

	// BASE extension
	struct sbiret sbi_get_spec_version(void);
	struct sbiret sbi_get_impl_id(void);
	struct sbiret sbi_get_impl_version(void);
	struct sbiret sbi_probe_extension(long extension_id);
	struct sbiret sbi_get_mvendorid(void);
	struct sbiret sbi_get_marchid(void);
	struct sbiret sbi_get_mimpid(void);

	// IPI


	// DBCN extension
	struct sbiret sbi_debug_console_write(char c);
	struct sbiret sbi_debug_console_read(char c);
	struct sbiret sbi_debug_console_write_byte(char c);
#endif
