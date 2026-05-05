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
#include "libpltnc/byteorder.h"

struct fdt_header *dtb;


long print_dtb(void)
{
	log(LOG_INFO, "looking for dtb...");

	if (dtb == 0) {
		log(LOG_ERR, "no dtb");
		return ERR_NOTFOUND;
	}

	u32 magic_be = dtb->magic;
	log_hex(LOG_DEBUG, "dtb magic BIG_ENDIAN = ", magic_be);

	u32 magic_le = be32_to_cpu(magic_be);
	log_hex(LOG_DEBUG, "dtb magic LITTLE_ENDIAN = ", magic_le);

	if (magic_le == FDT_HEADER_MAGIC) {
		log_hex(LOG_INFO, "found dtb @", (u64)dtb);
	} else {
		log_hex(LOG_ERR, "dtb magic number does not match, expected ", FDT_HEADER_MAGIC);
		return ERR_CORRUPT;
	}

	u64 strings_offset = (u32)be32_to_cpu(dtb->off_dt_strings);
	u64 strings_start_addr = (u64)(dtb + strings_offset);
	log_hex(LOG_DEBUG, "strings section @", strings_start_addr);

	u32 struct_offset = (u32)be32_to_cpu(dtb->off_dt_struct);
	u64 struct_start_addr = (u64)dtb + struct_offset;
	log_hex(LOG_DEBUG, "struct section @", struct_start_addr);

	u32 mem_rsvmap_offset = (u32)be32_to_cpu(dtb->off_mem_rsvmap);
	u64 mem_rsvmap_start_addr = (u64)dtb + mem_rsvmap_offset;
	log_hex(LOG_DEBUG, "mem_rsvmap section @", mem_rsvmap_start_addr);

	log_str(LOG_DEBUG, "first string = ", (char*)strings_start_addr);

	throw_error(ERR_DUMMY);

	return ERR_OK;
}