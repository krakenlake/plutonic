/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/ASCII.h"
#include "plutonic/stack.h"
#include "risc-v/register.h"

.global be32_to_cpu
.global cpu_to_be32
.global swap32

.text


# swap lower 4 bytes: big endian to low endian
# in: a0
# out: a0
be32_to_cpu:
cpu_to_be32:
swap32:
	mv		a1, zero			# init result
	# byte 0
	li		t1, 0xff			# init AND mask
	srli	t0, a0, 24			# shift byte 3 -> byte 0
	and		a1, t0, t1			# collect result in a1
	# byte 1
	slli	t1, t1, 8			# move AND mask one byte left
	srli	t0, a0, 8			# shift byte 2 -> byte 1
	and		t2, t0, t1			
	or		a1, a1, t2			# collect result in a1
	# byte 2
	slli	t1, t1, 8			# move AND mask one byte left
	slli	t0, a0, 8			# shift byte 1 -> byte 2
	and		t2, t0, t1
	or		a1, a1, t2			# collect result in a1
	# byte 3
	slli	t1, t1, 8			# move AND mask one byte left
	slli	t0, a0, 24			# shift byte 0 -> byte 3
	and		t2, t0, t1
	or		a0, a1, t2			# final return register is a0
	sext.w	a0, a0				# sign-extend final result
	ret
.size be32_to_cpu, .-be32_to_cpu
