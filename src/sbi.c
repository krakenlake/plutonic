/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */

#include "config.h"
#include "plutonic/log.h"
#include "plutonic/error.h"
#include "libsbicall/sbicall.h"


/*
 *  print info about SBI 
 */
long print_sbi_info(void)
{
	log(LOG_INFO, "SBI spec version: 0x%08x", sbi_get_spec_version().value );
	log(LOG_INFO, "SBI implementation ID: 0x%08x", sbi_get_impl_id().value );
	log(LOG_INFO, "SBI implementation version: 0x%08x", sbi_get_impl_version().value );

	log_no_newline(LOG_INFO, "SBI extensions: ");
	for (int i=0; i < sbi_num_extensions; i++) {
		if ((sbi_probe_extension(sbi_extensions[i].eid)).value != 0) {
			log_raw(LOG_INFO, "%s ", sbi_extensions[i].name);
		}
	}
	log_raw(LOG_INFO, "\n");

	log(LOG_INFO, "SBI mvendorid: 0x%08x", sbi_get_mvendorid().value );
	log(LOG_INFO, "SBI marchid: 0x%08x", sbi_get_marchid().value );
	log(LOG_INFO, "SBI mimpid: 0x%08x", sbi_get_mimpid().value );

	return ERR_OK;
}
