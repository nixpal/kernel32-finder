; Author: Tarek Ahmed
; All rights reserved
; email: unix.geek2014@gmail.com
; This version of memory sieve will work only if you use assembly file and not included as a shellcode. You can also use it as an inline assembly in a C program.

sub esp, 08h
xor eax, eax
cdq
call $ + 5	; get address of next instruction and it will be used as our start address for parsing
pop eax		; eax = address of next instruction
xor ecx, ecx
checkFirstByte:
inc ecx
mov  edx, dword ptr[eax+ecx]	; check byte by byte until we find 0xff
cmp dl, 0ffh
jne checkFirstByte
cmp byte ptr[eax+ecx+1], 15h
jne checkFirstByte


foundByte:
	mov bl, byte ptr [eax+ecx+5]	; check the byte of it ends with 0
	cmp bl, 0h
	je foundPtr
	jmp checkFirstByte

foundPtr:
	xor ebx, ebx
	mov ebx, dword ptr[eax + ecx + 2]
	mov edi, [ebx]
	shr edi, 28	; Moving first byte to the end of the address 0x70000000 --> 0x00000007
	cmp edi, 7h	
	je foundPossibleAddr
	jmp checkFirstByte


foundPossibleAddr:
	mov ebx, [ebx]		; This is a possible Kernel32 address, most likely it is.
	xor edx, edx
	mov dx, 1001h
	add edx, 0efffh
	sub ebx, edx
	mov bx, dx
	
			; You can add more code here from the Crack the Stack method to verify if it's really kernel32
