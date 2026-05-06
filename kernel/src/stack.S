/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/ASCII.h"
#include "plutonic/stack.h"
#include "riscv/register.h"
#include "plutonic/log.h"

.global log_saved_int_registers
.global log_saved_float_registers


.text


log_saved_int_registers:
	addi	sp, sp, -(XLEN_BYTES*1)	
	STORE	ra, 0(sp)
	la		a0, get_int_register_name_by_index
	li		a1, 1
	li		a2, 31
	
	# set a3 to the address of ra in the current stack frame
	# (XLEN_BYTES are also added to compensate for the pushing ra on entry here)
	addi	a3, sp, XLEN_BYTES + STK_FRAME_SIZE_FLOAT + STK_OFF_RA
	li		a4, XLEN_BYTES
	jal		log_saved_registers
	LOAD	ra, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
	ret
.size log_saved_int_registers, .-log_saved_int_registers


log_saved_float_registers:
	addi	sp, sp, -(XLEN_BYTES*1)	
	STORE	ra, 0(sp)
	la		a0, get_float_register_name_by_index
	li		a1, 0
	li		a2, 31 
	addi	a3, sp,  XLEN_BYTES						# compensate for ra pushed on entry
	li		a4, FLEN_BYTES
	jal		log_saved_registers
	LOAD	ra, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
	ret
.size log_saved_float_registers, .-log_saved_float_registers


# dump registers saved on stack
# in: a0 = register name lookup func ptr
# in: a1 = first register index
# in: a2 = last register index
# in: a3 = stack frame base addr
log_saved_registers:
	addi	sp, sp, -(XLEN_BYTES*9)
	STORE	s0, 0(sp)
	STORE	s1, (XLEN_BYTES*1)(sp)
	STORE	s2, (XLEN_BYTES*2)(sp)
	STORE	s3, (XLEN_BYTES*3)(sp)
	STORE	s4, (XLEN_BYTES*4)(sp)
	STORE	s5, (XLEN_BYTES*5)(sp)
	STORE	s6, (XLEN_BYTES*6)(sp)
	STORE	s7, (XLEN_BYTES*7)(sp)
	STORE	ra, (XLEN_BYTES*8)(sp)
	mv		s0, a3						# stack frame base addr
	mv		s1, a1						# first register index
	mv		s4, a2						# last register index
	mv		s5, a0						# register name lookup func ptr
	li		s7, 0
log_saved_registers_next:
	li		s6, 4						# 4 registers per line
	mv		s2, a0
	mv		s3, a1
	li		a0, LOG_DEBUG
	la		a1, string_register_dump
	jal		log_no_newline
	# prepare lookup function call
	mv		a1, s3
log_saved_registers_skip_newline:
	mv		a0, s1						# index of register
	jalr	s5
	mv		s7, a0
	# determine length of found name
	li		t1, 0						# len counter
log_saved_registers_len_loop:
	lb		t0, 0(a0)
	beqz	t0, log_saved_registers_len_done
	addi	a0, a0, 1
	addi	t1, t1, 1
	j		log_saved_registers_len_loop
log_saved_registers_len_done:
	# length now in t1, print spaces if register name is shorter than 6
	li		t2, 6						
	sub 	a5, t2, t1
	# print spaces
	li		a0, ' '
log_saved_registers_space_loop:
	beqz	a5, log_saved_registers_skip_space
	jal		print_char
	addi	a5, a5, -1
	j 		log_saved_registers_space_loop
log_saved_registers_skip_space:
	mv		a0, s7
	jal		print_string				# register name
	li		a0, '='
	jal		print_char
	LOAD	a0, 0(s0)					# saved value
	jal		print_hex_addr
	# check if all registers done
	li		t0, 31						# last valid index in any case
	bge		s1, t0, log_saved_registers_done
	# stop also if register specified in s4 reached
	beq		s1, s4, log_saved_registers_done
	addi	s0, s0, XLEN_BYTES			# next register
	addi	s1, s1, 1					# next register name
	addi	s6, s6, -1
	bnez	s6, log_saved_registers_skip_newline
	jal		print_newline
	j		log_saved_registers_next
log_saved_registers_done:
	jal		print_newline
	LOAD	s0, 0(sp)
	LOAD	s1, (XLEN_BYTES*1)(sp)
	LOAD	s2, (XLEN_BYTES*2)(sp)
	LOAD	s3, (XLEN_BYTES*3)(sp)
	LOAD	s4, (XLEN_BYTES*4)(sp)
	LOAD	s5, (XLEN_BYTES*5)(sp)
	LOAD	s6, (XLEN_BYTES*6)(sp)
	LOAD	s7, (XLEN_BYTES*7)(sp)
	LOAD	ra, (XLEN_BYTES*8)(sp)
	addi	sp, sp, (XLEN_BYTES*9)
	ret

.size log_saved_registers, .-log_saved_registers


.section .rodata

string_register_dump:
	.string "register dump:";

