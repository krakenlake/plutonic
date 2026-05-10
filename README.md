# plutonic - Experimental RISC-V kernel

<img width="1288" height="967" alt="Screenshot 2026-04-30 at 16 46 12" src="https://github.com/user-attachments/assets/aab0bb26-18ca-4692-b384-08cb7163b798" />

## Disclaimer
This is my experimental kernel tinkering project and currently not doing anything exciting.

## Currently implemented
- build system supporting mix of assembly and C
- booting into S-mode using OpenSBI
- getting IRQs under control
- setting up an early stack
- console output via OpenSBI
- printing a banner
- setting up a timer IRQ
- waiting for timer IRQ in wfi loop
- printing debug output
- catching and printing exceptions
- full register dumps
- checking for device tree
- libsbicall for SBI calls (https://github.com/krakenlake/libsbicall)
- SBI extensions probing and printing

## Targets
- RV64G (short for RV64IMAFD_Zicsr_Zifencei)

## Requirements
- riscv64 GNU toolchain for building
- https://github.com/krakenlake/libpltnc
- https://github.com/krakenlake/libsbicall
- QEMU or other hardware to run the kernel

## Current design decisions
- booting in S-mode required
- kernel is running on 1 (and always the same) hart only

## Links

<sub>

### Getting started

https://operating-system-in-1000-lines.vercel.app/en/

https://github.com/yhzhang0128/egos-2000

https://github.com/eyengin/xv6-riscv-unmatched/tree/unmatched

https://github.com/AuroBreeze/FrostVistaOS

https://popovicu.com/posts/writing-an-operating-system-kernel-from-scratch/

https://popovicu.com/posts/risc-v-sbi-and-full-boot-process/

https://github.com/popovicu/zig-time-sharing-kernel

https://book.rvemu.app/index.html

https://seiya.me/blog/riscv-hypervisor

https://traxys.me/riscv_os_setup.html

https://github.com/lycus/exocore/tree/master

https://zyedidia.github.io/blog/posts/2-baremetal-visionfive/

https://jborza.com/post/2021-04-21-ecalls-and-syscalls/

https://www.openeuler.org/en/blog/zhangxinhao/risc-v/2020-11-28-RISC-V.html

https://github.com/nanovms/nanos

https://git.kolibrios.org/KolibriOS/kolibrios

https://www.thegoodpenguin.co.uk/blog/an-overview-of-opensbi/

https://www.cs.cornell.edu/courses/cs4411/2022fa/schedule/slides/week5_timer_interrupt.pdf

### Standard C library

https://github.com/picolibc/picolibc

https://github.com/plctlab/mlibc

https://github.com/rsenn/dietlibc

### Graphics

https://anchorboot.org/posts/2024/04/21/vga-text-mode.html

### References

https://github.com/torvalds/linux/tree/master/arch/riscv

https://github.com/u-boot/u-boot/tree/master/arch/riscv

https://github.com/riscv-software-src/opensbi

https://gcc.gnu.org/onlinedocs/gcc/index.html

https://www.qemu.org/docs/master/

https://www.kraxel.org/blog/2019/09/display-devices-in-qemu/

### Specifications

https://docs.riscv.org/reference/isa/unpriv/unpriv-index.html

https://docs.riscv.org/reference/isa/priv/priv-index.html

https://github.com/riscv/riscv-aia

https://devicetree-specification.readthedocs.io/en/stable/flattened-format.html

### Misc

https://projectacrn.github.io/latest/developer-guides/asm_coding_guidelines.html

https://www.kernel.org/doc/html/v4.10/process/coding-style.html

</sub>
