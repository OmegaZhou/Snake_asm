BOX_START_X equ 0
BOX_START_Y equ 0
BOX_WIDTH equ 51
BOX_HEIGH equ 25

segment code

Init:
    call ScreenInit
    call MenuInit
    call CreateMap
	call MouseInit
    ret

GameStart:
    push ax
    call ClearScreen
    call CreateMap
    call SnakeInit
	call TimerInit
	call SetSeed
    call StopPause
    call MenuInit
    call SetNewFood
    mov al,0
    mov byte [is_end],al
    mov byte [now_dir],al
    pop ax
    ret

MainController:
    MainController.loop:
    call GetKey
    call MouseListen
    call CheckPause
    cmp al,1
	jz MainController.loop
	call TimerCheck
	cmp al,0
	jz MainController.loop
    call RealMove
	jmp MainController.loop
    ret

    

StopPause:
    push ax
    mov al,0
    mov byte [is_pause],al
    mov byte [now_dir],al
    call HidePauseItem
    pop ax
    ret 

Pause:
    push ax
    cmp byte [is_end],1
    jz Pause.end
    mov al,1
    mov byte [is_pause],al
    call ContinueItemInit
    call PauseItemInit
    Pause.end:
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
    call StopPause
    call GameOverItemInit
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

segment data

is_pause db     1

is_end db   1
