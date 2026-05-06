/*
 * librv64strings - RISC-V strings library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once

#define	HAS_ZERO_BYTE_MAGIC_1	0x0101010101010101
#define	HAS_ZERO_BYTE_MAGIC_2	0x8080808080808080

#ifndef __ASSEMBLER__
	extern u64		strlen(char *str);
	extern char*	strchain(char *str1, char *str2);
#endif
