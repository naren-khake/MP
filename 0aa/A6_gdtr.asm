; Write x86/64 ALP to switch from real mode to protected mode and display the values of GDTR, LDTR, IDTR, TR and MSW registers.

; ===== ===== ===== ===== =====

%macro print 2

	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall

%endmacro

; ===== ===== ===== ===== =====

section .data

	message1 db 'Contents of GDTR: '
	length1 equ $-message1
	
	message2 db 'Contents of LDTR: '
	length2 equ $-message2
	
	message3 db 'Contents of IDTR: '
	length3 equ $-message3
	
	message4 db 'Contents of TR: '
	length4 equ $-message4
	
	message5 db 'Contents of MSW: '
	length5 equ $-message5
	
	newline db 0Ah
	colon db ':'
	
; ===== ===== ===== ===== =====

section .bss

	gdtrContents resq 1
	ldtrContents resw 1
	idtrContents resq 1
	trContents resw 1
	mswContents resd 1
	outputBuffer resb 4
	
; ===== ===== ===== ===== =====

section .text

	global _start

_start:

	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx
	xor rdx, rdx
	
	smsw eax
	bt eax, 0
	jc up
	
up:

	sgdt [gdtrContents]
	sldt [ldtrContents]
	sidt [idtrContents]
	str [trContents]
	smsw [mswContents]
	
; ----- ----- ----- ----- -----

	print message1, length1

	mov bx, [gdtrContents + 4]
	call display16bit
	
	mov bx, [gdtrContents + 2]
	call display16bit
	
	mov bx, [gdtrContents]
	call display16bit
	
	print newline, 1	

; ----- ----- ----- ----- -----

	print message2, length2

	mov bx, [ldtrContents]
	call display16bit
	
	print newline, 1

; ----- ----- ----- ----- -----

	print message3, length3

	mov bx, [idtrContents + 4]
	call display16bit
	
	mov bx, [idtrContents + 2]
	call display16bit
	
	mov bx, [idtrContents]
	call display16bit
	
	print newline, 1

; ----- ----- ----- ----- -----

	print message4, length4

	mov bx, [trContents]
	call display16bit
	
	print newline, 1

; ----- ----- ----- ----- -----

	print message5, length5

	mov bx, [mswContents + 2]
	call display16bit
	
	mov bx, [mswContents]
	call display16bit
	
	print newline, 1

; ----- ----- ----- ----- -----

exit:
	mov rax, 60
	mov rdi, 0
	syscall

; ----- ----- ----- ----- -----

display16bit:

	mov rcx, 4
	mov rdi, outputBuffer

display16bit_label1:
	rol bx, 4
	mov al, bl
	and al, 0Fh
	cmp al, 09h
	jbe display16bit_label2
	add al, 07h
	
display16bit_label2:
	add al, 30h
	mov [rdi], al
	inc rdi
	loop display16bit_label1
	
	print outputBuffer, 4
	
ret

; ----- ----- ----- ----- -----
	
	
	
	
	
	
	
	
	
	
	
		
	
