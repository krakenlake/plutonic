/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/time.h"
#include "plutonic/stack.h"

.global get_timestamp

.text


get_timestamp:
	rdtime	a0
	ret
.size get_timestamp, .-get_timestamp
