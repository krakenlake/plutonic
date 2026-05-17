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
#include "libpltnc/plt_strings.h"
#include <stdio.h>
#include <string.h>

 char *loglevel_string[] = {
	"EMERGENCY",
	"ALERT",
	"CRITICAL",
	"ERROR",
	"WARNING",
	"NOTICE",
	"INFO",
	"DEBUG"
 };

char	log_buf[LOG_BUF_SIZE];
int		kernel_log_level = LOG_DEBUG;			// gobal kernel log level (default)
char	*log_sender = "kernel\0";				// global kernel sender ID
char	str_LF[2] = {ASCII_LF, '\0'};


/*
 *  check if message shall be printed at current loglevel 
 */
inline int log_skip_message(int level)
{
	return (level < 0 || level > LOG_DEBUG || level > kernel_log_level);
}


/*
 *  generate beginning of each log line 
 */
inline int log_begin_line(const int level)
{
	int n = snprintf(log_buf, LOG_BUF_SIZE, "%ld:%s:%s:", 
						get_timestamp(), 
						loglevel_string[level], 
						log_sender);
	return n;
}


/*
 * standard/default log function
 */
void log(const int level, const char *format, ...)
{
	if (log_skip_message(level)) return;
	int n = log_begin_line(level);
	va_list args;
	va_start(args, format);
	vsnprintf(log_buf + n, LOG_BUF_SIZE, format, args);
	va_end(args);
	console_out(log_buf);
	console_out(str_LF);
}


/*
 * log function that does not print newline at the end
 */
void log_no_newline(const int level, const char *format, ...)
{
	if (log_skip_message(level)) return;
	int n = log_begin_line(level);
	va_list args;
	va_start(args, format);
	vsnprintf(log_buf + n, LOG_BUF_SIZE, format, args);
	va_end(args);
	console_out(log_buf);
}


/*
 *  log info obtained from SBI 
 */
long log_sbiinfo(void)
{
	log(LOG_DEBUG, "SBI spec version: 0x%08x", sbi_get_spec_version().value );
	log(LOG_DEBUG, "SBI implementation ID: 0x%08x", sbi_get_impl_id().value );
	log(LOG_DEBUG, "SBI implementation version: 0x%08x", sbi_get_impl_version().value );

	log_no_newline(LOG_DEBUG, "SBI extensions: ");
	for (int i=0; i < sbi_num_extensions; i++) {
		if ((sbi_probe_extension(sbi_extensions[i].eid)).value != 0) {
			snprintf (log_buf, LOG_BUF_SIZE, "%s ", sbi_extensions[i].name);
			console_out(log_buf);
		}
	}
	console_out(str_LF);

	log(LOG_DEBUG, "SBI mvendorid: 0x%08x", sbi_get_mvendorid().value );
	log(LOG_DEBUG, "SBI marchid: 0x%08x", sbi_get_marchid().value );
	log(LOG_DEBUG, "SBI mimpid: 0x%08x", sbi_get_mimpid().value );

	return ERR_OK;
}
