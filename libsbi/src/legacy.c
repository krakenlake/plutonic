/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "libsbi/sbicall.h"


/*
 * LEGACY extension
 */

struct sbiret sbi_set_timer(u64 stime_value) {
	return sbi_call(stime_value, 0, 0, 0, 0, 0, SBI_FID_sbi_set_timer, SBI_EID_LEGACY);
}

struct sbiret sbi_console_putchar(char c) {
	return sbi_call(c, 0, 0, 0, 0, 0, SBI_FID_sbi_console_putchar, SBI_EID_LEGACY);
}

struct sbiret sbi_console_getchar(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_console_getchar, SBI_EID_LEGACY);
}

struct sbiret sbi_clear_ipi(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_clear_ipi, SBI_EID_LEGACY);
}

struct sbiret sbi_send_ipi(u64 hart_mask) {
	return sbi_call(hart_mask, 0, 0, 0, 0, 0, SBI_FID_sbi_send_ipi, SBI_EID_LEGACY);
}

struct sbiret sbi_remote_fence_i(u64 hart_mask) {
	return sbi_call(hart_mask, 0, 0, 0, 0, 0, SBI_FID_sbi_remote_fence_i, SBI_EID_LEGACY);
}

struct sbiret sbi_remote_sfence_vma(u64 hart_mask, u64 start, u64 size) {
	return sbi_call(hart_mask, start, size, 0, 0, 0, SBI_FID_sbi_remote_sfence_vma, SBI_EID_LEGACY);
}

struct sbiret sbi_remote_sfence_vma_asid(u64 hart_mask, u64 start, u64 size, u64 asid) {
	return sbi_call(hart_mask, start, size, asid, 0, 0, SBI_FID_sbi_remote_sfence_vma_asid, SBI_EID_LEGACY);
}

