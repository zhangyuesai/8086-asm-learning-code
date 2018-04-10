assume cs:code

data segment
	db 10 dup (0)
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

	mov ax,65535
	mov si,0
	call dtoc

	mov dh,8
	mov dl,3
	mov cl,02h
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h


; FUNCTION	dtoc
; USAGE		converts a word data to its decimal representation 
;			character string, ending with 0
; PARAMETER	(ax) - the word data, "WD"
;			(ds:si) - starting address of the string
; RETURNS	no return values
dtoc:
	push bp
	push dx
	push cx
	push bx
	push ax
	mov bp,sp

	mov bx,10
digits:
	mov dx,0
	div bx			; (ax) = (WD) / 10, (dx) = (WD) % 10
	mov cx,ax
	jcxz digits_done
	add dx,30h		; digit --> ASCII
	push dx			; saves a digit of WD (starting from the least significant end)
	jmp digits
digits_done:
	add dx,30h
	push dx
	mov cx,bp
	sub cx,sp 		; (cx) / 2: number of digits
stack2str:
	jcxz stack2str_done
	pop ax
	mov [si],al
	inc si
	sub cx,2
	jmp stack2str
stack2str_done:
	inc si
	mov byte ptr [si],0	; add ending-zero to the string

	pop ax
	pop bx
	pop cx
	pop dx
	pop bp
	ret

; from e1001.asm
; FUNCTION	show_str
; USAGE		shows a character string that ends with 0, 
;			with given attributes at given position
; PARAMETER	(dh) - line number (0-24)
;			(dl) - column number (0-79)
;			(cl) - attributes (B-BAC-I-FOR)
;			(si) - EA of the given string
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