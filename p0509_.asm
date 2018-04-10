assume cs:code
code segment
	mov ax,0ffffh
	mov ds,ax
	mov ax,0020h
	mov es,ax

	mov bx,0 		; EA
	mov cx,12 		; loop counter

s:	mov ds:[bx],dl	; (dl) <- (ffff:EA)
	mov es:[bx],dl	; (0020:EA) <- (dl)
	inc bx			; EA++
	loop s

	mov ax,4c00h
	int 21h
code ends
end