assume cs:codesg,ds:datasg

datasg segment
	db 'welcome to masm!'
	db '................'
datasg ends

codesg segment
start:
	mov ax,datasg
	mov ds,ax

	mov si,0
	mov di,16

	mov cx,16
s:	mov al,[si]
	mov [di],al
	inc si
	inc di
	loop s

	mov ax,4c00h
	int 21h
codesg ends

end start