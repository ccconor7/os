;
; boot.bin: a boot sector to boot a 32-bit (protected mode) C kernel
;

[org 0x7c00]
KERNEL_OFFSET equ 0x1000	; Kernel will be loaded at 0x1000

	mov [BOOT_DRIVE], dl	; The boot drive is stored in DL (by the BIOS)
				; This line copies the value in DL (the boot drive) into the 
				;  address of the BOOT_DRIVE global variable

	mov bp, 0x9000		; Stack set-up
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call printstr_16	; Print "16-bit real mode" indicator
;	call printnl		; Print a new line
	
	call load_kernel	; Call load_kernel, which will load the kernel from the disk
	call switch		; Call switch, which will switch the CPU to 32-bit protected mode

	jmp $			

; === INCLUDE FILES === ;
%include "../print/printstr_16.asm"
%include "../print/printstr_32.asm"
%include "../print/print_hex.asm"
;%include "../print/printnl.asm"
%include "../core/gdt.asm"
%include "../core/pm_switch.asm"
%include "disk.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL	
	call printstr_16
;	call printnl

	mov bx, KERNEL_OFFSET	; disk_load parameter setup
	mov dh, 15		;	- load first 15 sectors from the 
	mov dl, [BOOT_DRIVE]	;	boot disk (kernel code) to KERNEL_OFFSET
	call disk_load

	ret

[bits 32]

begin_pm:			; 32-bit protected mode initialisation
	mov ebx, MSG_PROT_MODE		
	call printstr_32	; Print "32-bit protected mode" indicator
;	call printnl	

	call KERNEL_OFFSET	; Jump to the address of the loaded kernel code, 
				;  giving control to the kernel
			
	jmp $			; Hang

; === GLOBAL VARIABLES === ;
BOOT_DRIVE 	db 0
MSG_REAL_MODE	db "Operation mode: 16 bit (real mode)", 0
MSG_PROT_MODE	db "Operation mode: 32 bit (protected mode)", 0
MSG_LOAD_KERNEL db "Loading kernel...", 0

; === BOOT SECTOR PADDING === ;
times 510-($-$$) db 0
dw 0xaa55
