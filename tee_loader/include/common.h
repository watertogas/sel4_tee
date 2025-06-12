/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 * Copyright 2021, HENSOLDT Cyber
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#pragma once

#include <types.h>
#include <config.h>

typedef uintptr_t paddr_t;
typedef uintptr_t vaddr_t;

#define PAGE_BITS           12

#define BIT(x)              (1 << (x))
#define MASK(n)             (BIT(n) - 1)
#define MIN(a, b)           (((a) < (b)) ? (a) : (b))
#define IS_ALIGNED(n, b)    (!((n) & MASK(b)))
#define ROUND_UP(n, b)      (((((n) - 1) >> (b)) + 1) << (b))
#define ROUND_DOWN(n, b) (((n) >> (b)) << (b))
#define ALIGN(n)            __attribute__((__aligned__(n)))
#define VISIBLE             __attribute__((externally_visible))
#define WEAK                __attribute__((weak))
#define NORETURN            __attribute__((noreturn))
#define UNREACHABLE()       __builtin_unreachable()
#define UNUSED              __attribute__((unused))
#define UNUSED_VARIABLE(x)  ((void)(x))
#define ARRAY_SIZE(a)       (sizeof(a)/sizeof((a)[0]))
#define NULL                ((void *)0)


#define ARCH_DEFAULT_STACK_SIZE 4096
#define SMP_MAX_CPUS            4
#define SMP_CPU_ID_BITS         24
#define SMP_CPU_CLUSTER_SHIFT   8

/*
 * Information about an image we are loading.
 */
struct image_info {
    /* Start/end byte of the image in physical memory. */
    paddr_t phys_region_start;
    paddr_t phys_region_end;

    /* Start/end byte in virtual memory the image requires to be located. */
    vaddr_t virt_region_start;
    vaddr_t virt_region_end;

    /* Virtual address of the user image's entry point. */
    vaddr_t  virt_entry;

    /* The seL4 kernel boot interface does not have the parameter virt_entry,
     * but expect a parameter with the offset between the physical and virtual
     * addresses of the image, where this must hold:
     *     virt_address + phys_virt_offset = phys_address
     * Practically, the offset is usually a positive value, because the virtual
     * address is a low value and the actually physical address is much greater.
     * But in general, there is no restrictions on the physical and virtual
     * image location. Defining phys_virt_offset as a signed value might seem
     * the intuitive choice how to handle this, but there is are two catches
     * here that break the C rules. We can't cover the full integer range then
     * and overflows/underflows are well defined for unsigned values only. They
     * are undefined for signed values, even if such operations practically work
     * in many cases due to how the compiler/machine implements negative
     * integers using the two's-complement.
     * Assume 32-bit system with virt_address=0xc0000000 and phys_address=0,
     * then phys_virt_offset would have to be -0xc0000000. This value is not
     * in the 32-bit signed integer range. With unsigned integers, calculating
     * 0 - 0xc0000000 results in 0x40000000 after an underflow, the reverse
     * calculation 0xc0000000 + 0x40000000 results in 0 again after overflow. If
     * 0x40000000 is a signed integer, result is likely the same, but the whole
     * operation is completely undefined by C rules.
     */
    word_t phys_virt_offset;
};

extern struct image_info kernel_info;
extern struct image_info user_info;

/* Symbols defined in linker scripts. */
extern char _text[];
extern char _end[];
extern char _bss[];
extern char _bss_end[];
extern char _kernel_elf_start[];
extern char _kernel_elf_end[];


extern void arm_enable_mmu(void);

/* Clear BSS. */
void clear_bss(void);
void clear_bss_aarch64(uint64_t* phys_addr, uint32_t size);

/* Load elf. */
int load_kernel_elf(
    const char *name,
    void const *elf_blob,
    size_t elf_blob_size,
    paddr_t dest_paddr,
    struct image_info *info);


/* This is a low level binary interface, thus we do not preserve the type
 * information here. All parameters are just register values (or stack values
 * that are register-sized).
 */
typedef void (*init_arm_kernel_t)(word_t ui_p_reg_start,
    word_t ui_p_reg_end,
    word_t pv_offset,
    word_t v_entry,
    word_t dtb,
    word_t dtb_size);

void init_boot_vspace(struct image_info *kernel_info);
int pl011_uart_putchar(unsigned int c);
int plat_console_putchar(unsigned int c);
void non_boot_main(void);
void cpu_idle(void);
void set_smp_boot_status(void);