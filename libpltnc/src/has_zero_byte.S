/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "risc-v/register.h"

.global has_zero_byte

.text


# return !=0 if any of the register bytes contains 0x00
# -> (a0 - 0x0101010101010101) & (~a0 & 0x8080808080808080)
# ->  a0 - t0                  &  t2 & t1
# ->  t0                       &  t2
# ->  a0
#
# in: a0
# out: a0
.type has_zero_byte, @function
has_zero_byte:
	# load constants:
	# - prefer constants pool over li instruction
	# - use offset adressing instead of advancing a2
	la		a1, const0x01
	LOAD	t0, 0(a1)
	LOAD	t1, 8(a1)
	sub 	t0, a0, t0
	not		t2, a0
	and		t2, t2, t1
	and		a0, t0, t2
	ret
.size has_zero_byte, .-has_zero_byte

.section .rodata

.align 8
const0x01:
	.quad 0x0101010101010101
const0x80:
	.quad 0x8080808080808080
