;
; Print a character to the screen by using video memory (VGA)
; 	* Video memory starts @ 0xB8000
;	** Colors:
;	    - 0x0f: white txt, black bg?
[bits 32]

VID_MEM equ 0xB8000
WH_ON_BL equ 0x0f ;WHite on BLack

print_str:
	pusha
	mov edx, VID_MEM

print_str_loop:
	mov al, [ebx]
	mov ah, WH_ON_BL

	cmp al, 0
	je print_str_done

	mov [edx], ax
	add ebx, 1
	add edx, 2

	jmp print_str_loop

print_str_done:
	popa
	ret
