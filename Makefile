.PHONY: default all run debug release clean  

default: all

PLUTONIC_VERSION = 0.0.1

TARGET ?= qemu-64g
#TARGET ?= vf2

DEBUG ?= -DDEBUG

# names
BUILDROOT = build
RELEASE = release


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

