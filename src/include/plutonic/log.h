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


#ifndef __ASSEMBLY__
	extern int print_char(char);

	void log(int level, char *str);
#endif


#endif /* PLUTONIC_LOG_H */
