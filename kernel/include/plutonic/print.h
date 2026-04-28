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
	extern int print_char(char);
	extern int print_string(char*);
	extern int print_decimal(unsigned long);
	extern int print_hex(u64);
	extern void print_newline(void);
#endif


#endif /* PLUTONIC_PRINT_H */
