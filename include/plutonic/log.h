/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once
#include "plutonic/types.h"


#define	LOG_EMERG	0
#define	LOG_ALERT	1
#define	LOG_CRIT	2
#define	LOG_ERR		3
#define	LOG_WARN	4
#define	LOG_NOTICE	5
#define	LOG_INFO	6
#define	LOG_DEBUG	7

#define LOG_BUF_SIZE	1024

#ifndef __ASSEMBLER__
	#include <stdarg.h>
	void log(const int level, const char *format, ...);
	void log_no_newline(const int level, const char *format, ...);
#endif
