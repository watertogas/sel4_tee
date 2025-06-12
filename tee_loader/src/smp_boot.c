/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#include <printf.h>
#include <abort.h>
#include <config.h>
#include <common.h>
#include <machine.h>
#include <smp.h>

void cpu_idle(void)
{
    dsb();
    wfi();
}

#if CONFIG_MAX_NUM_NODES > 1
static volatile int non_boot_lock = 0;

/* Entry point for all CPUs other than the initial. */
void non_boot_main(void)
{
    /* Spin until the first CPU has finished initialisation. */
    while (!non_boot_lock) {
        cpu_idle();
    }

    /* Enable the MMU, and enter the kernel. */
    arm_enable_mmu();

    /* Jump to the kernel. */
    ((init_arm_kernel_t)kernel_info.virt_entry)(user_info.phys_region_start,
                                                user_info.phys_region_end, user_info.phys_virt_offset,
                                                user_info.virt_entry, 0, 0);

    printf("ERROR: Unreachable.\n");
    abort();
}

void set_smp_boot_status(void)
{
    non_boot_lock = 1;
}
#endif /* CONFIG_MAX_NUM_NODES */
