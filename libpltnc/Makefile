.PHONY: default release clean

default: this

LIBPLTNC_VERSION = 0.0.1

TARGET ?= qemu-64g
#TARGET ?= vf2

DEBUG ?= -DDEBUG


# tools
GCCBIN	?= /usr/local/bin
TOOLBIN ?= /usr/local/bin
CC      = $(GCCBIN)/riscv64-elf-gcc
AR		= $(TOOLBIN)/riscv64-elf-ar


# CFLAGS
CFLAGS	+= $(DEBUG)
CFLAGS	+= -LIBPLTNC_VERSION=\"$(LIBPLTNC_VERSION)\"
CFLAGS	+= -nostartfiles
# gcc must not try to replace anything with built-in stuff
CFLAGS	+= -fno-builtin
CFLAGS	+= -O2 
CFLAGS	+= -g
CFLAGS	+= -I"$(SRCD)/include"


# names
NAME = libpltnc
CONFIG = ../config
BUILDROOT = ../build
BUILD = $(BUILDROOT)/$(TARGET)/$(NAME)
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
this: $(BUILD)/$(NAME).a

$(BUILD):
	mkdir -p $(BUILD)

$(RELEASE):
	mkdir -p $(RELEASE)

$(BUILD)/$(NAME).a: $(BUILD) $(OBJ) Makefile $(BUILD)/config.h
	$(AR) r $@ $(BUILD)/*.o

$(BUILD)/config.h: $(CONFIG)/config.$(TARGET).h
	cp $< $@

$(BUILD)/%.o: ./%.S Makefile $(BUILD)/config.h
	$(CC) $(CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(BUILD)/%.o: ./%.c Makefile $(BUILD)/config.h
	$(CC) $(CFLAGS) -I"$(BUILD)" -MMD -c $< -o $@

$(RELEASE)/$(NAME)-$(TARGET).a: $(BUILD)/$(NAME).a
	cp $(BUILD)/$(NAME).a $@
	@ls -ln $@

release: $(RELEASE) $(RELEASE)/$(NAME)-$(TARGET).a

clean:
	rm -fr $(BUILD)
