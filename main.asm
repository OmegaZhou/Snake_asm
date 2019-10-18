org 100h


section .text
start:
	call ScreenInit
	call GameStart
	call MenuInit
	Loop:
	call MainController
	;call TimerCheck
	;cmp al,0
	jz Loop
	jmp Loop
	call Quit
%include './Timer.asm'
%include './Drawer.asm'
%include './Menu.asm'	
%include './Game.asm'
%include './Food.asm'
%include './Keyboard.asm'
%include './Snake.asm'
