/*
 * plutonic - experimental RISC-V kernel
 */

#include "config.h"
#include "plutonic/drivers/uart/ns16550.h"
#include "plutonic/ASCII.h"
#include "plutonic/trap.h"


.global start


.section .init


# application entry point - activate our trap handler
start:

	# do not add anything before this

	# in M-Mode we need to make sure that we run only on one hart
	#ifdef M_MODE
		csrr	t0, mhartid
		# hart 0 only
		bnez	t0, plutonic_wait_hart
	#endif

	# enable RVF in xstatus of cpu 
	# (for M-mode at least this is disabled in QEMU per default)
	#ifdef HW_QEMU
		li		t0, 0b11
		slli	t0, t0, 13
		csrs	MODE_PREFIX(status), t0
	#endif

	# init kernel stack
	la		sp, _estack

	# set up trap vector
	la		t0, trap_handler
	csrw	MODE_PREFIX(tvec), t0

	# enable all x-mode irqs
	csrsi	MODE_PREFIX(status), 0b1000

	# set timer for the first time
	rdtime	t0
	li		t1, TIMER_INTERVAL
	add		t1, t0, t1
	la		t2, MTIMECMP
	sd		t1, 0(t2)
	# enable m-mode timer irq
	li		t1, 0b10000000
	csrs	MODE_PREFIX(ie), t1

	#ifdef M_MODE
		jal		uart_init
	#endif

	li		a0, '*'
	jal		print_char

	# startup message
	la		a0, string_startup
	jal		print_string

forever:
	# intentionally execute ebreak in order to enter trap handler
	wfi
#	ebreak
	j		forever
.size start, .-start


plutonic_wait_hart:
	wfi
	j	plutonic_wait_hart
.size plutonic_wait_hart, .-plutonic_wait_hart


.section .rodata


string_startup:
	.ascii "\n"
	.ascii "\n        _       _              _"
	.ascii "\n  _ __ | |_   _| |_ ___  _ __ (_) ___"
	.ascii "\n | '_ \\| | | | | __/ _ \\| '_ \\| |/ __|"
	.ascii "\n | |_) | | |_| | || (_) | | | | | (__"
	.ascii "\n | .__/|_|\\__,_|\\__\\___/|_| |_|_|\\___|"
	.ascii "\n |_|"
	.ascii "\n     v "
	.ascii PLUTONIC_VERSION
	.asciz " - experimental RISC-V kernel\n";
.size string_startup, .-string_startup

