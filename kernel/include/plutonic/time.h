/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef PLUTONIC_TIME_H
#define PLUTONIC_TIME_H


#include "plutonic/types.h"

#ifndef __ASSEMBLER__
	extern u64 get_timestamp(void);
	extern void print_timestamp(void);
#endif


#endif /* PLUTONIC_TIME_H */
