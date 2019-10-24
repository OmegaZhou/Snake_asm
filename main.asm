segment code
main:
	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax         
	mov sp,stacktop
	call Init
	call MainController
	call Quit


%include './Timer.asm'
%include './Drawer.asm'
%include './Menu.asm'	
%include './Game.asm'
%include './Food.asm'
%include './Keyboard.asm'
%include './Snake.asm'
%include './Mouse.asm'

segment stack stack
times 128 db 0 
stacktop: