.PHONY: default all run debug release clean devtools-mac

default: all

# output directories
BUILDROOT	?= build
RELEASE		?= release


LIBDIRS = $(wildcard ./lib*)
LIBNAMES =  $(LIBDIRS:./lib%=lib%)
$(foreach libname,$(LIBNAMES),$(eval LIBS+=$(BUILDROOT)/$(TARGET)/$(libname)/$(libname).a))
.PHONY: kernel $(LIBS)

# targets
all: Makefile $(LIBS) kernel

$(LIBS) kernel:
	cd $(notdir $(basename $@)) && make

run: Makefile
	cd kernel && make run

debug: Makefile
	cd kernel && make debug

disass: Makefile
	cd kernel && make gdb

release: Makefile
	cd kernel && make release

devicetree: Makefile
	cd kernel && make devicetree

clean:
	rm -fr $(BUILDROOT) $(RELEASE)

# install or update development toolchain on MacOS
devtools-mac:
	brew install riscv64-elf-gcc
	brew install riscv64-elf-gdb
	brew install riscv64-elf-binutils
	brew install qemu
