/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/time.h"
#include "plutonic/stack.h"

.global get_timestamp
.global print_timestamp

.text


get_timestamp:
	rdtime	a0
	ret
.size get_timestamp, .-get_timestamp

print_timestamp:
	addi	sp, sp, -(XLEN_BYTES*1)	
	SAVE_X	ra, 0(sp)
	rdtime	a0
	jal		print_decimal
	LOAD_X	ra, 0(sp)
	addi	sp, sp, (XLEN_BYTES*1)
	ret
.size print_timestamp, .-print_timestamp
