// ******************************************************************
// 
// Config for StarFive VisionFive 2 board (RV64GC CPU)
//
// ******************************************************************


#ifndef PLUTONIC_CONFIG_H
#define PLUTONIC_CONFIG_H

// hardware
#define HW_VF2
#define TARGET_HAS_RVF
#define XLEN	64
#define FLEN	64
#define TARGET_HAS_RVF

// include strings for verbose error messages?
#define ERROR_VERBOSE

// print a CR before each LF
// Note: at higher levels this varies by system but at this level most
// things expect both.
#define USE_CRLF

// size of character input buffer in bytes
#define BUFFER_SIZE			80

#endif /* PLUTONIC_CONFIG_H */
