; System calls
SYS_WRITE		equ		1

; File descriptors
FD_STDOUT		equ		1

; External symbols
extern libPuhfessorP_printSignedInteger64

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the data section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.data
; Strings
msg1 		db 	", "
msg1_len	equ	$-msg1
msg2 		db 	13, 10
msg2_len	equ	$-msg2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the text section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.text

global display_array

display_array:

	; Save registers
	push rbx
	push rbp
	
	; Save array's address in rbp register
	mov rbp, rdi
	
	; Save array's size in rbx register. 
	mov rbx, rsi
	
	; Check if the size is zero
	cmp rbx, 0					
	jle end_display_loop		; If yes, there is no need to enter into the display loop
	
	; Loop to display the integers
display_loop:
		
	; Print the number
	mov rdi, [rbp]
	call libPuhfessorP_printSignedInteger64
	
	; Decrement loop counter
	dec rbx
	
	; Check if we have printed all the numbers
	cmp rbx, 0					; If this is the last number
	jle end_display_loop		; End the loop and don't print the comma space
	
	; Print out a comma and a space
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg1				; Provide the memory location to start reading our characters to print
	mov rdx, msg1_len			; Provide the number of characters print
	syscall						
		
	; Repeat
	add rbp, 8
	jmp display_loop			
	
end_display_loop:	

	; Print out a new line
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg2				; Provide the memory location to start reading our characters to print
	mov rdx, msg2_len			; Provide the number of characters print
	syscall

	; Restore registers
	pop rbp
	pop rbx
	
	; Return
	ret
