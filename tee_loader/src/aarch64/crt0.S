/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#include <config.h>
#include <assembler.h>

.extern main
.extern non_boot_main

.section ".text.start"
BEGIN_FUNC(_start)
    bl      arm64_curr_cpu_num
    /* write cpu id to tpidr*/
    msr     tpidr_el1, x0
    ldr     x1, =ARCH_DEFAULT_STACK_SIZE
    add	x2, x0, #1
    mul	x2, x1, x2
    adrp    x19, core_stack_alloc
    add     x19, x19, x2
    mov     sp, x19
    cbnz    x0, .Lgo_secondary_boot_up
    /* boot with core id = 0 */
    /* Clear .bss section before calling main */
    bl      clear_bss
    b       main
.Lgo_secondary_boot_up:
    /* boot with secondary cpus*/
    b       non_boot_main
END_FUNC(_start)

/* cpu core number */
/*
 *  Decodes the CPU number out of MPIDR.
 *  This can be overridden by the platform.
 *  If it is, it must:
 *  - Not assume a stack
 *  - Only clobber x0, x9, x10
 *  - Return the CPU number in x0
 *  - If the CPU number would be invalid, return SMP_MAX_CPUS
 */
BEGIN_FUNC(arm64_curr_cpu_num)
    mrs     x0, mpidr_el1
    ubfx    x0, x0, #0, #SMP_CPU_ID_BITS
    and     x1, x0, #0xff
    cmp     x1, #(1 << SMP_CPU_CLUSTER_SHIFT)
    bge     .Lunsupported_cpu_num
    bic     x0, x0, #0xff
    orr     x0, x1, x0, LSR #(8 - SMP_CPU_CLUSTER_SHIFT)
    ret

.Lunsupported_cpu_num:
    mov     x0, #SMP_MAX_CPUS
    ret
END_FUNC(arm64_curr_cpu_num)
