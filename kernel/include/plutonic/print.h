/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef PLUTONIC_PRINT_H
#define PLUTONIC_PRINT_H


#include "plutonic/types.h"

#ifndef __ASSEMBLER__
	extern void print_char(char c);
	extern void print_string(char* str);
	extern void print_decimal(u64 val);
	extern void print_hex(u64 val);
	extern void print_newline(void);
#endif


#endif /* PLUTONIC_PRINT_H */
