printstr_16:
	pusha		; push all registers and values

printstr_16_loop:
	mov al, [bx]	; bx contains the (current letter of the) string
			; [bx] means access the contents of bx
	cmp al, 0	; compare current char to 0, if not go to: --+
	je done_16		; finished reading string                    |
			;					     |
	mov ah, 0x0e	; tty					     |
	int 0x10	; print				             |
			;					     |
	add bx, 1	; read next char of bx                     <-+ here
	jmp printstr_16_loop	; jump to label

done_16:
	popa		; pop all registers and values
	ret		; return to caller function

printnl:
	pusha

	mov ah, 0x0e
	mov al, 0x0a
	int 0x10

	mov al, 0x0d
	int 0x10

	popa
	ret
