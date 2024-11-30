#!/usr/bin/env fish

# Assemble
set ASM_SRC (ls src/**/*.asm)
mkdir -p obj

for asm_file in $ASM_SRC
  # Change the filename from src/*.asm to *.o
  set obj_file (string replace ".asm" ".dbg.o" (basename $asm_file))

  nasm -gdwarf -f elf64 -o "obj/$obj_file" "$asm_file"
end

# Link
set obj_src (ls obj/**/*.dbg.o)
ld -m elf_x86_64 -o obj/main.dbg $obj_src
