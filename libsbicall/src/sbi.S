/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "riscv/register.h"
#include "libsbicall/sbi.h"


.text

#define SBI_CALL(eid, name)			\
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

SBI_CALL(EID_BASE, sbi_get_spec_version)
SBI_CALL(EID_BASE, sbi_get_impl_id)
SBI_CALL(EID_BASE, sbi_get_impl_version)
SBI_CALL(EID_BASE, sbi_probe_extension)
SBI_CALL(EID_BASE, sbi_get_mvendorid)
SBI_CALL(EID_BASE, sbi_get_marchid)
SBI_CALL(EID_BASE, sbi_get_mimpid)

SBI_CALL(EID_EXT_DBCN, sbi_debug_console_write)
SBI_CALL(EID_EXT_DBCN, sbi_debug_console_read)
SBI_CALL(EID_EXT_DBCN, sbi_debug_console_write_byte)

