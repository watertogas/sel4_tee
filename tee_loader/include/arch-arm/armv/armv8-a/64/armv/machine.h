/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#pragma once

static inline void wfi(void)
{
    __asm__ volatile("wfi" ::: "memory");
}

static inline void dsb(void)
{
    __asm__ volatile("dsb sy" ::: "memory");
}

static inline void dmb(void)
{
    __asm__ volatile("dmb sy" ::: "memory");
}

static inline void isb(void)
{
    __asm__ volatile("isb" ::: "memory");
}


#define MRS(reg, v)  __asm__ volatile("mrs %0," reg : "=r"(v))
#define MSR(reg, v)                                \
    do {                                           \
        word_t _v = v;                             \
        __asm__ volatile("msr " reg ",%0" :: "r" (_v));\
    } while(0)
