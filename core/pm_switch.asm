;
; Functionality to switch from 16-bit real mode to 32-bit protected mode
;

[bits 16]

switch:
	cli			; disable interrupts on the CPU
	lgdt [gdt_descriptor]	; load GTD, which defines protected mode segments
	
	mov eax, cr0		; 
	or eax, 0x1		; set the first bit of CR0 to 1
	mov cr0, eax		; 

	jmp CODE_SEG:init_pm	; make a far jump (to a new segment) to 32-bit code,
				;  which forces the CPU to flush its cache

[bits 32]

; initialise registers and stack in protected mode
init_pm:
	mov ax, DATA_SEG	; old segments are meaningless in 32 PM	
	mov ds, ax		;  therefore, point all segment registers to data seg
	mov ss, ax		;  in GDT
	mov es, ax		
	mov fs, ax		; all segment registers -> AX -> DATA_SEG
	mov gs, ax

	mov ebp, 0x90000	; move stack to top of free memory
	mov esp, ebp

	call begin_pm

