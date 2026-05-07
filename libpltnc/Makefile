.PHONY: default release clean

default: this

LIBPLTNC_VERSION = 0.0.1

LIBPLTNC_TARGET ?= qemu-64g
#LIBPLTNC_TARGET ?= vf2

LIBPLTNC_TARGET_XLEN ?= 64

# tools
LIBPLTNC_TOOLBIN	?= /usr/local/bin
LIBPLTNC_CC			?= $(LIBPLTNC_TOOLBIN)/riscv64-elf-gcc
LIBPLTNC_CPP		?= $(LIBPLTNC_TOOLBIN)/riscv64-elf-cpp
LIBPLTNC_AR			?= $(LIBPLTNC_TOOLBIN)/riscv64-elf-ar
LIBPLTNC_RANLIB		?= $(LIBPLTNC_TOOLBIN)/riscv64-elf-ranlib

# CFLAGS
CFLAGS = -march=rv$(LIBPLTNC_TARGET_XLEN)g
CFLAGS += -I"$(LIBPLTNC_SRCD)/include"
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
LIBPLTNC_CFLAGS ?= $(CFLAGS)

# names
LIBPLTNC_NAME		= $(notdir $(shell pwd))
LIBPLTNC_CONFIG		?= config
LIBPLTNC_BUILDROOT	?= ../build
LIBPLTNC_BUILD		?= $(LIBPLTNC_BUILDROOT)/$(LIBPLTNC_TARGET)/$(LIBPLTNC_NAME)
LIBPLTNC_BUILDCONF	?= $(LIBPLTNC_BUILD)/$(LIBPLTNC_CONFIG)
LIBPLTNC_RELEASE	?= ../release/$(LIBPLTNC_TARGET)
LIBPLTNC_SRC_S		= $(wildcard ./src/*.S)
LIBPLTNC_SRC_C		= $(wildcard ./src/*.c)
LIBPLTNC_SRC		= $(LIBPLTNC_SRC_S) $(LIBPLTNC_SRC_C)
LIBPLTNC_OBJ_S		= $(LIBPLTNC_SRC_S:./src/%.S=$(LIBPLTNC_BUILD)/%.o)
LIBPLTNC_OBJ_C		= $(LIBPLTNC_SRC_C:./src/%.c=$(LIBPLTNC_BUILD)/%.o)
LIBPLTNC_OBJ		= $(LIBPLTNC_OBJ_S) $(LIBPLTNC_OBJ_C)
LIBPLTNC_DEP		= $(LIBPLTNC_OBJ:%.o=%.d)

# dependencies
-include $(LIBPLTNC_DEP)


# targets
this: $(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a Makefile
	@ls -ln $<

$(LIBPLTNC_BUILD) $(LIBPLTNC_RELEASE):
	mkdir -p $@

$(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a: $(LIBPLTNC_BUILD) $(LIBPLTNC_OBJ) Makefile $(LIBPLTNC_BUILD)/config.h
	$(LIBPLTNC_AR) r $@ $(LIBPLTNC_BUILD)/*.o
	$(LIBPLTNC_RANLIB) $@

$(LIBPLTNC_BUILD)/config.h: $(LIBPLTNC_CONFIG)/config.$(LIBPLTNC_TARGET).h
	cp -p $(LIBPLTNC_CONFIG)/config.$(LIBPLTNC_TARGET).h $@

$(LIBPLTNC_BUILD)/%.o: ./src/%.S Makefile $(LIBPLTNC_BUILD)/config.h
	$(LIBPLTNC_CC) $(LIBPLTNC_CFLAGS) -I$(LIBPLTNC_BUILD) -Iinclude -MMD -c $< -o $@

$(LIBPLTNC_BUILD)/%.o: ./src/%.c Makefile $(LIBPLTNC_BUILD)/config.h
	$(LIBPLTNC_CC) $(LIBPLTNC_CFLAGS) -I$(LIBPLTNC_BUILD) -Iinclude -MMD -c $< -o $@

$(LIBPLTNC_RELEASE)/$(LIBPLTNC_NAME)-$(LIBPLTNC_TARGET).a: $(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a
	cp $< $@
	@ls -ln $@

release: Makefile $(LIBPLTNC_RELEASE) $(LIBPLTNC_RELEASE)/$(LIBPLTNC_NAME)-$(LIBPLTNC_TARGET).a

clean:
	rm -fr $(LIBPLTNC_BUILD)
