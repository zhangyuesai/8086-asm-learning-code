assume cs:codesg

data segment
; 0000h:	; year array
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
; 0054h:	; income array
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
; 00a8h:	; employee array
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
data ends

table segment
	db 21 dup ('year',0,'summ ne ?? ')
	db 16 dup (0)
table ends

stack segment
	db 32 dup (0)
stack ends

codesg segment
start:
	mov ax,data
	mov ds,ax		; (ds) <-- DATA
	mov ax,table
	mov es,ax		; (es) <-- TABLE
	mov ax,stack
	mov ss,ax
	mov sp,32		; (ss) <-- STACK

	call fill_table

	mov ax,table 
	mov ds,ax		; (ds) <-- TABLE

	mov cx,21 		; 21 rcds
	mov bx,0 		; bx: starting address for each rcd in TABLE
	mov dh,2 		; the first rcd is printed at the 2nd line on the screen
	push dx			; saves the starting position of each rcd on the screen
rcd_in_table:
	pop dx
	push cx

	mov dl,42
	mov cl,07h		; TODO: 02h for green, for debug purpose only. change to 07h (white) instead
	mov si,bx
	call show_str

	push dx			; saves the starting position of each rcd on the screen
	mov ax,[bx].5
	mov dx,[bx].7 	; (dx:ax): income
	mov si,0150h
	call dtoc_dword
	pop dx

	mov dl,52
	mov cl,07h	; TODO
	mov si,0150h
	call show_str

	push dx
	mov ax,[bx].0ah
	mov dx,00h
	mov si,0150h
	call dtoc_dword
	pop dx

	mov dl,62
	mov cl,07h	; TODO
	mov si,0150h
	call show_str

	push dx
	mov ax,[bx].0dh
	mov dx,00h
	mov si,0150h
	call dtoc_dword
	pop dx

	mov dl,72
	mov cl,07h	; TODO
	mov si,0150h
	call show_str

	add bx,10h
	pop cx
	inc dh
	push dx
	loop rcd_in_table



	













	mov ax,4c00h
	int 21h


fill_table:
	mov di,0		; index of a word array (ie. EMPLOYEE)
	mov bp,0		; index of each rcd in TABLE
	mov cx,21		; 21 rcds
rcd:				; "record" is a reserved word!
	mov bx,di		
	add bx,di		; index of a dword array (ie. YEAR & INCOME)
	mov si,0		; pointer for each digit in a year
	push cx			; saves the counter for the RCD loop, so that cx can be used as the counter for the YEAR loop
	mov cx,4		; 4 digits for a year
year:
	mov al,0000h[bx][si]	; (al) <-- 1 of the 4 digits of a year
	mov es:[bp].00h[si],al
	inc si
	loop year
income:
	mov si,0
	mov ax,0054h[bx][si]	; (ax) <-- least significant part of dividend (ie. income)
	mov es:[bp].05h[si],ax
	mov si,2
	mov dx,0054h[bx][si]	; (dx) <-- most significant part of dividend (ie. income)
	mov es:[bp].05h[si],dx
employee:
	mov cx,00a8h[di]		; (cx) <-- divisor (ie. employee)
	mov es:[bp].0ah,cx
average:
	div cx					; (ax) <-- quotient (ie. average)
	mov es:[bp].0dh,ax

	add di,2				; di is now the index of the next word
	add bp,16				; bp is now the index of the next rcd
	pop cx
	loop rcd

	ret
; fill_table_done


; from e1001.asm
; FUNCTION	show_str
; USAGE		shows a character string that ends with 0, 
;			with given attributes at given position
; PARAMETER	(dh) - line number (0-24)
;			(dl) - column number (0-79)
;			(cl) - attributes (B-BAC-I-FOR)
;			(ds:si) - starting address of the given string
; RETURNS	no return values
show_str:
	push dx
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
	pop dx
	ret
; show_str_done


; FUNCTION	dtoc_dword
; USAGE		converts a dword data (DW) to its decimal representation 
;			character string, ending with 0
; PARAMETER	(dx) - most significant 16 bits of the dword data, "HW"
;			(ax) - least significant 16 bits of the dword data, "LW"
;			(ds:si) - starting address of the string
; RETURNS	no return values
dtoc_dword:
	push bp
	push dx
	push cx
	push ax
	mov bp,sp
	
digits:
	mov cx,10
	call divdw	; (dx:ax) = (DW) / 10, (cx) = (DW) % 10
	push cx		; saves remainder
	mov cx,dx
	jcxz high_zero
	jmp quotient_not_zero
high_zero:
	mov cx,ax
	jcxz digits_done	; quotient == 0
quotient_not_zero:
	pop cx
	add cx,30h		; remainder: digit --> ASCII
	push cx			; saves a digit of (DW) (starting from the least significant end)
	jmp digits
digits_done:
	pop cx
	add cx,30h
	push cx
	mov cx,bp
	sub cx,sp		; (cx) / 2: number of digits
stack2str:
	jcxz stack2str_done
	pop ax
	mov [si],al
	inc si
	sub cx,2
	jmp stack2str
stack2str_done:
	; inc si
	mov byte ptr [si],0	; add ending-zero to the string

	pop ax
	pop cx
	pop dx
	pop bp
	ret


; from e1002.asm
; FUNCTION	divdw
; USAGE		division operation that doesn't cause overflow. 
;			dividend: dword, divisor: word, 
;			quotient: dword, remainder: word
; PARAMETER	(dx) - most significant 16 bits of dividend,	"H"
;			(ax) - least significant 16 bits of dividend,	"L"
;			(cx) - divisor,									"N"
; RETURNS	(dx) - most significant 16 bits of quotient
;			(ax) - least significant 16 bits of quotient
;			(cx) - remainder
divdw:
	push bp
	push ax		; ax will be used in DIV instructions, so (ax), ie. L, is saved here
	mov bp,sp	; bp: points to L

	mov ax,dx
	mov dx,0
	div cx		; (ax) = H / N, (dx) = H % N
	push ax

	mov ax,[bp]
	div cx		; (ax) = ((H % N) + L) / N, (dx) = ((H % N) + L) % N
	mov cx,dx	; (cx) = ((H % N) + L) % N
	pop dx		; (dx) = H / N

	add sp,2
	pop bp
	ret
codesg ends

end start