public print_menu
public input_command
public input_hex
public endl
public stop

extern bin:word
extern sign:byte

EXTRN	print_oct : NEAR	
EXTRN	print_bin : NEAR


DTS Segment para public "Data"
DTS ends

DataS Segment para "DataS"
MenuMsg DB 10 ;перевести курсор на нов. строку
 DB "Choose next action: " ;текст сообщения
 DB 10 ;перевести курсор на нов. строку
 DB "1: Input a unsigned hex nubmer" ;текст сообщения
 DB 10 ;перевести курсор на нов. строку
 DB "2: Print an unsigned bin number" ;текст сообщения
 DB 10 ;перевести курсор на нов. строку
 DB "3: Print a signed oct number" ;текст сообщения
 DB 10 ;перевести курсор на нов. строку
 DB "4: Close program" ;текст сообщения
 DB '$' ;ограничитель для функции 
DataS ends
CDS Segment para public "Code"
	ASSUME CS:CDS
	 ;функция вывода меню
 print_menu proc near
	xor dx,dx
	push ds
	mov ax,DataS
    mov ds,ax
	mov ah,9
	int 21h
	pop ds
	call endl
	ret
 print_menu endp
 
 ;функция ввода выбранного пункта меню
 input_command proc near
	mov AH,01h
	int 21h
	xor AH,AH
	sub AX,"1";1 - т.к. комманды 1-4, но индексы 0-3
	shl AX,1; двигаем влево, ибо каждая комманда 2 байта
	;push AX
	call endl
	ret
 input_command endp
 
 
 input_hex proc near
	mov CX,4
	xor AX,AX
	l:
		mov AH,01h
		int 21h
		xor AH,AH
		cmp AL,"A"
		jae big_letter
		sub AL,"0"
		jmp move
		big_letter:
		 sub AL,"A"
		 add AL, 10
		move:
		shl bin,1
		shl bin,1
		shl bin,1
		shl bin,1
		add bin,AX
		loop l
	call endl

	end_of_f:
		ret
 input_hex endp
 
 
 ;закрытие программы
 stop proc near
	  mov AH,4Ch ;АН=4Ch завершить процесс
	  int 21h ;вызов функции DOS 
 stop endp
 
 
 ;конец строки
 endl proc near
	 push dx
	 push ax
	 MOV dl, 10
	 MOV ah, 02h
	 INT 21h
	 pop ax
	 pop dx
	 ret
 endl endp

 CDS ends
 END
