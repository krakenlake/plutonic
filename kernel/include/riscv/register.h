/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once
#include "config.h"


/*
 * integer registers
 */
#if XLEN == 32
	#define LOAD	lw
	#define	STORE	sw
	#define LWU		lw
	#define SWU		sw
#endif
#if XLEN == 64
	#define LOAD	ld
	#define	STORE	sd
	#define LWU		lwu
	#define SWU		swu
#endif
#define XLEN_BYTES			(XLEN/8)
#define NUM_INT_REGISTERS	32

/*
 * float registers
 */
#if FLEN == 32
	#define SAVE_F	fsw
	#define LOAD_F	flw
#endif
#if FLEN == 64
	#define	SAVE_F	fsd
	#define LOAD_F	fld
#endif
#define FLEN_BYTES				(FLEN/8)
#define NUM_FLOAT_REGISTERS		32

/*
 * CSR sstatus bits
 */
#define SSTATUS_SIE		(1 << 1)		// all IRQs
#define SSTATUS_SPIE	(1 << 5)		// prior enabled
#define SSTATUS_SPP		(1 << 8)		// privilege level

/*
 * CSR sie bits
 */
#define SIE_SSIE		(1 << 1)		// software IRQ
#define SIE_STIE		(1 << 5)		// timer IRQ
#define SIE_SEIE		(1 << 9)		// external IRQ

/*
 * CSR sip bits
 */
#define SIP_SSIP		(1 << 1)		// software IRQ
#define SIP_STIP		(1 << 5)		// timer IRQ
#define SIP_SEIP		(1 << 9)		// external IRQ

/*
 * scause exception types
 */
#define SCAUSE_MISALIGNED_FETCH			0
#define SCAUSE_FAULT_FETCH				1
#define SCAUSE_ILLEGAL_INSTRUCTION		2
#define SCAUSE_BREAKPOINT				3
#define SCAUSE_MISALIGNED_LOAD			4
#define SCAUSE_FAULT_LOAD				5
#define SCAUSE_MISALIGNED_STORE			6
#define SCAUSE_FAULT_STORE				7
#define SCAUSE_USER_ECALL				8
#define SCAUSE_SUPERVISOR_ECALL			9
#define SCAUSE_HYPERVISOR_ECALL			10
#define SCAUSE_MACHINE_ECALL			11
#define SCAUSE_FETCH_PAGE_FAULT			12
#define SCAUSE_LOAD_PAGE_FAULT			13
#define SCAUSE_RESERVED_14				14
#define SCAUSE_STORE_PAGE_FAULT			15
#define SCAUSE_RESERVED_16				16
#define SCAUSE_RESERVED_17				17
#define SCAUSE_SOFTWARE_CHECK			18
#define SCAUSE_HARDWARE_ERROR			19
