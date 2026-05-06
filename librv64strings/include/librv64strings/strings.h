/*
 * librv64strings - RISC-V strings library
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#pragma once

#ifndef __ASSEMBLER__
	extern u64		strlen(char *str);
	extern char*	strchain(char *str1, char *str2);
#endif
