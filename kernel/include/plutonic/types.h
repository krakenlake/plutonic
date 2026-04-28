/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#ifndef PLUTONIC_TYPES_H
#define PLUTONIC_TYPES_H

/*
* Include files are included in .S and .c files, but C declarations
* are invalid in assembly code, so they need to be guarded.
*
* __ASSEMBLER__ is a predefined macro in gcc.
*/
#ifndef __ASSEMBLER__
	typedef unsigned int	u32;
	typedef unsigned long	u64;
#endif


#endif /* PLUTONIC_TYPES_H */
