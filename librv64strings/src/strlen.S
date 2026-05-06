/*
 * libpltnc - RISC-V library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "risc-v/register.h"

.global strlen

.text


# copy str2 to the end of str1
# in: a0 = char* str1
# out: a0 = number of bytes (not counting termination)
.type strlen, @function
strlen:
	# load constants for zero byte testing only once
	la		a2, check_zero_consts
	LOAD	t4, 0(a2)				# t4 = 0x0101010101010101
	LOAD	t5, 8(a2)				# t5 = 0x8080808080808080

	mv		a1, a0
	# scan loop
scan_check_align:
	andi	t2, a0, XLEN_BYTES-1	# check for 8-byte alignment
	bnez	t2, scan_load_byte
scan_load_quad:
	LOAD	t1, 0(a0)				# load full register
	# check if t1 contains any 0x00 bytes
	sub 	t3, t1, t4				# t3 = t1 - 0x0101010101010101
	not		t6, t1					# t6 = ~t1
	and		t6, t6, t5				# t6 = ~t1 & 0x8080808080808080
	and		t6, t3, t6				# t6 = (t1 - 0x0101010101010101) & (~t1 & 0x8080808080808080)
	# result in t6 - if it is 0, there were no 0x00 bytes in t1
	beqz	t6, scan_advance_quad
scan_load_byte:
	# continue byte-wise if there was a 0x00 byte in t1
	lb		t1, 0(a0)
	beqz	t1, scan_done			# done scanning if termination found
	addi	a0, a0, 1
	j		scan_check_align
scan_advance_quad:
	addi	a0, a0, XLEN_BYTES
	j		scan_load_quad
scan_done:
	# a0 is now guaranteed to point to the end of str1
	sub		a0, a0, a1
	ret
.size strlen, .-strlen


.align 8
check_zero_consts:
	.quad 0x0101010101010101
	.quad 0x8080808080808080
