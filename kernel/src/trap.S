/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "risc-v/register.h"
#include "plutonic/trap.h"
#include "plutonic/stack.h"
#include "plutonic/log.h"

.global set_timer
.global trap_handler
.global exit_trap_handler

.text


/*
 * read current timestamp, add a constant and set timer IRQ
 */
set_timer:
	rdtime	t0
	li		t1, TIMER_INTERVAL
	add		a0, t0, t1
	# new time now in a0
#ifdef TARGET_HAS_SSTC
	# with sstc extension we can set the timer from S-Mode
	csrw	stimecmp, a0
#else
	# otherwise we need to call SBI
    li		a7, 0x54494D45
    li		a6, 0x00
	ecall
#endif
	ret


/*
 * trap handler entry point
 * (needs to be aligned manually as that is not automatically guaranteed 
 * with RVC enabled)
 */
.align 4
trap_handler:
	# disable all S-mode IRQs
	csrci	sstatus, SSTATUS_SIE
	# save all registers on stack
	PUSH_ALL_INT_REGISTERS
	PUSH_ALL_FLOAT_REGISTERS
	# irq or exception? check leftmost bit of xcause
	csrr	a0, scause
	srli	a0, a0, XLEN-1
	bnez	a0, handle_irq


	# we have an exception, filter for specific ones
	csrr	t0, scause
	li		t1, SCAUSE_BREAKPOINT
	beq		t0, t1, handle_exception_ebreak
	li		t1, SCAUSE_ILLEGAL_INSTRUCTION
	beq		t0, t1, handle_exception_illegal_instruction
	# all other exceptions
	j		skip_this_instruction_after_sret
handle_exception_ebreak:
	# continue after ebreak when exiting trsp handler
	j		skip_this_instruction_after_sret
handle_exception_illegal_instruction:
	# TODO: code to emulate unsupported instructions could go here
	# continue after illegal instruction when exiting trsp handler
	j		skip_this_instruction_after_sret
skip_this_instruction_after_sret:
	LOAD	t0, (STK_FRAME_SIZE_FLOAT + STK_OFF_PC)(sp)
	addi	t0, t0, 4
	STORE	t0, (STK_FRAME_SIZE_FLOAT + STK_OFF_PC)(sp)
print_exception:
	li		a0, LOG_CRIT
	la		a1, string_exception_msg
	li		a2, 0								# no newline
	jal		log_no_newline
	# print sepc
	la		a0, string_epc_msg
	jal		print_string
	csrr	a0, sepc
	jal		print_hex
	# print scause
	la		a0, string_cause_msg
	jal		print_string
	csrr	a0, scause
	mv		s0, a0								# save for later
	jal		print_hex
	# print SCAUSE verbose
	li		a0, ' '
	jal		print_char
	li		a0, '('
	jal		print_char
	# each entry in CAUSE string table is 4 bytes
	# TODO: use a loop to go to the n-th entry in the table, would save "cause_verbose_table" and require less space
	addi	t0, s0, -20							# highest known cause +1		
	blt		t0, zero, known_cause
	# cause not in table
	LWU		a0, string_CAUSE_RESERVED
	j		output_cause
known_cause:
	slli	a0, s0, 2							# set a0 = xcause * 4
	la		s0, cause_verbose_table				# start of CAUSE string table
	add		a0, a0, s0
	LWU		a0, 0(a0)
output_cause:
	jal		print_string
	li		a0, ')'
	jal		print_char
	# print stval
	la		a0, string_tval_msg
	jal		print_string
	csrr	a0, stval
	jal		print_hex
	# end of printing
	jal		print_newline
	# dump registers to log
	jal 	log_saved_int_registers;
	jal		log_saved_float_registers;
	j 		exit_trap_handler


# we have an IRQ
handle_irq:
	# log message
	li		a0, LOG_DEBUG
	la		a1, string_timer_irq
	jal		log
	# set timer for next time
	jal		set_timer
	j 		exit_trap_handler


# return after IRQ or exception
exit_trap_handler:
	POP_ALL_FLOAT_REGISTERS
	POP_ALL_INT_REGISTERS
	# bye bye - jump to address in xepc (while staying in current mode, see above)
	sret
.size trap_handler, .-trap_handler


.section .rodata

.align 4
cause_verbose_table:
	.word string_CAUSE_MISALIGNED_FETCH			#  0
	.word string_CAUSE_FAULT_FETCH				#  1
	.word string_CAUSE_ILLEGAL_INSTRUCTION		#  2
	.word string_CAUSE_BREAKPOINT				#  3
	.word string_CAUSE_MISALIGNED_LOAD			#  4
	.word string_CAUSE_FAULT_LOAD				#  5
	.word string_CAUSE_MISALIGNED_STORE			#  6
	.word string_CAUSE_FAULT_STORE				#  7
	.word string_CAUSE_USER_ECALL				#  8
	.word string_CAUSE_SUPERVISOR_ECALL			#  9
	.word string_CAUSE_HYPERVISOR_ECALL			# 10
	.word string_CAUSE_MACHINE_ECALL			# 11
	.word string_CAUSE_FETCH_PAGE_FAULT			# 12
	.word string_CAUSE_LOAD_PAGE_FAULT			# 13
	.word string_CAUSE_RESERVED					# 14
	.word string_CAUSE_STORE_PAGE_FAULT			# 15
	.word string_CAUSE_RESERVED					# 16
	.word string_CAUSE_RESERVED					# 17
	.word string_CAUSE_SOFTWARE_CHECK			# 18
	.word string_CAUSE_HARDWARE_ERROR			# 19

string_CAUSE_MISALIGNED_FETCH:		.string "MISALIGNED_FETCH";
string_CAUSE_FAULT_FETCH:			.string "FAULT_FETCH";
string_CAUSE_ILLEGAL_INSTRUCTION:	.string "ILLEGAL_INSTRUCTION";
string_CAUSE_BREAKPOINT:			.string "BREAKPOINT";
string_CAUSE_MISALIGNED_LOAD:		.string "MISALIGNED_LOAD";
string_CAUSE_FAULT_LOAD:			.string "FAULT_LOAD";
string_CAUSE_MISALIGNED_STORE:		.string "MISALIGNED_STORE";
string_CAUSE_FAULT_STORE:			.string "FAULT_STORE";
string_CAUSE_USER_ECALL:			.string "USER_ECALL";
string_CAUSE_SUPERVISOR_ECALL:		.string "SUPERVISOR_ECALL";
string_CAUSE_HYPERVISOR_ECALL:		.string "HYPERVISOR_ECALL";
string_CAUSE_MACHINE_ECALL:			.string "MACHINE_ECALL";
string_CAUSE_FETCH_PAGE_FAULT:		.string "FETCH_PAGE_FAULT";
string_CAUSE_LOAD_PAGE_FAULT:		.string "LOAD_PAGE_FAULT";
string_CAUSE_STORE_PAGE_FAULT:		.string "STORE_PAGE_FAULT";
string_CAUSE_SOFTWARE_CHECK:		.string "SOFTWARE_CHECK";
string_CAUSE_HARDWARE_ERROR:		.string "HARDWARE_ERROR";
string_CAUSE_RESERVED:				.string "RESERVED_OR_CUSTOM";

string_exception_msg:
	.string "exception: "
string_epc_msg:
	.string "sepc=";
string_tval_msg:
	.string ", stval=";
string_cause_msg:
	.string ", scause=";

string_timer_irq: 
	.string "timer IRQ"

