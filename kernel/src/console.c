/*
 * plutonic - experimental RISC-V kernel
 *
 * Copyright (C) 2026 krakenlake
 *
 */
#include "config.h"
#include "plutonic/error.h"
#include "plutonic/drivers/uart/ns16550.h"

long console_out(char *str)
{
	while (*str != 0) uart_output_char(*str++);

	return ERR_OK;
}