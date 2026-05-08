/*
 * libsbicall - RISC-V SBI wrapper
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "libsbicall/sbicall.h"


/*
 * TIME extension
 */

struct sbiret sbi_system_reset(unsigned int reset_type, 
							unsigned int reset_reason)
{
	return sbicall(reset_type, reset_reason, 0, 0, 0, 0,
		FID_sbi_system_reset, EID_TIME);
}

