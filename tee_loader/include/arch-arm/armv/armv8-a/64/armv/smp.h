/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#pragma once

#include <config.h>

#if CONFIG_MAX_NUM_NODES > 1

#define STACK_SIZE  4096

extern unsigned long core_stacks[CONFIG_MAX_NUM_NODES][STACK_SIZE / sizeof(unsigned long)] ALIGN(BIT(12));
void core_entry(uint64_t sp);
int  is_core_up(int id);

#endif
