// ******************************************************************
// 
// Config for QEMU RV64G
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

// size of character input buffer in bytes
#define BUFFER_SIZE			80

#endif /* PLUTONIC_CONFIG_H */
