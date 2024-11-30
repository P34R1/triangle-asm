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

  sub rsp, rax        ; allocate on stack for rax bytes
  mov rcx, rax        ; rcx = number of bytes to set (size of the buffer)
  add rcx, 1          ; 1 byte for \n
  mov rdi, rsp

  mov r8, rax         ; index
  mov r9, 1           ; chars to print

  mov al, '*'
  rep stosb           ; fill rdi[..rcx] with al
  mov byte [rsp + r8], 0xa  ; newline
tri_loop:
  dec r8
  inc r9

; print
  lea rsi, [rsp + r8]                 ; make rsi the beginning of the string
  mov rdx, r9
  mov rdi, 1
  mov rax, 1
  syscall

  cmp r8, 0                           ; repeat if i > 0
  jg tri_loop

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
