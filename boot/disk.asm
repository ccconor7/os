;
; Functionality to load sectors from boot drive into ES:BX
;

; For more info. on hard disk sectors/cylinders/etc.
;	http://www.tldp.org/LDP/sag/html/hard-disk.html


disk_load:
	push dx

	mov ah, 0x02		; 0x02: BIOS "read sector" function
	mov al, dh		; Copy number of sectors to read (DH) into AL
	mov ch, 0x00		; Select cylinder number to read (0x00), store in CH
	mov dh, 0x00		; Select head number (0x00), store in DH
	mov cl, 0x02		; Select sector number to read (0x02), store in CL
				; 	(Boot sector = 0x01; First avail. sector = 0x02)
	int 0x13		; BIOS interrupt

	jc disk_error		; Jump to disk_error if we failed to read the disk

	pop dx			; Restore DX 
	cmp dh, al		; The BIOS assigns AL to the num. of sectors read 
				; 	Compare it with the expected num. of sectors read
	jne sector_error	; Jump to sector_error if we fucked up reading sectors
	ret			; Return to caller function

disk_error:
	mov bx, DISK_ERR_MSG	; Copy DISK_ERR_MSG into BX
	call printstr_16	; Print the message
	mov dh, ah		; Copy error >code< (AH) into DH (note: DL = disk drive that the error occured on)
	call print_hex		; Print the code
				; 	Error codes: http://stanislavs.org/helppc/int_13-1.html
	jmp $			; Hang

sector_error:
	mov bx, SECTOR_ERR_MSG	
	call printstr_16
	jmp $

DISK_ERR_MSG db "Disk error", 0
SECTOR_ERR_MSG db "# sectors read != # sectors expected", 0
