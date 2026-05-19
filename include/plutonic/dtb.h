/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once

#define	FDT_HEADER_MAGIC	(0xd00dfeed)
#define FDT_BEGIN_NODE		(0x00000001)
#define FDT_END_NODE		(0x00000002)
#define FDT_PROP			(0x00000003)
#define FDT_NOP				(0x00000004)
#define FDT_END				(0x00000009)


#ifndef __ASSEMBLER__
	#include "plutonic/types.h"

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
		u64 address;
		u64 size;
	};

	struct fdt_property {
		/* all BIG_ENDIAN */
		u32 len;
		u32 nameoff;
	};

	long print_dtb(void);

#endif
