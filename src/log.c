#include "config.h"
#include "plutonic/log.h"

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
char *string_log_delim = ": \0";


/*
 *  print str to console if level is <= current kernel log level 
 */
void log(int level, char *str)
{

	if (level > kernel_log_level) return;
	if (level < 0 || level > LOG_DEBUG) return;
	
	char *c = string_log_sender;
	while(*c != 0)
		print_char(*c++);

	c = string_log_delim;
	while(*c != 0)
		print_char(*c++);

	c = loglevel_string[level];
	while(*c != 0)
		print_char(*c++);

	c = string_log_delim;
	while(*c != 0)
		print_char(*c++);
	
	while(*str != 0)
		print_char(*str++);
	print_char('\n');
		return;
}

