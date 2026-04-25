.PHONY: default release clean run debug device-tree

default: this

DEBUG ?= -DDEBUG


ifeq ($(TARGET), qemu-64g)
	QEMU_BIOS			= default
	QEMU_FLAGS			= -machine virt -cpu rv$(TARGET_XLEN),pmp=false,h=true -smp $(QEMU_HARTS) -gdb tcp::1234 -bios $(QEMU_BIOS) -serial stdio -display none -kernel $(BUILD)/$(NAME).img
	FLASH_START			= 0x80200000
	RAM_START			= 0x80020000
	FLASH_SIZE			= 64K
	RAM_SIZE			= 32K
	CFLAGS				+= -march=rv$(TARGET_XLEN)g
endif 

ifeq ($(TARGET), vf2)
	FLASH_START			= 0x80200000
	RAM_START			= 0x80020000
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


# flags
CFLAGS	+= -DDEBUG
CFLAGS	+= -DPLUTONIC_VERSION=\"$(PLUTONIC_VERSION)\"
CFLAGS	+= -nostartfiles
# gcc must not try to replace anything with built-in stuff
CFLAGS	+= -fno-builtin
# warn if inline function cannot be substituted
CFLAGS	+= -Winline
# needed to access memory beyond 0x7fffffff
CFLAGS	+= -mcmodel=medany
CFLAGS	+= -O2 
CFLAGS	+= -g
CFLAGS	+= -I"./include"
LDFLAGS	?= --no-warn-rwx-segments -m elf$(TARGET_XLEN)lriscv


# names
NAME = plutonic
CONFIG = ../config
BUILDROOT = ../build
BUILD = $(BUILDROOT)/$(TARGET)/kernel
RELEASE = ../release/$(TARGET)
SRC_S = $(wildcard ./*.S)
SRC_C = $(wildcard ./*.c)
SRC = $(SRC_S) $(SRC_C)
OBJ_S = $(SRC_S:./%.S=$(BUILD)/%.o)
OBJ_C = $(SRC_C:./%.c=$(BUILD)/%.o)
OBJ = $(OBJ_S) $(OBJ_C)
DEP = $(OBJ:%.o=%.d)


# dependencies
-include $(DEP)


# targets
this: $(BUILD)/$(NAME).img $(BUILD)/$(NAME)-stripped.elf
	@ls -ln $(BUILD)/$(NAME).img $(BUILD)/$(NAME)-stripped.elf

$(BUILD):
	mkdir -p $(BUILD)

$(RELEASE):
	mkdir -p $(RELEASE)

$(BUILD)/$(NAME).img: $(BUILD) $(BUILD)/$(NAME).elf
	$(OBJCOPY) $(BUILD)/$(NAME).elf -O binary $@

$(BUILD)/$(NAME).elf: Makefile $(BUILDROOT)/$(TARGET)/libpltnc/libpltnc.a $(OBJ) $(BUILD)/link.ld
	$(LD) -T $(BUILD)/link.ld $(LDFLAGS) -o $@ $(OBJ) $(BUILDROOT)/$(TARGET)/libpltnc/libpltnc.a

$(BUILD)/link.ld: linker/link.ld.in Makefile $(BUILD)
	$(CPP) $(CFLAGS) -DFLASH_START=$(FLASH_START) -DFLASH_SIZE=$(FLASH_SIZE) -DRAM_START=$(RAM_START) -DRAM_SIZE=$(RAM_SIZE) -E -P -x c $< > $@ 

#$(BUILD)/config.h: $(CONFIG)/config.$(TARGET).h
#	cp $< $@
$(BUILD)/config.h: $(CONFIG)/config.$(TARGET).h
	cp $(CONFIG)/config.$(TARGET).h $@

$(BUILD)/%.o: %.S Makefile $(BUILD)/config.h
	$(CC) $(CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(BUILD)/%.o: %.c Makefile $(BUILD)/config.h
	$(CC) $(CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(BUILD)/$(NAME)-stripped.elf: $(BUILD)/$(NAME).elf
	$(STRIP) $< -o $@

$(BUILDROOT)/$(TARGET)/libpltnc/libpltnc.a:
	cd ../libpltnc && make TARGET=$(TARGET)

$(RELEASE)/plutonic-$(TARGET).img: $(BUILD)/$(NAME).img
	cp $(BUILD)/$(NAME).img $@
	@ls -ln $@

release: $(RELEASE) $(RELEASE)/plutonic-$(TARGET).img

clean:
	rm -fr $(BUILD)

run: $(BUILD)/$(NAME).img
	$(RUN)

debug:
	$(GDB) entry -ex "target remote :1234"

device-tree:
	qemu-system-riscv$(TARGET_XLEN) $(QEMU_FLAGS) -machine dumpdtb=$(BUILD)/qemu.dtb
	dtc -I dtb -O dts $(BUILD)/qemu.dtb -o $(BUILD)/qemu-device-tree.dts
	less $(BUILD)/qemu-device-tree.dts

