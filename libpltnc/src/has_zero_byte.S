/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "riscv/register.h"

.global has_zero_byte

.text


# return !=0 if any of the register bytes contains 0x00
# in: a0
# out: a0 = (a0 - 0x0101010101010101) & (~a0 & 0x8080808080808080)
.type has_zero_byte, @function
has_zero_byte:
	# load constants:
	# - prefer constants pool over li instruction
	# - use offset adressing instead of advancing a1
	la		a1, has_zero_byte_constants
	LOAD	t0, 0(a1)				# t0 = 0x0101010101010101
	LOAD	t1, 8(a1)				# t1 = 0x8080808080808080
	sub 	t0, a0, t0				# t0 = a0 - 0x0101010101010101
	not		t2, a0					# t2 = ~a0
	and		t2, t2, t1				# t2 = ~a0 & 0x8080808080808080
	and		a0, t0, t2				# a0 = (a0 - 0x0101010101010101) & (~a0 & 0x8080808080808080)
	ret
.size has_zero_byte, .-has_zero_byte

.section .rodata

.align 8
has_zero_byte_constants:
	.quad LIBPLTNC_BITWISE_CONST1
	.quad LIBPLTNC_BITWISE_CONST2

