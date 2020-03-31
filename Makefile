#
# "$^": substituted with all of target's dependancy files
# "$<": first dependancy
# "$@": target file
#

C_SRC = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h) drivers/*.h)

OBJ = ${C_SRC:.c=.o}

all: os-img.bin

run: all
	qemu-system-i386 -fda os-img.bin

os-img: boot/boot.bin kernel/kernel.bin
	cat $^ > os-img.bin

kernel.bin : kernel/kernel_entry.o kernel/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o : kernel/kernel.c
	gcc -fno-pie -m32 -ffreestanding -c $< -o $@

kernel_entry.o : kernel/kernel_entry.asm
	nasm $< -f elf -o $@

boot.bin: boot/boot.asm
	nasm -f bin $^ -o $@

# Remove bin and o files
clean:
	rm -r */*.bin */*.o
