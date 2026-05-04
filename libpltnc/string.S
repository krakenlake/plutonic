/*
 * libpltnc - RISC-V library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "risc-v/register.h"


.global strcat


.text

# in: a0 = char* string1
# in: a1 = char* string2
# out: a0 = char* string1
strcat:
	mv		t2, a0					# save a0
strcat_loop1:
	lb		t0, 0(a0)
	beqz	t0, strcat_str1_ended
	addi	a0, a0, 1
	j		strcat_loop1	
strcat_str1_ended:
strcat_loop2:
	lb		t1, 0(a1)
	beqz	t1, strcat_str2_ended
	sb		t1, 0(a0)
	addi	a0, a0, 1
	addi	a1, a1, 1
	j		strcat_loop2
strcat_str2_ended:
	sb		zero, 0(a0)
	mv		a0, t2
	ret
.size strcat, .-strcat