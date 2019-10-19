org 100h


section .text
start:
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