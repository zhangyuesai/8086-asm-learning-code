assume cs:codesg

codesg segment
s:
	db 4096 dup (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	jmp s
	; jmp short s
	jmp near ptr s
	jmp far ptr s
codesg ends

end s