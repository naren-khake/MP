%macro myprintf 1
	mov rdi,formatpf
	sub rsp,8
	movsd xmm0,[%1]
	mov rax,1
	call printf
	add rsp,8
%endmacro

%macro myprintf1 2
	mov rdi,ff1
	sub rsp,8
	movsd xmm0,[%1]
	movsd xmm1,[%2]
	mov rax,1
	call printf
	add rsp,8
%endmacro

%macro myprintf2 2
	mov rdi,ff2
	sub rsp,8
	movsd xmm0,[%1]
	movsd xmm1,[%2]
	mov rax,1
	call printf
	add rsp,8
%endmacro

%macro myscanf 1
	mov rdi,formatsf
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[%1],r8
	add rsp,8
%endmacro

section .data
	ff1 db 10,"%lf +%lf ",10,0
	ff2 db 10,"%lf +%lf ",10,0
	formatpi db "%d",10
	formatpf db "%lf",10,0
	formatsf db "%lf",10,0
	four dq 4
	two dq 2
	ipart1 db "+i",10
	ipart2 db "-i",10

section .bss
	a resq 1
	b resq 1
	c resq 1
	b2 resq 1
	fac resq 1
	delta resq 1
	ta resq 1
	rdelta resq 1
	r1 resq 1
	r2 resq 1
	realn resq 1
	img1 resq 1
	img2 resq 2

section .text
	extern printf
	extern scanf
	global main
main:
	myscanf a
	myscanf b
	myscanf c
	
	fld qword[b]
	fmul qword[b]
	fstp qword[b2]
	
	fild qword[four]
	fmul qword[a]
	fmul qword[c]
	fstp qword[fac]
	
	fld qword[b2]
	fsub qword[fac]
	fstp qword[delta]

	fild qword[two]
	fmul qword[a]
	fstp qword[ta]

	btr qword[delta],63
	jc imaginary
	
;------REAL ROOTS--------

fld qword[delta]
fsqrt 
fstp qword[rdelta]
	
fldz
fsub qword[b]
fadd qword[rdelta]
fdiv qword[ta]
fstp qword[r1]
myprintf r1

fldz
fsub qword[b]
fsub qword[rdelta]
fdiv qword[ta]
fstp qword[r2]
myprintf r2

jmp exit

;----Imaginary roots----
imaginary:
fld qword[delta]
fsqrt 
fstp qword[rdelta]

fldz 
fsub qword[b]
fdiv qword[ta]
fstp qword[realn]

fld qword[rdelta]
fdiv qword[ta]
fstp qword[img1]

;--Printing imaginary root--
myprintf1 realn,img1
myprintf2 realn,img2

exit:
	mov rax,60
	mov rdx,0
	
