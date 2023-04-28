nasm -f elf64 -o strcpy.o strcpy.asm
gcc -c -masm=intel -o main.o main.cpp
g++ main.o strcpy.o -o app.exe
