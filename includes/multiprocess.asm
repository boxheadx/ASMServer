section .data
	fork_err_msg db "fork error", 0xa
	fork_err_msglen equ $-fork_err_msg

section .text

extern child_subroutine
extern parent_subroutine

create_child_ps:
	push eax	; saving eax
	mov eax, 0x2	; fork syscall
	int 0x80
	test eax, eax
	js fork_error
	pop eax		; restoring eax
	je child_subroutine
	jmp parent_subroutine

fork_error:

	mov eax, 1
	mov ebx, -1
	int 0x80
	
