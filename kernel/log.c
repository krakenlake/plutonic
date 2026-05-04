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
#include "string.h"


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

int kernel_log_level = LOG_DEBUG;			// gobal kernel log level (default)
char *string_log_sender = "kernel\0";		// global kernel sender ID

/*
 * standard/default log function
 */
inline void log(int level, char *str)
{
	do_log(level, str, 1);
}


/*
 * log function that does not print newline at the end
 */
inline void log_no_newline(int level, char *str)
{
	do_log(level, str, 0);
}


/*
 * log a string and print hex value after that 
 */
void log_hex(int level, char *str, u64 val)
{
	log_no_newline(level, str);
	print_hex(val);
	print_newline();
}


/*
 * log a string and print another string after that
 */
void log_str(int level, char *str, char *c)
{
	log_no_newline(level, str);
	while (*c != 0) print_char(*c++);
	print_newline();
}


/*
 *  print str to console if level is <= current kernel log level 
 */
void do_log(int level, char *str, int newline)
{
	char buf[256];
	char *p = buf;
	u64 timestamp;

	if (level < 0 || level > LOG_DEBUG || level > kernel_log_level) return;

	timestamp = get_timestamp();
	print_decimal(timestamp);

	buf[0] = LOG_DELIM;
	buf[1] = '\0';
	strcat(buf, loglevel_string[level]);

	char delim_str[2] = {LOG_DELIM , '\0'};
	strcat(buf, delim_str);
	strcat(buf, string_log_sender);
	strcat(buf, delim_str);
	strcat(buf, str);

	console_out(buf);
	if (newline){
		p=buf;
		*p++ = ASCII_LF;
		*p++ = 0;
		console_out(buf);
	};
}

