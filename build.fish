#!/usr/bin/env fish

# Assemble
set ASM_SRC (ls src/**/*.asm)
mkdir -p obj

for asm_file in $ASM_SRC
  # Change the filename from src/*.asm to *.o
  set obj_file (string replace ".asm" ".o" (basename $asm_file))

  nasm -f elf64 -o "obj/$obj_file" "$asm_file"
end

# Link
set obj_src (ls obj/**/*.o)
ld -m elf_x86_64 -o obj/main $obj_src
