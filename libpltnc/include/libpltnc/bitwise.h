/*
 * libpltnc - RISC-V library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef LIBPLTNC_BITWISE_H
#define LIBPLTNC_BITWISE_H


#include "libpltnc/types.h"

#ifndef __ASSEMBLER__
	u32 swap32(u32 val);
	u64 has_zero_byte(u64 val);
#endif


#endif /* LIBPLTNC_BITWISE_H */
