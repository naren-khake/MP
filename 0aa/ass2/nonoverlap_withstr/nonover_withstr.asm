;perform nonoverlapped  block transfer


	section .data

	array db 10h,20h,30h,40h,50h
        
	
        msg1: db 'Before overlapped :',0xa
	len1: equ $-msg1

	msg2: db 'After overlapped :',0xa
	len2: equ $-msg2

        msg3: db ' ',0xa
	len3: equ $-msg3
        
        msg4: db ' : '
	len4: equ $-msg4
         
        
        count db 0
        count1 db 0
        count2 db 0
        count3 db 0
        count4  db 0
	


	section .bss
	 addr resb 8
         num1 resb 2
         

	section .text
	global _start


	_start: 
       
        
        mov rax,1
	mov rdi,1
	mov rsi,msg1
	mov rdx,len1
	syscall 

        xor rsi,rsi

	mov rsi,array
	mov byte[count],05

	up:
        mov rbx,rsi
	push rsi
        mov rdi,addr
	call HtoA1
	pop rsi


	mov dl,[rsi]
	push rsi
        mov rdi,num1
	call HtoA2
	pop rsi

	inc rsi

	dec byte[count]
	jnz up

       
        mov rsi,array
        mov rdi,array+5h
	mov byte[count3],05h

       loop10:
 	movsb
        dec byte[count3]
        jnz loop10

       
        mov rax,1
	mov rdi,1
	mov rsi,msg2
	mov rdx,len2
	syscall 

        mov rsi,array
        mov byte[count4],0Ah

      

        up10:
        mov rbx,rsi
	push rsi
        mov rdi,addr
	call HtoA1
	pop rsi

	mov dl,[rsi]
	push rsi
        mov rdi,num1
	call HtoA2
	pop rsi

	inc rsi

	dec byte[count4]
	jnz up10
                  

        mov rax,60
	mov rdi,0
	syscall	

HtoA1:
	mov byte[count1],16
	
	dup1:
	rol rbx,4
	mov al,bl
	and al,0fh
	cmp al,09
	jg p3
	add al,30h
	jmp p4
	p3: add al,37h
	p4:mov [rdi],al
	inc rdi
        dec byte[count1]
        jnz dup1

        
        mov rax,1
	mov rdi,1
	mov rsi,addr
	mov rdx,16
	syscall 


        mov rax,1
	mov rdi,1
	mov rsi,msg4
	mov rdx,len4
	syscall 

	
ret

HtoA2:
	mov byte[count2],02
	
	dup2:

	rol dl,04
	mov al,dl
	and al,0fh
	cmp al,09h
	jg p31
	add al,30h
	jmp p41

	p31: add al,37h
	p41:mov [rdi],al

	inc rdi
	dec byte[count2]
        jnz dup2
        
        mov rax,1
	mov rdi,1
	mov rsi,num1
	mov rdx,02
	syscall 

        mov rax,1
	mov rdi,1
	mov rsi,msg3
	mov rdx,len3
	syscall

	
ret






;************output*********
;[student@localhost]$ nasm -f elf64 w_over.asm
;[student@localhost]$ ld -o w_over w_over.o
;[student@localhost]$ ./w_over 
;Before overlapped :
;0000000000600264 : 10 
;0000000000600265 : 20 
;0000000000600266 : 30 
;0000000000600267 : 40 
;0000000000600268 : 50 
;After overlapped :
;0000000000600264 : 10 
;0000000000600265 : 20 
;0000000000600266 : 30 
;0000000000600267 : 40 
;0000000000600268 : 50 
;0000000000600269 : 10 
;000000000060026A : 20 
;000000000060026B : 30 
;000000000060026C : 40 
;000000000060026D : 50 
;[student@localhost]$ 

