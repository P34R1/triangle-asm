  section .text
  global find_len

; Function find_len
; Parameters:
; rdi: ptr to \0 terminated string
; Return:
; rax: int (length of the string)

find_len:
  xor rcx, rcx                         ; rcx = 0

loop:
  cmp byte [rdi + rcx], 0              ; check for \0
  je return
  inc rcx                              ; rcx++
  jmp loop

return:
  mov rax, rcx
  ret
