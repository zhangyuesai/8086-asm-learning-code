assume cs:code

a segment
	db 1,2,3,4,5,6,7,8
a ends

b segment
	db 1,2,3,4,5,6,7,8
b ends
	
c segment
	db 0,0,0,0,0,0,0,0
c ends

code segment
start:
	mov ax,a
	mov ds,ax		; (ds) <--> a

	mov bx,0		; EA

	mov cx,8		; loop counter
s:	mov dl,[bx]		; (dl) <- (a:EA)

	mov ax,b
	mov es,ax		; (es) <--> b
	add dl,es:[bx]	; (dl) <- (a:EA) + (b:EA)

	mov ax,c
	mov es,ax		; (es) <--> c
	mov es:[bx],dl	; (c:EA) <- (a:EA) + (b:EA)

	inc bx
	loop s

	mov ax,4c00h
	int 21h
code ends

end start