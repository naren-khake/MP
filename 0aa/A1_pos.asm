section .data
array : dq 0x1234567899876543, 0x9876543212345678, 0x1234567891234567, 0x1928374651234567, 8987654321234567H

pos: db 0
neg: db 0
count: db 5

msg1:  db 'Positive nos:'
len1: equ $-msg1
msg2: db 'Negative nos:'
len2: equ $-msg2

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

;=====================================

section .text
global _start
_start:

mov rsi,array

up:
mov rax,qword[rsi]
BT rax,63
jc negative
inc byte[pos]
add rsi,8
dec byte[count]
jnz up
jmp next2

negative:
inc byte[neg]
add rsi,8
dec byte[count]
jnz up

next2:		       ;HEX TO ASCII	
cmp byte[pos], 9
jbe down
add byte[pos], 7
down:
add byte[pos],30H

cmp byte[neg], 9
jbe down2
add byte[neg],7
down2:
add byte[neg],30H

print msg1,len1		
print pos,1		;PRINTING K LIYE ASCII ME CHAHIYE
print msg2,len2
print neg,1

mov rax,60
mov rdi,1
syscall




