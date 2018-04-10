assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
	db '1. display      '
	db '2. browse       '
	db '3. replace      '
	db '4. modify       '
datasg ends

codesg segment
start:
	mov ax,stacksg
	mov ss,ax
	mov sp,10h
	mov ax,datasg
	mov ds,ax

	mov bx,0
	mov cx,4
outer:
	mov si,0
	push cx
	mov cx,5
inner:
	mov al,[bx+3+si]
	and al,11011111b
	mov [bx+3+si],al
	inc si
	loop inner

	pop cx
	add bx,16
	loop outer

	mov ax,4c00h
	int 21h
codesg ends

end start