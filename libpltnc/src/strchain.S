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


# copy str2 to the end of str1
# in: a0 = char* str1
# in: a1 = char* str2
# out: ptr to null-termination of str1
.type strchain, @function
strchain:
	# in the first part we find the end of str1

	# load constants for zero byte testing only once
	la		a2, check_zero_consts
	LOAD	t4, 0(a2)				# t4 = 0x0101010101010101
	LOAD	t5, 8(a2)				# t5 = 0x8080808080808080

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

	# now copy from src to dst
copy_check_align:
	# todo: we should check a0 as well 
	andi	t2, a1, XLEN_BYTES-1	# check for 8-byte alignment of src
	bnez	t2, copy_bytes			# go fetching 8 bytes at once if XLEN_BYTES aligned
copy_quad:
	# when ptr into str2 is XLEN_BYTES aligned, do full register loads
	LOAD	t1, 0(a1)				# load full register
	# check if t1 contains any 0x00 bytes
	sub 	t3, t1, t4				# t3 = t1 - 0x0101010101010101
	not		t6, t1					# t6 = ~t1
	and		t6, t6, t5				# t6 = ~t1 & 0x8080808080808080
	and		t6, t3, t6				# t6 = (t1 - 0x0101010101010101) & (~t1 & 0x8080808080808080)
	# result in t6 - if it is 0, there were no 0x00 bytes in t1
	bnez	t6, store_bytes
	STORE	t1, 0(a0)				# store 8 bytes
	addi	a0, a0, XLEN_BYTES		# advance to next quad
	addi	a1, a1, XLEN_BYTES
	j		copy_quad				# next 8 bytes
copy_bytes:
	# copy byte-wise until we hit next alignment
	lb		t1, 0(a1)				
	sb		t1, 0(a0)
	beqz	t1, copy_done			# check if string ended
	addi	a0, a0, 1				# advance dst ptr
	addi	a1, a1, 1				# advance src ptr
	j		copy_check_align
	# t1 contained a 0x00 byte, so we need to store t1 byte-wise
store_bytes:
	# shift through bytes in t1 and store them one by one
	sb		t1, 0(a0)
	andi	t3, t1, 0xff			# done if termination found
	beqz	t3, copy_done
	srli	t1, t1, 8				# shift next register byte into position
	addi	a0, a0, 1				# advance dst ptr
	j 		store_bytes

copy_done:
	ret
.size strchain, .-strchain


.align 8
check_zero_consts:
	.quad 0x0101010101010101
	.quad 0x8080808080808080
