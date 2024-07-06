; invoke socket() syscall using socketcall() syscall 
; because only socketcall syscall is available to the kernel
socket:

	mov ebp, esp

	; pushing the arguments for socket() into the stack
	push 0x6	; IPPROTO_TCP (/usr/include/linux/in.h)
	push 0x1	; SOCK_STREAM (/usr/include/x86_64-linux-gnu/bits/socket_type.h)
	push 0x2	; AF_INET (/usr/include/x86_64-linux-gnu/bits/socket.h)

	mov eax, 0x66	; socketcall syscall
	mov ebx, 0x1	; SYS_SOCKET (/usr/include/linux/net.h)
	mov ecx, esp	; args for socket()
	int 0x80

	mov esp, ebp
	ret

bind:
	mov ebp, esp

	; initializing struct sockaddr_in
	; 8 bytes padding
	push 0x0	; sin_zero
	push 0x0	; sin_zero

	push dword [ebp+0x6]	; sin_address	
	push word [ebp+0x4]	; sin_port
	push word 0x2		; sin_family (AF_INET)
	mov ecx, esp
	
	; pushing args for bind()
	push 0x10	; addrlen
	push ecx	; struct sockaddr_in*
	push esi	; File descriptor
	
	mov eax, 0x66
	mov ebx, 0x2	; SYS_BIND
	mov ecx, esp	; args
	int 0x80
	
	mov esp, ebp
	ret

listen:
	mov ebp, esp

	; pushing args for listen()
	push dword [ebp+0x4]	; total connections
	push esi	; fd

	mov eax, 0x66
	mov ebx, 0x4	; SYS_LISTEN
	mov ecx, esp	; args
	int 0x80
	
	mov esp, ebp
	ret

accept:
	mov ebp, esp
	
	; alloating memory for client addr and addrlen
	sub esp, 0x14
	mov ecx, esp

	; pushing args for accept()

	lea eax, [ecx+0x10]
	push eax	; *addrlen
	push ecx	; sockaddr*
	push esi

	mov eax, 0x66
	mov ebx, 0x5	; SYS_ACCEPT
	mov ecx, esp
	int 0x80

	mov edi, esp	; client info stuffs in edi and fd will be in eax

	mov esp, ebp
	ret

send:
	mov ebp, esp

	; pushing args for send()

	push 0x0
	push dword [ebp+0x8]
	push dword [ebp+0x4]
	push eax

	mov eax, 0x66
	mov ebx, 0x9	; SYS_SEND
	mov ecx, esp
	int 0x80

	mov esp, ebp
	ret
