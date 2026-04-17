#ifndef PLUTONIC_REGISTER_H
#define PLUTONIC_REGISTER_H

// int register width
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

// float register width
#if FLEN == 32
	#define SAVE_F	fsw
	#define LOAD_F	flw
#endif
#if FLEN == 64
	#define	SAVE_F	fsd
	#define LOAD_F	fld
#endif
#define FLEN_BYTES			(FLEN/8)

#define NUM_FLOAT_REGISTERS		32

#endif /* PLUTONIC_REGISTER_H */
