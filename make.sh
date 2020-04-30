#!/bin/bash

i686-elf-gcc -c -ffreestanding -std=gnu99 kernel.c -o kernel.o
i686-elf-gcc -T linker.ld -o myOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
cp myOS.bin isodir/boot/myOS.bin
grub-mkrescue -o myOS.iso isodir
