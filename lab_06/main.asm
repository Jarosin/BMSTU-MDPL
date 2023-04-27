.model tiny
.code
.186

org 100h ; 0h..100h - PSP

start:
    jmp init

    current DB 0
    speed DB 1Fh ; 2 symb/sec - slowest speed   
    old_08h_seg DW ?
    old_08h_off DW ?
    old_int DD ?

my_interrupt:
    pusha ; save base registers in stack
    push ES
    push DS

    mov AH, 02h ; get seconds in DH
    int 1Ah ; get time command execution

    cmp DH, current ;if time changed
    mov current, DH ; save last time it's called
    je end_loop; if it didnt - leave

    mov AL, 0F3h ; set parameters for autorepeat mode
    out 60h, AL ; 60h - keyboard port, 0F3h - autorepeat command
    mov AL, speed ; autorepeat speed 
    out 60h, AL ; set speed

    dec speed

    test speed, 1Fh ;check if it's zero
    jz reset_speed ; if speed == 30 symb/sec(speed = 0 => max speed of repeat) (fastest)
    jmp end_loop

reset_speed:
    mov speed, 01Fh ; set slowest speed

end_loop:
    pop DS
    pop ES
    popa

    jmp CS:old_int

; set interrupt
init:    
    ; get 08h interrupt handler address in ES:BX
    mov AX, 3508h; AH = 35h, AL = 08h, 08h - interrupt that we catch
    int 21h         
      

    ; save old interrupt address
    mov word ptr old_int, BX  
    mov word ptr old_int+2, ES         

    ; set new 08h interrupt handler address that need to be in DS:DX
    mov AX, 2508h ; AH = 25h, AL = 08h                
    mov DX, offset my_interrupt ; DS:DX - new interrupt handler address
    int 21h      ;в DS:DX как обработчик прерываний лежит теперь адресс этой проги и смещение my_interrupt                       

    ; make program resident
    mov DX, offset init ;  saves all bytes before init as resident
    int 27h 


end start