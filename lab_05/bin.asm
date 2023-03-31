public print_bin
EXTRN	endl : NEAR	
extern bin:word
extern sign:byte

CDS Segment para public "Code"
	ASSUME CS:CDS
	
  print_bin proc near
	xor BX,BX
	mov CX,16
	mov AH,02h
	push bin
	l:
		ROL bin,1
		mov BX,1
		and BX,bin
		add BX,"0"
		mov DX,BX
		int 21h
		loop l
	call endl
	pop bin
	ret
 print_bin endp
 CDS ends
 END