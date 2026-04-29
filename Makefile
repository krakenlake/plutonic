.PHONY: default all run debug release clean  

default: all

export PLUTONIC_VERSION = 0.0.2

export TARGET ?= qemu-64g
#export TARGET ?= vf2

export TARGET_XLEN ?= 64

# output directories
export BUILDROOT	?= build
export RELEASE		?= release

# tools
export TOOLBIN	?= /usr/local/bin
export CC		= $(TOOLBIN)/riscv64-elf-gcc
export CPP		= $(TOOLBIN)/riscv64-elf-cpp
export LD		= $(TOOLBIN)/riscv64-elf-ld
export AR		= $(TOOLBIN)/riscv64-elf-ar
export RANLIB	= $(TOOLBIN)/riscv64-elf-ranlib
export OBJCOPY	= $(TOOLBIN)/riscv64-elf-objcopy
export OBJDUMP	= $(TOOLBIN)/riscv64-elf-objdump
export STRIP	= $(TOOLBIN)/riscv64-elf-strip
export GDB		= $(TOOLBIN)/riscv64-elf-gdb

# flags
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
# we need frame pointers for stack unwinding(?)
CFLAGS += -fno-omit-frame-pointer
# no crt0
CFLAGS += -nostartfiles
# optimisation
CFLAGS += -O2
# add debug symbols
CFLAGS += -g

export PLUTONIC_CFLAGS = $(CFLAGS)
export LIBPLTNC_CFLAGS = $(CFLAGS)

# targets
all:
	cd libpltnc && make
	cd kernel && make

run: Makefile
	cd kernel && make run

debug:
	$(GDB) entry -ex "target remote :1234"

gdb:
	cd kernel && make gdb

release: Makefile
	cd libpltnc && make release
	cd kernel && make release

devicetree: Makefile
	cd kernel && make devicetree

clean:
	rm -fr $(BUILDROOT) $(RELEASE)

devtools-mac:
	brew install riscv64-elf-gcc
	brew install riscv64-elf-gdb
	brew install riscv64-elf-binutils
	brew install qemu

