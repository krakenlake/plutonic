/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "riscv/register.h"
#include "libsbi/sbicall.h"

struct sbiret sbi_call(u64 arg0, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5, u64 fid, u64 eid) {
	register u64 a0 __asm__("a0") = arg0;
	register u64 a1 __asm__("a1") = arg1;
	register u64 a2 __asm__("a2") = arg2;
	register u64 a3 __asm__("a3") = arg3;
	register u64 a4 __asm__("a4") = arg4;
	register u64 a5 __asm__("a5") = arg5;
	register u64 a6 __asm__("a6") = fid;
	register u64 a7 __asm__("a7") = eid;

	__asm__ __volatile__(
		"ecall"
		: "=r"(a0), "=r"(a1)
		: "r"(a0), "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a6), "r"(a7)
		: "memory"
	);

	return (struct sbiret){.error = a0, .val = a1};
}

/*
 * Base extension
 */

struct sbiret sbi_get_spec_version(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_get_spec_version, SBI_EID_BASE);
}

struct sbiret sbi_get_impl_id(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_get_impl_id, SBI_EID_BASE);
}

struct sbiret sbi_get_impl_version(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_get_impl_version, SBI_EID_BASE);
}

struct sbiret sbi_probe_extension(u64 extension_id) {
	return sbi_call(extension_id, 0, 0, 0, 0, 0, SBI_FID_sbi_probe_extension, SBI_EID_BASE);
}

struct sbiret sbi_get_mvendorid(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_get_mvendorid, SBI_EID_BASE);
}

struct sbiret sbi_get_marchid(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_get_marchid, SBI_EID_BASE);
}

struct sbiret sbi_get_mimpid(void) {
	return sbi_call(0, 0, 0, 0, 0, 0, SBI_FID_sbi_get_mimpid, SBI_EID_BASE);
}

/*
 * Debug console extension
 */

struct sbiret sbi_debug_console_write(char c) {
	return sbi_call(c, 0, 0, 0, 0, 0, SBI_FID_sbi_debug_console_write, SBI_EID_DBCN);
}
struct sbiret sbi_debug_console_read(char c) {
	return sbi_call(c, 0, 0, 0, 0, 0, SBI_FID_sbi_debug_console_read, SBI_EID_DBCN);
}
struct sbiret sbi_debug_console_write_byte(char c) {
	return sbi_call(c, 0, 0, 0, 0, 0, SBI_FID_sbi_debug_console_write_byte, SBI_EID_DBCN);
}
