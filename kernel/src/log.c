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
#include "librv64strings/strings.h"


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


int 	kernel_log_level = LOG_DEBUG;			// gobal kernel log level (default)
char 	*string_log_sender = "kernel\0";		// global kernel sender ID
char 	delim_str[2] = {LOG_DELIM, '\0'};
char 	str_LF[2] = {ASCII_LF, '\0'};
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
