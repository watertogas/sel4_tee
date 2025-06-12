
MKDIR = if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi


LOADER_START_ADDR := 0xE000000
CONFIG_MAX_NUM_NODES := 2

#default platform is aarch64 with armv8-a
BUILD_INCLUDES := -Iinclude
BUILD_FLAGS :=  -D__KERNEL_64__ \
				-O2 -g -DNDEBUG \
				-std=c99 -Wall -Werror \
				-Wstrict-prototypes -Wmissing-prototypes \
				-Wnested-externs -Wmissing-declarations \
				-Wundef -Wpointer-arith -Wno-nonnull \
				-nostdinc -ffreestanding -fno-stack-protector \
				-fno-asynchronous-unwind-tables -fno-common -O2 -nostdlib \
				-fno-pic -fno-pie -DDEBUG -g -ggdb -mgeneral-regs-only -mno-outline-atomics

LINKER_SCRIPT := $(LOADER_PATH)/linker.lds
LOADER_LDFLAGS := -static --defsym=LOADER_START_ADDR=$(LOADER_START_ADDR)
LOADER_LDFLAGS += --defsym=CONFIG_MAX_NUM_NODES=$(CONFIG_MAX_NUM_NODES)
BUILD_CC := $(CROSS_COMPILE)gcc
BUILD_LD := $(CROSS_COMPILE)ld
BUILD_STRIP := $(CROSS_COMPILE)strip
BUILD_OBJCOPY := $(CROSS_COMPILE)objcopy

BUILD_OUT := $(LOADER_PATH)/out
BUILD_INCLUDES += -Iinclude/arch-arm/64 \
				  -Iinclude/arch-arm/armv/armv8-a/64/armv

$(info CROSS_COMPILE:$(CROSS_COMPILE))
$(info BUILD_OUT:$(BUILD_OUT))

LOADER_SRCS := \
	src/common.c \
    src/debug.c \
    src/mmu.c \
    src/printf.c \
    src/string.c \
    src/smp_boot.c \
    src/sys_boot.c \
	src/structures.c \
    src/pl011-uart.c \
	src/elf/elf.c \
	src/elf/elf32.c \
	src/elf/elf64.c \
    src/aarch64/crt0.S \
    src/aarch64/mmu.S \
	src/aarch64/kernel_elf.S \
    src/aarch64/traps.S



# create a separate list of objects per source type
LOADER_CSRCS := $(sort $(filter %.c,$(LOADER_SRCS)))
LOADER_ASMSRCS := $(filter %.S,$(LOADER_SRCS))

LOADER_ASMOBJS := $(addprefix $(BUILD_OUT)/,$(patsubst %.S,%.o,$(LOADER_ASMSRCS)))
LOADER_COBJS := $(addprefix $(BUILD_OUT)/,$(patsubst %.c,%.o,$(LOADER_CSRCS)))
LOADER_OBJS := $(LOADER_ASMOBJS) $(LOADER_COBJS)

$(info LOADER_CSRCS:$(LOADER_CSRCS))
$(info LOADER_ASMSRCS:$(LOADER_ASMSRCS))
$(info LOADER_OBJS:$(LOADER_OBJS))

OUTELF := $(BUILD_OUT)/sel4_packed.elf
OUTBIN := $(BUILD_OUT)/sel4_packed.bin

$(LOADER_COBJS): $(BUILD_OUT)/%.o: %.c
	@$(MKDIR)
	@echo compiling c file: $<
	$(NOECHO)$(BUILD_CC) $(BUILD_FLAGS) $(BUILD_INCLUDES) -c $< -MD -MP -MT $@ -MF $(@:%o=%d) -o $@

$(LOADER_ASMOBJS): $(BUILD_OUT)/%.o: %.S
	@$(MKDIR)
	@echo compiling asm file: $<
	$(NOECHO)$(BUILD_CC) $(BUILD_FLAGS) $(BUILD_INCLUDES) -c $< -MD -MP -MT $@ -MF $(@:%o=%d) -o $@

$(OUTELF).sym: $(LOADER_OBJS) $(LINKER_SCRIPT)
	$(info linking $@)
	$(NOECHO)$(BUILD_LD) $(LOADER_LDFLAGS) -T $(LINKER_SCRIPT) $(LOADER_OBJS) -Map=$(OUTELF).map -o $@

$(OUTELF): $(OUTELF).sym
	$(info generating striped kernel packed elf files: $@)
	$(NOECHO)$(BUILD_STRIP) --strip-all $< -o $@

$(OUTBIN): $(OUTELF)
	$(info generating kernel packed bin: $@)
	$(NOECHO)$(BUILD_OBJCOPY) -O binary $< $@

all: $(OUTELF) $(OUTBIN)