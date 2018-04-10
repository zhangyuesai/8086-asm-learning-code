assume cs:codesg

codesg segment
s:
	db 100 dup (0b8h,0,0)
	jmp s
	; jmp short s
	jmp near ptr s
	jmp far ptr s
codesg ends

end s