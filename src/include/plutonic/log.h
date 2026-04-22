#ifndef PLUTONIC_LOG_H
#define PLUTONIC_LOG_H


#define	LOG_EMERG	0
#define	LOG_ALERT	1
#define	LOG_CRIT	2
#define	LOG_ERR		3
#define	LOG_WARN	4
#define	LOG_NOTICE	5
#define	LOG_INFO	6
#define	LOG_DEBUG	7


/*
 * Include files are included in .S and .c files, but C declarations
 * are invalid in assembly code, so they need to be guarded.
 *
 * __ASSEMBLER__ is a predefined macro in gcc.
 */
#ifndef __ASSEMBLER__
	void log(int level, char *str);
#endif


#endif /* PLUTONIC_LOG_H */
