assume cs:code
code segment
	mov ax,0ffffh
	mov ds,ax		; (ds) <- ffffh
	mov bx,0 		; EA

	mov dx,0 		; sum

	mov cx,12		; loop counter

s:	mov al,[bx]
	mov ah,0 		; (ax) <- (ffff0h + (bx))
	add dx,ax
	inc bx
	loop s

	mov ax,4c00h
	int 21h
code ends
end
