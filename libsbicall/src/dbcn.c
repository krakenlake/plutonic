/*
 * libsbicall - RISC-V SBI wrapper
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "libsbicall/sbicall.h"


/*
 * DBCN console extension
 */

struct sbiret sbi_debug_console_write(char c)
{
	return sbicall(c, 0, 0, 0, 0, 0, SBI_FID_sbi_debug_console_write, SBI_EID_DBCN);
}

struct sbiret sbi_debug_console_read(char c)
{
	return sbicall(c, 0, 0, 0, 0, 0, SBI_FID_sbi_debug_console_read, SBI_EID_DBCN);
}

struct sbiret sbi_debug_console_write_byte(char c)
{
	return sbicall(c, 0, 0, 0, 0, 0, SBI_FID_sbi_debug_console_write_byte, SBI_EID_DBCN);
}
