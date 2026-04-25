/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

 #ifndef PLUTONIC_PRINT_H
#define PLUTONIC_PRINT_H


/*
 * Include files are included in .S and .c files, but C declarations
 * are invalid in assembly code, so they need to be guarded.
 *
 * __ASSEMBLER__ is a predefined macro in gcc.
 */
#ifndef __ASSEMBLER__
	extern int print_char(char);
	extern int print_string(char*);
	extern int print_decimal(unsigned long);
#endif


#endif /* PLUTONIC_PRINT_H */
