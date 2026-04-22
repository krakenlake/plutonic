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
	# when booting in S-mode, only the hart we are running on is enabled

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
	csrw	stvec, t0

	# enable all S-mode irqs
	csrsi	sstatus, 0b0010
	
	# set timer for the first time
	rdtime	t0
	li		t1, TIMER_INTERVAL
	add		t1, t0, t1
	la		t2, MTIMECMP
	sd		t1, 0(t2)
	# enable timer irq
	li		t1, 0b00100000
	csrs	sie, t1

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
	ebreak
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
	.asciz " - experimental RISC-V kernel\n\n";
.size string_startup, .-string_startup
