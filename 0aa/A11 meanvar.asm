%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	mm db 10,"The mean of the number: ",10
		len equ $-mm
	vm db 10,"The variance of the number: ",10
		len1 equ $-vm
	sm db 10,"The standard deviation: ",10
		len2 equ $-sm

	newline db "",10
	 newl equ $-newline

point db "."
 lpoint equ $-point

hundred dw 100

array dd 100.00,300.00,300.00,400.00,400.00

arrcnt dw 5

section .bss
	count resb 1
	counter resb 1
	mean resd 1
	variance resd 1
	sdeviation resd 1
	temp resb 2
	buffer resb 10
	
section .text
	global _start
_start:
	mov byte[count],05h
	scall 1,1,mm,len
	mov rsi,array
	
	finit
	fldz
	call Mean
	call Display
	
	scall 1,1,newline,newl
	scall 1,1,vm,len1
	
	finit
	fldz
	mov rsi,array
	mov byte[count],05h
	call Variance
	
	scall 1,1,newline,newl
	scall 60,1,0,0

Mean:
	fadd dword[rsi]
	add rsi,4
	dec byte[count]
	jnz Mean

	fidiv word[arrcnt]
	fst dword[mean]
	ret

Variance:
	fldz
	fadd dword[rsi]
	fsub dword[mean]
	fmul st0
	fadd st1

	add rsi,04h
	dec byte[count]
	jnz Variance
	
	fidiv dword[arrcnt]
	fst dword[variance]
	call Display	
	
	fldz
	fadd dword[variance]
	fsqrt
	fst dword[sdeviation]

	scall 1,1,newline,newl
	scall 1,1,sm,len2

	call Display
	ret
 
		
Display:
	fimul word[hundred]
	fbstp tword[buffer]
	mov byte[counter],09h
	mov rsi,buffer+9

Display1:
	mov al,byte[rsi]
	push rsi
	call htoa
	pop rsi
	dec rsi
	dec byte[counter]
	jnz Display1

scall 1,1,point,lpoint
mov al,byte[buffer] 	
call htoa
ret

htoa:
	mov byte[count],02h	
	mov rsi,temp

	Convert:
	rol al,04h
	mov dl,al
	and dl,0Fh
	cmp dl,09h
	jbe add30h
	add dl,07h
	
add30h:
	add dl,30h
	mov byte[rsi],dl
	inc rsi
	dec byte[count]
	jnz Convert
	scall 1,1,temp,2
	ret
	


