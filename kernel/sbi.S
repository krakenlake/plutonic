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

#define SBI_CALL_PROLOGUE		\
		addi	sp, sp, -16;	\
		STORE	a0, 0(sp);		\
		STORE	a1, 8(sp);		\
		;

#define SBI_CALL_EPILOGUE		\
		LOAD	a0, 0(sp);		\
		LOAD	a1, 8(sp);		\
		addi	sp, sp, 16;		\
		;

#define SBI_CALL(name, eid)			\
	.global name;					\
	name:							\
		SBI_CALL_PROLOGUE;			\
		li		a7, eid ;			\
		li		a6, FID_##name;		\
		ecall;						\
		SBI_CALL_EPILOGUE;			\
		ret							\
		;


SBI_CALL( sbi_debug_console_write_byte, EID_EXT_DBCN )




