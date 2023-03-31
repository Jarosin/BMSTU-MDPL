public print_oct
EXTRN	endl : NEAR	
extern bin:word
extern sign:byte

CDS Segment para public "Code"
	ASSUME CS:CDS
	
 print_oct proc near
	xor BX,BX
	mov CX,5
	mov AH,02h
	push bin
	ROL bin,1
	mov DX, bin
	and DX,1
	cmp DX,1
	jne l
	xor DX,DX
	mov DL,"-"
	int 21h
	l:
		ROL bin,1
		ROL bin,1
		ROL bin,1
		
		mov BX,bin
		and BX,0007h;обнуляем все кроме последних 3 бит
		
		add BX,"0"
		mov DX,BX
		int 21h
		loop l
	call endl
	pop bin
	ret
 print_oct endp
 CDS ends
 END