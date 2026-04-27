/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#ifndef PLUTONIC_TRAP_H
#define PLUTONIC_TRAP_H

#include "config.h"

#define TIMER_INTERVAL		10000000

#ifdef HW_QEMU
	#define MTIMECMP		0x2004000		# QEMU CLINT 0x2000000 + 0x4000 + 8*(hart_id)
#endif


#endif /* PLUTONIC_TRAP_H */
