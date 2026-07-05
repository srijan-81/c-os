CC      := i686-elf-gcc
AS      := i686-elf-as
CFLAGS  := -std=gnu11 -ffreestanding -O2 -Wall -Wextra
LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

BUILD   := build
ISODIR  := isodir

all: $(BUILD)/myos.bin

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.o: boot/boot.s | $(BUILD)
	$(AS) $< -o $@

$(BUILD)/kernel.o: src/kernel.c | $(BUILD)
	$(CC) -c $< -o $@ $(CFLAGS)

$(BUILD)/myos.bin: $(BUILD)/boot.o $(BUILD)/kernel.o boot/linker.ld
	$(CC) -T boot/linker.ld -o $@ $(LDFLAGS) $(BUILD)/boot.o $(BUILD)/kernel.o

check-multiboot: $(BUILD)/myos.bin
	grub-file --is-x86-multiboot $(BUILD)/myos.bin && echo "Multiboot confirmed"

iso: $(BUILD)/myos.bin
	mkdir -p $(ISODIR)/boot/grub
	cp $(BUILD)/myos.bin $(ISODIR)/boot/myos.bin
	cp iso/boot/grub/grub.cfg $(ISODIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(BUILD)/myos.iso $(ISODIR)

run: iso
	qemu-system-i386 -cdrom $(BUILD)/myos.iso

run-bin: $(BUILD)/myos.bin
	qemu-system-i386 -kernel $(BUILD)/myos.bin

clean:
	rm -rf $(BUILD) $(ISODIR)

.PHONY: all clean iso run run-bin check-multiboot