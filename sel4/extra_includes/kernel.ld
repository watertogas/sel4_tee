/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
       
/*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
       
/* Compile-time configuration parameters. Might be set by the build system. */
       
       
/* disabled: CONFIG_ARM_HIKEY_PREFETCHER_STBPFDIS */
/* disabled: CONFIG_ARM_HIKEY_PREFETCHER_STBPFRS */
/* disabled: CONFIG_PLAT_IMX7 */
/* disabled: CONFIG_ARCH_AARCH32 */
/* disabled: CONFIG_ARCH_ARM_HYP */
/* disabled: CONFIG_ARCH_RISCV32 */
/* disabled: CONFIG_ARCH_RISCV64 */
/* disabled: CONFIG_ARCH_X86_64 */
/* disabled: CONFIG_ARCH_IA32 */
/* disabled: CONFIG_PLAT_BCM2711 */
/* disabled: CONFIG_PLAT_BCM2837 */
/* disabled: CONFIG_PLAT_FVP */
/* disabled: CONFIG_PLAT_HIKEY */
/* disabled: CONFIG_PLAT_IMX8MQ_EVK */
/* disabled: CONFIG_PLAT_IMX8MM_EVK */
/* disabled: CONFIG_PLAT_IMX8MP_EVK */
/* disabled: CONFIG_PLAT_IMX93 */
/* disabled: CONFIG_PLAT_MAAXBOARD */
/* disabled: CONFIG_PLAT_ODROIDC2 */
/* disabled: CONFIG_PLAT_ODROIDC4 */
/* disabled: CONFIG_PLAT_QUARTZ64 */
/* disabled: CONFIG_PLAT_ROCKPRO64 */
/* disabled: CONFIG_PLAT_TQMA8XQP1GB */
/* disabled: CONFIG_PLAT_TX1 */
/* disabled: CONFIG_PLAT_TX2 */
/* disabled: CONFIG_PLAT_ZYNQMP */
/* disabled: CONFIG_ARM_CORTEX_A7 */
/* disabled: CONFIG_ARM_CORTEX_A8 */
/* disabled: CONFIG_ARM_CORTEX_A9 */
/* disabled: CONFIG_ARM_CORTEX_A15 */
/* disabled: CONFIG_ARM_CORTEX_A35 */
/* disabled: CONFIG_ARM_CORTEX_A55 */
/* disabled: CONFIG_ARM_CORTEX_A57 */
/* disabled: CONFIG_ARM_CORTEX_A72 */
/* disabled: CONFIG_ARCH_ARM_V7A */
/* disabled: CONFIG_ARCH_ARM_V7VE */
/* disabled: CONFIG_AARCH64_SERROR_IGNORE */
/* disabled: CONFIG_KERNEL_MCS */
/* disabled: CONFIG_ARM_PA_SIZE_BITS_44 */
/* disabled: CONFIG_DEBUG_DISABLE_L2_CACHE */
/* disabled: CONFIG_DEBUG_DISABLE_L1_ICACHE */
/* disabled: CONFIG_DEBUG_DISABLE_L1_DCACHE */
/* disabled: CONFIG_DEBUG_DISABLE_BRANCH_PREDICTION */
/* disabled: CONFIG_ARM_HYPERVISOR_SUPPORT */
/* disabled: CONFIG_AARCH64_VSPACE_S2_START_L1 */
/* disabled: CONFIG_ARM_HYP_ENABLE_VCPU_CP14_SAVE_AND_RESTORE */
/* disabled: CONFIG_ARM_ERRATA_430973 */
/* disabled: CONFIG_ARM_ERRATA_773022 */
/* disabled: CONFIG_ARM_SMMU */
/* disabled: CONFIG_TK1_SMMU */
/* disabled: CONFIG_ENABLE_A9_PREFETCHER */
/* disabled: CONFIG_EXPORT_PMU_USER */
/* disabled: CONFIG_DISABLE_WFI_WFE_TRAPS */
/* disabled: CONFIG_SMMU_INTERRUPT_ENABLE */
/* disabled: CONFIG_AARCH32_FPU_ENABLE_CONTEXT_SWITCH */
/* disabled: CONFIG_ALLOW_SMC_CALLS */
/* disabled: CONFIG_ARM_TLS_REG_TPIDRURO */
/* disabled: CONFIG_ARM_HAS_TLB_LOCK */
/* disabled: CONFIG_EXCEPTION_FASTPATH */
/* disabled: CONFIG_SIGNAL_FASTPATH */
/* disabled: CONFIG_VERIFICATION_BUILD */
/* disabled: CONFIG_BINARY_VERIFICATION_BUILD */
/* disabled: CONFIG_HARDWARE_DEBUG_API */
/* disabled: CONFIG_KERNEL_INVOCATION_REPORT_ERROR_IPC */
/* disabled: CONFIG_BENCHMARK_GENERIC */
/* disabled: CONFIG_BENCHMARK_TRACK_KERNEL_ENTRIES */
/* disabled: CONFIG_BENCHMARK_TRACEPOINTS */
/* disabled: CONFIG_BENCHMARK_TRACK_UTILISATION */
/* disabled: CONFIG_ENABLE_BENCHMARKS */
/* disabled: CONFIG_KERNEL_LOG_BUFFER */
/* disabled: CONFIG_KERNEL_OPT_LEVEL_OS */
/* disabled: CONFIG_KERNEL_OPT_LEVEL_O0 */
/* disabled: CONFIG_KERNEL_OPT_LEVEL_O1 */
/* disabled: CONFIG_KERNEL_OPT_LEVEL_O3 */
/* disabled: CONFIG_KERNEL_FWHOLE_PROGRAM */
/* disabled: CONFIG_DANGEROUS_CODE_INJECTION */
/* disabled: CONFIG_DEBUG_DISABLE_PREFETCHERS */
/* disabled: CONFIG_SET_TLS_BASE_SELF */
/* disabled: CONFIG_CLZ_32 */
/* disabled: CONFIG_CLZ_64 */
/* disabled: CONFIG_CTZ_32 */
/* disabled: CONFIG_CTZ_64 */
/* disabled: CONFIG_CLZ_NO_BUILTIN */
/* disabled: CONFIG_CTZ_NO_BUILTIN */
/* disabled: CONFIG_EXPORT_PCNT_USER */
/* disabled: CONFIG_EXPORT_VCNT_USER */
/* disabled: CONFIG_EXPORT_PTMR_USER */
/* disabled: CONFIG_EXPORT_VTMR_USER */
/* Set ENABLE_SMP_SUPPORT for kernel source files */
/*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
       
/* Each architecture defines a set of constants in #defines. These
 * constants describe the memory regions of the kernel's portion of the
 * address space including the physical memory window, the kernel ELF
 * region, and the device region.
 *
 *  - USER_TOP: The first address after the end of user memory
 *
 *  - PADDR_BASE: The first physical address mapped in the kernel's
 *    physical memory window.
 *  - PPTR_BASE: The first virtual address of the kernel's physical
 *    memory window.
 *  - PPTR_TOP: The first virtual address after the end of the kernel's
 *    physical memory window.
 *
 *  - KERNEL_ELF_PADDR_BASE: The first physical address used to map the
 *    initial kernel image. The kernel ELF is mapped contiguously
 *    starting at this address.
 *  - KERNEL_ELF_BASE: The first virtual address used to map the initial
 *    kernel image.
 *
 *  - KDEV_BASE: The first virtual address used to map devices.
 */
/* The offset from a physical address to a virtual address in the
 * physical memory window. */
/* The last address in the physical memory region mapped into the
 * physical memory window */
/* The kernel base offset is a way to translate the kernel image segment
 * from virtual to physical. This translation must be a single offset
 * for for the entire segment (i.e. the kernel image must be contiguous
 * both virtually and physically) */
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
       
/*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
       
/* Provide a helper macro to define integer constants that are not of the
 * default type 'int', but 'unsigned long [long]'. When such constants are
 * shared between assembly and C code, some assemblers will fail because they
 * don't support C-style integer suffixes like 'ul'. Using a macro works around
 * this, as the suffix is only applied when the C compiler is used and dropped
 * when the assembler runs.
 */
/* Time constants are defined to use the 'unsigned long long'. Rationale is,
 * that the C rules define the calculation result is determined by largest type
 * involved. Enforcing the largest possible type C provides avoids pitfalls with
 * 32-bit overflows when values are getting quite large. Keep in mind that even
 * 2^32 milli-seconds roll over within 50 days, which is an uptime that embedded
 * systems will reach easily and it resembles not even two months in a calendar
 * calculation. In addition, using the largest integer type C currently defines
 * enforces that all calculations results need a cast back to a 32-bit type
 * explicitly. This might feel annoying, but practically it makes code more
 * robust and enforces thinking about potential overflows.
 * Note that at this stage of the includes, we do not have defined the type
 * uint64_t yet, so we can't use any definitions around it, but have to stick to
 * plain C types. Neither moving the time constant definitions behind the
 * uint64_t type definitions nor including the header with the uint64_t
 * definitions here is currently a feasible option.
 */
/*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
       
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
       
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
       
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
       
/* _Static_assert() is a c11 feature. Since the kernel is currently compiled
 * with c99, we have to emulate it. */
/*
 * Some compilers attempt to pack enums into the smallest possible type.
 * For ABI compatibility with the kernel, we need to ensure they remain
 * the same size as a 'long'.
 */
/* object sizes - 2^n */
/* word size */
/* Untyped size limits */
/* IPC buffer is 1024 bytes, giving size bits of 10 */
/* First address in the virtual address space that is not accessible to user level */
/* Extract the n-level PT index from a virtual address:
 * - n is page table level counting from the root page table,
 * - NUM_PT_LEVELS are either 3 or 4 page table levels depending
 *   on whether the address range being translated is 48bits, 44 bits or 40 bits.
 * - If translating an address in the kernel addrspace NUM_PT_LEVELS = 4 always.
 * - PageTables always have 512 slots (PT_INDEX_BITS = 9) but if there are only
 *   3 total levels then the root level is implemented with 4 concatenated tables
 *   meaning 2048 slots (UPT_LEVELS = 3 => seL4_VSpaceIndexBits = 12)
 *
 * PT_LEVEL_SHIFT(n) == PT_INDEX_BITS * (NUM_PT_LEVELS - n) + seL4_PageBits
 * GET_PT_INDEX(addr, n) == (addr >> PT_LEVEL_SHIFT(n)) & MASK(PT_INDEX_BITS)
 */
/* Control register fields */
/*
 * Used to align the big kernel lock to the exclusive reservation granule size.
 * Without this nearby writes can delay atomic operations implemented with looping
 * exclusive load/store instructions for an undefined time.
 *
 * Usually equal to L1_CACHE_LINE_SIZE, but 2k is the maximum for SMP systems.
 *
 * ARM Architecture Reference Manual ARMv7-A and ARMv7-R edition, chapter A3.4.5
 * Load-Exclusive and Store-Exclusive usage restrictions, page 122 states:
 *
 * "The architecture sets an upper limit of 2048 bytes on the size of a region
 *  that can be marked as exclusive."
 *
 * ARM Architecture Reference Manual ARMv8 for A-profile architecture, chapter
 * B2.9.5 Load-Exclusive and Store-Exclusive instruction usage restrictions,
 * page 216 states:
 *
 * "The architecture sets an upper limit of 2048 bytes on the Exclusives
 *  reservation granule that can be marked as exclusive."
 */
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
       
/* The QEMU virt platform can emulate various cores */
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */
       
/* Cortex-A53 Manual, Section 11.6.1 */
/* First address in the virtual address space that is not accessible to user level */
/* EL2 kernel address map:
 *
 * The EL2 mode kernel uses TTBR0_EL2 which covers the range of
 * 0x0 - 0x0000ffffffffffff (48 bits of vaddrspace).
 *
 * The CPU on the TX1 only allows for 48-bits of addressable virtual memory.
 * Within the seL4 EL2 kernel's separate vaddrspace, it uses
 * the 512 GiB at the top of that 48 bits of addressable
 * virtual memory.
 *
 * In EL2 there is no canonical-high portion of the address space since
 * address tagging is not supported in EL2. Therefore the kernel is linked
 * to the canonical lower portion of the address space (all the unused top bits
 * are set to 0, not 1).
 *
 * The memory map used by the EL2 kernel's separate address space
 * ends up looking something like this:
 *
 * +-----------------------------------+ <- 0xFFFFFFFF_FFFFFFFF
 * | Canonical high portion - unusable |
 * | virtual addrs                     |
 * +-----------------------------------+ <- PPTR_TOP: 256TiB mark (top of 48 bits)
 * | seL4 EL2 kernel                   |    ^
 * |                                   |    |
 * |                                   |    512GiB
 * |                                   |    of EL2 kernel windowing
 * |                                   |    into memory.
 * |                                   |    |
 * |                                   |    v
 * +-----------------------------------+ <- PPTR_BASE: 256TiB minus 512GiB.
 * | Unused virtual addresses within   |    ^
 * | the EL2 kernel's                  |    |
 * | separate vaddrspace.              |    Rest of the
 * |                                   |    EL2 kernel
 * |                                   |    vaddrspace, unused,
 * |                                   |    which is the rest of
 * |                                   |    the lower 256 TiB.
 * |                                   |    |
 * |                                   |    v
 * +-----------------------------------+ <- 0x0
 *
 * !defined(CONFIG_ARM_HYPERVISOR_SUPPORT)
 *
 *          2^64 +-------------------+
 *               | Kernel Page PDPT  | --+
 *   2^64 - 2^39 +-------------------+ PPTR_BASE
 *               |    TLB Bitmaps    |   |
 *               +-------------------+   |
 *               |                   |   |
 *               |     Unmapped      |   |
 *               |                   |   |
 *   2^64 - 2^48 +-------------------+   |
 *               |                   |   |
 *               |   Unaddressable   |   |
 *               |                   |   |
 *          2^48 +-------------------+ USER_TOP
 *               |                   |   |
 *               |       User        |   |
 *               |                   |   |
 *           0x0 +-------------------+   |
 *                                       |
 *                         +-------------+
 *                         |
 *                         v
 *          2^64 +-------------------+
 *               |                   |
 *               |                   |     +------+
 *               | Kernel Page Table | --> |  PD  | ----+
 *               |                   |     +------+     |
 *               |                   |                  |
 *   2^64 - 2^30 +-------------------+ PPTR_TOP         |
 *               |                   |                  |
 *               |  Physical Memory  |                  |
 *               |       Window      |                  |
 *               |                   |                  |
 *               +-------------------+                  |
 *               |                   |                  |
 *               |                   |     +------+     |
 *               |    Kernel ELF     | --> |  PD  |     |
 *               |                   |     +------+     |
 *               |                   |                  |
 *               +-------------------+ KERNEL_ELF_BASE  |
 *               |                   |                  |
 *               |  Physical Memory  |                  |
 *               |       Window      |                  |
 *               |                   |                  |
 *   2^64 - 2^39 +-------------------+ PPTR_BASE        |
 *                                                      |
 *                                +---------------------+
 *                                |
 *                                v
 *   2^64 - 2^21 + 2^12 +-------------------+
 *                      |                   |
 *                      |  Kernel Devices   |
 *                      |                   |
 *          2^64 - 2^21 +-------------------+ KDEV_BASE
 *
 *
 * defined(CONFIG_ARM_HYPERVISOR_SUPPORT)
 *
 *          2^64 +-------------------+
 *               |                   |
 *               |   Unaddressable   |
 *               |                   |
 *          2^48 +-------------------+
 *               | Kernel Page PDPT  | --+
 *   2^48 - 2^39 +-------------------+ PPTR_BASE
 *               |    TLB Bitmaps    |   |
 *               +-------------------+   |
 *               |                   |   |
 *               |     Unmapped      |   |
 *               |                   |   |
 *           0x0 +-------------------+   |
 *                                       |
 *                         +-------------+
 *                         |
 *                         v
 *          2^48 +-------------------+
 *               |                   |
 *               |                   |     +------+
 *               | Kernel Page Table | --> |  PD  | ----+
 *               |                   |     +------+     |
 *               |                   |                  |
 *   2^48 - 2^30 +-------------------+ PPTR_TOP         |
 *               |                   |                  |
 *               |  Physical Memory  |                  |
 *               |       Window      |                  |
 *               |                   |                  |
 *               +-------------------+                  |
 *               |                   |                  |
 *               |                   |     +------+     |
 *               |    Kernel ELF     | --> |  PD  |     |
 *               |                   |     +------+     |
 *               |                   |                  |
 *               +-------------------+ KERNEL_ELF_BASE  |
 *               |                   |                  |
 *               |  Physical Memory  |                  |
 *               |       Window      |                  |
 *               |                   |                  |
 *   2^48 - 2^39 +-------------------+ PPTR_BASE        |
 *                                                      |
 *                                +---------------------+
 *                                |
 *                                v
 *   2^48 - 2^21 + 2^12 +-------------------+
 *                      |                   |
 *                      |  Kernel Devices   |
 *                      |                   |
 *          2^48 - 2^21 +-------------------+ KDEV_BASE
 *
 */
/* last accessible virtual address in user space */
/* The first physical address to map into the kernel's physical memory
 * window */
/* The base address in virtual memory to use for the 1:1 physical memory
 * mapping */
/* Top of the physical memory window */
/* The physical memory address to use for mapping the kernel ELF */
/* For use by the linker (only integer constants allowed) */
/* The base address in virtual memory to use for the kernel ELF mapping */
/* For use by the linker (only integer constants allowed) */
/* This is a page table mapping at the end of the virtual address space
 * to map objects with 4KiB pages rather than 4MiB large pages. */
/* The base address in virtual memory to use for the kernel device
 * mapping region. These are mapped in the kernel page table. */
/* The log buffer is placed before the device region */
/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */
/*
 * This file is autogenerated by <kernel>/tools/hardware/outputs/c_header.py.
 */
       
ENTRY(_start)
KERNEL_OFFSET = ((0xffffff8000000000 - 0x0) + 0xe200000) - 0xe200000;
SECTIONS
{
    . = ((0xffffff8000000000 - 0x0) + 0xe200000);
    .boot . : AT(ADDR(.boot) - KERNEL_OFFSET)
    {
        *(.boot.text)
        *(.boot.rodata)
        *(.boot.data)
        . = ALIGN(64K);
    }
    ki_boot_end = .;
    .text . : AT(ADDR(.text) - KERNEL_OFFSET)
    {
        /* Sit inside a large frame */
        . = ALIGN(64K);
        *(.vectors)
        /* Fastpath code */
        *(.vectors.fastpath_call)
        *(.vectors.fastpath_reply_recv)
        *(.vectors.text)
        /* Anything else that should be in the vectors page. */
        *(.vectors.*)
        /* Hopefully all that fits into 4K! */
        /* Standard kernel */
        *(.text)
    }
    .rodata . : AT(ADDR(.rodata) - KERNEL_OFFSET)
    {
        *(.rodata)
        *(.rodata.*)
    }
    .data . : AT(ADDR(.data) - KERNEL_OFFSET)
    {
        *(.data)
    }
    .bss . (NOLOAD): AT(ADDR(.bss) - KERNEL_OFFSET)
    {
        *(.bss)
        *(COMMON) /* fallback in case '-fno-common' is not used */
        /* large data such as the globals frame and global PD */
        *(.bss.aligned)
    }
    . = ALIGN(4K);
    ki_end = .;
    /DISCARD/ :
    {
        *(.note.gnu.build-id)
        *(.comment)
    }
}
