/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once

#include "plutonic/types.h"


#ifndef __ASSEMBLER__

	extern u64 get_timestamp(void);
	extern void print_timestamp(void);

#endif
