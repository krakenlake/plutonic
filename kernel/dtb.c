#include "config.h"
#include "plutonic/dtb.h"


char *dtb;

void print_dtb(void)
{
	char *c = dtb;
	while(c < (dtb+1024) )
		print_char(*c++);
	return;
}