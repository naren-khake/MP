; ===== ===== ===== ===== =====

%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro accept 2
	mov rax, 0
	mov rdi, 0
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

; ===== ===== ===== ===== =====

section .data

	menuMessage	db 10, '===== Number Conversion =====', 10
			db 10, '1. Hex to BCD'
			db 10, '2. BCD to Hex'
			db 10, '3. Exit'
			db 10, 10, 'Enter your choice: '
	menuMessageLength equ $-menuMessage
	
	message1 db 'Enter 4 digit hexadecimal number: '
	length1 equ $-message1
	
	message2 db 'Equivalent BCD number is: '
	length2 equ $-message2
	
	message3 db 'Enter a 5 digit BCD number: '
	length3 equ $-message3
	
	message4 db 'Equivalent hexadecimal number is: '
	length4 equ $-message4
	
	newline db 0Ah
	
; ===== ===== ===== ===== =====

section .bss

	hexNumberInput resb 5
	decNumberInput resb 6
	hexNumberOutput resb 4
	decNumberOutput resb 5
	decimalDigits resb 1
	choice resb 2

; ===== ===== ===== ===== =====

section .text

	global _start
	
_start:

	print menuMessage, menuMessageLength
	accept choice, 2
	
	cmp byte[choice], '1'
	je hexToDec
	
	cmp byte[choice], '2'
	je decToHex
	
	cmp byte[choice], '3'
	je exit
	
	jmp _start
	
; ----- ----- ----- ----- -----
	
hexToDec:
	print message1, length1
	accept hexNumberInput, 5
	
	mov rsi, hexNumberInput
	call packNumber
	
	mov ax, bx
	xor rbx, rbx
	mov bl, 0Ah
	mov rcx, 0
	
hexToDec_label1:
	mov rdx, 0
	div bx
	push rdx
	inc rcx
	cmp ax, 00h
	jne hexToDec_label1
	
	mov rdi, decNumberOutput
	mov [decimalDigits], rcx
	mov rdx, 00h
	
hexToDec_label2:
	pop rdx
	add dl, 30h
	mov [rdi], dl
	inc rdi
	loop hexToDec_label2
	
	print message2, length2
	print decNumberOutput, [decimalDigits]
		
	jmp _start
	
; ----- ----- ----- ----- -----

decToHex:
	print message3, length3
	accept decNumberInput, 6
	
	mov rsi, decNumberInput
	mov rcx, 05h
	xor rax, rax
	mov rbx, 0Ah
	
decToHex_label1:
	xor rdx, rdx
	mul ebx
	mov dl, [rsi]
	sub dl, 30h
	add rax, rdx
	inc rsi
	loop decToHex_label1
	
	call display16bit
	
	print message4, length4
	print hexNumberOutput, 4
	
	print newline, 1
	
	jmp _start
	
; ----- ----- ----- ----- -----

exit:
	mov rax, 60
	mov rdi, 0
	syscall
	
; ----- ----- ----- ----- -----

packNumber:
	mov rcx, 04h
	xor rbx, rbx
	
packNumber_label1:
	rol bx, 4			;rbx me no kab dala
	mov al, [rsi]
	cmp al, 39h
	jbe packNumber_label2
	sub al, 07h
	
packNumber_label2:
	sub al, 30h
	add bl, al
	inc rsi
	loop packNumber_label1
	
ret

; ----- ----- ----- ----- -----

display16bit:
	mov rdi, hexNumberOutput
	mov rcx, 04h

display16bit_label1:
	rol ax, 4
	mov bl, al
	and bl, 0Fh
	cmp bl, 09h
	jbe display16bit_label2
	add bl, 07h

display16bit_label2:
	add bl, 30h
	mov [rdi], bl
	inc rdi
	loop display16bit_label1
	
ret

; ===== ===== ===== ===== =====

















