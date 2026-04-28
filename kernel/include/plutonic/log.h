/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#ifndef PLUTONIC_LOG_H
#define PLUTONIC_LOG_H


#include "plutonic/types.h"

#define	LOG_EMERG	0
#define	LOG_ALERT	1
#define	LOG_CRIT	2
#define	LOG_ERR		3
#define	LOG_WARN	4
#define	LOG_NOTICE	5
#define	LOG_INFO	6
#define	LOG_DEBUG	7

#define LOG_DELIM	':'

#ifndef __ASSEMBLER__
	/* public */
	void log(int level, char *str);
	void log_no_newline(int level, char *str);
	void log_hex(int level, char *str, u64 val);
	void log_str(int level, char *str, char *c);
	/* private */
	void _do_log(int level, char *str, int newline);
#endif


#endif /* PLUTONIC_LOG_H */
