/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#include "config.h"
#include "plutonic/log.h"
#include "plutonic/dtb.h"
#include "plutonic/byteorder.h"


struct fdt_header *dtb;


void print_dtb(void)
{
	log_no_newline(LOG_DEBUG, "dtb start addr = ");
	print_hex((u64)dtb);
	print_newline();

	u32 magic_be = (u32)dtb->magic;
	log_no_newline(LOG_DEBUG, "magic BIG_ENDIAN = ");
	print_hex(magic_be);
	print_newline();

	u32 magic_le = (u32)be32_to_cpu(magic_be);
	log_no_newline(LOG_DEBUG, "magic LITTLE_ENDIAN = ");
	print_hex(magic_le);
	print_newline();

	if ((u32)magic_le == (u32)FDT_HEADER_MAGIC) {
		log(LOG_DEBUG, "dtb magic number OK");
	} else {
		log_no_newline(LOG_ERR, "dtb magic number does not match, expected ");
		print_hex(FDT_HEADER_MAGIC);
		print_newline();
	}

	u64 strings_offset = (u32)be32_to_cpu(dtb->off_dt_strings);
	u64 strings_start_addr = (u64)(dtb + strings_offset);
	log_no_newline(LOG_DEBUG, "strings section start addr = ");
	print_hex(strings_start_addr);
	print_newline();

	u32 struct_offset = (u32)be32_to_cpu(dtb->off_dt_struct);
	u64 struct_start_addr = (u64)dtb + struct_offset;
	log_no_newline(LOG_DEBUG, "struct section start addr = ");
	print_hex(struct_start_addr);
	print_newline();

	u32 mem_rsvmap_offset = (u32)be32_to_cpu(dtb->off_mem_rsvmap);
	u64 mem_rsvmap_start_addr = (u64)dtb + mem_rsvmap_offset;
	log_no_newline(LOG_DEBUG, "mem_rsvmap section start addr = ");
	print_hex(mem_rsvmap_start_addr);
	print_newline();

	log_no_newline(LOG_DEBUG, "first string = ");
	char *c = (char*)strings_start_addr;
	while (*c != 0) print_char(*c++);
	print_newline();
}