assume cs:code

stack segment
	db 32 dup (0)
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,32

	mov dx,4996h
	mov ax,02dah
	mov cx,04d2h
	call divdw

	mov ax,4c00h
	int 21h


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
code ends

end start