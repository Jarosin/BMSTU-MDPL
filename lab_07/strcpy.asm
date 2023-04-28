global copy

section .data
section .text

copy:
    mov RCX, RDX

    cmp RSI, RDI
    jge std_copy

    add RDI, RCX
    add RSI, RCX

    dec RDI
    dec RSI

    std
std_copy:
    rep movsb
    cld
    ret
