/*
 * libpltnc - RISC-V library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "risc-v/register.h"
#include "libpltnc/bitwise.h"

.global strchain

.text


# string1 = string1 + string2
# in: a0 = char* string1
# in: a1 = char* string2
# out: ptr to null-termination of resulting string
.type strchain, @function
strchain:
loop1:
	# todo: use ld here as well when possible
	lb		t0, 0(a0)
	beqz	t0, str1_ended
	addi	a0, a0, 1
	j		loop1	
str1_ended:
loop2:
	andi	t2, a1, XLEN_BYTES		# check for 8-byte alignment
	beqz	t2, fastloop_init		# go fetching 8 bytes at once if XLEN_BYTES aligned
	# copy byte-wise until we hit next alignment
	lb		t1, 0(a1)
	beqz	t1, str2_ended
	sb		t1, 0(a0)
	addi	a0, a0, 1
	addi	a1, a1, 1
	j		loop2
	# when ptr into string2 is XLEN_BYTES aligned, do full register loads
fastloop_init:
	# load constants for zero byte testing only once
	la		a2, strchain_constants
	LOAD	t4, 0(a2)				# t4 = 0x0101010101010101
	LOAD	t5, 8(a2)				# t5 = 0x8080808080808080
fastloop:
	LOAD	t1, 0(a1)				# load full register
	# check if t1 contains any 0x00 bytes
	sub 	t4, t1, t4				# t4 = t1 - 0x0101010101010101
	not		t6, t1					# t6 = ~a0
	and		t6, t2, t5				# t6 = ~a0 & 0x8080808080808080
	and		t6, t4, t6				# t6 = (a0 - 0x0101010101010101) & (~a0 & 0x8080808080808080)
	# result in t7
	bnez	t6, next_quad
	li		t0, XLEN_BYTES			# bytes per load
next_byte:
	andi	t3, t1, 0xff			# if byte is 0, string ends
	beqz	t3,str2_ended
	sb		t1, 0(a0)
	addi	a0, a0, 1
	# next byte
	srli	t1, t1, 8				# shift to next byte
	addi	t0, t0, -1
	bnez	t0, next_byte
	# every 8 bytes
	addi	a1, a1, XLEN_BYTES
	j		fastloop
next_quad:
	STORE	t1, 0(a0)				# store 8 bytes
	addi	a0, a0, XLEN_BYTES		# advance to next quad
	addi	a1, a1, XLEN_BYTES
	j		fastloop
str2_ended:
	sb		zero, 0(a0)
	ret
.size strchain, .-strchain


.align 8
strchain_constants:
	.quad LIBPLTNC_BITWISE_CONST1
	.quad LIBPLTNC_BITWISE_CONST2
