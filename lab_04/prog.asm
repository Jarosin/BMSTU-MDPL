Stk segment para STACK 'Stack'
 DB 200h DUP (?)
Stk ends

Dts segment para 'Data'
 x db 81 dup(?)
 rows db 2
 columns db 2
 temp db 81 dup(?)
Dts ends

;ah - первый(больший), al - второй(меньший)
;при mul - берется из al, кладется в ax
;при div - делимое - ax, частное - al, остаток - ah
Cds segment para 'Code'
Assume DS:Dts, SS:Stk, CS:Cds


read proc near
 mov AH,01h ;АН=07h ввести символ без эха
 INT 21h ;вызов функции DOS
 mov rows, AL
 sub rows, "0"
 mov AH,02h
 mov DL," "
 int 21h 
 mov AH,01h ;АН=07h ввести символ без эха
 INT 21h ;вызов функции DOS
 mov columns, AL
 sub columns, "0"
 xor AX, AX
 mov AL, rows
 mul columns
 mov CX,AX
 call endl
 call endl
 ;CX здесь верный при 4x4(0010)
 l:  mov AH,01h ;АН=07h ввести символ без эха
	 INT 21h ;вызов функции DOS
	 mov BX,CX
	 mov x[BX - 1],AL
	 sub x[BX - 1],"0"
	 xor AX,AX
	 mov AH,02h
	 mov DL," "
	 int 21h
	 mov AX,CX
	 dec AX
	 div columns
	 cmp ah,0
	 jne p;если не равны, переходит на метку(полагается на флаги)
	 call endl
	 p: loop l
 ret
read endp


print proc near
 call endl
 xor AX, AX
 mov AL, rows
 mul columns
 mov CX,AX
 l:  mov AH,02h ;АН=02h вывод символа
 	 mov BX,CX
     mov DL,x[BX - 1]
	 add DL,"0"
	 INT 21h ;вызов функции DOS	
	 mov DL," "
	 int 21h
	 mov AX,CX
	 dec AX
	 div columns
	 cmp ah,0
	 jne p;если не равны, переходит на метку(полагается на флаги)
	 call endl
	 p: loop l
 ret
 print endp
 
endl proc near
	 push AX
	 push DX
	 xor AX,AX
	 xor DX,DX
	 MOV dl, 10
	 MOV ah, 02h
	 INT 21h
	 pop DX
	 pop AX
	 ret
endl endp


change_matr proc near
 xor AX, AX
 mov AL, rows
 mul columns
 mov CX,AX
	l:
	 mov BX,CX
	 XOR AX,AX
	 mov AL,x[BX - 1]
	 push AX
	 mov AX,CX
	 dec AX
	 xor DX,DX
	 mov DL, columns
	 div DL
	 mov DL, AH
	 mov AL, columns
	 sub AL, DL
	 dec AL
	 xor AH,AH
	 XOR DX,DX
	 mov DL, rows
	 mul DX
	 push AX
	 mov AX, CX
	 dec AX
	 xor DX,DX
	 mov DL, columns
	 div DL
	 xor DX,DX
	 mov DL, AL
	 pop AX
	 add AX, DX
	 xor BX,BX
	 mov BX, AX
	 pop AX
	 mov temp[BX],AL
	 loop l
 mov AL, rows
 mov AH, columns
 mov rows, AH
 mov columns, AL
 xor AX, AX
 mov AL, rows
 mul columns
 mov CX,AX
 	 copy:
	 mov BX,CX
	 mov AL, temp[BX - 1]
	 mov x[BX - 1], AL
	 loop copy
 ret
 
change_matr endp

main:
 mov AX,Dts ;загрузка в AX адреса сегмента данных
 mov DS,AX ;установка DS
 call read
 call change_matr
 call print
 xor AX,AX
 mov AH,4Ch
 int 21h ;вызов функции DOS 
Cds ends
End main
