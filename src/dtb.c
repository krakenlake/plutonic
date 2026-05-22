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
#include "libpltnc/byteswap.h"

fdt_header *dtb;


long print_dtb(void)
{
	log(LOG_INFO, "looking for in-memory dtb passed in a1");

	if (dtb == 0) {
		log(LOG_ERR, "no dtb");
		return ERR_NOTFOUND;
	}

	u64 magic_le = swap32((u32)dtb->magic);
	log(LOG_DEBUG, "dtb magic = 0x%08x", magic_le);

	if (magic_le == FDT_HEADER_MAGIC) {
		log(LOG_INFO, "magic number 0x%08x found @ 0x%016lx", FDT_HEADER_MAGIC, (u64)dtb);
	} else {
		log(LOG_ERR, "dtb magic number @ 0x%016lx does not match, expected 0x%08x", (u64)dtb, FDT_HEADER_MAGIC);
		return ERR_MAGIC;
	}

	u64 boot_cpuid_phys = (u64)swap32(dtb->boot_cpuid_phys);
	log(LOG_DEBUG, "booting on CPU %ld", boot_cpuid_phys);

	u64 strings_offset = (u64)swap32(dtb->off_dt_strings);
	u64 strings_start_addr = (u64)dtb + strings_offset;
	u64 strings_end_addr = strings_start_addr +  (u64)swap32(dtb->size_dt_strings);
	log(LOG_DEBUG, "strings section @ 0x%016lx-0x%016lx (%ld bytes), starting with \"%s\"", 
					strings_start_addr, strings_end_addr, 
					(u64)swap32(dtb->size_dt_strings), strings_start_addr);

	u64 struct_offset = (u64)swap32(dtb->off_dt_struct);
	u64 struct_start_addr = (u64)dtb + struct_offset;
	u64 struct_end_addr = struct_start_addr +  (u64)swap32(dtb->size_dt_struct);
	log(LOG_DEBUG, "struct section @ 0x%016lx-0x%016lx (%ld bytes)", 
		struct_start_addr, struct_end_addr,
		(u64)swap32(dtb->size_dt_struct));
	
	u64 mem_rsvmap_offset = (u64)swap32(dtb->off_mem_rsvmap);
	u64 mem_rsvmap_start_addr = (u64)dtb + mem_rsvmap_offset;
	log(LOG_DEBUG, "mem_rsvmap section @ 0x%016lx", mem_rsvmap_start_addr);
	fdt_reserve_entry *p;
	for (p = (fdt_reserve_entry *)mem_rsvmap_start_addr;  p->address && p->size !=0; p++) {
		log(LOG_DEBUG, "reserved memory area: fdt_reserve_entry @ 0x%016lx: 0x%016lx - 0x%016lx", 
						p, swap64(p->address), swap64(p->address) + swap64(p->size));
	}
	if (p==(fdt_reserve_entry *)mem_rsvmap_start_addr) log(LOG_DEBUG, "mem_rsvmap is empty");


	// todo: just testing error handling
	throw_error(ERR_DUMMY);

	return ERR_OK;
}