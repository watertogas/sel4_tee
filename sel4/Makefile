
MKDIR = if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi


KERNEL_PLATFORM := qemu-virt
KERNEL_IS_MCS := false
KERNEL_ARCH_BIT := 64
KERNEL_ARCH := arm
KERNEL_ARCH_TYPE := armv8-a
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

LINKER_SCRIPT := $(SEL4_PATH)/extra_includes/kernel.ld
KERNEL_LDFLAGS := -static
BUILD_CC := $(CROSS_COMPILE)gcc
BUILD_LD := $(CROSS_COMPILE)ld
BUILD_STRIP := $(CROSS_COMPILE)strip
BUILD_OBJCOPY := $(CROSS_COMPILE)objcopy
GEN_FILE_TOOL := $(SEL4_PATH)/tools/cpp_gen.sh

BUILD_OUT := $(SEL4_PATH)/out
BUILD_INCLUDES += -Iextra_includes \
				  -Iextra_includes/gen_headers \
				  -Ilibsel4/include \
				  -Iinclude/plat/default \
				  -Ilibsel4/mode_include/$(KERNEL_ARCH_BIT)

$(info CROSS_COMPILE:$(CROSS_COMPILE))
$(info BUILD_OUT:$(BUILD_OUT))

KERNEL_SRCS := \
	src/inlines.c \
    src/assert.c \
    src/util.c \
    src/string.c \
    src/fastpath/fastpath.c \
    src/api/syscall.c \
    src/api/faults.c \
    src/kernel/cspace.c \
    src/kernel/faulthandler.c \
    src/kernel/thread.c \
    src/kernel/boot.c \
    src/kernel/stack.c \
    src/object/notification.c \
    src/object/cnode.c \
    src/object/endpoint.c \
    src/object/interrupt.c \
    src/object/objecttype.c \
    src/object/tcb.c \
    src/object/untyped.c \
    src/model/preemption.c \
    src/model/statedata.c \
    src/model/smp.c \
    src/machine/io.c \
    src/machine/capdl.c \
    src/machine/registerset.c \
    src/machine/fpu.c \
    src/benchmark/benchmark.c \
    src/benchmark/benchmark_track.c \
    src/benchmark/benchmark_utilisation.c \
    src/smp/lock.c \
    src/smp/ipi.c

ifeq ($(KERNEL_PLATFORM),qemu-virt)
	KERNEL_SRCS += \
	src/arch/arm/machine/l2c_nop.c \
    src/arch/arm/machine/gic_v3.c \
	src/drivers/serial/pl011.c \
	src/drivers/timer/generic_timer.c

	BUILD_INCLUDES += -Ilibsel4/sel4_plat_include/qemu-arm-virt
endif

ifeq ($(KERNEL_IS_MCS),true)
	KERNEL_SRCS += \
	src/object/reply.c \
    src/object/schedcontext.c \
    src/object/schedcontrol.c \
    src/kernel/sporadic.c
endif

ifeq ($(KERNEL_ARCH),arm)
	KERNEL_SRCS += \
    src/arch/arm/c_traps.c \
    src/arch/arm/api/faults.c \
    src/arch/arm/benchmark/benchmark.c \
    src/arch/arm/kernel/boot.c \
    src/arch/arm/kernel/thread.c \
    src/arch/arm/machine/cache.c \
    src/arch/arm/machine/errata.c \
    src/arch/arm/machine/debug.c \
    src/arch/arm/machine/hardware.c \
    src/arch/arm/machine/io.c \
    src/arch/arm/object/interrupt.c \
    src/arch/arm/object/tcb.c \
    src/arch/arm/object/iospace.c \
    src/arch/arm/object/vcpu.c \
    src/arch/arm/object/smmu.c \
    src/arch/arm/object/smc.c \
    src/arch/arm/smp/ipi.c

	BUILD_INCLUDES += -Iinclude/arch/arm
	BUILD_INCLUDES += -Ilibsel4/arch_include/arm

ifeq ($(KERNEL_ARCH_BIT),64)
	KERNEL_SRCS += \
	src/arch/arm/64/object/objecttype.c \
    src/arch/arm/64/machine/capdl.c \
    src/arch/arm/64/machine/registerset.c \
    src/arch/arm/64/machine/fpu.c \
    src/arch/arm/64/machine/debug.c \
    src/arch/arm/64/model/statedata.c \
    src/arch/arm/64/c_traps.c \
    src/arch/arm/64/idle.c \
    src/arch/arm/64/kernel/thread.c \
    src/arch/arm/64/kernel/vspace.c \
	src/arch/arm/64/head.S \
	src/arch/arm/64/traps.S

	BUILD_FLAGS += -march=armv8-a
	BUILD_INCLUDES += -Iinclude/arch/arm/arch/64
	BUILD_INCLUDES += -Iinclude/64
	BUILD_INCLUDES += -Ilibsel4/sel4_arch_include/aarch64
endif

ifeq ($(KERNEL_ARCH_TYPE),armv8-a)
	KERNEL_SRCS += \
	src/arch/arm/armv/armv8-a/$(KERNEL_ARCH_BIT)/cache.c \
    src/arch/arm/armv/armv8-a/$(KERNEL_ARCH_BIT)/user_access.c \
    src/arch/arm/armv/armv8-a/$(KERNEL_ARCH_BIT)/machine_asm.S

	BUILD_INCLUDES += -Iinclude/arch/arm/armv/armv8-a
	BUILD_INCLUDES += -Iinclude/arch/arm/armv/armv8-a/$(KERNEL_ARCH_BIT)
endif
endif

# create a separate list of objects per source type
KERNEL_CSRCS := $(sort $(filter %.c,$(KERNEL_SRCS)))
#add extra files for kernel all:
KERNEL_CSRCS += src/config/default_domain.c
KERNEL_ASMSRCS := $(filter %.S,$(KERNEL_SRCS))

KERNEL_ALL_CSRC := $(BUILD_OUT)/kernel_all.c
KERNEL_ALL_COBJS := $(BUILD_OUT)/kernel_all.o

KERNEL_ASMOBJS := $(addprefix $(BUILD_OUT)/,$(patsubst %.S,%.o,$(KERNEL_ASMSRCS)))
KERNEL_OBJS := $(KERNEL_ASMOBJS) $(KERNEL_ALL_COBJS)

$(info KERNEL_CSRCS:$(KERNEL_CSRCS))
$(info KERNEL_OBJS:$(KERNEL_OBJS))
$(info KERNEL_ALL_COBJS:$(KERNEL_ALL_COBJS))
$(info KERNEL_ASMOBJS:$(KERNEL_ASMOBJS))

#.PHONY: clean-for-build
#clean-for-build:
#	rm $(KERNEL_ALL_CSRC)
#	rm $(KERNEL_ALL_COBJS)

OUTELF := $(BUILD_OUT)/sel4.elf
OUTBIN := $(BUILD_OUT)/sel4.bin

$(KERNEL_ALL_CSRC): $(KERNEL_CSRCS)
	@$(MKDIR)
	@echo combining all c file: $^
	$(GEN_FILE_TOOL) $^ > $@

$(KERNEL_ALL_COBJS): $(KERNEL_ALL_CSRC)
	@$(MKDIR)
	@echo compiling c file: $<
	$(NOECHO)$(BUILD_CC) $(BUILD_FLAGS) $(BUILD_INCLUDES) -c $< -MD -MP -MT $@ -MF $(@:%o=%d) -o $@

$(KERNEL_ASMOBJS): $(BUILD_OUT)/%.o: %.S
	@$(MKDIR)
	@echo compiling asm file: $<
	$(NOECHO)$(BUILD_CC) $(BUILD_FLAGS) $(BUILD_INCLUDES) -c $< -MD -MP -MT $@ -MF $(@:%o=%d) -o $@

$(OUTELF).sym: $(KERNEL_OBJS) $(LINKER_SCRIPT)
	$(info linking $@)
	$(NOECHO)$(BUILD_LD) $(KERNEL_LDFLAGS) -T $(LINKER_SCRIPT) $(KERNEL_OBJS) -Map=$(OUTELF).map -o $@

$(OUTELF): $(OUTELF).sym
	$(info generating striped kernel elf files: $@)
	$(NOECHO)$(BUILD_STRIP) --strip-all $< -o $@

$(OUTBIN): $(OUTELF)
	$(info generating kernel bin: $@)
	$(NOECHO)$(BUILD_OBJCOPY) -O binary $< $@

all: $(OUTELF) $(OUTBIN)