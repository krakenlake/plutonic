/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/ASCII.h"
#include "plutonic/stack.h"
#include "risc-v/register.h"

.global print_comma
.global print_newline
.global print_space
.global print_hex
.global print_hex_raw
.global print_hex_byte
.global print_hex_fixed_width
.global print_hex_addr
.global print_ascii
.global print_char
.global print_string
.global print_decimal

.global out_buf


#define OUT_BUFFER_SIZE		32

.text


print_comma:
	PUSH_RA
	li		a0, ','
	jal		print_char
	#ifdef SPACE_AFTER_COMMA
		jal		print_space
	#endif
	POP_RA_RET
.size print_comma, .-print_comma


print_newline:
	PUSH_RA
	#ifdef USE_CRLF
		li		a0, ASCII_RETURN
		jal		print_char
	#endif
	li		a0, ASCII_NEWLINE
	jal		print_char
	POP_RA_RET
.size print_newline, .-print_newline


print_space:
	li		a0, ' '
	j		print_char
.size print_space, .-print_space



# print hex value with "0x" prefix
# in: a0 = value to print
print_hex:
	PUSH_S0_RA
	# print "0x"
	mv		s0, a0						# save a0 for later
	li		a0, '0'
	jal		print_char
	li		a0, 'x'
	jal		print_char
	mv		a0, s0						# restore a0
	# print value
	jal		print_hex_raw
	POP_S0_RA_RET
.size print_hex, .-print_hex


# print hex value (no trailing zeroes, no prefix)
# in: a0 = value to print
print_hex_raw:
	PUSH_RA
	# terminate buffer at the end
	# TODO: do buffer termination only once
	la		t2, out_buf
	addi	t2, t2, (OUT_BUFFER_SIZE-1)
	sb		zero, 0(t2)
	# print to output buffer backwards
print_hex_new_next_nibble:
	addi	t2, t2, -1 
	andi	t0, a0, 0x0f
	# digit < 10?
	sltiu	t1, t0, 10
	bnez	t1, print_hex_new_decimal
	addi	t0, t0, 39
print_hex_new_decimal:
	addi	t0, t0, 48
	sb		t0, 0(t2)						# to buffer
	srli	a0, a0, 4						# next nibble
	bnez	a0, print_hex_new_next_nibble	# only if more to come
	# print buffer
	mv		a0, t2
	jal		print_string
	POP_RA_RET
.size print_hex_raw, .-print_hex_raw


# print a 2-digit hex value (with leading zero for 1-digit values)
# in: byte value in a0
print_hex_byte:
	PUSH_S0_RA
	li		t0, 15
	bgt		a0, t0, print_hex_byte_two_digits
	# print a leading zero if necessary
	mv		s0, a0						# save a0 for later
	li		a0, '0'
	jal		print_char
	mv		a0, s0						# restore a0
print_hex_byte_two_digits:
	jal		print_hex_raw
	POP_S0_RA_RET
.size print_hex_byte, .-print_hex_byte


# Print a hex value with a fixed number of bytes
# in: a0 = value to print
# in: a1 = width (in bytes) to print	
# in: a2 = print 0x prefix? (0=no, otherwise yes)
print_hex_fixed_width:
	PUSH_S1_S0_RA
	mv		s0, a0
	mv		s1, a1
	beqz	a2, print_hex_fixed_width_loop
	li		a0, '0'
	call	print_char
	li		a0, 'x'
	call	print_char
print_hex_fixed_width_loop:	
	addi	s1, s1, -1
	slli	t0, s1, 3					# t0 = a1 * 3
	srl		a0, s0, t0  				# shift byte of interest to lowest byte
	and		a0, a0, 0xff 				# mask low order byte and print
	call	print_hex_byte
	bnez	s1, print_hex_fixed_width_loop
	POP_S1_S0_RA_RET
.size print_hex_fixed_width, .-print_hex_fixed_width

# shorthand for address printing
# in: a0 = address to print
print_hex_addr:
	li		a1, XLEN_BYTES				# full address length
	li		a2, 1						# with 0x prefix
	j		print_hex_fixed_width
.size print_hex_addr, .-print_hex_addr


# print char to terminal (if printable, else '.')
# in: a0 = char to print
print_ascii:
	PUSH_RA
	# consider only chars from 0x20-0x7e as printable
	li		t0, 0x20
	blt		a0, t0, print_ascii_substitute
	li		t0, 0x7e
	bgt		a0, t0, print_ascii_substitute
	j		print_ascii_out				# char is printable
print_ascii_substitute:
	li		a0, '.'						# print dot if char is not printable
print_ascii_out:
	jal		print_char
	POP_RA_RET
.size print_ascii, .-print_ascii


# print ASCII char to terminal
# in: a0 = char to print
print_char:
	j		uart_output_char
.size print_char, .-print_char


# print string to terminal
# in: a0 = string ptr
print_string:
	j		uart_output_string
.size print_string, .-print_string


# print 32/64-bit signed decimal to terminal
# in: a0 = value to print
print_decimal:
	PUSH_S1_S0_RA
	beqz	a0, print_decimal_zero
	# save a0
	mv		s1, a0
	# terminate buffer at the end
	la		s0, out_buf
	addi	s0, s0, (OUT_BUFFER_SIZE-1)
	sb		zero, 0(s0)
	# invert if negative
	bgtz	s1, print_decimal_skip_invert
	neg		a0, a0
print_decimal_skip_invert:
	# write ASCII digits to buffer backward starting at the end
print_decimal_loop:
	# dec buffer ptr
	addi	s0, s0, -1
	li		t1, 10
	# a0 = quotient, t1 = divisor
	rem		a1, a0, t1
	div		a0, a0, t1
	# output digit as ASCII to buffer
	addi	t0, a1, 48
	sb		t0, 0(s0)
	# repeat
	bnez	a0, print_decimal_loop
	# print minus if negative
	bgtz	s1, print_decimal_skip_minus
	li		a0, '-'
	jal		print_char
print_decimal_skip_minus:
	# output buffer, starting at last written location
	mv		a0, s0
	jal		print_string
	j		print_decimal_done
print_decimal_zero:
	li		a0, '0'
	jal		print_char
print_decimal_done:
	POP_S1_S0_RA_RET
.size print_decimal, .-print_decimal


.bss


.align 8
.comm out_buf, OUT_BUFFER_SIZE
.size out_buf, OUT_BUFFER_SIZE
