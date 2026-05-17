/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/log.h"
#include "plutonic/dtb.h"
#include "plutonic/types.h"
#include "plutonic/print.h"
#include "plutonic/error.h"
#include "libpltnc/bitwise.h"

struct fdt_header *dtb;


long print_dtb(void)
{
	log(LOG_INFO, "looking for dtb...");

	if (dtb == 0) {
		log(LOG_ERR, "no dtb");
		return ERR_NOTFOUND;
	}

	u32 magic_be = dtb->magic;
	log(LOG_DEBUG, "dtb magic BIG_ENDIAN = 0x%08x", magic_be);

	u32 magic_le = swap32(magic_be);
	log(LOG_DEBUG, "dtb magic LITTLE_ENDIAN = 0x%08x", magic_le);

	if (magic_le == FDT_HEADER_MAGIC) {
		log(LOG_INFO, "found dtb @0x%08x", (u64)dtb);
	} else {
		log(LOG_ERR, "dtb magic number does not match, expected 0x%08x", FDT_HEADER_MAGIC);
		return ERR_CORRUPT;
	}

	u64 strings_offset = (u32)swap32(dtb->off_dt_strings);
	u64 strings_start_addr = (u64)(dtb + strings_offset);
	log(LOG_DEBUG, "strings section @0x%08x", strings_start_addr);

	u32 struct_offset = (u32)swap32(dtb->off_dt_struct);
	u64 struct_start_addr = (u64)dtb + struct_offset;
	log(LOG_DEBUG, "struct section @0x%08x", struct_start_addr);

	u32 mem_rsvmap_offset = (u32)swap32(dtb->off_mem_rsvmap);
	u64 mem_rsvmap_start_addr = (u64)dtb + mem_rsvmap_offset;
	log(LOG_DEBUG, "mem_rsvmap section @0x%08x", mem_rsvmap_start_addr);

	log(LOG_DEBUG, "first string = %s", (char*)strings_start_addr);

	throw_error(ERR_DUMMY);

	return ERR_OK;
}