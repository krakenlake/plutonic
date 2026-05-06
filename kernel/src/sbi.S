/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "riscv/register.h"
#include "riscv/sbi.h"


.text

#define SBI_CALL(name, eid)			\
	.global name;					\
	name:							\
		addi	sp, sp, -16;		\
		STORE	a0, 0(sp);			\
		STORE	a1, 8(sp);			\
		li		a7, eid;			\
		li		a6, FID_##name;		\
		ecall;						\
		LOAD	a0, 0(sp);			\
		LOAD	a1, 8(sp);			\
		addi	sp, sp, 16;			\
		ret

/*
 * Base extension
 */
SBI_CALL(sbi_get_spec_version, EID_BASE)
SBI_CALL(sbi_get_impl_id, EID_BASE)
SBI_CALL(sbi_get_impl_version, EID_BASE)
SBI_CALL(sbi_probe_extension, EID_BASE)
SBI_CALL(sbi_get_mvendorid, EID_BASE)
SBI_CALL(sbi_get_marchid, EID_BASE)
SBI_CALL(sbi_get_mimpid, EID_BASE)

/*
 * Debug console extension
 */
SBI_CALL(sbi_debug_console_write, EID_EXT_DBCN)
SBI_CALL(sbi_debug_console_read, EID_EXT_DBCN)
SBI_CALL(sbi_debug_console_write_byte, EID_EXT_DBCN)

