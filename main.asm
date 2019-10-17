org 100h


section .text
start:
	call ScreenInit
	call TimerInit
	call CreateMap
	call SetSeed
	mov cx,2000
	Loop:
	call GetKey
	call TimerCheck
	cmp al,0
	jz Loop
	jmp Loop
	call Quit
Count:
	push word 4
	push word [pos]
	push word 1
	push word 1
	mov al,[tmp]
	mov ah,7
	push ax
	call DrawLine
	mov ax,1
	add [pos],ax
	mov ax,1
	add [tmp],ax
	pop ax
	pop ax
	pop ax
	pop ax
	pop ax
	ret
RandValue:
	call Rand
	push word 0
	push word 0
	push word 1
	push word 1
	push ax
	call DrawLine
	pop ax
	pop ax
	pop ax
	pop ax
	pop ax
	ret
%include './Timer.asm'
%include './Drawer.asm'
%include './Game.asm'
%include './Food.asm'
%include './Keyboard.asm'
section .data
	pos dw 0
	tmp db 0
	