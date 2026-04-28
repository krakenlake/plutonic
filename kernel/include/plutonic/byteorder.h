/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#ifndef PLUTONIC_BYTEORDER_H
#define PLUTONIC_BYTEORDER_H

#include "plutonic/types.h"

/*
 * Include files are included in .S and .c files, but C declarations
 * are invalid in assembly code, so they need to be guarded.
 *
 * __ASSEMBLER__ is a predefined macro in gcc.
 */
#ifndef __ASSEMBLER__
	u32 be32_to_cpu(u32 val);
	u32 cpu_to_be32(u32 val);
#endif


#endif /* PLUTONIC_BYTEORDER_H */
