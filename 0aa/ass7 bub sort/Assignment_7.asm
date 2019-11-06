%macro scall 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro

; ===== ===== ===== ===== =====

section .data

	message1 db 'Original array is: '
	length1 equ $-message1

	message2 db 'Sorted array is:   '
	length2 equ $-message2
	
	fileName db 'array.txt', 0
	newline db 10
	
section .bss

	fd resq 1
	buffer resb 200
	bufferLength resb 1
	
	counter_i resb 1
	counter_j resb 1

section .text

	global _start

_start:

	scall 2, fileName, 2, 0777
	mov qword[fd], rax
	
	scall 0, [fd], buffer, 200
	mov byte[bufferLength], al
	dec byte[bufferLength]
	
	scall 1, 1, message1, length1
	scall 1, 1, buffer, [bufferLength]
	scall 1, 1, newline, 1
	
	mov cl, byte[bufferLength]
	dec cl
	mov byte[counter_i], cl
	
	
outer:
	mov byte[counter_j], cl
	mov rsi, buffer
	mov rdi, buffer + 1
	
inner:
	mov al, [rsi]
	mov bl, [rdi]
	cmp al, bl
	ja swap
	jmp moveAhead
	
	swap:
		mov [rdi], al
		mov [rsi], bl
		
	moveAhead:
		inc rsi
		inc rdi
		dec byte[counter_j]
		jnz inner
		
	dec cl
	dec byte[counter_i]
	jnz outer
	
	scall 1, 1, message2, length2
	scall 1, 1, buffer, [bufferLength]
	scall 1, 1, newline, 1
	
	scall 1, [fd], buffer, [bufferLength]
	
exit:
	mov rax, 60
	mov rdi, 00
	syscall
	












	
