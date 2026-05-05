/*
 * libpltnc - RISC-V library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "risc-v/register.h"

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
	beqz	t2, fastloop			# load byte-wise if src not XLEN_BYTES-aligned
	lb		t1, 0(a1)
	beqz	t1, str2_ended
	sb		t1, 0(a0)
	addi	a0, a0, 1
	addi	a1, a1, 1
	j		loop2
	# when ptr into string2 is XLEN_BYTES aligned, do full register loads
fastloop:
	li		t0, XLEN_BYTES			# bytes per load
	LOAD	t1, 0(a1)				# load full register
next_byte:
	# todo: improve further by checking if t1 contains a full 0x00 byte
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
str2_ended:
	sb		zero, 0(a0)
	ret
.size strchain, .-strchain
