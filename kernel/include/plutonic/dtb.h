/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#ifndef PLUTONIC_DTB_H
#define PLUTONIC_DTB_H

#include "plutonic/types.h"

extern int print_char(char c);
extern int print_hex(u64);
extern void print_newline(void);


/*
 * NOTE: all fdt structures use BIG ENDIAN values
 */
struct fdt_header {
	u32 magic;
	u32 totalsize;
	u32 off_dt_struct;
	u32 off_dt_strings;
	u32 off_mem_rsvmap;
	u32 version;
	u32 last_comp_version;
	u32 boot_cpuid_phys;
	u32 size_dt_strings;
	u32 size_dt_struct;
};

struct fdt_reserve_entry {
	u32 address;
	u32 size;
};

struct fdt_property {
	u32 len;
	u32 nameoff;
};

void print_dtb(void);


#endif /* PLUTONIC_DTB_H */
