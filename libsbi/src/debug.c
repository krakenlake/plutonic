/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "libsbi/sbicall.h"


/*
 * DBCN console extension
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
