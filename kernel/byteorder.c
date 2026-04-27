/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#include "config.h"
#include "plutonic/byteorder.h"


inline u32 be32_to_cpu(u32 val)
{
	return ((val >> 24) & 0xff) |
			((val << 8) & 0xff0000) |
			((val >> 8) & 0xff00) |
			((val << 24) & 0xff000000);
}
