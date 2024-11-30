  section .rodata
argc_err_msg:
  db "No Argument was Given!", 0xa
  argc_err_len equ $ - argc_err_msg
nan_err_msg:
  db "argv[1] should be > 0", 0xa
  nan_err_len equ $ - nan_err_msg

  section .text
  global _start

  extern atoi
  extern exit

_start:
; err check instead of segfault
  mov ecx, [rsp]                       ; load argc (assuming smaller then 2^32)
  cmp ecx, 1
  jbe argc_err                         ; jmp to argc_err if argc <= 1 (no args)

; convert to num
  mov rdi, [rsp+16]                    ; argv[1]
  call atoi

  cmp rax, 0
  jle nan_err

; square
  mul rax                              ; square rax

; print
  mov rsi, rax                         ; make rsi the beginning of the string
  mov rdx, rdx                         ; make rdx the string size
  mov rdi, 1
  mov rax, 1
  syscall

; exit
  mov rdi, 0
  call exit

argc_err:
; print err
  mov rsi, argc_err_msg
  mov rdx, argc_err_len
  mov rdi, 1
  mov rax, 1
  syscall

; exit with err code 1
  mov rdi, 1
  call exit


nan_err:
; print err
  mov rsi, nan_err_msg
  mov rdx, nan_err_len
  mov rdi, 1
  mov rax, 1
  syscall

; exit with err code 1
  mov rdi, 1
  call exit
