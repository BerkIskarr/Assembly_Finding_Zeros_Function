extern printf         ; External reference to the printf function

section .data
   ; Define with random number to prevent error
    a     dq 2.0         ; Variable a
    b     dq 4.0         ; Variable b
    c     dq 10.0        ; Variable c
    d     dq 4.0         ; Variable d
    e     dq 8.0         ; Variable e
    f     dq 20.0        ; Variable f
    pol1        db "ax1+bx2=c", 0x0A, 0  ; String pol1 with newline character (0x0A)
    pol2        db "dx1+ex2=f", 0x0A, 0  ; String pol2 with newline character (0x0A)
    solution1   db "x1 is %f and x2 is %f", 0  ; String solution1
    zerodiv     db "No solution!", 0x0A, 0  ; String zerodivisionerror indicator with newline character

section .bss
    A0 resq 1   ; Reserved space for A0
    A1 resq 1   ; Reserved space for A1
    A2 resq 1   ; Reserved space for A2
    x1 resq 1   ; Reserved space for x1
    x2 resq 1   ; Reserved space for x2

section .text
global main

main:
    push rbp
    mov rbp, rsp

    ; Print pol1 string
    mov rax, 1       ; System call number for write
    mov rdi, 1       ; File descriptor for standard output (stdout)
    mov rsi, pol1    ; Address of the string pol1
    mov rdx, 9       ; Length of the string pol1
    syscall

    ; Print pol2 string
    mov rax, 1       ; System call number for write
    mov rdi, 1       ; File descriptor for standard output (stdout)
    mov rsi, pol2    ; Address of the string pol2
    mov rdx, 9       ; Length of the string pol2
    syscall

; Calculation of x1 and x2 using Cramer's Rule
    ; Calculate A0
    movsd xmm0, qword ptr[a]     ; Load the value of a into xmm0
    mulsd xmm0, qword ptr[e]     ; Multiply xmm0 by the value of e
    movsd xmm1, qword ptr[b]     ; Load the value of b into xmm1
    mulsd xmm1, qword ptr[d]     ; Multiply xmm1 by the value of d
    subsd xmm0, xmm1          ; Subtract xmm1 from xmm0
    movsd qword ptr[A0], xmm0    ; Store the result in memory location A0
    
    cmp [A0],0   	     ; When A0 is 0, it causes zero division, meaning no solution 
    je  no_solution

; In assembly language, the brackets ([]) are used to indicate memory access. When you enclose a memory address or variable inside brackets, it signifies that you want to access the value stored at that memory location.

; The "qword" size specifier indicates that a quadword (64-bit) value is being loaded.

; The reason for using instructions like movsd is that they specifically move 'scalar double-precision floating-point' values between SSE registers and memory.
	
    ; Calculate A1
    movsd xmm3, qword ptr[c]     ; Load the value of c into xmm3
    mulsd xmm3, qword ptr[e]     ; Multiply xmm3 by the value of e
    movsd xmm4, qword ptr[b]     ; Load the value of b into xmm4
    mulsd xmm4, qword ptr[f]     ; Multiply xmm4 by the value of f
    subsd xmm3, xmm4          ; Subtract xmm4 from xmm3
    movsd qword ptr[A1], xmm3    ; Store the result in memory location A1

    ; Calculate A2
    movsd xmm5, qword ptr[a]     ; Load the value of a into xmm5
    mulsd xmm5, qword ptr[f]     ; Multiply xmm5 by the value of f
    movsd xmm6, qword ptr[d]     ; Load the value of d into xmm6
    mulsd xmm6, qword ptr[c]     ; Multiply xmm6 by the value of c
    subsd xmm5, xmm6          ; Subtract xmm6 from xmm5
    movsd qword ptr[A2], xmm5    ; Store the result in memory location A2
    
    movsd xmm9, qword ptr[A1]   ; divsd requires the destination operand to be a register, not memory.
    divsd xmm9, qword ptr[A0]   ; A1 / A0
    movsd qword ptr[x1], xmm9   ; Store result in x1
    movsd xmm10, qword ptr[A2]
    divsd xmm10, qword ptr[A0]   ; A2 / A0
    movsd qword ptr[x2], xmm10   ; Store result in x2
    

    ; Print the solution using printf
    mov rdi, solution1      ; Pass the format string to the first argument (rdi)
    mov rax, 0             ; System call number for printf
    movsd xmm7, qword ptr[x1]    ; Load the value of x1
    movsd xmm8, qword ptr[x2]    ; Load the value of x2
    call printf            ; Call the printf function to print the values
    
    jmp exit

; The reason I pass to xmm register is that in x86-64 assembly, floating-point values are typically passed in the XMM registers, not the general-purpose registers (such as rax, rsi, rdi, and rdx) used for integer values. Xmm register is from xmm0 to xmm15.

no_solution:
    mov rax, 1		; 1 = write
    mov rdi, 1		; 1 = to stdout
    mov rsi, zerodiv	; string to display
    mov rdx, 12
exit:                
    mov rsp, rbp
    pop rbp

    mov rax, 60      ; System call number for exit
    xor edi, edi     ; Set exit status to 0
    syscall

