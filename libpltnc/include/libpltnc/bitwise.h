/*
 * libpltnc - RISC-V library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef LIBPLTNC_BITWISE_H
#define LIBPLTNC_BITWISE_H


#include "libpltnc/types.h"

#define LIBPLTNC_BITWISE_CONST1	0x0101010101010101
#define LIBPLTNC_BITWISE_CONST2	0x8080808080808080

#ifndef __ASSEMBLER__
	u32 swap32(u32 val);
	u64 has_zero_byte(u64 val);
#endif


#endif /* LIBPLTNC_BITWISE_H */
