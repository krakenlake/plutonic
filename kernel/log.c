/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/log.h"
#include "plutonic/print.h"
#include "plutonic/types.h"


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


/*
 * current global kernel log level
 */
int kernel_log_level = LOG_DEBUG;		// default value at boot time

char *string_log_sender = "kernel\0";


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
 *  print str to console if level is <= current kernel log level 
 */
void do_log(int level, char *str, int newline)
{
	char *c;
	char delim = ':';
	unsigned long timestamp;

	if (level > kernel_log_level) return;
	if (level < 0 || level > LOG_DEBUG) return;

	__asm( 
		// read system time from csr 
		"rdtime t0\n"
		// and put result into timestamp variable in memory
		"sd t0,%0"
		: "=m" (timestamp)	/* output */
		:					/* no input */
		: "t0"				/* clobbered */
	);

	print_decimal(timestamp);

	print_char(delim);
	c = loglevel_string[level];
	print_string(c);

	print_char(delim);
	c = string_log_sender;
	print_string(c);

	print_char(delim);
	print_string(str);

	if (newline) print_char('\n');
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
