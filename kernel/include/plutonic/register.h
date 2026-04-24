#ifndef PLUTONIC_REGISTER_H
#define PLUTONIC_REGISTER_H


/*
 * integer registers
 */
#if XLEN == 32
	#define	SAVE_X	sw
	#define LOAD_X	lw
	#define LWU		lw
	#define SWU		sw
#endif
#if XLEN == 64
	#define	SAVE_X	sd
	#define LOAD_X	ld
	#define LWU		lwu
	#define SWU		sw
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


#endif /* PLUTONIC_REGISTER_H */
