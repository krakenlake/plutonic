/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/drivers/uart/ns16550.h"
#include <plutonic/ASCII.h>
#include "plutonic/trap.h"
#include "plutonic/log.h"
#include "plutonic/stack.h"
#include "risc-v/register.h"

.global start


.section .init


# kernel entry point
start:

	#-------------------- hart control	
	# when booting in S-mode, only the hart we are running on is enabled

	#-------------------- IRQ control	
	# disable all S-mode IRQs
	csrci	sstatus, SSTATUS_SIE

	#-------------------- save incoming parameters
	# pointer to dtb is in a1
	la		t0, dtb
	SAVE_X	a1, 0(t0)

	#-------------------- init kernel stack
	# use initial value from linker
	la		sp, _estack

	#-------------------- "hart is alive" indicator
	# visual check that only one hart is running, in case that
	# more than one character appears, something is not right
	li		a0, '*'
	jal		print_char

	#-------------------- startup message
	la		a0, string_startup
	jal		print_string

	#-------------------- IRQ setup
	# set up trap vector
	la		t0, trap_handler
	csrw	stvec, t0
	# disable external and software IRQs
	li		t0, SIE_SSIE | SIE_SEIE
	csrc	sie, t0
	# set time for next timer IRQ
	jal		set_timer
	# enable timer IRQs
	li		t0, SIE_STIE
	csrs	sie, t0
	# enable S-mode irqs again
	csrsi	sstatus, SSTATUS_SIE

	#-------------------- print dtb
	la		t0, dtb
	LOAD_X	a0, 0(t0)
	jal		print_dtb
	beqz	a0, dtb_done
	mv		s1, a0					# save error code
	li		a0, LOG_ERR
	la		a1, string_dtb_error
	jal		log_no_newline
	mv		a0, s1
	jal		print_hex
	jal		print_newline
dtb_done:

	#-------------------- check exception catching
	# check ILLEGAL_INSTRUCTION exception
#	unimp
	# check BREAKPOINT exception
#	ebreak
	# check FAULT_LOAD exception
#	ld		t1, 0(t0)
	# check FAULT_STORE exception
	sd 		t1, 0(t0)

	li		s1, 0
# fall through from above
forever:
	wfi

	# check that s1 will be preserved in the loop
	addi	s1, s1, 1

	LOG_ALL_REGISTERS

	j		forever
.size start, .-start


plutonic_wait_hart:
	wfi
	j	plutonic_wait_hart
.size plutonic_wait_hart, .-plutonic_wait_hart


thread1:
	li		a0, '+'
	jal		print_char
	li		t0, 99999
busy_wait1:
	addi	t0, t0, -1
	bnez	t0, busy_wait1
	j		thread1


.section .rodata


string_startup:
	.ascii "\n"
	.ascii "\n        _       _              _"
	.ascii "\n  _ __ | |_   _| |_ ___  _ __ (_) ___"
	.ascii "\n | '_ \\| | | | | __/ _ \\| '_ \\| |/ __|"
	.ascii "\n | |_) | | |_| | || (_) | | | | | (__"
	.ascii "\n | .__/|_|\\__,_|\\__\\___/|_| |_|_|\\___|"
	.ascii "\n |_|"
	.ascii " experimental RISC-V kernel v";
	.ascii PLUTONIC_VERSION
	.asciz "\n\n"
.size string_startup, .-string_startup


string_dtb_error:
	.asciz "returned to main with error code "