.PHONY: default release clean

default: this

LIBPLTNC_VERSION = 0.0.1

LIBPLTNC_TARGET ?= qemu-64g
#LIBPLTNC_TARGET ?= vf2

LIBPLTNC_TARGET_XLEN ?= 64

# tools
LIBPLTNC_TOOLBIN	?= /usr/local/bin
LIBPLTNC_CC			= $(LIBPLTNC_TOOLBIN)/riscv64-elf-gcc
LIBPLTNC_CPP		= $(LIBPLTNC_TOOLBIN)/riscv64-elf-cpp
LIBPLTNC_AR			= $(LIBPLTNC_TOOLBIN)/riscv64-elf-ar
LIBPLTNC_RANLIB		= $(LIBPLTNC_TOOLBIN)/riscv64-elf-ranlib

# CFLAGS
LIBPLTNC_CFLAGS += -march=rv$(LIBPLTNC_TARGET_XLEN)g
LIBPLTNC_CFLAGS += -I"$(LIBPLTNC_SRCD)/include"
LIBPLTNC_CFLAGS += -DDEBUG
LIBPLTNC_CFLAGS += -DPLUTONIC_VERSION=\"$(PLUTONIC_VERSION)\"
# warnings
LIBPLTNC_CFLAGS += -Wall -Werror -Wextra -pedantic
# warn if inline function cannot be substituted
LIBPLTNC_CFLAGS += -Winline
# create position-independent code
LIBPLTNC_CFLAGS += -fPIC
# create position-independent executables
LIBPLTNC_CFLAGS += -fPIE
# gcc must not try to replace anything with built-in stuff
LIBPLTNC_CFLAGS += -fno-builtin
# no crt0
LIBPLTNC_CFLAGS += -nostartfiles
# optimisation
LIBPLTNC_CFLAGS += -O2
# add debug symbols
LIBPLTNC_CFLAGS += -g

# names
LIBPLTNC_NAME		= libpltnc
LIBPLTNC_CONFIG		?= ../config
LIBPLTNC_BUILDROOT	?= ../build
LIBPLTNC_BUILD		= $(LIBPLTNC_BUILDROOT)/$(LIBPLTNC_TARGET)/$(LIBPLTNC_NAME)
LIBPLTNC_RELEASE	= ../release/$(LIBPLTNC_TARGET)
LIBPLTNC_SRC_S		= $(wildcard ./*.S)
LIBPLTNC_SRC_C		= $(wildcard ./*.c)
LIBPLTNC_SRC		= $(LIBPLTNC_SRC_S) $(LIBPLTNC_SRC_C)
LIBPLTNC_OBJ_S		= $(LIBPLTNC_SRC_S:./%.S=$(LIBPLTNC_BUILD)/%.o)
LIBPLTNC_OBJ_C		= $(LIBPLTNC_SRC_C:./%.c=$(LIBPLTNC_BUILD)/%.o)
LIBPLTNC_OBJ		= $(LIBPLTNC_OBJ_S) $(LIBPLTNC_OBJ_C)
LIBPLTNC_DEP		= $(LIBPLTNC_OBJ:%.o=%.d)

# dependencies
-include $(LIBPLTNC_DEP)


# targets
this: Makefile $(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a
	@ls -ln $(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a

$(LIBPLTNC_BUILD) $(LIBPLTNC_RELEASE):
	mkdir -p $@

$(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a: $(LIBPLTNC_BUILD) $(LIBPLTNC_OBJ) Makefile $(LIBPLTNC_BUILD)/config.h
	$(LIBPLTNC_AR) r $@ $(LIBPLTNC_BUILD)/*.o
	$(LIBPLTNC_RANLIB) $@

$(LIBPLTNC_BUILD)/config.h: $(LIBPLTNC_CONFIG)/config.$(LIBPLTNC_TARGET).h
	cp $< $@

$(LIBPLTNC_BUILD)/%.o: ./%.S Makefile $(LIBPLTNC_BUILD)/config.h
	$(LIBPLTNC_CC) $(LIBPLTNC_CFLAGS) -I"$(LIBPLTNC_BUILD)" -MMD -c $< -o $@

$(LIBPLTNC_BUILD)/%.o: ./%.c Makefile $(LIBPLTNC_BUILD)/config.h
	$(LIBPLTNC_CC) $(LIBPLTNC_CFLAGS) -I"$(LIBPLTNC_BUILD)" -MMD -c $< -o $@

$(LIBPLTNC_RELEASE)/$(LIBPLTNC_NAME)-$(LIBPLTNC_TARGET).a: $(LIBPLTNC_BUILD)/$(LIBPLTNC_NAME).a
	cp $< $@
	@ls -ln $@

release: Makefile $(LIBPLTNC_RELEASE) $(LIBPLTNC_RELEASE)/$(LIBPLTNC_NAME)-$(LIBPLTNC_TARGET).a

clean:
	rm -fr $(LIBPLTNC_BUILD)
