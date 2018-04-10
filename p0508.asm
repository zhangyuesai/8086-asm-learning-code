assume cs:code
code segment
	mov cx,12 		; loop counter
	mov bx,0 		; EA

s:	mov ax,0ffffh
	mov ds,ax
	mov dl,[bx]		; (dl) <- (ffff:EA)
	mov ax,0020h
	mov ds,ax
	mov [bx],dl		; (0020:EA) <- (dl)
	inc bx			; EA++
	loop s

	mov ax,4c00h
	int 21h
code ends
end