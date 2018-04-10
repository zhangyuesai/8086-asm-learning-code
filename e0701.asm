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
	db 21 dup ('year summ ne ?? ')
table ends

stack segment
	db 16 dup (0)
stack ends

codesg segment
start:
	mov ax,data
	mov ds,ax		; (ds) <-- (DATA)
	mov ax,table
	mov es,ax		; (es) <-- (TABLE)
	mov ax,stack
	mov ss,ax
	mov sp,16		; (ss) <-- (STACK)

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

	mov ax,4c00h
	int 21h
codesg ends

end start