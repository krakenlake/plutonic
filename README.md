# plutonic - experimental RISC-V kernel

<img width="903" height="786" alt="Screenshot 2026-04-23 at 10 46 36" src="https://github.com/user-attachments/assets/7f5a1bcb-4183-46ae-9727-20a5413d6666" />

## Disclaimer
This is my experimental kernel tinkering project and currently not doing anything exciting.

## Current Features
- booting into S-mode using OpenSBI
- getting IRQs under control
- setting up an early stack
- console output
- printing a banner
- setting up a timer IRQ
- printing debug output
- catching and printing exceptions

## Targets
- RV64G (short for RV64IMAFD_Zicsr_Zifencei)


## Requirements
- riscv64 GNU toolchain for building
- QEMU or other hardware to run the kernel

## Design Decisions
- booting in S-mode required
- kernel is running on 1 (and always the same) hart only


## Links

### Learning from examples

https://operating-system-in-1000-lines.vercel.app/en/

https://popovicu.com/posts/writing-an-operating-system-kernel-from-scratch/

https://popovicu.com/posts/risc-v-sbi-and-full-boot-process/

https://book.rvemu.app/index.html

https://seiya.me/blog/riscv-hypervisor

https://traxys.me/riscv_os_setup.html

https://github.com/lycus/exocore/tree/master

https://zyedidia.github.io/blog/posts/2-baremetal-visionfive/

https://jborza.com/post/2021-04-21-ecalls-and-syscalls/

https://www.openeuler.org/en/blog/zhangxinhao/risc-v/2020-11-28-RISC-V.html


### Sources

https://github.com/torvalds/linux/tree/master/arch/riscv

https://github.com/u-boot/u-boot/tree/master/arch/riscv

https://github.com/riscv-software-src/opensbi


### Courses

https://www.thegoodpenguin.co.uk/blog/an-overview-of-opensbi/

https://www.cs.cornell.edu/courses/cs4411/2022fa/schedule/slides/week5_timer_interrupt.pdf

### Specifications

https://docs.riscv.org/reference/isa/unpriv/unpriv-index.html

https://docs.riscv.org/reference/isa/priv/priv-index.html

https://github.com/riscv/riscv-aia

https://devicetree-specification.readthedocs.io/en/stable/flattened-format.html

### Misc

https://www.kernel.org/doc/html/v4.10/process/coding-style.html
