assume cs:code

data segment
	db 'Welcome to MASM!'
	db 02h				; text - G
	db 24h				; text - R, back - G
	db 71h				; text - B, back - RGB
data ends

stack segment
	db 16 dup (0)
stack ends

code segment
start:
	mov ax,data
	mov ds,ax			; ds: data
	mov ax,stack
	mov ss,ax			; ss: stack
	mov sp,0
	mov ax,0b800h
	mov es,ax			; es: display buffer
	mov bp,16			; bp: attributes

	mov bx,06e0h		; EA of the 12th line on the screen
	mov cx,3			; 3 lines (ie. 12-14th line)
line:
	mov si,0			; EA of the char in DATA
	mov di,0			; EA of the char on the screen
	push cx
	mov cx,16			; 16 characters
char:
	mov al,[si]			; mov a char...
	mov ah,ds:[bp]		; ... and its attribute...
	mov es:[bx].40h[di],ax	; ... to the screen
	inc si
	add di,2
	loop char

	pop cx
	add bx,160
	inc bp
	loop line

	mov ax,4c00h
	int 21h
code ends

end start