EXTRN	input_hex : NEAR
EXTRN	print_oct : NEAR	
EXTRN	print_bin : NEAR	
EXTRN	stop : NEAR	
EXTRN	print_menu : NEAR
EXTRN	endl : NEAR	
EXTRN	input_command : NEAR	

public bin,sign

STS Segment para STACK "STACK"
 DB 200h DUP (?)
STS ends

DTS Segment para public "Data" 
 F DW input_hex,print_bin,print_oct,stop
 bin DW 0
 sign DB 0
DTS ends


CDS Segment para public "Code"
 ASSUME SS:STS, DS:DTS, CS:CDS


main:
	mov AX,DTS
	mov DS,AX
	call print_menu
	commands:
		call input_command
		xor BX,BX
		mov BL,AL
		call F[BX]
		call endl
		jmp commands
	;mov AH,4Ch ;АН=4Ch завершить процесс
	;int 21h ;вызов функции DOS 
CDS ends
end main