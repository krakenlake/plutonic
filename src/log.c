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
 * standard/default log function
 */
void log(const int level, const char *format, ...)
{
	if (log_skip_message(level)) return;
	va_list args;
	va_start(args, format);
	do_log (LOG_FLAG_LINEPREFIX | LOG_FLAG_NEWLINE, level, format, args);
	va_end(args);
}


/*
 * log function that does not print newline at the end
 */
void log_no_newline(const int level, const char *format, ...)
{
	if (log_skip_message(level)) return;
	va_list args;
	va_start(args, format);
	do_log (LOG_FLAG_LINEPREFIX, level, format, args);
	va_end(args);
}


/*
 * log function that does not print newline at the end
 */
void log_raw(const int level, const char *format, ...)
{
	if (log_skip_message(level)) return;
	va_list args;
	va_start(args, format);
	do_log(LOG_FLAG_NONE, level, format, args);
	va_end(args);
}


/*
 * process log
 */
void do_log(const u64 flags, const int level, const char *format, va_list args)
{
	int n;

	if (flags && LOG_FLAG_LINEPREFIX) {
		n = snprintf(log_buf, LOG_BUF_SIZE, "[%016ld]:%s:%s:", 
											get_timestamp(), 
											loglevel_string[level], 
											log_sender);
	} else {
		n=0;
		log_buf[0]='\0';
	}
	vsnprintf(log_buf + n, LOG_BUF_SIZE-n, format, args);
	console_out(log_buf);

	if (flags & LOG_FLAG_NEWLINE) console_out(str_LF);
}
