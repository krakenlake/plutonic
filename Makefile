.PHONY: plutonic release clean debug run device-tree

default: plutonic


PLUTONIC_VERSION = 0.0.2

DEBUG ?= -DDEBUG

TARGET ?= qemu-64g
#TARGET ?= vf2

TARGET_XLEN ?= 64


ifeq ($(TARGET), qemu-64g)
	QEMU ?= /usr/local/bin/qemu-system-riscv$(TARGET_XLEN)
	QEMU_HARTS			= 4
	QEMU_BIOS			= default
	QEMU_FLAGS			= -machine virt
	QEMU_FLAGS			+= -cpu rv$(TARGET_XLEN),pmp=false,h=true
	QEMU_FLAGS			+= -smp $(QEMU_HARTS)
	QEMU_FLAGS			+= -gdb tcp::1234
	QEMU_FLAGS			+= -bios $(QEMU_BIOS)
	QEMU_FLAGS			+= -serial stdio
	QEMU_FLAGS			+= -display none
#	QEMU_FLAGS			+= -device virtio-vga
#	QEMU_FLAGS			+= -vga none -device ramfb
	FLASH_START			= 0x80200000
	RAM_START			= 0x80020000
	FLASH_SIZE			= 64K
	RAM_SIZE			= 32K
endif 

ifeq ($(TARGET), vf2)
	FLASH_START			= 0x80200000
	RAM_START			= 0x80020000
define VF2_RUN_MSG

	running on VF2:
	- set TARGET = vf2 in this Makefile
	- make clean; make
	- create a FAT filesystem on SD card
	- copy build/vf2/plutonic.img to SD card
	- insert SD card into VF2
	- attach GPIO-to-USB serial terminal to VF2 (e.g. minicom, 115200 baud)
	- boot into U-Boot from SPI (both dip-switches to L)
	- in U-Boot command line, load and run plutonic.img:
	StarFive # fatload mmc 1:2  0x43fff000 plutonic.img
	StarFive # go 44000000

endef
	VF2_RUN_MSG 
	RUN			= @echo "$$VF2_RUN_MSG"

endif

# tools
TOOLBIN	?= /usr/local/bin
GCC_INC	?= /usr/local/Cellar/riscv-gnu-toolchain/main/riscv64-unknown-elf/include
CC		= $(TOOLBIN)/riscv64-elf-gcc
CPP		= $(TOOLBIN)/riscv64-elf-cpp
LD		= $(TOOLBIN)/riscv64-elf-ld
AR		= $(TOOLBIN)/riscv64-elf-ar
RANLIB	= $(TOOLBIN)/riscv64-elf-ranlib
OBJCOPY	= $(TOOLBIN)/riscv64-elf-objcopy
OBJDUMP	= $(TOOLBIN)/riscv64-elf-objdump
STRIP	= $(TOOLBIN)/riscv64-elf-strip
GDB		= $(TOOLBIN)/riscv64-elf-gdb
QEMU	= $(TOOLBIN)/qemu-system-riscv$(TARGET_XLEN)


# CFLAGS
CFLAGS = $(DEBUG)
CFLAGS += -DPLUTONIC_VERSION=\"$(PLUTONIC_VERSION)\"
# target platform
CFLAGS += -march=rv$(TARGET_XLEN)g
# warnings
CFLAGS += -Wall -Werror -Wextra -pedantic
# warn if inline function cannot be substituted
CFLAGS += -Winline
# create position-independent code
CFLAGS += -fPIC
# create position-independent executables
CFLAGS += -fPIE
# gcc must not try to replace anything with built-in stuff
CFLAGS += -fno-builtin
CFLAGS += -ffreestanding
# no crt0
CFLAGS += -nostartfiles
# we need frame pointers for stack unwinding(?)
#CFLAGS += -fno-omit-frame-pointer
# optimisation
CFLAGS += -O2
# add debug symbols
CFLAGS += -g
# needed to access memory beyond 0x7fffffff
CFLAGS += -mcmodel=medany

PLUTONIC_CFLAGS ?= $(CFLAGS)

# LDFLAGS
PLUTONIC_LDFLAGS ?= --no-warn-rwx-segments -m elf$(TARGET_XLEN)lriscv

# CPPFLAGS
PLUTONIC_CPPFLAGS += -DFLASH_START=$(FLASH_START)
PLUTONIC_CPPFLAGS += -DFLASH_SIZE=$(FLASH_SIZE)
PLUTONIC_CPPFLAGS += -DRAM_START=$(RAM_START)
PLUTONIC_CPPFLAGS += -DRAM_SIZE=$(RAM_SIZE)

# names
NAME = $(notdir $(shell pwd))
CONFIG = config
SRCDIR = src
BUILDROOT = ../build
BUILD = $(BUILDROOT)/$(TARGET)/$(NAME)
RELEASE = ../release/$(TARGET)
SRC_S = $(wildcard ./src/*.S) $(wildcard ./src/**/*.S)
SRC_C = $(wildcard ./src/*.c) $(wildcard ./src/**/*.c)
SRC = $(SRC_S) $(SRC_C)
OBJ_S = $(SRC_S:./src/%.S=$(BUILD)/%.o)
OBJ_C = $(SRC_C:./src/%.c=$(BUILD)/%.o)
OBJ = $(OBJ_S) $(OBJ_C)
DEP = $(OBJ:%.o=%.d)

# libs
LIBNAMES = libpltnc libsbicall
$(foreach libname,$(LIBNAMES),$(eval LIBS+=$(BUILDROOT)/$(TARGET)/$(libname)/$(libname).a))
$(foreach libname,$(LIBNAMES),$(eval LIBINCLUDES+= -I../$(libname)/include))
.PHONY: $(LIBS)

INCLUDES = -Iinclude $(LIBINCLUDES) -I$(BUILD) -I$(GCC_INC)

SRCDIRS = $(shell find $(SRCDIR) -type d)
BUILDDIRS = $(SRCDIRS:src%=$(BUILD)%)


# dependencies
-include $(DEP)


# targets

plutonic: $(BUILD)/$(NAME).img
	@ls -ln $<

$(BUILDDIRS) $(RELEASE):
	mkdir -p $@

$(BUILD)/$(NAME).img: $(BUILD)/$(NAME).elf
	$(OBJCOPY) $< -O binary $@

$(BUILD)/$(NAME).elf: $(LIBS) Makefile $(BUILDDIRS) $(BUILD)/link.ld $(BUILD)/config.h $(OBJ)
	$(LD) -T $(BUILD)/link.ld $(PLUTONIC_LDFLAGS) -o $@ $(OBJ) $(LIBS)

$(BUILD)/link.ld: $(CONFIG)/link.ld.in Makefile
	$(CPP) $(PLUTONIC_CPPFLAGS) $(PLUTONIC_CFLAGS) -E -P -x c $< > $@ 

$(BUILD)/config.h: $(CONFIG)/config.$(TARGET).h Makefile
	cp -p $(CONFIG)/config.$(TARGET).h $@

$(BUILD)/%.o: $(SRCDIR)/%.S Makefile
	$(CC) $(PLUTONIC_CFLAGS) $(INCLUDES) -MMD -c $< -o $@

$(BUILD)/%.o: $(SRCDIR)/%.c Makefile
	$(CC) $(PLUTONIC_CFLAGS) $(INCLUDES) -MMD -c $< -o $@

$(LIBS):
	cd ../$(notdir $(basename $@)) && make TARGET=$(TARGET)

$(RELEASE)/plutonic$(PLUTONIC_VERSION)-$(TARGET).img: $(BUILD)/$(NAME).img
	cp $< $@
	@ls -ln $@

release: Makefile $(RELEASE) $(RELEASE)/plutonic$(PLUTONIC_VERSION)-$(TARGET).img

clean:
	rm -fr $(BUILD)

run: $(BUILD)/$(NAME).img Makefile
	$(QEMU) $(QEMU_FLAGS) -kernel $<

disass: $(BUILD)/$(NAME).elf Makefile
	$(GDB) $<

debug:
	$(GDB) $(BUILD)/$(NAME).elf -ex "target remote :1234"

devicetree:
	$(QEMU) $(QEMU_FLAGS) -machine dumpdtb=$(BUILD)/qemu.dtb
	dtc -I dtb -O dts $(BUILD)/qemu.dtb -o $(BUILD)/qemu-device-tree.dts
	less $(BUILD)/qemu-device-tree.dts

