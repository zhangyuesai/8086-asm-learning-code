assume cs:codesg

codesg segment
start:
	mov ax,0123h
	mov ds:[0],ax
	jmp word ptr ds:[0]

codesg ends
end start