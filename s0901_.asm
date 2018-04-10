assume cs:codesg

codesg segment
s:
	mov ax,bx
	mov si,offset s
	mov di,offset s0
	mov ax,cs:[si]
	mov cs:[di],ax
s0:
	nop
	nop
codesg ends

end s
\