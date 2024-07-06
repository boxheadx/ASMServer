%include "sockets.asm"
%include "multiprocess.asm"

section .data
	server_msg db "Welcome to ASM server!", 0xa
	server_msglen equ $-server_msg

section .text
global _start
_start:
	call socket	; stores FD in eax
	
	; Preparing to call bind
	mov esi, eax	; FD in esi
	push 0x0100007f	; host: 127.0.0.1 in Little Endian format
	push word 0x5c11	; port: 4444 in Little Endian format 
	call bind

	; Preparing to call listen
	push 0x4	; total connections to listen
	call listen

accept_loop:

	call accept	; client socket fd in eax
	
	test eax, eax
	js accept_loop
	
	call create_child_ps	

parent_subroutine:
	jmp accept_loop


child_subroutine:
	push server_msglen
	push server_msg
	call send
	jmp _exit




_exit:
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80
