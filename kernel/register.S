/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#include "config.h"
#include "plutonic/register.h"
#include "plutonic/stack.h"


# register table access functions
.global get_int_register_name_by_index
.global get_float_register_name_by_index
.global get_int_register_index_by_name
.global get_float_register_index_by_name


.text


get_int_register_name_by_index:
	la		a1, int_register_names
	j 		get_register_name_by_index
.size get_int_register_name_by_index, .-get_int_register_name_by_index


get_float_register_name_by_index:
	la		a1, float_register_names
	j 		get_register_name_by_index
.size get_float_register_name_by_index, .-get_float_register_name_by_index


# return a string ptr to the name of the n-th register
# in:	a0 = n
# in:	a1 = ptr to table (int_register_names or float_register_names)
# out:	a0 = string ptr
get_register_name_by_index:	
	beqz	a0, get_register_name_by_index_found
	addi	a1, a1, 1
get_register_name_by_index_skip_next_zero:
	lb		t1, 0(a1)
	beqz	t1, get_register_name_by_index_next_zero
	# arrived at zero
	addi	a1, a1, 1
	j		get_register_name_by_index_skip_next_zero
get_register_name_by_index_next_zero:
	addi	a0, a0, -1
	addi	a1, a1, 1
	j		get_register_name_by_index
get_register_name_by_index_found:
	mv		a0, a1
	ret
.size get_register_name_by_index, .-get_register_name_by_index


# return index of int register given by name
# in: a0 = string ptr to start of name
# in: a1 = string ptr to end of name (last char; no 0-termination expected)
# out: a0 = index number of int register (-1 if error)
get_int_register_index_by_name:
	la		a2, int_register_names
	li		a3, NUM_INT_REGISTERS
	j 		get_register_index_by_name
.size get_int_register_index_by_name, .-get_int_register_index_by_name


#ifdef DISASS_RVF
	# return index of float register given by name
	# in: a0 = string ptr to start of name
	# in: a1 = string ptr to end of name (last char; no 0-termination expected)
	# out: a0 = index number of float register (-1 if error)
	get_float_register_index_by_name:
		la		a2, float_register_names
		li		a3, NUM_FLOAT_REGISTERS
		j 		get_register_index_by_name
	.size get_float_register_index_by_name, .-get_float_register_index_by_name
#endif /* DISASS_RVF */


# return index of register given by name
# in: a0 = start of string ptr to name
# in: a1 = end of string ptr to name (after last char; no 0-termination expected)
# in: a2 = ptr to table (int_register_names or float_register_names)
# in: a3 = number of registers
# out: a0 = index number of register (-1 if error)
get_register_index_by_name:
	li		a5, 0											# init index counter
	mv		a4, a0											# save a0 for reuse
get_register_index_by_name_compare_next:
	lb		t1, 0(a0)										# search string byte
	lb		t2, 0(a2)										# table string byte
	beq		t1, t2, get_register_index_by_name_next_char	# chars matched
	# chars are not equal
	beqz	t2, get_register_index_by_name_check1			# register name ended
	bgt		a0, a1, get_register_index_by_name_check2		# search string ended
	# chars did not match and register name did not terminate
	j		get_register_index_by_name_next_reg
get_register_index_by_name_next_char:
	addi	a0, a0,1
	addi	a2, a2,1
	j 		get_register_index_by_name_compare_next
get_register_index_by_name_next_reg:
	mv		a0, a4											# reset search string ptr
get_register_index_by_name_to_reg_end:
	addi	a2, a2, 1										# advance a2 to next reg
	lb		t2, 0(a2)										# table string byte	
	bnez	t2, get_register_index_by_name_to_reg_end		# until 0 reached
	addi	a2, a2, 1										# start of next reg
	addi	a5, a5, 1										# inc index counter
	beq		a5, a3, get_register_index_by_name_not_found	# out of entries
	j 		get_register_index_by_name_compare_next
get_register_index_by_name_check1:
	bgt		a0, a1,	get_register_index_by_name_found
	addi	a5, a5, 1										# entry is prefix of search string
	j		get_register_index_by_name_next_reg
get_register_index_by_name_check2:
	lb		t2, 1(a2)
	beqz	t2, get_register_index_by_name_found
	j		get_register_index_by_name_next_reg
get_register_index_by_name_found:
	mv		a0, a5											# return index counter
	j 		get_register_index_by_name_done
get_register_index_by_name_not_found:
	li		a0, -1											# return error
get_register_index_by_name_done:
	ret
.size get_register_index_by_name, .-get_register_index_by_name


.section .rodata


int_register_names:
	.string "zero", "ra",  "sp",  "gp", "tp", "t0", "t1", "t2"
	.string "fp",	"s1",  "a0",  "a1", "a2", "a3", "a4", "a5"		# x8 = fp
	.string "a6",	"a7",  "s2",  "s3", "s4", "s5", "s6", "s7"
	.string "s8",	"s9", "s10", "s11", "t3", "t4", "t5", "t6"
.size int_register_names, .-int_register_names


float_register_names:
	.string	 "f0",	"f1",  "f2",  "f3",	 "f4",	"f5",  "f6",  "f7"
	.string	 "f8",	"f9", "f10", "f11", "f12", "f13", "f14", "f15"
	.string "f16", "f17", "f18", "f19", "f20", "f21", "f22", "f23"
	.string "f24", "f25", "f26", "f27", "f28", "f29", "f30", "f31"
.size float_register_names, .-float_register_names
