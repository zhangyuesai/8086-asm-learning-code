assume cs:codesg

codesg segment
start:
	mov ax,0
	jmp near ptr s
	add ax,1
	db 4 dup (0)
s:	inc ax

codesg ends
end start