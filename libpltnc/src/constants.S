/*
 * librv64strings - RISC-V strings library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "libpltnc/strings.h"

.global check_zero_consts

.section .rodata


.align 8
check_zero_consts:
	.quad HAS_ZERO_BYTE_MAGIC_1
	.quad HAS_ZERO_BYTE_MAGIC_2
