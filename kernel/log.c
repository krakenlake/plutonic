#include "config.h"
#include "plutonic/log.h"
#include "plutonic/print.h"


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
int kernel_log_level = LOG_DEBUG;

char *string_log_sender = "kernel\0";


/*
 *  print str to console if level is <= current kernel log level 
 */
void log(int level, char *str)
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
		: "=m" (timestamp) );

	print_decimal(timestamp);

	print_char(delim);
	c = loglevel_string[level];
	print_string(c);

	print_char(delim);
	c = string_log_sender;
	print_string(c);

	print_char(delim);
	print_string(str);

	print_char('\n');
		return;
}

