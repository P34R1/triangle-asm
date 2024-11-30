  section .text
  global exit

; Function exit
; Parameters:
; rdi: error code (0 is okay)

exit:
  mov rax, 60
  syscall

