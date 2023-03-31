
StkSeg SEGMENT PARA STACK 'STACK'
 DB 200h DUP (?)
StkSeg ENDS
;
DataSeg Segment PARA 'Data'
 x DB 11
DataSeg ENDS
Code SEGMENT WORD 'CODE'
 ASSUME CS:Code, DS:DataSeg, SS:StkSeg
DispMsg:
 mov AH,01h ;АН=07h ввести символ без эха
 INT 21h ;вызов функции DOS
 mov x, AL
 jmp printf
CODE ENDS	

Code2 Segment word 'CODE'
	printf label far
	 mov AH,02h
	 mov DL, " "
	 int 21h
	 mov AL,x
	 sub AL,"a"
	 add AL,"A"
	 mov DL,AL
	 mov AH,02h
	 int 21h
	 mov AH,4Ch ;АН=4Ch завершить процесс
	 int 21h ;вызов функции DOS 
CODE2 ENDS
END DispMsg