.PHONY: clean default all

default: this

PLUTONIC_VERSION = 0.0.1

#TARGET ?= qemu-M-64g
TARGET ?= qemu-S-64g

# TODO: currently not working
#TARGET ?= vf2

DEBUG ?= -DDEBUG


ifeq ($(TARGET), qemu-M-64g)
	QEMU_BIOS			= none
	QEMU_FLAGS			= -machine virt -cpu rv$(TARGET_XLEN),pmp=false,h=true -smp $(QEMU_HARTS) -gdb tcp::1234 -bios none -serial stdio -display none -kernel $(BUILD)/$(NAME).img
	FLASH_START			= 0x80000000
	RAM_START			= 0x80020000
	FLASH_SIZE			= 64K
	RAM_SIZE			= 32K
	TARGET_XLEN			= 64
	CFLAGS				+= -march=rv$(TARGET_XLEN)g
endif 

ifeq ($(TARGET), qemu-S-64g)
	QEMU_BIOS			= default
	QEMU_FLAGS			= -machine virt -cpu rv$(TARGET_XLEN),pmp=false,h=true -smp $(QEMU_HARTS) -gdb tcp::1234 -bios $(QEMU_BIOS) -serial stdio -display none -kernel $(BUILD)/$(NAME).img
	FLASH_START			= 0x80200000
	RAM_START			= 0x80020000
	FLASH_SIZE			= 64K
	RAM_SIZE			= 32K
	TARGET_XLEN			= 64
	CFLAGS				+= -march=rv$(TARGET_XLEN)g
endif 

ifeq ($(TARGET), vf2)
	FLASH_START			= 0x80200000
	RAM_START			= 0x80020000
	TARGET_XLEN			= 64
	CFLAGS				+= -march=rv$(TARGET_XLEN)g
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
	export VF2_RUN_MSG 
	RUN			= @echo "$$VF2_RUN_MSG"

endif

QEMU_HARTS			= 4
RUN					= qemu-system-riscv$(TARGET_XLEN) $(QEMU_FLAGS) 


# tools
GCCBIN	?= /usr/local/bin
TOOLBIN ?= /usr/local/bin
CC      = $(GCCBIN)/riscv64-elf-gcc
CPP     = $(GCCBIN)/riscv64-elf-cpp
CFLAGS	+= $(DEBUG) -DPLUTONIC_VERSION=\"$(PLUTONIC_VERSION)\" -nostartfiles -O2 -g -I"src/include"
LD		= $(TOOLBIN)/riscv64-elf-ld
LDFLAGS = --no-warn-rwx-segments -m elf$(TARGET_XLEN)lriscv
OBJCOPY = $(TOOLBIN)/riscv64-elf-objcopy
OBJDUMP = $(TOOLBIN)/riscv64-elf-objdump
STRIP   = $(TOOLBIN)/riscv64-elf-strip
GDB		= $(TOOLBIN)/riscv64-elf-gdb


# directories
SRCD	= src
LOGD	= log


# names
NAME = plutonic
CONFIG = config
BUILDROOT = build
BUILD = $(BUILDROOT)/$(TARGET)
RELEASE = release
SRC = $(wildcard $(SRCD)/*.S)
OBJ = $(SRC:$(SRCD)/%.S=$(BUILD)/%.o)
DEP = $(OBJ:%.o=%.d)


# dependencies
-include $(DEP)


# targets
this: $(BUILD)/$(NAME).img $(BUILD)/$(NAME)-stripped.elf
	ls -al $(BUILD)/$(NAME).img $(BUILD)/$(NAME)-stripped.elf

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/$(NAME).img: $(BUILD)/$(NAME).elf
	$(OBJCOPY) $(BUILD)/$(NAME).elf -O binary $@

$(BUILD)/$(NAME).elf: $(BUILD)/link.ld Makefile $(OBJ)
	$(LD) -T $(BUILD)/link.ld $(LDFLAGS) -o $@ $(OBJ)

$(BUILD)/link.ld: linker/link.ld.in Makefile $(BUILD)
	$(CPP) $(CFLAGS) -DFLASH_START=$(FLASH_START) -DFLASH_SIZE=$(FLASH_SIZE) -DRAM_START=$(RAM_START) -DRAM_SIZE=$(RAM_SIZE) -E -P -x c $< > $@ 

$(BUILD)/config.h: $(CONFIG)/config.$(TARGET).h
	cp $< $@

$(BUILD)/%.o: $(SRCD)/%.S Makefile $(BUILD)/config.h
	-$(CC) $(CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(BUILD)/$(NAME)-stripped.elf: $(BUILD)/$(NAME).elf
	$(STRIP) $< -o $@

$(RELEASE)/plutonic-$(TARGET).img: $(BUILD)/$(NAME).img
	mkdir -p $(RELEASE)
	cp $< $@
	ls -al $(RELEASE)/*.img

release: $(RELEASE)/plutonic-$(TARGET).img

clean:
	rm -fr $(BUILD)

veryclean:
	rm -fr $(BUILDROOT) $(RELEASE)

run: $(BUILD)/$(NAME).img
	$(RUN)

debug:
	$(GDB) entry -ex "target remote :1234"

device-tree:
	qemu-system-riscv$(TARGET_XLEN) $(QEMU_FLAGS) -machine dumpdtb=$(BUILD)/qemu.dtb
	dtc -I dtb -O dts $(BUILD)/qemu.dtb -o $(BUILD)/qemu-device-tree.dts
	less $(BUILD)/qemu-device-tree.dts

all: 
	make TARGET=qemu-M-64g release
	make TARGET=qemu-S-64g release
#	make TARGET=vf2 release
