/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once
#include "plutonic/types.h"

#define ERR_OK					0
#define ERR_DUMMY				1
#define ERR_NOTFOUND			2
#define ERR_CORRUPT				3
#define ERR_SBI					4

#ifndef __ASSEMBLER__
	extern u64 throw_error(u64 error_code);
#endif
