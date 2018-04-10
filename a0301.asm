assume cs:codesg

codesg segment
s:
	jmp s
	jmp short s
	jmp near ptr s
	jmp far ptr s
codesg ends

end s