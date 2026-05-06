/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once
#include "plutonic/types.h"

#define		FDT_HEADER_MAGIC	0xd00dfeed

#ifndef __ASSEMBLER__

	struct fdt_header {
		/* all BIG_ENDIAN */
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
		/* all BIG_ENDIAN */
		u32 address;
		u32 size;
	};

	struct fdt_property {
		/* all BIG_ENDIAN */
		u32 len;
		u32 nameoff;
	};

	long print_dtb(void);

#endif
