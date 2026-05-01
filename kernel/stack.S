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
#include "plutonic/log.h"


.global log_saved_int_registers
.global log_saved_float_registers


.text


log_saved_int_registers:
	addi	sp, sp, -(XLEN_BYTES*1)	
	SAVE_X	ra, 0(sp)
	la		a0, get_int_register_name_by_index
	li		a1, 1
	li		a2, 31
	
	# set a3 to the address of ra in the current stack frame
	# (XLEN_BYTES are also added to compensate for the pushing ra on entry here)
	addi	a3, sp, XLEN_BYTES + STK_FRAME_SIZE_FLOAT + STK_OFF_RA
	li		a4, XLEN_BYTES
	jal		log_saved_registers
	LOAD_X	ra, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
	ret
.size log_saved_int_registers, .-log_saved_int_registers


log_saved_float_registers:
	addi	sp, sp, -(XLEN_BYTES*1)	
	SAVE_X	ra, 0(sp)
	la		a0, get_float_register_name_by_index
	li		a1, 0
	li		a2, 31 
	addi	a3, sp,  XLEN_BYTES						# compensate for ra pushed on entry
	li		a4, FLEN_BYTES
	jal		log_saved_registers
	LOAD_X	ra, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
	ret
.size log_saved_float_registers, .-log_saved_float_registers


# dump registers saved on stack
# in: a0 = register name lookup func ptr
# in: a1 = first register index
# in: a2 = last register index
# in: a3 = stack frame base addr
log_saved_registers:
	addi	sp, sp, -(XLEN_BYTES*4)
	SAVE_X	tp, 0(sp)
	SAVE_X	s1, (XLEN_BYTES*1)(sp)
	SAVE_X	s0, (XLEN_BYTES*2)(sp)
	SAVE_X	ra, (XLEN_BYTES*3)(sp)
	# TODO: clean this up
	addi	sp, sp, -(XLEN_BYTES*3)		# 3 extra local vars
	SAVE_X 	a0, 0(sp)					# register name lookup func ptr
	SAVE_X 	zero, (XLEN_BYTES*1)(sp)	# counting regs per line
	SAVE_X	zero, (XLEN_BYTES*2)(sp)	# name string ptr
	mv		s1, a1						# first register index
	mv		tp, a2						# last register index
	mv		s0, a3						# stack frame base addr
log_saved_registers_next:
	li		t0, 4						# registers per line
	SAVE_X	t0, (XLEN_BYTES*1)(sp)
	mv		s2, a0
	mv		s3, a1
	li		a0, LOG_DEBUG
	la		a1, string_register_dump
	jal		log_no_newline
	mv		a0, s2
	mv		a1, s3
log_saved_registers_skip_newline:
	mv		a0, s1						# index of register
	LOAD_X	t0, 0(sp)					# register name lookup func ptr
	jalr	t0
	SAVE_X	a0, (XLEN_BYTES*2)(sp)
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
	LOAD_X	a0, (XLEN_BYTES*2)(sp)
	jal		print_string				# register name
	li		a0, '='
	jal		print_char
	LOAD_X	a0, 0(s0)					# saved value
	jal		print_hex_addr
	# check if all registers done
	li		t0, 31						# last valid index in any case
	bge		s1, t0, log_saved_registers_done
	# stop also if register specified in tp reached
	beq		s1, tp, log_saved_registers_done
	addi	s0, s0, XLEN_BYTES			# next register
	addi	s1, s1, 1					# next register name
	LOAD_X	t0, (XLEN_BYTES*1)(sp)
	addi	t0, t0, -1					# count number of printed registers
	SAVE_X	t0, (XLEN_BYTES*1)(sp)
	bnez	t0, log_saved_registers_skip_newline
	jal		print_newline
	j		log_saved_registers_next
log_saved_registers_done:
	jal		print_newline
	addi	sp, sp, (XLEN_BYTES*3)		# discard 5 extra local vars
	LOAD_X	tp, 0(sp)
	LOAD_X	s1, (XLEN_BYTES*1)(sp)
	LOAD_X	s0, (XLEN_BYTES*2)(sp)
	LOAD_X	ra, (XLEN_BYTES*3)(sp)
	addi	sp, sp, (XLEN_BYTES*4)
	ret

.size log_saved_registers, .-log_saved_registers


.section .rodata

string_register_dump:
	.string "register dump:";

