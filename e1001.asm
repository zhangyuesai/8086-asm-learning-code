assume cs:code

data segment
	db 'Welcome to MASM!',0
data ends

stack segment
	db 32 dup (0)
stack ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,32

	mov dh,8
	mov dl,3
	mov cl,02h
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h


; FUNCTION	show_str
; USAGE		shows a character string that ends with 0, 
;			with given attributes at given position
; PARAMETER	(dh) - line number (0-24)
;			(dl) - column number (0-79)
;			(cl) - attributes (B-BAC-I-FOR)
;			(ds:si) - starting address of the given string
; RETURNS	no return values
show_str:
	push cx
	push si
	push ax
	push es
	push bx
	push di

	mov ax,0b800h
	mov es,ax			; es: screen buffer

	mov al,dh
	mov ah,0a0h
	mul ah
	mov bx,ax			; bx: EA at the beginning of the given line

	mov dh,0
	mov di,dx
	add di,di			; di: bias of the given column

	mov al,cl 			; al: attributes

char:
	mov cl,[si]			; mov a char...
	mov ch,0
	jcxz done			; check if it meets the string's end
	mov ch,al			; ... and its attributes...
	mov es:[bx][di],cx	; ... to the screen
	inc si
	add di,2
	jmp char

done:
	pop di
	pop bx
	pop es
	pop ax
	pop si
	pop cx
	ret
code ends

end start