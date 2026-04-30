/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef PLUTONIC_STACK_H
#define PLUTONIC_STACK_H

#include "config.h"
#include "risc-v/register.h"

#ifndef __ASSEMBLER__
	void log_saved_int_registers(void);
	void log_saved_float_registers(void);
#endif

/*
 * int register offsets from start of int stack frame
 * store pc in position 0; x0 is always 0 and will not be saved on stack
 */
#define STK_FRAME_SIZE_INT	(XLEN_BYTES * NUM_INT_REGISTERS)
#define STK_OFF_PC			(0)
#define STK_OFF_X1			(XLEN_BYTES*1)
#define STK_OFF_X2			(XLEN_BYTES*2)
#define STK_OFF_X3			(XLEN_BYTES*3)
#define STK_OFF_X4			(XLEN_BYTES*4)
#define STK_OFF_X5			(XLEN_BYTES*5)
#define STK_OFF_X6			(XLEN_BYTES*6)
#define STK_OFF_X7			(XLEN_BYTES*7)
#define STK_OFF_X8			(XLEN_BYTES*8)
#define STK_OFF_X9			(XLEN_BYTES*9)
#define STK_OFF_X10			(XLEN_BYTES*10)
#define STK_OFF_X11			(XLEN_BYTES*11)
#define STK_OFF_X12			(XLEN_BYTES*12)
#define STK_OFF_X13			(XLEN_BYTES*13)
#define STK_OFF_X14			(XLEN_BYTES*14)
#define STK_OFF_X15			(XLEN_BYTES*15)
#define STK_OFF_X16			(XLEN_BYTES*16)
#define STK_OFF_X17			(XLEN_BYTES*17)
#define STK_OFF_X18			(XLEN_BYTES*18)
#define STK_OFF_X19			(XLEN_BYTES*19)
#define STK_OFF_X20			(XLEN_BYTES*20)
#define STK_OFF_X21			(XLEN_BYTES*21)
#define STK_OFF_X22			(XLEN_BYTES*22)
#define STK_OFF_X23			(XLEN_BYTES*23)
#define STK_OFF_X24			(XLEN_BYTES*24)
#define STK_OFF_X25			(XLEN_BYTES*25)
#define STK_OFF_X26			(XLEN_BYTES*26)
#define STK_OFF_X27			(XLEN_BYTES*27)
#define STK_OFF_X28			(XLEN_BYTES*28)
#define STK_OFF_X29			(XLEN_BYTES*29)
#define STK_OFF_X30			(XLEN_BYTES*30)
#define STK_OFF_X31			(XLEN_BYTES*31)
// aliases
#define STK_OFF_RA			(STK_OFF_X1)
#define STK_OFF_SP			(STK_OFF_X2)

/*
 * float register offsets from start of float stack frame
 */
#define STK_FRAME_SIZE_FLOAT	(FLEN_BYTES * NUM_FLOAT_REGISTERS)
#define STK_OFF_F0				(0)
#define STK_OFF_F1				(FLEN_BYTES*1)
#define STK_OFF_F2				(FLEN_BYTES*2)
#define STK_OFF_F3				(FLEN_BYTES*3)
#define STK_OFF_F4				(FLEN_BYTES*4)
#define STK_OFF_F5				(FLEN_BYTES*5)
#define STK_OFF_F6				(FLEN_BYTES*6)
#define STK_OFF_F7				(FLEN_BYTES*7)
#define STK_OFF_F8				(FLEN_BYTES*8)
#define STK_OFF_F9				(FLEN_BYTES*9)
#define STK_OFF_F10				(FLEN_BYTES*10)
#define STK_OFF_F11				(FLEN_BYTES*11)
#define STK_OFF_F12				(FLEN_BYTES*12)
#define STK_OFF_F13				(FLEN_BYTES*13)
#define STK_OFF_F14				(FLEN_BYTES*14)
#define STK_OFF_F15				(FLEN_BYTES*15)
#define STK_OFF_F16				(FLEN_BYTES*16)
#define STK_OFF_F17				(FLEN_BYTES*17)
#define STK_OFF_F18				(FLEN_BYTES*18)
#define STK_OFF_F19				(FLEN_BYTES*19)
#define STK_OFF_F20				(FLEN_BYTES*20)
#define STK_OFF_F21				(FLEN_BYTES*21)
#define STK_OFF_F22				(FLEN_BYTES*22)
#define STK_OFF_F23				(FLEN_BYTES*23)
#define STK_OFF_F24				(FLEN_BYTES*24)
#define STK_OFF_F25				(FLEN_BYTES*25)
#define STK_OFF_F26				(FLEN_BYTES*26)
#define STK_OFF_F27				(FLEN_BYTES*27)
#define STK_OFF_F28				(FLEN_BYTES*28)
#define STK_OFF_F29				(FLEN_BYTES*29)
#define STK_OFF_F30				(FLEN_BYTES*30)
#define STK_OFF_F31				(FLEN_BYTES*31)

/*
 * function prologue/epilogue optimisation
 */
#define PUSH_RA						jal		gp, push_ra
#define POP_RA_RET					j		pop_ra_ret
#define PUSH_S0_RA					jal		gp, push_s0_ra
#define POP_S0_RA_RET				j		pop_s0_ra_ret
#define PUSH_S1_S0_RA				jal		gp, push_s1_s0_ra
#define POP_S1_S0_RA_RET			j		pop_s1_s0_ra_ret
#define PUSH_TP_S1_S0_RA			jal		gp, push_tp_s1_s0_ra
#define POP_TP_S1_S0_RA_RET			j		pop_tp_s1_s0_ra_ret

/*
 * push/pop registers
 */
#define PUSH_ALL_INT_REGISTERS \
	addi	sp, sp, -(STK_FRAME_SIZE_INT);		\
	SAVE_X	ra, (STK_OFF_RA)(sp);				\
	SAVE_X	x3, (STK_OFF_X3)(sp);				\
	SAVE_X	x4, (STK_OFF_X4)(sp);				\
	SAVE_X	x5, (STK_OFF_X5)(sp);				\
	SAVE_X	x6, (STK_OFF_X6)(sp);				\
	SAVE_X	x7, (STK_OFF_X7)(sp);				\
	SAVE_X	x8, (STK_OFF_X8)(sp);				\
	SAVE_X	x9, (STK_OFF_X9)(sp);				\
	SAVE_X	x10, (STK_OFF_X10)(sp);				\
	SAVE_X	x11, (STK_OFF_X11)(sp);				\
	SAVE_X	x12, (STK_OFF_X12)(sp);				\
	SAVE_X	x13, (STK_OFF_X13)(sp);				\
	SAVE_X	x14, (STK_OFF_X14)(sp);				\
	SAVE_X	x15, (STK_OFF_X15)(sp);				\
	SAVE_X	x16, (STK_OFF_X16)(sp);				\
	SAVE_X	x17, (STK_OFF_X17)(sp);				\
	SAVE_X	x18, (STK_OFF_X18)(sp);				\
	SAVE_X	x19, (STK_OFF_X19)(sp);				\
	SAVE_X	x20, (STK_OFF_X20)(sp);				\
	SAVE_X	x21, (STK_OFF_X21)(sp);				\
	SAVE_X	x22, (STK_OFF_X22)(sp);				\
	SAVE_X	x23, (STK_OFF_X23)(sp);				\
	SAVE_X	x24, (STK_OFF_X24)(sp);				\
	SAVE_X	x25, (STK_OFF_X25)(sp);				\
	SAVE_X	x26, (STK_OFF_X26)(sp);				\
	SAVE_X	x27, (STK_OFF_X27)(sp);				\
	SAVE_X	x28, (STK_OFF_X28)(sp);				\
	SAVE_X	x29, (STK_OFF_X29)(sp);				\
	SAVE_X	x30, (STK_OFF_X30)(sp);				\
	SAVE_X	x31, (STK_OFF_X31)(sp);				\
	addi	t0, sp, STK_FRAME_SIZE_INT;			\
	SAVE_X	t0, (STK_OFF_SP)(sp);				\
	csrr	t0, sepc;							\
	SAVE_X	t0, (STK_OFF_PC)(sp);				\
	;

#define PUSH_ALL_FLOAT_REGISTERS \
	addi	sp, sp, -(STK_FRAME_SIZE_FLOAT);	\
	SAVE_F	f0, (STK_OFF_F0)(sp);				\
	SAVE_F	f1, (STK_OFF_F1)(sp);				\
	SAVE_F	f2, (STK_OFF_F2)(sp);				\
	SAVE_F	f3, (STK_OFF_F3)(sp);				\
	SAVE_F	f4, (STK_OFF_F4)(sp);				\
	SAVE_F	f5, (STK_OFF_F5)(sp);				\
	SAVE_F	f6, (STK_OFF_F6)(sp);				\
	SAVE_F	f7, (STK_OFF_F7)(sp);				\
	SAVE_F	f8, (STK_OFF_F8)(sp);				\
	SAVE_F	f9, (STK_OFF_F9)(sp);				\
	SAVE_F	f10, (STK_OFF_F10)(sp);				\
	SAVE_F	f11, (STK_OFF_F11)(sp);				\
	SAVE_F	f12, (STK_OFF_F12)(sp);				\
	SAVE_F	f13, (STK_OFF_F13)(sp);				\
	SAVE_F	f14, (STK_OFF_F14)(sp);				\
	SAVE_F	f15, (STK_OFF_F15)(sp);				\
	SAVE_F	f16, (STK_OFF_F16)(sp);				\
	SAVE_F	f17, (STK_OFF_F17)(sp);				\
	SAVE_F	f18, (STK_OFF_F18)(sp);				\
	SAVE_F	f19, (STK_OFF_F19)(sp);				\
	SAVE_F	f20, (STK_OFF_F20)(sp);				\
	SAVE_F	f21, (STK_OFF_F21)(sp);				\
	SAVE_F	f22, (STK_OFF_F22)(sp);				\
	SAVE_F	f23, (STK_OFF_F23)(sp);				\
	SAVE_F	f24, (STK_OFF_F24)(sp);				\
	SAVE_F	f25, (STK_OFF_F25)(sp);				\
	SAVE_F	f26, (STK_OFF_F26)(sp);				\
	SAVE_F	f27, (STK_OFF_F27)(sp);				\
	SAVE_F	f28, (STK_OFF_F28)(sp);				\
	SAVE_F	f29, (STK_OFF_F29)(sp);				\
	SAVE_F	f30, (STK_OFF_F30)(sp);				\
	SAVE_F	f31, (STK_OFF_F31)(sp);				\
	;

#define POP_ALL_FLOAT_REGISTERS \
	LOAD_F	f0, (STK_OFF_F0)(sp);				\
	LOAD_F	f1, (STK_OFF_F1)(sp);				\
	LOAD_F	f2, (STK_OFF_F2)(sp);				\
	LOAD_F	f3, (STK_OFF_F3)(sp);				\
	LOAD_F	f4, (STK_OFF_F4)(sp);				\
	LOAD_F	f5, (STK_OFF_F5)(sp);				\
	LOAD_F	f6, (STK_OFF_F6)(sp);				\
	LOAD_F	f7, (STK_OFF_F7)(sp);				\
	LOAD_F	f8, (STK_OFF_F8)(sp);				\
	LOAD_F	f9, (STK_OFF_F9)(sp);				\
	LOAD_F	f10, (STK_OFF_F10)(sp);				\
	LOAD_F	f11, (STK_OFF_F11)(sp);				\
	LOAD_F	f12, (STK_OFF_F12)(sp);				\
	LOAD_F	f13, (STK_OFF_F13)(sp);				\
	LOAD_F	f14, (STK_OFF_F14)(sp);				\
	LOAD_F	f15, (STK_OFF_F15)(sp);				\
	LOAD_F	f16, (STK_OFF_F16)(sp);				\
	LOAD_F	f17, (STK_OFF_F17)(sp);				\
	LOAD_F	f18, (STK_OFF_F18)(sp);				\
	LOAD_F	f19, (STK_OFF_F19)(sp);				\
	LOAD_F	f20, (STK_OFF_F20)(sp);				\
	LOAD_F	f21, (STK_OFF_F21)(sp);				\
	LOAD_F	f22, (STK_OFF_F22)(sp);				\
	LOAD_F	f23, (STK_OFF_F23)(sp);				\
	LOAD_F	f24, (STK_OFF_F24)(sp);				\
	LOAD_F	f25, (STK_OFF_F25)(sp);				\
	LOAD_F	f26, (STK_OFF_F26)(sp);				\
	LOAD_F	f27, (STK_OFF_F27)(sp);				\
	LOAD_F	f28, (STK_OFF_F28)(sp);				\
	LOAD_F	f29, (STK_OFF_F29)(sp);				\
	LOAD_F	f30, (STK_OFF_F30)(sp);				\
	LOAD_F	f31, (STK_OFF_F31)(sp);				\
	addi	sp, sp, (STK_FRAME_SIZE_FLOAT);		\
	;

#define POP_ALL_INT_REGISTERS \
	LOAD_X	t0, STK_OFF_PC(sp);					\
	csrw	sepc, t0;							\
	LOAD_X	ra, (STK_OFF_RA)(sp);				\
	LOAD_X	x3, (STK_OFF_X3)(sp);				\
	LOAD_X	x4, (STK_OFF_X4)(sp);				\
	LOAD_X	x5, (STK_OFF_X5)(sp);				\
	LOAD_X	x6, (STK_OFF_X6)(sp);				\
	LOAD_X	x7, (STK_OFF_X7)(sp);				\
	LOAD_X	x8, (STK_OFF_X8)(sp);				\
	LOAD_X	x9, (STK_OFF_X9)(sp);				\
	LOAD_X	x10, (STK_OFF_X10)(sp);				\
	LOAD_X	x11, (STK_OFF_X11)(sp);				\
	LOAD_X	x12, (STK_OFF_X12)(sp);				\
	LOAD_X	x13, (STK_OFF_X13)(sp);				\
	LOAD_X	x14, (STK_OFF_X14)(sp);				\
	LOAD_X	x15, (STK_OFF_X15)(sp);				\
	LOAD_X	x16, (STK_OFF_X16)(sp);				\
	LOAD_X	x17, (STK_OFF_X17)(sp);				\
	LOAD_X	x18, (STK_OFF_X18)(sp);				\
	LOAD_X	x19, (STK_OFF_X19)(sp);				\
	LOAD_X	x20, (STK_OFF_X20)(sp);				\
	LOAD_X	x21, (STK_OFF_X21)(sp);				\
	LOAD_X	x22, (STK_OFF_X22)(sp);				\
	LOAD_X	x23, (STK_OFF_X23)(sp);				\
	LOAD_X	x24, (STK_OFF_X24)(sp);				\
	LOAD_X	x25, (STK_OFF_X25)(sp);				\
	LOAD_X	x26, (STK_OFF_X26)(sp);				\
	LOAD_X	x27, (STK_OFF_X27)(sp);				\
	LOAD_X	x28, (STK_OFF_X28)(sp);				\
	LOAD_X	x29, (STK_OFF_X29)(sp);				\
	LOAD_X	x30, (STK_OFF_X30)(sp);				\
	LOAD_X	x31, (STK_OFF_X31)(sp);				\
	addi	sp, sp, (STK_FRAME_SIZE_INT);		\
	;

/*
 * dump all registers to log
 */
#define LOG_ALL_REGISTERS \
	PUSH_ALL_INT_REGISTERS						\
	PUSH_ALL_FLOAT_REGISTERS					\
	jal 	log_saved_int_registers;			\
	jal		log_saved_float_registers;		\
	POP_ALL_FLOAT_REGISTERS						\
	POP_ALL_INT_REGISTERS						\
	;

#endif /* PLUTONIC_STACK_H */
