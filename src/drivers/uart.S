/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/drivers/uart/ns16550.h"
#include "plutonic/ASCII.h"
#include "plutonic/stack.h"
#include "riscv/register.h"
#include "libsbicall/sbicall.h"

.global uart_init
.global uart_wait_get_char
.global uart_output_char
.global uart_output_string
.global uart_getline

.text


uart_init:
	li		t1, UART_BASE
	li		t0, UART_MODE_8N1
	sb		t0, UART_REG_LSR(t1)
	ret
.size uart_init, .-uart_init


uart_clear_buffer:
	la		t0, uart_input_buffer
	addi	t1, t0, BUFFER_SIZE
uart_clear_buffer_loop:
	sw		zero, 0(t0)
	addi	t0, t0, 4
	ble		t0, t1, uart_clear_buffer_loop
	ret
.size uart_clear_buffer, .-uart_clear_buffer


# wait and get one character from UART
# out: char (ASCII) in a0
uart_wait_get_char:
	li		t0, UART_BASE
uart_get_char_wait:
	# busy wait for key pressed
	# TODO: use interrupt instead of polling
	lb		a0, UART_REG_LSR(t0)				# read Line Status Register
	and		a0, a0, 0x01
	beqz	a0, uart_get_char_wait				# wait for char input
	lbu		a0, 0(t0)							# get input from UART  
	ret
.size uart_wait_get_char, .-uart_wait_get_char


# output zero-terminated string
# in: string ptr in a0
uart_output_string:
	addi	sp, sp, -(XLEN_BYTES*2)	
	STORE	ra, 0(sp)
	STORE	s1, 8(sp)
	mv		s1, a0
uart_output_string_loop:
	lb		a0, 0(s1)
	beqz	a0, uart_output_string_done
	jal		uart_output_char
	addi	s1, s1, 1
	j		uart_output_string_loop
uart_output_string_done:
	LOAD	ra, 0(sp)
	LOAD	s1, 8(sp)
	addi	sp, sp, (XLEN_BYTES*2)
	ret
.size uart_output_string, .-uart_output_string


# output one char to console via SBI
# in: char (ASCII) in a0
uart_output_char:
	# save a0 and a1 over SBI calls
	addi	sp, sp, -(XLEN_BYTES*2)
	STORE	ra, 0(sp)
	STORE	s1, 8(sp)
	# save char
	mv		s1, a0
	# prepare ecall parameters
	li		a7, SBI_EID_DBCN
	li		a6, SBI_FID_sbi_debug_console_write_byte
	# print CR first if we have an LF to print
	li		t0, ASCII_LF
	bne		a0, t0, uart_output_char_skip_CR
	li		a0, ASCII_CR
	# call SBI
	ecall
	mv		a0, s1
uart_output_char_skip_CR:
	# call SBI
	ecall
	LOAD	ra, 0(sp)
	LOAD	s1, 8(sp)
	addi	sp, sp, (XLEN_BYTES*2)	
	ret
.size uart_output_char, .-uart_output_char


.bss


.align 8

.comm uart_input_buffer, BUFFER_SIZE
.size uart_input_buffer, BUFFER_SIZE
