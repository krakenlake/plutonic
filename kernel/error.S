/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#include "config.h"
#include "plutonic/error.h"
#include "risc-v/register.h"
#include "plutonic/log.h"


.global error_handler


.text






# in: a0 = error number
# out: a0 = error number
error_handler:
	ld		ra,-8(fp) 
	mv		sp, fp

	addi	sp, sp, -(XLEN_BYTES*4)
	SAVE_X	ra, 0(sp)
	SAVE_X	a0, (XLEN_BYTES*1)(sp)
	SAVE_X	a1, (XLEN_BYTES*2)(sp)
	SAVE_X	a2, (XLEN_BYTES*3)(sp)

	mv		s1, a0
	la		a1, error_msg
	jal		log_no_newline
	mv		a0, s1
	jal		print_hex
	jal		print_newline

	LOAD_X	ra, 0(sp)
	LOAD_X	a0, (XLEN_BYTES*1)(sp)
	LOAD_X	a1, (XLEN_BYTES*2)(sp)
	LOAD_X	a2, (XLEN_BYTES*3)(sp)
	addi	sp, sp, (XLEN_BYTES*4)
	ret
.size error_handler, .-error_handler	


.section .rodata


error_msg:
	.string "ERROR: error_handler: ERROR = ";
.size error_msg, .-error_msg

