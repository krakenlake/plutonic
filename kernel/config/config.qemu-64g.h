// ******************************************************************
// 
// Config for QEMU RV64G
//
// ******************************************************************
#pragma once

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
