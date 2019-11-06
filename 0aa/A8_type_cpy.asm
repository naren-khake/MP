%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

msg1: db 'File opened successfully',0xa
len1: equ $ -msg1
msg2: db 'The contents copied to the other file',0xa
len2: equ $ -msg2
msg3: db 'The contents were deleted',0xa
len3: equ $ -msg3
msg4: db 'Enter the data to write to the file',0xa
len4: equ $ -msg4
msge: db 'Error in opening',0xa
lene: equ $ -msge


section .bss

fd1: resq 1
fd2: resq 1
buffer: resb 200
flen: resq 1
choice: resq 1
f1_name: resq 1
f2_name: resq 1

section .text
global _start
_start:

pop rbx
pop rbx
pop rbx

;mov qword[choice],rbx
;mov rsi,choice
cmp byte[rbx],43H
je cpy
cmp byte[rbx],44H
je del
jmp typ

cpy:

pop rbx
mov rsi,f1_name

up1:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0H
jne up1

scall 2,f1_name,2,0777

mov qword[fd1],rax
bt rax,63
jc err
jmp skip

err:
scall 1,1,msge,lene


skip:

scall 1,1,msg1,len1

scall 0,[fd1],buffer,200
mov qword[flen],rax

;scall 1,1,buffer,[flen]

pop rbx

mov rsi,f2_name
up2:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0H
jne up2

scall 2,f2_name,2,0777
mov qword[fd2],rax

b1:
bt rax,63
jc err2
jmp skip2

err2:
scall 1,1,msge,lene
jmp exit

skip2:
scall 1,1,msg1,len1
scall 1,[fd2],buffer,[flen]


mov rax,3
mov rdi,fd1
syscall


mov rax,3
mov rdi,fd2
syscall

jmp exit

del:

pop rbx
mov rsi,f1_name
up5:
mov al,byte[rbx]
mov byte[rsi],al
inc rsi
inc rbx
cmp byte[rbx],0H
jne up5

scall 2,f1_name,2,0777

mov qword[fd1],rax
bt rax,63
jc er
jmp skp

er:
scall 1,1,msge,lene
jmp exit

skp:
scall 1,1,msg1,len1

mov rax,87
mov rdi,f1_name
syscall

jmp exit

typ:

pop rbx

mov rsi,f2_name

upx:
mov al,byte[rbx]
mov byte[rsi],al
inc rsi
inc rbx
cmp byte[rbx],0H
jne upx

scall 2,f2_name,2,0777
mov [fd2],rax

bt rax,63
jc erx
jmp skpx

erx:
scall 1,1,msge,lene
jmp exit

skpx:
scall 1,1,msg1,len1

scall 0,1,buffer,200

scall 1,[fd2],buffer,200

jmp exit


exit:
mov rax,60
mov rdi,0
syscall
