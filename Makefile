#
# "$^": substituted with all of target's dependancy files
# "$<": first dependancy
# "$@": target file
#

C_SRC = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h) drivers/*.h)

KERNEL = kernel
BOOT = boot

OBJ = ${C_SRC:.c=.o}

all: os-img.bin

run: all
	qemu-system-i386 -fda os-img.bin 

os-img: #$(BOOT)/boot.bin $(KERNEL)/kernel.bin
	cat $(BOOT)/boot.bin $(KERNEL)/kernel.bin > os-img.bin

kernel.bin : #kernel/kernel_entry.o kernel/kernel.o
	cd kernel && make 
	#ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o : #kernel/kernel.c
	cd kernel && make 
	#gcc -fno-pie -m32 -ffreestanding -c $< -o $@

kernel_entry.o : #kernel/kernel_entry.asm
	cd kernel && make 
	#nasm $< -f elf -o $@

boot.bin: boot/boot.asm
	nasm -f bin $^ -o $@

drivers:
	cd drivers && make

# Remove bin and o files
cleanobj:
	rm -r */*.o
