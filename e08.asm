assume cs:codesg

codesg segment
	mov ax,4c00h		; d) after c) is executed, cs:ip jumps here
	int 21h				; e) so this program can terminate normally

start:
	mov ax,0
s:	nop					; c) the instruction to be copied to here is "jump 10 bytes forward"
	nop

	mov di,offset s
	mov si,offset s2
	mov ax,cs:[si]		; a) copy the instruction from [si] to [di]
	mov cs:[di],ax		; b) the instruction at [si] is actually "jump 10 bytes forward", rather than "jump to s1"

s0:	jmp short s
	
s1:	mov ax,0
	int 21h
	mov ax,0

s2:	jmp short s1
	nop
codesg ends
end start