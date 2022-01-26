; Author: Tarek Ahmed
; All rights reserved
; email: unix.geek2014@gmail.com
; This version of memory sieve will work only if you use assembly file and not included as a shellcode. You can also use it as an inline assembly in a C program.


xor eax, eax
cdq

pop eax	
push eax
sub esp, 0x8
xor ecx, ecx
checkFirstByte:
inc ecx
mov  edx, dword ptr[eax+ecx]
cmp dl, 0xff
jne checkFirstByte
cmp byte ptr[eax+ecx+1], 0x15
jne checkFirstByte
jmp foundByte


foundByte:
	mov bl, byte ptr [eax+ecx+5]
	cmp bl, 0
	je foundPtr
	jmp checkFirstByte

foundPtr:
	xor ebx, ebx
	mov ebx, dword ptr[eax + ecx + 2]
	mov edi, [ebx]
	shr edi, 28
	cmp edi, 7
	je foundPossibleAddr
	jmp checkFirstByte


foundPossibleAddr:
	mov ebx, [ebx]
	xor edx, edx
	mov dx, 0x1001
	add edx, 0xefff

findMZ:
	sub ebx, edx
	mov bx, dx

	mov ax, [ebx]
	cmp ax, 0x5a4d		
	jne findMZ
	
	mov edi, [ebx + 0x3c]	
	add edi, ebx
	mov edi, [edi + 0x78]
	add edi, ebx
	mov edi, [edi + 0xc]
	add edi, ebx
	add edi, 4

	xor eax, eax
	push eax
	push 0x6c6c642e
	push 0x32334c45
	mov esi, esp

checkKernel :
	mov edx, ecx
	mov ecx, 8
	cld

	repe cmpsb		
	cmp ecx, 0
	jne checkFirstByte

FoundKernel32:
		


