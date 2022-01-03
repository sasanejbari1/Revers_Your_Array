; System calls
SYS_WRITE		equ		1
SYS_READ		equ		0
; File descriptors
FD_STDIN		equ		0
FD_STDOUT		equ		1

; External symbols
extern libPuhfessorP_printSignedInteger64
extern libPuhfessorP_parseSignedInteger64
extern display_array
extern reverse

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the data section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.data
; Strings
msg1 		db 	"This program will reverse your array of integers.",13,10
msg1_len	equ	$-msg1
msg2 		db 	"Enter a sequence of long integers separated by the enter key (one integer per line). Enter 'q' to quit.", 13, 10
msg2_len	equ	$-msg2
msg3 		db 	13, 10, "Enter the next integer: "
msg3_len	equ	$-msg3
msg4 		db 	"You entered: "
msg4_len	equ	$-msg4
msg5 		db 	"You've entered nonsense. Assuming you are done!", 13, 10, 13, 10
msg5_len	equ	$-msg5
msg6 		db 	"These numbers are received and placed into the array: ", 13, 10
msg6_len	equ	$-msg6
msg7 		db 	13, 10, "After the reverse function, these are the numbers of the array in their new order: ", 13, 10
msg7_len	equ	$-msg7
msg8 		db 	13, 10, "You entered "
msg8_len	equ	$-msg8
msg9 		db 	" total numbers and their mean is "
msg9_len	equ	$-msg9
msg10 		db 	".", 13, 10, "The mean will now be returned to the main function.", 13, 10, 13, 10
msg10_len	equ	$-msg10
buffer		times 24 db 0		; buffer will store the user input 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the text section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.text

global manager
manager:
	; Save registers
	push rbx
	push rbp
	push r12
	push r13
	push r14
	
	; Save current value of rsp register
	mov rbp, rsp
	
	; Allocate space in stack for an array of 100 long intergers
	sub rsp, 800
	mov r13, rsp				; Keep a pointeer to the first integer we've created
	mov r14, 0					; Index into the array
	
	; Print out welcome message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg1				; Provide the memory location to start reading our characters to print
	mov rdx, msg1_len			; Provide the number of characters print
	syscall
	
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg2				; Provide the memory location to start reading our characters to print
	mov rdx, msg2_len			; Provide the number of characters print
	syscall

	; rbx will store the count of the numbers entered by the user
	mov rbx, 0
	
	; r12 will store the sum of the numbers entered by the user
	mov r12, 0
	
	; loop to get input numbers from the user
input_loop:
	
	; Print out the message asking for the integer as input
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg3				; Provide the memory location to start reading our characters to print
	mov rdx, msg3_len			; Provide the number of characters print
	syscall
	
	; Read integer as input from user
	mov rax, SYS_READ    		; System read
    mov rdi, FD_STDIN       	; Tell the system to read from STDIN
    mov rsi, buffer 			; Provide the buffer address where to store the characters read
    mov rdx, 24					; Buffer size
    syscall
	
	; Check if user just pressed enter
	cmp rax, 1
	jbe input_error				; If yes, display input error
	
	mov rdi, buffer				; RDI has the buffer's adddress
	mov dl, [rdi]				; Get a character
	cmp dl, '+'					; Check if it's a new + character
	je its_sign					
	cmp dl, '-'					; Check if it's a - character
	jne verify_loop			
	
its_sign:
	inc rdi
	
	; Check if user just entered the sign
	cmp rax, 2
	jbe input_error				; If yes, display input error
	
	; Loop to verify if given input is correct
verify_loop:	

	mov al, [rdi]				; Get a character
	cmp al, 10					; Check if it's a new line character
	je end_verify_loop			; If it is, we have reached the end of inpu	t
	cmp al, '0'					; Check if the character is out of the 0-9 range
	jb input_error				; If yes, display the error	
	cmp al, '9'					; Check if the character is out of the 0-9 range
	ja input_error				; If yes, display the error	
	inc rdi						; Move on to the next character
	jmp verify_loop				; Repeat

input_error:
	
	; Print out the message input error message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg5				; Provide the memory location to start reading our characters to print
	mov rdx, msg5_len			; Provide the number of characters print
	syscall
	jmp end_input_loop 

end_verify_loop:
	
	; Null terminate the user input string
	mov al, 0
	mov [rdi], al
	
	; Convert the input string to number
	mov rdi, buffer
	call libPuhfessorP_parseSignedInteger64
	
	; Save the input in stack
	mov [r13 + (r14 * 8)], rax			

	; Accumate the sum in r12
	add r12, rax
	
	; Print out the integer
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg4				; Provide the memory location to start reading our characters to print
	mov rdx, msg4_len			; Provide the number of characters print
	syscall
	
	mov rdi, [r13 + (r14 * 8)]
	call libPuhfessorP_printSignedInteger64

	; Next iteration
	inc r14						; Move on to the next location of the array in the stack
	inc rbx						; Increment the count
	
	jmp input_loop
	
end_input_loop:
		
	; Print out the msg6
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg6				; Provide the memory location to start reading our characters to print
	mov rdx, msg6_len			; Provide the number of characters print
	syscall	
	
	; Call assembly procedure display_array and ask it to print out the comma separated numbers
	mov rdi, r13
	mov rsi, rbx
	call display_array
	
	; Call C++ reverse function to reverse the array
	mov rdi, r13
	mov rsi, rbx
	call reverse
	
	; Print out the msg7
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg7				; Provide the memory location to start reading our characters to print
	mov rdx, msg7_len			; Provide the number of characters print
	syscall	
	
	; Call display_array and ask it to print out the comma separated numbers
	mov rdi, r13
	mov rsi, rbx
	call display_array
	
	; Find mean value
	mov rax, r12				; RAX has the sum
	cqo
	idiv rbx						; Find sum/count
	mov r12, rax				; r12 now has the mean
	
	; Print out the msg8
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg8				; Provide the memory location to start reading our characters to print
	mov rdx, msg8_len			; Provide the number of characters print
	syscall
	
	; Print the number count
	mov rdi, rbx
	call libPuhfessorP_printSignedInteger64
	
	; Print out the msg9
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg9				; Provide the memory location to start reading our characters to print
	mov rdx, msg9_len			; Provide the number of characters print
	syscall
	
	; Print the mean
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	
	; Print out the bye message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg10				; Provide the memory location to start reading our characters to print
	mov rdx, msg10_len			; Provide the number of characters print
	syscall
	
	; Return
	mov rax, r12				; Set return value to mean
	mov rsp, rbp				; Free up the space that was reserved in stack for input array
	pop r14
	pop r13
	pop r12
	pop rbp
	pop rbx
	ret
