IDIR = ../drivers

CC = i686-elf-gcc
CFLAGS = -fno-pie -m32 -ffreestanding -c
LD = i686-elf-ld
LDFLAGS = -m elf_i286 -Ttext 0x1000 --oformat binary

kernel.bin : kernel_entry.o kernel.o $(IDIR)/screen.o $(IDIR)/ports.o
	$(LD) $(LDFLAGS) -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o : kernel.c
	$(CC) $(CFLAGS) $< -o $@

kernel_entry.o : kernel_entry.asm
	nasm $< -f elf -o $@