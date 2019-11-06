;-------------------------macro for printing and reading data----------------------

	%macro print 2
	mov rax,1
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
	
	%macro read 2
	mov rax,0
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
;------------------------------------------------------
section .data

file db "sample.txt",0
menu db "Enter choice:",10
db "1 for NO OF SPACES ",10
db "2 for NO OF LINES",10
db "3 for NO OF OCCURENCES OF ENTERED CHARACTER",10
db "4 for EXIT",10
menulen equ $-menu

text db "Text is ",10
lent equ $-text

newline db 10

section .bss

fin resq 8

global var
var resb 100

choice resb 2

section .text

global _start

_start:

extern space
extern line
extern character

;-------------------opening a file--------------

	mov rax,2
	mov rdi,file
	mov rsi,2
	mov rdx,777
	syscall
		
	mov qword[fin],rax	
	;cmp [fin],0h
	;ja read_f
;----------------reading from file---------------

	read_f:
	
	mov rax,0
	mov rdi,[fin]
	mov rsi,var
	mov rdx,100
	syscall
	
	print text,lent
	print var,100
	
;------------------menu-----------------
	main:
	
	print menu,menulen
	read choice,3

	cmp byte[choice],31h
	je COUNT_SPACE
	

	cmp byte[choice],32h
	je COUNT_LINE
	

	cmp byte[choice],33h
	je COUNT_CHAR
	
	cmp byte[choice],34h
	jae EXIT
	
;------------count spaces------------------

	COUNT_SPACE:
	
	call space
	jmp main
		
;------------count lines-------------------

	COUNT_LINE:
	
	call line
	jmp main
;------------count occurence of character-------------------

	COUNT_CHAR:
	
	call character
	jmp main	
;--------------close a file---------------

	mov rax,3
	mov rdi,[fin]
	syscall
	
;------------exit system call--------------


	EXIT:
	mov rax,60
	mov rdi,0h
	syscall
	jmp main
	
	
