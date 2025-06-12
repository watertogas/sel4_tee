/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 * Copyright 2021, HENSOLDT Cyber
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#pragma once

#define ARCH_DEFAULT_STACK_SIZE 4096
#define SMP_MAX_CPUS            4
#define SMP_CPU_ID_BITS         24
#define SMP_CPU_CLUSTER_SHIFT   8
#define CONFIG_MAX_NUM_NODES    2

#define CONFIG_PLAT_MMIO_PADDR  0x9000000

//sel4 kernel is loaded by physcical offset: 2MB
#define CONFIG_KERNEL_LOAD_PADDR  0xe200000