BOX_START_X equ 0
BOX_START_Y equ 0
BOX_WIDTH equ 51
BOX_HEIGH equ 25

section .text

GameStart:
    push ax
    call SnakeInit
	call TimerInit
	call CreateMap
	call SetSeed
    call StopPause
    mov al,0
    mov byte [is_end],al
    pop ax
    ret

MainController:
    MainController.loop:
    call KeyController
    call CheckPause
    cmp al,1
	jz MainController.loop
	call TimerCheck
	cmp al,0
	jz MainController.loop
    call Move
	jmp MainController.loop
    ret
KeyController:
    call GetKey
    push ax
    mov al,[now_key]
    cmp al,PAUSE_KEY
    jz KeyController.pause
    cmp al,QUIT_KEY
    jz KeyController.quit
    cmp al,0
    jz KeyController.end
    
    jmp KeyController.dir

    KeyController.pause:
    call Pause
    jmp KeyController.end
    KeyController.quit:
    call Quit
    jmp KeyController.end
    KeyController.dir:
    mov byte [now_dir],al
    jmp KeyController.end

    KeyController.end:
    mov al,0
    mov byte [now_key],0
    pop ax
    ret
    

StopPause:
    push ax
    mov al,0
    mov byte [is_pause],al
    pop ax
    ret 

Pause:
    push ax
    mov al,1
    mov byte [is_pause],al
    pop ax
    ret 

CheckPause:
    mov ax,0
    mov al,byte [is_pause]
    or al, byte [is_end]
    ret

GameOver:
    push ax
    mov al,1
    mov byte [is_end],al
    call Quit
    pop ax
    ret
CreateMap:
    push bp
    mov bp,sp

    ;左
    push word BOX_START_X
    push word BOX_START_Y
    push word BOX_HEIGH
    call DrawVerticalWall
    mov sp,bp

    ;右
    push word BOX_START_X
    push word BOX_START_Y+BOX_WIDTH-1
    push word BOX_HEIGH
    call DrawVerticalWall
    mov sp,bp

    ;上
    push word BOX_START_X
    push word BOX_START_Y
    push word BOX_WIDTH
    call DrawHorizontalWall
    mov sp,bp

    ;下
    push word BOX_START_X+BOX_HEIGH-1
    push word BOX_START_Y
    push word BOX_WIDTH
    call DrawHorizontalWall
    mov sp,bp

    pop bp
    ret

section .data

is_pause db     1

is_end db   1
