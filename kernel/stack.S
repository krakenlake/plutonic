#include "config.h"
#include "plutonic/ASCII.h"
#include "plutonic/stack.h"
#include "plutonic/register.h"


# PUSH
.global push_ra
.global push_s0_ra
.global push_s1_s0_ra
.global push_tp_s1_s0_ra						# use tp like another s register 

# POP
.global pop_ra_ret
.global pop_s0_ra_ret
.global pop_s1_s0_ra_ret
.global pop_tp_s1_s0_ra_ret						# use tp like another s register

.global print_pc
.global print_int_registers
.global print_float_registers


.text


# for function prologue optimisation (shorter code in total)
push_ra:
	addi	sp, sp, -(XLEN_BYTES*1)	
	SAVE_X	ra, 0(sp)
	jr		gp
.size push_ra, .-push_ra	

push_s0_ra:
	addi	sp, sp, -(XLEN_BYTES*2)
	SAVE_X	s0, 0(sp)
	SAVE_X	ra, (XLEN_BYTES*1)(sp)
	jr		gp
.size push_s0_ra, .-push_s0_ra	

push_s1_s0_ra:
	addi	sp, sp, -(XLEN_BYTES*3)
	SAVE_X	s1, 0(sp)
	SAVE_X	s0, (XLEN_BYTES*1)(sp)
	SAVE_X	ra, (XLEN_BYTES*2)(sp)
	jr		gp
.size push_s1_s0_ra, .-push_s1_s0_ra	

push_tp_s1_s0_ra:
	addi	sp, sp, -(XLEN_BYTES*4)
	SAVE_X	tp, 0(sp)
	SAVE_X	s1, (XLEN_BYTES*1)(sp)
	SAVE_X	s0, (XLEN_BYTES*2)(sp)
	SAVE_X	ra, (XLEN_BYTES*3)(sp)
	jr		gp
.size push_tp_s1_s0_ra, .-push_tp_s1_s0_ra	


# for function epilogue optimisation (shorter code in total)
pop_tp_s1_s0_ra_ret:
	LOAD_X	tp, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
pop_s1_s0_ra_ret:
	LOAD_X	s1, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
pop_s0_ra_ret:
	LOAD_X	s0, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
pop_ra_ret:
	LOAD_X	ra, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
	ret
.size pop_tp_s1_s0_ra_ret, .-pop_tp_s1_s0_ra_ret	

print_pc:
	PUSH_RA
	la		a0, string_pc
	jal		print_string
	LOAD_X	a0, (XLEN_BYTES + STK_FRAME_SIZE_FLOAT + STK_OFF_PC)(sp)
	jal		print_hex_addr
	jal		print_newline
	POP_RA_RET
.size print_pc, .-print_pc	


.section .rodata


string_pc:
	.string "    pc=";
.size string_pc, .-string_pc
.text




print_int_registers:
	PUSH_RA
	la		a0, get_int_register_name_by_index
	li		a1, 1
	
	li		a2, 31
	
	# set a3 to the address of ra in the current stack frame
	# (XLEN_BYTES are also added to compensate for the pushing ra on entry here)
	#ifdef TARGET_HAS_RVF
		addi		a3, sp, XLEN_BYTES + STK_FRAME_SIZE_FLOAT + STK_OFF_RA
	#else
		addi		a3, sp, XLEN_BYTES + STK_OFF_RA
	#endif

	li		a4, XLEN_BYTES
	jal		print_saved_registers
	POP_RA_RET
.size print_int_registers, .-print_int_registers


print_float_registers:
	PUSH_RA
	la		a0, get_float_register_name_by_index
	li		a1, 0
	li		a2, 31 
	addi	a3, sp,  XLEN_BYTES						# compensate for ra pushed on entry
	li		a4, FLEN_BYTES
	jal		print_saved_registers
	POP_RA_RET
.size print_float_registers, .-print_float_registers


# dump registers saved on stack
# in: a0 = register name lookup func ptr
# in: a1 = first register index
# in: a2 = last register index
# in: a3 = stack frame base addr
print_saved_registers:
	PUSH_TP_S1_S0_RA
	addi	sp, sp, -(XLEN_BYTES*3)		# 3 extra local vars
	SAVE_X 	a0, 0(sp)					# register name lookup func ptr
	SAVE_X 	zero, (XLEN_BYTES*1)(sp)	# counting regs per line
	SAVE_X	zero, (XLEN_BYTES*2)(sp)	# name string ptr

	mv		s1, a1						# first register index
	mv		tp, a2						# last register index
	mv		s0, a3						# stack frame base addr
print_saved_registers_next:
	li		t0, 3
	SAVE_X	t0, (XLEN_BYTES*1)(sp)
	jal		print_newline
print_saved_registers_skip_newline:
	mv		a0, s1						# index of register
	LOAD_X	t0, 0(sp)					# register name lookup func ptr
	jalr	t0
	SAVE_X	a0, (XLEN_BYTES*2)(sp)
	# determine length of found name
	li		t1, 0						# len counter
print_saved_registers_len_loop:
	lb		t0, 0(a0)
	beqz	t0, print_saved_registers_len_done
	addi	a0, a0, 1
	addi	t1, t1, 1
	j		print_saved_registers_len_loop
print_saved_registers_len_done:
	# length now in t1, print spaces if register name is shorter than 6
	li		t2, 6						
	sub 	a5, t2, t1
print_saved_registers_space_loop:
	beqz	a5, print_saved_registers_skip_space
	jal		print_space
	addi	a5, a5, -1
	j 		print_saved_registers_space_loop
print_saved_registers_skip_space:
	LOAD_X	a0, (XLEN_BYTES*2)(sp)
	jal		print_string				# register name
	li		a0, '='
	jal		print_char
	LOAD_X	a0, 0(s0)					# saved value
	jal		print_hex_addr
	# check if all registers done
	li		t0, 31						# last valid index in any case
	bge		s1, t0, print_saved_registers_done
	# stop also if register specified in tp reached
	beq		s1, tp, print_saved_registers_done
	addi	s0, s0, XLEN_BYTES			# next register
	addi	s1, s1, 1					# next register name
	LOAD_X	t0, (XLEN_BYTES*1)(sp)
	addi	t0, t0, -1					# count number of printed registers
	SAVE_X	t0, (XLEN_BYTES*1)(sp)
	beqz	t0, print_saved_registers_next
	j		print_saved_registers_skip_newline
print_saved_registers_done:
	jal		print_newline
	addi	sp, sp, (XLEN_BYTES*3)		# discard 5 extra local vars
	POP_TP_S1_S0_RA_RET
.size print_saved_registers, .-print_saved_registers
