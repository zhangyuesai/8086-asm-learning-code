assume cs:code
code segment
	mov ax,0020h
	mov ds,ax		; (ds) <- 0020h

	mov cx,003fh	; loop counter
	mov bx,0000h	; 0 ~ 3fh, EA; also the data to be written (bl)

s:	mov [bx],bl		; eg. (0020:0012) <- (12h)
	inc bx
	loop s

	mov ax,4c00h
	int 21h
code ends
end