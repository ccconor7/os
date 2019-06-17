; == Global Descriptor Table ==
gdt_start:

; Null descriptor -- must be present
;  'dd': define double word (4B)
gdt_null:
	dd 0x0
	dd 0x0

; Code (.text) segment descriptor entry
;  base: 0x0, limit: 0xfffff
;  first flags:  1(present) 00(privilege) 1(descriptor type)
;  second flags: 1(granularity) 1(32b default) 0(64b seg.) 0(accessed)
;  type flags:	 1(code) 0(conforming) 1(readable) 0(accessed)
gdt_code:
	dw 0xffff	; limit
	dw 0x0		; base (bits 0-15)
	db 0x0		; base (bits 16-23)
	db 10011010b	; first flags, type flags
	db 11001111b	; second flags, limit (bits 16-19)
	db 0x0		; base (bits 24-31)

; Data (.data) segment descriptor entry
;  same as code seg., apart from type flags
;  type flags: 0(code) 0(expand down) 1(writable) 0(accessed)
gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

; End of GDT
;  serves as a point of reference when calculating the size of the GDT
;  used in GDT descriptor
gdt_end:

; GDT descriptor
;  size of GTD = (address of GDT end) - (address of GDT start) - 1
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
