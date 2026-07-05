# c-os

A bare-metal x86 kernel written in C.

It boots via GRUB (Multiboot), sets up its own stack in raw assembly, hands off to a C kernel, and writes directly to the VGA text-mode framebuffer. No libc, no underlying OS.

## What it does right now

- Boots as a Multiboot-compliant kernel under GRUB
- Sets up a 16KB stack from assembly before jumping into C
- Implements basic VGA text-mode output: colors, newlines, and screen scrolling
- Prints a startup message to prove it's alive

## Project layout

```
boot/boot.s          Assembly entry point + Multiboot header
boot/linker.ld       Linker script, places the kernel at 1MB
src/kernel.c         C kernel entry point (VGA driver + kernel_main)
iso/boot/grub/       GRUB config for the bootable ISO
Makefile
```

## Building it

Requires an `i686-elf` cross-compiler (a regular `gcc` can't build a freestanding kernel, see [OSDev: GCC Cross-Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)), plus `grub-mkrescue`, `xorriso`, and `qemu-system-i386`.

```bash
make run
```

This assembles `boot.s`, compiles `kernel.c`, links them at 1MB, packages everything into a bootable `.iso` with GRUB, and launches it in QEMU.

For faster iteration without rebuilding the ISO each time:
```bash
make run-bin
```

## Roadmap

- [ ] GDT (Global Descriptor Table)
- [ ] IDT + interrupt handlers (so CPU exceptions don't just silently reboot)
- [ ] PIC remapping + hardware IRQs
- [ ] PS/2 keyboard driver
- [ ] A minimal interactive shell
- [ ] Paging + a basic memory allocator


## References

- [OSDev Wiki: Bare Bones](https://wiki.osdev.org/Bare_Bones)
- [OSDev Wiki: Meaty Skeleton](https://wiki.osdev.org/Meaty_Skeleton)
