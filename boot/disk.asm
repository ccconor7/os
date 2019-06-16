; load dh (register) sectors to es:bx from drive dl (register)

disk_load:
	push dx
	mov ah, 0x02		; BIOS read sector function
	mov al, dh		; read dh sectors
	mov ch, 0x00		; select cylinder 0
	mov dh, 0x00		; select head 0
	mov cl, 0x02		; start reading from second sector
				;  (boot sector is 1st)
	int 0x13		; BIOS interrupt

	jc disk_error		; jump if error (if carry flag set)

	pop dx			; restore dx from stack
	cmp dh, al		; if al (a.k.a sectors have been read)
				;  != dh (sectors expected)
	jne sector_error
	ret

disk_error:
	mov bx, DISK_ERR_MSG
	call print_string
	mov dh, ah		; init error message
	call print_hex		; print error message 
				; http://stanislavs.org/helppc/int_13-1.html
	jmp $

sector_error:
	mov bx, SECTOR_ERR_MSG
	call print_string
	jmp $

DISK_ERR_MSG db "Disk error", 0
SECTOR_ERR_MSG db "# sectors read != # sectors expected", 0
