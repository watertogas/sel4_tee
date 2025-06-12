/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#include <common.h>
#include <config.h>

#define UARTDR      0x000
#define UARTFR      0x018
#define UARTFR_TXFF (1 << 5)

static volatile char *mmio = (void *)CONFIG_PLAT_MMIO_PADDR;

#define UART_REG(mmio, x) ((volatile uint32_t *)(mmio + (x)))

int pl011_uart_putchar(unsigned int c)
{

    /* Wait until UART ready for the next character. */
    while ((*UART_REG(mmio, UARTFR) & UARTFR_TXFF) != 0);

    /* Add character to the buffer. */
    *UART_REG(mmio, UARTDR) = (c & 0xff);

    return 0;
}

int plat_console_putchar(unsigned int c)
{
    pl011_uart_putchar(c);
    return 0;
}
