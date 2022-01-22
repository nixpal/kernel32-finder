; Author: Tarek Ahmed
; All rights reserved
; email: unix.geek2014@gmail.com
; This version of memory sieve will work only if you use assembly file and not included as a shellcode. You can also use it as an inline assembly in a C program.

sub esp, 08h
xor eax, eax
cdq
call $ + 5
pop eax
xor ecx, ecx
checkFirstByte:
inc ecx
mov  edx, dword ptr[eax+ecx]
cmp dl, 0ffh
jne checkFirstByte
cmp byte ptr[eax+ecx+1], 15h
jne checkFirstByte
jmp foundByte


foundByte:
	mov bl, byte ptr [eax+ecx+5]
	cmp bl, 0h
	je foundPtr
	jmp checkFirstByte

foundPtr:
	xor ebx, ebx
	mov ebx, dword ptr[eax + ecx + 2]
	mov edi, [ebx]
	shr edi, 28
	cmp edi, 7h
	je foundPossibleAddr
	jmp checkFirstByte


foundPossibleAddr:
	mov ebx, [ebx]
	xor edx, edx
	mov dx, 1001h
	add edx, 0efffh
	sub ebx, edx
	mov bx, dx
