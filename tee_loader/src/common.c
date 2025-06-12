/*
 * Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
 * Copyright 2021, HENSOLDT Cyber
 *
 * SPDX-License-Identifier: GPL-2.0-only
 */

#include <printf.h>
#include <types.h>
#include <abort.h>
#include <binaries/elf/elf.h>
#include <common.h>
#include <strops.h>

/*
 * Clear the BSS segment
 */
void clear_bss(void)
{
    char *start = _bss;
    char *end = _bss_end;
    while (start < end) {
        *start = 0;
        start++;
    }
}

void clear_bss_aarch64(uint64_t* phys_addr, uint32_t size)
{
    int loop = size >> 3;
    uint64_t* start = phys_addr;
    while(loop > 0) {
        *start = 0;
        start++;
        loop--;
    }
}
 
 #define KEEP_HEADERS_SIZE BIT(PAGE_BITS)
 
 /*
  * Determine if two intervals overlap.
  */
 static int regions_overlap(
     uintptr_t startA,
     uintptr_t endA,
     uintptr_t startB,
     uintptr_t endB)
 {
     if (endA < startB) {
         return 0;
     }
     if (endB < startA) {
         return 0;
     }
     return 1;
 }
 
 /*
  * Ensure that we are able to use the given physical memory range.
  *
  * We fail if the destination physical range overlaps us, or if it goes outside
  * the bounds of memory.
  */
 static int ensure_phys_range_valid(
     paddr_t paddr_min,
     paddr_t paddr_max)
 {
     /*
      * Ensure that the physical load address of the object we're loading (called
      * `name`) doesn't overwrite us.
      */
     if (regions_overlap(paddr_min,
                         paddr_max - 1,
                         (uintptr_t)_text,
                         (uintptr_t)_end - 1)) {
         printf("ERROR: image load address overlaps with ELF-loader!\n");
         return -1;
     }
 
     return 0;
 }
 
 /*
  * Unpack an ELF file to the given physical address.
  */
 static int unpack_elf_to_paddr(
     void const *elf,
     paddr_t dest_paddr)
 {
     int ret;
 
     /* Get the memory bounds. Unlike most other functions, this returns 1 on
      * success and anything else is an error.
      */
     uint64_t u64_min_vaddr, u64_max_vaddr;
     ret = elf_getMemoryBounds(elf, 0, &u64_min_vaddr, &u64_max_vaddr);
     if (ret != 1) {
         printf("ERROR: Could not get image size\n");
         return -1;
     }
 
     /* Check that image virtual address range is sane */
     if ((u64_min_vaddr > UINTPTR_MAX) || (u64_max_vaddr > UINTPTR_MAX)) {
         printf("ERROR: image virtual address [%"PRIu64"..%"PRIu64"] exceeds "
                "UINTPTR_MAX (%u)\n",
                u64_min_vaddr, u64_max_vaddr, UINTPTR_MAX);
         return -1;
     }
 
     vaddr_t max_vaddr = (vaddr_t)u64_max_vaddr;
     vaddr_t min_vaddr = (vaddr_t)u64_min_vaddr;
     size_t image_size = max_vaddr - min_vaddr;
 
     if (dest_paddr + image_size < dest_paddr) {
         printf("ERROR: image destination address integer overflow\n");
         return -1;
     }
 
     /* Zero out all memory in the region, as the ELF file may be sparse. */
     memset((void *)dest_paddr, 0, image_size);
 
     /* Load each segment in the ELF file. */
     for (unsigned int i = 0; i < elf_getNumProgramHeaders(elf); i++) {
         /* Skip segments that are not marked as being loadable. */
         if (elf_getProgramHeaderType(elf, i) != PT_LOAD) {
             continue;
         }
 
         /* Parse size/length headers. */
         vaddr_t seg_vaddr = elf_getProgramHeaderVaddr(elf, i);
         size_t seg_size = elf_getProgramHeaderFileSize(elf, i);
         size_t seg_elf_offset = elf_getProgramHeaderOffset(elf, i);
 
         size_t seg_virt_offset = seg_vaddr - min_vaddr;
         paddr_t seg_dest_paddr = dest_paddr + seg_virt_offset;
         void const *seg_src_addr = (void const *)((uintptr_t)elf +
                                                   seg_elf_offset);
 
         /* Check segment sanity and integer overflows. */
         if ((seg_vaddr < min_vaddr) ||
             (seg_size > image_size) ||
             (seg_src_addr < elf) ||
             ((uintptr_t)seg_src_addr + seg_size < (uintptr_t)elf) ||
             (seg_virt_offset > image_size) ||
             (seg_virt_offset + seg_size > image_size) ||
             (seg_dest_paddr < dest_paddr) ||
             (seg_dest_paddr + seg_size < dest_paddr)) {
             printf("ERROR: segement %d invalid\n", i);
             return -1;
         }
 
         /* Load data into memory. */
         memcpy((void *)seg_dest_paddr, seg_src_addr, seg_size);
     }
 
     return 0;
 }
 
 /*
  * Load an ELF file into physical memory at the given physical address.
  *
  * Returns in 'next_phys_addr' the byte past the last byte of the physical
  * address used.
  */
int load_kernel_elf(
     const char *name,
     void const *elf_blob,
     size_t elf_blob_size,
     paddr_t dest_paddr,
     struct image_info *info)
 {
     int ret;
     uint64_t min_vaddr, max_vaddr;
 
     /* Print diagnostics. */
     printf("ELF-loading image '%s' to %p\n", name, dest_paddr);
 
     /* Get the memory bounds. Unlike most other functions, this returns 1 on
      * success and anything else is an error.
      */
     ret = elf_getMemoryBounds(elf_blob, 0, &min_vaddr, &max_vaddr);
     if (ret != 1) {
         printf("ERROR: Could not get image bounds\n");
         return -1;
     }
 
     /* round up size to the end of the page next page */
     max_vaddr = ROUND_UP(max_vaddr, PAGE_BITS);
     size_t image_size = (size_t)(max_vaddr - min_vaddr);
 
     /* Ensure our starting physical address is aligned. */
     if (!IS_ALIGNED(dest_paddr, PAGE_BITS)) {
         printf("ERROR: Attempting to load ELF at unaligned physical address\n");
         return -1;
     }
 
     /* Ensure that the ELF file itself is 4-byte aligned in memory, so that
      * libelf can perform word accesses on it. */
     if (!IS_ALIGNED(dest_paddr, 2)) {
         printf("ERROR: Input ELF file not 4-byte aligned in memory\n");
         return -1;
     }
 
     /* Print diagnostics. */
     printf("  paddr=[%p..%p]\n", dest_paddr, dest_paddr + image_size - 1);
     printf("  vaddr=[%p..%p]\n", (vaddr_t)min_vaddr, (vaddr_t)max_vaddr - 1);
     printf("  virt_entry=%p\n", (vaddr_t)elf_getEntryPoint(elf_blob));
 
     /* Ensure the ELF file is valid. */
     ret = elf_checkFile(elf_blob);
     if (0 != ret) {
         printf("ERROR: Invalid ELF file\n");
         return -1;
     }
 
     /* Ensure sane alignment of the image. */
     if (!IS_ALIGNED(min_vaddr, PAGE_BITS)) {
         printf("ERROR: Start of image is not 4K-aligned\n");
         return -1;
     }
 
     /* Ensure that we region we want to write to is sane. */
     ret = ensure_phys_range_valid(dest_paddr, dest_paddr + image_size);
     if (0 != ret) {
         printf("ERROR: Physical address range invalid\n");
         return -1;
     }
 
     /* Copy the data. */
     ret = unpack_elf_to_paddr(elf_blob, dest_paddr);
     if (0 != ret) {
         printf("ERROR: Unpacking ELF to %p failed\n", dest_paddr);
         return -1;
     }
 
     /* Record information about the placement of the image. */
     info->phys_region_start = dest_paddr;
     info->phys_region_end = dest_paddr + image_size;
     info->virt_region_start = (vaddr_t)min_vaddr;
     info->virt_region_end = (vaddr_t)max_vaddr;
     info->virt_entry = (vaddr_t)elf_getEntryPoint(elf_blob);
     info->phys_virt_offset = dest_paddr - (vaddr_t)min_vaddr;

     return 0;
}
