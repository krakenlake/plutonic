.PHONY: default all run debug release clean  

default: all

export PLUTONIC_VERSION = 0.0.2

export TARGET ?= qemu-64g
#export TARGET ?= vf2

export TARGET_XLEN ?= 64

# names
export BUILDROOT	?= build
export RELEASE		?= release

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
export CFLAGS += -DDEBUG
CFLAGS	+= -DPLUTONIC_VERSION=\"$(PLUTONIC_VERSION)\"
CFLAGS += -Wall -Werror -Wextra -pedantic
# warn if inline function cannot be substituted
CFLAGS	+= -Winline
# create position-independent code
CFLAGS += -fPIC
# create position-independent executables
CFLAGS += -fPIE
# gcc must not try to replace anything with built-in stuff
CFLAGS	+= -fno-builtin
# no crt0
CFLAGS	+= -nostartfiles
CFLAGS	+= -O2
CFLAGS	+= -g


# targets
all:
	cd libpltnc && make
	cd kernel && make

run:
	cd kernel && make run

debug:
	$(GDB) entry -ex "target remote :1234"

release:
	cd libpltnc && make release
	cd kernel && make release

clean:
	rm -fr $(BUILDROOT) $(RELEASE)

