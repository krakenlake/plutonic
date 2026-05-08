/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/log.h"
#include "plutonic/print.h"
#include "plutonic/time.h"
#include "plutonic/types.h"
#include "plutonic/stack.h"
#include "plutonic/console.h"
#include "plutonic/ASCII.h"
#include "plutonic/error.h"
#include "libsbicall/sbicall.h"
#include "libpltnc/strings.h"


 char *loglevel_string[8] = {
	"EMERGENCY",
	"ALERT",
	"CRITICAL",
	"ERROR",
	"WARNING",
	"NOTICE",
	"INFO",
	"DEBUG"
 };


int		kernel_log_level = LOG_DEBUG;			// gobal kernel log level (default)
char	*string_log_sender = "kernel\0";		// global kernel sender ID
char	delim_str[2] = {LOG_DELIM, '\0'};
char	str_LF[2] = {ASCII_LF, '\0'};
char	log_buf[1024];


/*
 * standard/default log function
 */
void log(int level, char *msg)
{
	char *p;
	if (skip_message(level)) return;
	p = begin_logline(level);
	p = strchain(p, msg);
	p = strchain(p, str_LF);
	console_out(log_buf);
}


/*
 * log function that does not print newline at the end
 */
void log_no_newline(int level, char *msg)
{
	char *p;
	if (skip_message(level)) return;
	p = begin_logline(level);
	p = strchain(p, msg);
	console_out(log_buf);
}


/*
 * log a string and print hex value after that 
 */
void log_hex(int level, char *msg, u64 val)
{
	char *p;
	if (skip_message(level)) return;
	p = begin_logline(level);
	p = strchain(p, msg);
	console_out(log_buf);
	print_hex(val);
	print_newline();
}


/*
 * log a string and print another string after that
 */
void log_str(int level, char *msg, char *c)
{
	char *p;
	if (skip_message(level)) return;
	p = begin_logline(level);
	p = strchain(p, msg);
	p = strchain(p, c);
	p = strchain(p, str_LF);
	console_out(log_buf);
}


/*
 *  check if message shall be printed at current loglevel 
 */
inline int skip_message(int level)
{
	return (level < 0 || level > LOG_DEBUG || level > kernel_log_level);
}


/*
 *  prepare prefix of logline in buffer 
 */
char* begin_logline(int level)
{
	char *p;
	print_decimal(get_timestamp());
	log_buf[0] = LOG_DELIM;
	log_buf[1] = '\0';
	p = strchain(&log_buf[1], loglevel_string[level]);
	p = strchain(p, delim_str);
	p = strchain(p, string_log_sender);
	p = strchain(p, delim_str);
	return p;
}

/*
 *  log info obtained from SBI 
 */
long log_sbiinfo(void)
{
	log_hex(LOG_DEBUG, "SBI spec version:", sbi_get_spec_version().value );
	log_hex(LOG_DEBUG, "SBI implementation ID:", sbi_get_impl_id().value );
	log_hex(LOG_DEBUG, "SBI implementation version:", sbi_get_impl_version().value );

	log_no_newline(LOG_DEBUG, "SBI extensions:");
	(sbi_probe_extension(EID_LEGACY)).value ? console_out(" LEGACY") : 0 ;
	(sbi_probe_extension(EID_BASE)).value ? console_out(" BASE") : 0 ;
	(sbi_probe_extension(EID_TIME)).value ? console_out(" TIME") : 0 ;
	(sbi_probe_extension(EID_IPI)).value ? console_out(" IPI") : 0 ;
	(sbi_probe_extension(EID_RFENCE)).value ? console_out(" RFENCE") : 0 ;
	(sbi_probe_extension(EID_HSM)).value ? console_out(" HSM") : 0 ;
	(sbi_probe_extension(EID_SRST)).value ? console_out(" SRST") : 0 ;
	(sbi_probe_extension(EID_SUSP)).value ? console_out(" SUSP") : 0 ;
	(sbi_probe_extension(EID_PMU)).value ? console_out(" PMU") : 0 ;
	(sbi_probe_extension(EID_DBCN)).value ? console_out(" SBCN") : 0 ;
	(sbi_probe_extension(EID_STA)).value ? console_out(" STA") : 0 ;
	(sbi_probe_extension(EID_NACL)).value ? console_out(" NACL") : 0 ;
	(sbi_probe_extension(EID_FWFT)).value ? console_out(" FWFT") : 0 ;
	(sbi_probe_extension(EID_DBTR)).value ? console_out(" DBTR") : 0 ;
	(sbi_probe_extension(EID_MPXY)).value ? console_out(" MPXY") : 0 ;
	print_newline();

	log_hex(LOG_DEBUG, "SBI mvendorid:", sbi_get_mvendorid().value );
	log_hex(LOG_DEBUG, "SBI marchid:", sbi_get_marchid().value );
	log_hex(LOG_DEBUG, "SBI mimpid:", sbi_get_mimpid().value );

	return ERR_OK;
}
