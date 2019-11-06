%macro print 2
mov rax,1
mov rdi,1
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
section .data
	menu: db "Menu",10
		db "1.Successive Adding",10
		db "2.Add and Shift",10
		db "3.Exit",10
		db "Enter your Choice:",10
	len: equ $-menu
	msg: db "Enter 4 Digit Number:",10
	len1: equ $-msg
	msg1: db "Resulting Successive Adding Number:",10
	len2: equ $-msg1
	msg2: db "Enter second 4 Digit Number:",10
	len3: equ $-msg2
	msg3: db "Resulting Add and Shift Number:",10
	len4: equ $-msg3
	msg4: db "We are here",10
	len5:	equ $-msg4
	ent: db 0x0A
	lent: equ $-ent
section .bss
	cnt1: resb 2
	cnt2: resb 2
	choice: resb 2
	result2: resb 4
	result: resb 4
	num1: resb 8
	num2: resb 8
	count: resb 16
section .text
global main:
main:
	print ent,lent
	print menu,len
	read choice,2
	
	cmp byte[choice],31H
	JE SAMUL
	cmp byte[choice],32H
	JE ASMUL
	cmp byte[choice],33H
	JAE EXIT
EXIT:
	mov rax,60
	mov rdi,0
	syscall
SAMUL:
	call SADD
	jmp main
ASMUL:
	call ADS
	jmp main
;===============================Successive Add Method
SADD:
	print msg,len1
	read num1,8
	mov rsi,num1
	call AtoH
	mov [num1],bx
	
	print msg2,len3
	read num2,8
	mov rsi,num2
	call AtoH
	mov [num2],bx
	
	mov bx,[num1]
	mov cx,[num2]
	
	mov ax,00H
sp1:
	add ax,bx ;because of decremented cx the next successive digit will be fetched
	dec cx
	jnz sp1
	
	mov dx,ax
	mov rdi,result
	call HtoA
	print msg1,len2
	print result,4
ret
;==========Add and Shift
ADS:
	print msg,len1
	read num1,8
	mov rsi,num1
	call AtoH
	mov [num1],bx
	
	print msg2,len3
	read num2,8
	mov rsi,num2
	call AtoH
	mov [num2],bx
	
	mov byte[count],16
	mov eax,0000H
	mov bx,[num1]
	mov cx,[num2]
TOP:
	shl ax,1
	rol bx,1
	jnc below
	add ax,cx
below:
	dec byte[count]
	jnz TOP
	
	mov dx,ax
	mov rdi,result2
	call HtoA
	print msg3,len4
	print result2,4
ret
;==========
AtoH:
	mov byte[cnt1],04H
	mov ebx,00H
hup:
	rol ebx,04
	mov al,byte[rsi]
	cmp al,39H
	jbe HNEXT
	sub al,07H
HNEXT:
	sub al,30H
	add bl,al
	inc rsi
	dec byte[cnt1]
	jnz hup
ret
;=================
HtoA: 				;hex_no to be converted is in dx //result is stored in rdi/user defined variable
	mov byte[cnt2],04H
aup:
	rol dx,04
	mov cl,dl
	and cl,0FH
	cmp cl,09H
	jbe ANEXT
	add cl,07H
ANEXT: 
	add cl,30H
	mov byte[rdi],cl
	inc rdi
	dec byte[cnt2]
	JNZ aup
ret
