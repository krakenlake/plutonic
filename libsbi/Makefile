.PHONY: default release clean

default: this

LIBSBI_VERSION = 0.0.1

LIBSBI_TARGET ?= qemu-64g
#LIBSBI_TARGET ?= vf2

LIBSBI_TARGET_XLEN ?= 64

# tools
LIBSBI_TOOLBIN	?= /usr/local/bin
LIBSBI_CC		?= $(LIBSBI_TOOLBIN)/riscv64-elf-gcc
LIBSBI_CPP		?= $(LIBSBI_TOOLBIN)/riscv64-elf-cpp
LIBSBI_AR		?= $(LIBSBI_TOOLBIN)/riscv64-elf-ar
LIBSBI_RANLIB	?= $(LIBSBI_TOOLBIN)/riscv64-elf-ranlib

# CFLAGS
CFLAGS = -march=rv$(LIBSBI_TARGET_XLEN)g
CFLAGS += -I"$(LIBSBI_SRCD)/include"
CFLAGS += -DDEBUG
CFLAGS += -DPLUTONIC_VERSION=\"$(PLUTONIC_VERSION)\"
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
# no crt0
CFLAGS += -nostartfiles
# optimisation
CFLAGS += -O2
# add debug symbols
CFLAGS += -g
LIBSBI_CFLAGS ?= $(CFLAGS)

# names
LIBSBI_NAME			= $(notdir $(shell pwd))
LIBSBI_CONFIG		?= config
LIBSBI_BUILDROOT	?= ../build
LIBSBI_BUILD		?= $(LIBSBI_BUILDROOT)/$(LIBSBI_TARGET)/$(LIBSBI_NAME)
LIBSBI_BUILDCONF	?= $(LIBSBI_BUILD)/$(LIBSBI_CONFIG)
LIBSBI_RELEASE		?= ../release/$(LIBSBI_TARGET)
LIBSBI_SRC_S		= $(wildcard ./src/*.S)
LIBSBI_SRC_C		= $(wildcard ./src/*.c)
LIBSBI_SRC			= $(LIBSBI_SRC_S) $(LIBSBI_SRC_C)
LIBSBI_OBJ_S		= $(LIBSBI_SRC_S:./src/%.S=$(LIBSBI_BUILD)/%.o)
LIBSBI_OBJ_C		= $(LIBSBI_SRC_C:./src/%.c=$(LIBSBI_BUILD)/%.o)
LIBSBI_OBJ			= $(LIBSBI_OBJ_S) $(LIBSBI_OBJ_C)
LIBSBI_DEP			= $(LIBSBI_OBJ:%.o=%.d)

# dependencies
-include $(LIBSBI_DEP)


# targets
this: $(LIBSBI_BUILD)/$(LIBSBI_NAME).a Makefile
	@ls -ln $<

$(LIBSBI_BUILD) $(LIBSBI_RELEASE):
	mkdir -p $@

$(LIBSBI_BUILD)/$(LIBSBI_NAME).a: $(LIBSBI_BUILD) $(LIBSBI_OBJ) Makefile $(LIBSBI_BUILD)/config.h
	$(LIBSBI_AR) -r -u -v $@ $(LIBSBI_BUILD)/*.o
	$(LIBSBI_RANLIB) $@

$(LIBSBI_BUILD)/config.h: $(LIBSBI_CONFIG)/config.$(LIBSBI_TARGET).h
	cp -p $(LIBSBI_CONFIG)/config.$(LIBSBI_TARGET).h $@

$(LIBSBI_BUILD)/%.o: ./src/%.S Makefile $(LIBSBI_BUILD)/config.h
	$(LIBSBI_CC) $(LIBSBI_CFLAGS) -I$(LIBSBI_BUILD) -Iinclude -MMD -c $< -o $@

$(LIBSBI_BUILD)/%.o: ./src/%.c Makefile $(LIBSBI_BUILD)/config.h
	$(LIBSBI_CC) $(LIBSBI_CFLAGS) -I$(LIBSBI_BUILD) -Iinclude -MMD -c $< -o $@

$(LIBSBI_RELEASE)/$(LIBSBI_NAME)-$(LIBSBI_TARGET).a: $(LIBSBI_BUILD)/$(LIBSBI_NAME).a
	cp $< $@
	@ls -ln $@

release: Makefile $(LIBSBI_RELEASE) $(LIBSBI_RELEASE)/$(LIBSBI_NAME)-$(LIBSBI_TARGET).a

clean:
	rm -fr $(LIBSBI_BUILD)
