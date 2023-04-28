cmake_minimum_required(VERSION 3.9)

project(lab_07)
enable_language(ASM_NASM)
set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
set(CMAKE_ASM_NASM_COMPILE_OBJECT "<CMAKE_ASM_NASM_COMPILER> <INCLUDES> \
    <FLAGS> -f elf64 ${CMAKE_ASM_NASM_OBJECT_FORMAT} -o <OBJECT> <SOURCE>")


set_source_files_properties(src/strcpy.asm PROPERTIES COMPILE_FLAGS "-g -Fdwarf")
add_executable(lab_07 main.cpp strcpy.asm)
target_compile_options(lab_07 PRIVATE -masm=intel)
