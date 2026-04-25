.PHONY: default all run debug release clean  

default: all

export PLUTONIC_VERSION = 0.0.1

export TARGET ?= qemu-64g
#export TARGET ?= vf2

export TARGET_XLEN ?= 64

export DEBUG ?= -DDEBUG

# names
export BUILDROOT = build
export RELEASE = release

# tools
export GCCBIN	?= /usr/local/bin
export TOOLBIN	?= /usr/local/bin
export CC		= $(GCCBIN)/riscv64-elf-gcc
export CPP		= $(GCCBIN)/riscv64-elf-cpp
export LD		= $(TOOLBIN)/riscv64-elf-ld
export AR		= $(TOOLBIN)/riscv64-elf-ar
export RANLIB	= $(TOOLBIN)/riscv64-elf-ranlib
export OBJCOPY	= $(TOOLBIN)/riscv64-elf-objcopy
export OBJDUMP	= $(TOOLBIN)/riscv64-elf-objdump
export STRIP	= $(TOOLBIN)/riscv64-elf-strip
export GDB		= $(TOOLBIN)/riscv64-elf-gdb

# flags
export LDFLAGS	?= --no-warn-rwx-segments -m elf$(TARGET_XLEN)lriscv


# targets
all:
	cd libpltnc && make TARGET=$(TARGET)
	cd kernel && make TARGET=$(TARGET)

run:
	cd kernel && make TARGET=$(TARGET) run

debug:
	$(GDB) entry -ex "target remote :1234"

release: 
	cd libpltnc && make TARGET=$(TARGET) release
	cd kernel && make TARGET=$(TARGET) release

clean:
	rm -fr $(BUILDROOT) $(RELEASE)

