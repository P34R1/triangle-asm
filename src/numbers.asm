; HELPFUL LINKS
; https://www.cs.umd.edu/~srhuang/teaching/cmsc212/gdb-tutorial-handout.pdf GDB
; https://bytetool.web.app/en/ascii/code/0x32/ for debugging ascii
; https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
; https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html
; https://www.cs.virginia.edu/%7Eevans/cs216/guides/x86.html
; https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

  section .text
  global atoi

; Function atoi
; Parameters:
; rdi: ptr to \0 terminated string (number)
; Return:
; rax: int     -1 is err

atoi:
  mov rax, 0                           ; Set initial total to 0

convert:
; get the character
  movzx rsi, byte [rdi]                ; current char
  test rsi, rsi                        ; check for \0
  je done

; err if not a num
  cmp rsi, '0'                         ; less than 0 is invalid
  jl error

  cmp rsi, '9'                         ; greater than 9 is invalid
  jg error

; convert
  sub rsi, '0'                         ; convert from ASCII to decimal
  imul rax, 10                         ; mul total by 10 (shift digits)
  add rax, rsi                         ; add digit to total

  inc rdi
  jmp convert

error:
  mov rax, -1                          ; -1 on error

done:
  ret
