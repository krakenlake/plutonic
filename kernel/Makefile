.PHONY: default release clean run debug device-tree

default: this

DEBUG ?= -DDEBUG


ifeq ($(TARGET), qemu-64g)
	QEMU_BIOS			= default
	QEMU_FLAGS			= -machine virt
# cpu type and extensions
	QEMU_FLAGS			+= -cpu rv$(TARGET_XLEN),pmp=false,h=true
# number of cpus
	QEMU_FLAGS			+= -smp $(QEMU_HARTS)
# turn debugging port on
	QEMU_FLAGS			+= -gdb tcp::1234
# boot via SBI
	QEMU_FLAGS			+= -bios $(QEMU_BIOS)
# serial device
	QEMU_FLAGS			+= -serial stdio
# display
	QEMU_FLAGS			+= -display none
#	QEMU_FLAGS			+= -device virtio-vga
# framebuffer device
#	QEMU_FLAGS			+= -vga none -device ramfb
	QEMU_FLAGS			+= -kernel $(BUILD)/$(NAME).img
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
	export VF2_RUN_MSG 
	RUN			= @echo "$$VF2_RUN_MSG"

endif

QEMU_HARTS			= 4
RUN					= qemu-system-riscv$(TARGET_XLEN) $(QEMU_FLAGS) 

# CFLAGS
CFLAGS = -DDEBUG
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
CFLAGS += -fno-omit-frame-pointer
# optimisation
CFLAGS += -O2
# add debug symbols
CFLAGS += -g

PLUTONIC_CFLAGS ?= $(CFLAGS)
# needed to access memory beyond 0x7fffffff
PLUTONIC_CFLAGS += -mcmodel=medany
PLUTONIC_CFLAGS += -I"../kernel/include"
PLUTONIC_CFLAGS += -I"../libpltnc/include"

# LDFLAGS
PLUTONIC_LDFLAGS ?= --no-warn-rwx-segments -m elf$(TARGET_XLEN)lriscv

# CPPFLAGS
PLUTONIC_CPPFLAGS += -DFLASH_START=$(FLASH_START)
PLUTONIC_CPPFLAGS += -DFLASH_SIZE=$(FLASH_SIZE)
PLUTONIC_CPPFLAGS += -DRAM_START=$(RAM_START)
PLUTONIC_CPPFLAGS += -DRAM_SIZE=$(RAM_SIZE)

# names
NAME = plutonic
CONFIG = config
BUILDROOT = ../build
BUILD = $(BUILDROOT)/$(TARGET)/kernel
RELEASE = ../release/$(TARGET)
SRC_S = $(wildcard ./src/*.S)
SRC_C = $(wildcard ./src/*.c)
SRC = $(SRC_S) $(SRC_C)
OBJ_S = $(SRC_S:./src/%.S=$(BUILD)/%.o)
OBJ_C = $(SRC_C:./src/%.c=$(BUILD)/%.o)
OBJ = $(OBJ_S) $(OBJ_C)
DEP = $(OBJ:%.o=%.d)

# dependencies
-include $(DEP)


# targets
this: Makefile $(BUILD)/$(NAME).img
	@ls -ln $(BUILD)/$(NAME).img

$(BUILD) $(RELEASE):
	mkdir -p $@

$(BUILD)/$(NAME).img: $(BUILD) $(BUILD)/$(NAME).elf
	$(OBJCOPY) $(BUILD)/$(NAME).elf -O binary $@

$(BUILD)/$(NAME).elf: Makefile $(BUILDROOT)/$(TARGET)/libpltnc/libpltnc.a $(OBJ) $(BUILD)/link.ld
	$(LD) -T $(BUILD)/link.ld $(PLUTONIC_LDFLAGS) -o $@ $(OBJ) $(BUILDROOT)/$(TARGET)/libpltnc/libpltnc.a

$(BUILD)/link.ld: Makefile linker/link.ld.in $(BUILD)
	$(CPP) $(PLUTONIC_CPPFLAGS) $(PLUTONIC_CFLAGS) -E -P -x c linker/link.ld.in > $@ 

linker/link.ld.in:

$(BUILD)/config.h: $(CONFIG)/config.$(TARGET).h
	cp $(CONFIG)/config.$(TARGET).h $@

$(BUILD)/%.o: src/%.S Makefile $(BUILD)/config.h
	$(CC) $(PLUTONIC_CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(BUILD)/%.o: src/%.c Makefile $(BUILD)/config.h
	$(CC) $(PLUTONIC_CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(BUILDROOT)/$(TARGET)/libpltnc/libpltnc.a:
	cd ../libpltnc && make TARGET=$(TARGET)

$(RELEASE)/plutonic-$(TARGET).img: $(BUILD)/$(NAME).img
	cp $(BUILD)/$(NAME).img $@
	@ls -ln $@

release: Makefile $(RELEASE) $(RELEASE)/$(NAME)-$(TARGET).img

clean:
	rm -fr $(BUILD)

run: Makefile $(BUILD)/$(NAME).img
	$(RUN)

gdb: Makefile $(BUILD)/$(NAME).elf
	$(GDB) $(BUILD)/$(NAME).elf

debug:
	$(GDB) entry -ex "target remote :1234"

devicetree:
	qemu-system-riscv$(TARGET_XLEN) $(QEMU_FLAGS) -machine dumpdtb=$(BUILD)/qemu.dtb
	dtc -I dtb -O dts $(BUILD)/qemu.dtb -o $(BUILD)/qemu-device-tree.dts
	less $(BUILD)/qemu-device-tree.dts

