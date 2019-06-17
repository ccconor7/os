;
; Print a character to the screen by using video memory (VGA)
; 	* Video memory starts @ 0xB8000
;	** Colors:
;	    - 0x0f: white txt, black bg?
[bits 32]

VID_MEM equ 0xB8000
WH_ON_BL equ 0x0f ;WHite on BLack

printstr_32:
	pusha
	mov edx, VID_MEM

printstr_32_loop:
	mov al, [ebx]
	mov ah, WH_ON_BL

	cmp al, 0
	je done_32

	mov [edx], ax
	add ebx, 1
	add edx, 2

	jmp printstr_32_loop

done_32:
	popa
	ret
