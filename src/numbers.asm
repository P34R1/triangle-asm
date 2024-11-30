; HELPFUL LINKS
; https://www.cs.umd.edu/~srhuang/teaching/cmsc212/gdb-tutorial-handout.pdf GDB
; https://bytetool.web.app/en/ascii/code/0x32/ for debugging ascii
; https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
; https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html
; https://www.cs.virginia.edu/%7Eevans/cs216/guides/x86.html
; https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

  section .bss
  buf resb 20

  section .text
  global atoi
  global itoa

; Function atoi
; Parameters:
; rdi: ptr to \0 terminated string (number)
; Return:
; rax: int

atoi:
  mov rax, 0                           ; Set initial total to 0

convert:
; get the character
  movzx rsi, byte [rdi]                ; Get the current character
  test rsi, rsi                        ; Check for \0
  je done

; err if not a num
  cmp rsi, 48                          ; Anything less than 0 is invalid
  jl error

  cmp rsi, 57                          ; Anything greater than 9 is invalid
  jg error

; convert
  sub rsi, '0'                         ; Convert from ASCII to decimal
  imul rax, 10                         ; Multiply total by 10
  add rax, rsi                         ; Add current digit to total

  inc rdi                              ; Get the address of the next character
  jmp convert

error:
  mov rax, -1                          ; Return -1 on error

done:
  ret                                  ; Return total or error code

; Function itoa
; Parameters:
; rsi: int to convert
; Returns
; rax: memory location
; rdx: string size

itoa:
  mov rax, rsi
  push rbx                             ; Save rbx since we'll use it as a temporary register

; add newline
  mov rbx, 0Ah
  mov [buf + 20], rbx                  ; insert newline
  mov rcx, 1                           ; size of newline char

; load the string loc
  lea rbx, [buf + 20]                  ; rbx = buffer pointer (point to the end of the buffer)
  push rbx                             ; save mem loc in stack
  mov rbx, [rsp]                       ; copy into rbx

  add [rsp], rcx                       ; to account for the newline
  mov rcx, 10                          ; Divider (10 for decimal base)

itoa_loop:
; divide
  mov rdx, 0                           ; ref rdx
  div rcx                              ; Divide rax by rcx (10), quotient in rax, remainder in rdx

; convert to char and insert
  add rdx, '0'                         ; Convert remainder (digit) to ASCII            dl is lowest byte of rdx
  dec rbx                              ; Move buffer pointer backwards
  mov [rbx], dl                        ; Store the digit in the buffer

; check if done looping
  test rax, rax                        ; Check if quotient is zero
  jnz itoa_loop                        ; If not zero, continue loop

itoa_end:
  lea rax, [rbx]                       ; Return address of the start of the string in rax
  pop rdx                              ; [buf + 20] mem loc
  sub rdx, rbx                         ; calculate string len    (buf + 20) - rdx (dec counter)

  pop rbx                              ; Restore rbx
  ret
