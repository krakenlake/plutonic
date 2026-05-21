/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#include "config.h"
#include "plutonic/error.h"
#include "riscv/register.h"
#include "plutonic/log.h"

.global throw_error

.text


# log an error, reset stack and jump to main
# in: a0 = error code
# out: a0 = error code
throw_error:
#	ld		ra,-8(fp) 
#	mv		sp, fp
	la		sp, _estack

	addi	sp, sp, -(XLEN_BYTES*3)
	STORE	ra, 0(sp)
	STORE	a0, (XLEN_BYTES*1)(sp)
	STORE	a1, (XLEN_BYTES*2)(sp)

	mv		s1, a0
	li		a0, LOG_ERR
	la		a1, error_msg
	jal		log_no_newline
	mv		a0, s1
	jal		print_hex
	jal		print_newline

	LOAD	ra, 0(sp)
#	LOAD	a0, (XLEN_BYTES*1)(sp)
#	LOAD	a1, (XLEN_BYTES*2)(sp)
	la		sp, _estack
#	ret
	j		main_wfi_loop
	
.size throw_error, .-throw_error	


.section .rodata


error_msg:
	.string "throw_error: ERROR = ";
.size error_msg, .-error_msg

