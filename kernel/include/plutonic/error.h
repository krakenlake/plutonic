/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#ifndef PLUTONIC_ERROR_H
#define PLUTONIC_ERROR_H


#include "plutonic/types.h"

#define ERR_OK					0
#define ERR_NOTFOUND			1
#define ERR_CORRUPT				2

#ifndef __ASSEMBLER__
	extern u64 error_handler(u64 error_number);
#endif


#endif /* PLUTONIC_ERROR_H */
