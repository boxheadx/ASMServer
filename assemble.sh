#!/bin/bash

nasm -f elf32 src/server.asm -i includes
ld -m elf_i386 -o bin/server src/server.o
rm src/*.o
