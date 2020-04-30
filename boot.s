/* Declare constants for the multiboot header */
.set ALIGN,    1 << 0           /* Align loaded modules on page boundaries */
.set MEMINFO,  1 << 1           /* Provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'Magic number', lets bootloader find header */
.set CHECKSUM,  -(MAGIC + FLAGS) /* Checksum of above, proves we are multiboot */

/* Declare a multiboot header that marks the program as a kernel. These are magic
values that are documented in the multiboot standard. The bootloader will search 
for this signature in the first 8 KiB of the kernel file, aligned at a 32-bit 
boundary. The signature is in its own section so the header can be forced to be
within the first 8 KiB of the kernel file. */
.section .multiboot
.align 4       /* Align on 4 byte boundaries */
.long MAGIC    /* .long = .int = 32 bits */
.long FLAGS
.long CHECKSUM

/* The multiboot standard does not define the value of the stack pointer register
(esp) and it is up to the kernel to provide a stack. This allocates room for a 
small stack by creating a symbol at the bottom of it, then allocating 16384 bytes
(16 KiB) for it, and finally creating a symbol at the top. The stack grows down-
wards on x86. The stack is in its own section so it can be marked nobits, which 
means the kernel file is smaller because it does not contain an uninitialised
stack. The stack on x96 must be 16-byte aligned according to the SysVABI standard
and de-facto extensions. The compiler will assume the stack is properly aligned
and failure to align the stack will result in undefined behaviour. */
.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:

/* The linker script specifies _start as the entry point to the kernel and the 
bootloader will jump to this position once the kernel has been loaded. It doesn't
make sense to return from this function; the bootloader is gone at this point. */
.section .text
.global _start
.type _start, @function
_start:
    /* The bootloader has loaded us into 32-bit protected mode on a x86 machine.
    Interrupts are disabled. Paging is diabled. The processor state is as defined
    in the multiboot standard. The kernel has full control of the CPU. The kernel
    can only make use of the hardware features and any code it provides as part
    of itself. There's no printf function, unless the kernel provides its own
    <stdio.h> header and a printf implementation. There are no security 
    restrictions, no safeguards, no debugging mechanisms, only what the kernel
    provides itself.

    To setup a stack, we set the esp register to pint to the top of the stack.
    This is necessarily done in ASM as languages such as C cannot function with-
    out a stack. */
    mov $stack_top, %esp

    /* This is a good place to initialise crucial processor state before the 
    high-level kernel is entered. It's best to minise the early environment where
    crucial features are offline. Note that the processor is not fully 
    initialised yet: features such as floating point instructions and instruction
    set extensions are not initialised yet. The GDT should be loaded here. Paging
    should be enabled here. C++ features such as global constructors and 
    exceptions will require runtime support to work as well.

    Enter the high-level kernel. The ABI requires the stack is 16-byte aligned at
    the time of the call instruction (which afterwards pushes the return pointer
    of size 4 bytes). The stack was originally 16-byte aligned above and we've 
    pushed a multiple of 16 bytes to the stack since (pushed 0 bytes so far), so
    the alignment thus far has been preserved and the call is well defined. */
    call kernel_main

    /* If the system has nothing more to do, put the computer into an infinite
    loop. To do that:
        1. Disable interrupts with cli (clear interrupt enable in EFLAGS).
           They are already disabled by the bootloader, so this is not needed.
           Mind that later you might enable interrupts and return from 
           kernel_main (which is sort of nonsensical to do).
        2. Wait for the next interrupt to arrive with hlt (halt). Since they are
           disabled, this will lock up the computer.
        3. Jump to the hlt instruction if it ever wakes up due to a non-maskable
           interrupt occuring or due to the system management mode. */
    cli
1:  hlt
    jmp 1b

/* Set the size of the _start symbol to the current location '.' minus its start.
This is useful when debugging or when you implement call tracing. */
.size _start, . - _start
