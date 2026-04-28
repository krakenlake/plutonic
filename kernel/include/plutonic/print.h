/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#ifndef PLUTONIC_PRINT_H
#define PLUTONIC_PRINT_H


#ifndef __ASSEMBLER__
	extern int print_char(char);
	extern int print_string(char*);
	extern int print_decimal(unsigned long);
#endif


#endif /* PLUTONIC_PRINT_H */
