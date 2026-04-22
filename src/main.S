/*
 * plutonic - experimental RISC-V kernel
 */

#include "config.h"
#include "plutonic/drivers/uart/ns16550.h"
#include "plutonic/ASCII.h"
#include "plutonic/trap.h"
#include "plutonic/register.h"
#include "plutonic/log.h"



.global start


.section .init


# application entry point - activate our trap handler
start:
	# do not add anything before this

	#-------------------- hart control	
	# in M-Mode we need to make sure that we run only on one hart
	#ifdef M_MODE
		csrr	t0, mhartid
		# hart 0 only
		bnez	t0, plutonic_wait_hart
	#endif

	#-------------------- RVF init
	# enable RVF in xstatus of cpu 
	# (for M-mode at least this is disabled in QEMU per default)
	#ifdef HW_QEMU
		li		t0, 0b11
		slli	t0, t0, 13
		csrs	MODE_PREFIX(status), t0
	#endif

	#-------------------- save incoming parameters
	# pointer to dtb is in a1
	la		t0, dtb
	SAVE_X	a1, 0(t0)

	#-------------------- init kernel stack
	# use initial value from linker
	la		sp, _estack

	#-------------------- IRQ setup
	# set up trap vector
	la		t0, trap_handler
	csrw	MODE_PREFIX(tvec), t0

	# enable all x-mode irqs
	#ifdef M_MODE
		csrsi	MODE_PREFIX(status), 0b1000
	#endif
	#ifdef S_MODE
		csrsi	MODE_PREFIX(status), 0b0010
	#endif
	
	# set timer for the first time
	rdtime	t0
	li		t1, TIMER_INTERVAL
	add		t1, t0, t1
	la		t2, MTIMECMP
	sd		t1, 0(t2)
	# enable m-mode timer irq
	#ifdef M_MODE
		li		t1, 0b10000000
	#endif
	#ifdef S_MODE
		li		t1, 0b00100000
	#endif
	csrs	MODE_PREFIX(ie), t1

	#-------------------- console init
	#ifdef M_MODE
		jal		uart_init
	#endif

	#-------------------- "hart is alive" indicator
	li		a0, '*'
	jal		print_char
	li		a0, '0'
	jal		print_char

	#-------------------- startup message
	la		a0, string_startup
	jal		print_string

	#-------------------- print dtb
//	jal		print_dtb


forever:
	wfi
#	ebreak
	j		forever
.size start, .-start


plutonic_wait_hart:
	# convert hartid to ASCII number
	addi	a0, t0, 0x30
	# We cannot call print_string here, because that would mess up the
	# (still global) stack.	But we can call print_char, because that is
	# a leaf function and only requires ra to return properly.
	jal		print_char
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
	.asciz " - experimental RISC-V kernel\n\n";
.size string_startup, .-string_startup
