assume cs:codesg

codesg segment
start:
	mov ax,123h
	jmp ax
	add ax,1
	db 16 dup (0)
s:	inc ax

codesg ends
end start