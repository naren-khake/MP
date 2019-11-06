%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro


section .data

	result dq 00h
	
section .text
	global _start
	
_start:
	pop rsi
	pop rsi
	pop rsi
	
	xor rbx, rbx
	mov bl, byte[rsi]
	cmp bl, 39h
	jbe _start_label1
	sub bl, 07h
	
_start_label1:
	sub bl, 30h
	
	mov rdi, result
	mov rax, 01	;for 0 ans should be 1
	
	call factorial
	
	mov qword[result], rax
	mov rdi, result
	call hexToAscii
	
exit:
	mov rax, 60
	mov rdi, 0
	syscall
	
factorial:
	push rbx
	dec rbx
	cmp rbx, 0
	je factorial_label1
	call factorial
	
factorial_label1:
	pop rcx
	mul rcx
ret

hexToAscii:
	mov rcx, 16
	xor rbx, rbx
	
hexToAscii_label1:
	rol rax, 4
	mov bl, al
	and bl, 0Fh
	cmp bl, 09h
	jbe hexToAscii_label2
	add bl, 07h
	
hexToAscii_label2:
	add bl, 30h
	mov [rdi], bl
	inc rdi
	loop hexToAscii_label1
	
	print result, 16	
ret
