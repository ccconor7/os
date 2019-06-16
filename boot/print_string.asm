print_string:
	pusha		; push all registers and values

start:
	mov al, [bx]	; bx contains the (current letter of the) string
			; [bx] means access the contents of bx
	cmp al, 0	; compare current char to 0, if not go to: --+
	je done		; finished reading string                    |
			;					     |
	mov ah, 0x0e	; tty					     |
	int 0x10	; print				             |
			;					     |
	add bx, 1	; read next char of bx                     <-+ here
	jmp start	; jump to start: label

done:
	popa		; pop all registers and values
	ret		; return to caller function
