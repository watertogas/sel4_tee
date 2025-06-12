/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 * Copyright 2021, HENSOLDT Cyber
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#include <printf.h>
#include <types.h>
#include <abort.h>
#include <strops.h>
#include <common.h>
#include <binaries/efi/efi.h>

/* 0xd00dfeed in big endian */
#define DTB_MAGIC (0xedfe0dd0)

/* Maximum alignment we need to preserve when relocating (64K) */
#define MAX_ALIGN_BITS (14)

struct image_info kernel_info;
/* pretend to have rootserver!!! */
struct image_info user_info = {
    .phys_region_start = 0xe600000,
    .phys_region_end = 0xe620000,
    .virt_region_start = 0x400000,
    .virt_region_end = 0x420000,
    .virt_entry = 0x400000,
    .phys_virt_offset = 0xe200000,
};

/*
 * Entry point.
 *
 * Unpack images, setup the MMU, jump to the kernel.
 */
void main(void *arg)
{
    int ret = 0;
    /* check UART OK*/
    printf("uart should be able to use now???\n");

    /* Print welcome message. */
    printf("  paddr=[%p..%p]\n", _text, (uintptr_t)_end - 1);
    void const *kernel_elf = _kernel_elf_start;
    size_t elf_len = _kernel_elf_end - _kernel_elf_start;

    /* Load the kernel */
    ret = load_kernel_elf("kernel", kernel_elf, elf_len, CONFIG_KERNEL_LOAD_PADDR, &kernel_info); 

    if (0 != ret) {
        printf("ERROR: Could not load kernel ELF\n");
        abort();
    }

    /*init boot vaspace*/
    init_boot_vspace(&kernel_info);
    /*block other cpus if needed*/
    set_smp_boot_status();
    /*enable mmu*/
    printf("Enabling MMU and paging\n");
    arm_enable_mmu();

    //jumping to sel4 kernel
    ((init_arm_kernel_t)kernel_info.virt_entry)(user_info.phys_region_start,
        user_info.phys_region_end,
        user_info.phys_virt_offset,
        user_info.virt_entry,
        0,
        0);

    printf("ERROR: Unreachable!!!\n");
    abort();
}