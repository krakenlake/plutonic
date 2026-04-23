// ******************************************************************
// 
// Config for QEMU RV64G (=RV64IMAF) full version 
// (all features)
//
// ******************************************************************


#ifndef PLUTONIC_CONFIG_H
#define PLUTONIC_CONFIG_H

// hardware
#define HW_QEMU
#define XLEN	64
#define FLEN	64
#define TARGET_HAS_RVF
#define TARGET_HAS_SSTC

// include strings for verbose error messages?
#define ERROR_VERBOSE

// default number of lines for the "d" command if no end address is given
#define	DEFAULT_D_LINES		16

// default number of lines for the "m" command if no end address is given
#define M_BYTES_PER_LINE	16
#define DEFAULT_M_LINES		16

// print a space after commas in disassembler output
#define SPACE_AFTER_COMMA

// print a CR before each LF
// Note: at higher levels this varies by system but at this level most
// things expect both.
#define USE_CRLF

// size of character input buffer in bytes
#define BUFFER_SIZE			80

#endif /* PLUTONIC_CONFIG_H */
