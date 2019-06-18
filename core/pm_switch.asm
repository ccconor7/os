;
; Functionality to switch from 16-bit real mode to 32-bit protected mode
;

[bits 16]

switch:
	cli			; Disable interrupts on the CPU
	lgdt [gdt_descriptor]	; Load GTD, which defines protected mode segments
	
	mov eax, cr0		; 
	or eax, 0x1		; Set the first bit of CR0 to 1, which enables 32-bit PM
	mov cr0, eax		; 

	jmp CODE_SEG:init_pm	; Make a far jump (to a new segment) to 32-bit code,
				;  which forces the CPU to flush its cache

[bits 32]

; Initialise registers and stack in protected mode
init_pm:
	mov ax, DATA_SEG	; Old segments are meaningless in 32 PM,	
	mov ds, ax		;  therefore, point all segment registers to data seg.
	mov ss, ax		;  in GDT
	mov es, ax		
	mov fs, ax		; (i.e.) All segment registers point to AX which points to DATA_SEG
	mov gs, ax

	mov ebp, 0x90000	; Move stack to top of free memory
	mov esp, ebp

	call begin_pm		; Call begin_pm in boot.asm

