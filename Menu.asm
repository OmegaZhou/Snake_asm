SCORE_ITEM_START equ (((80*1)+58)*2)
SCORE_ITEM_END equ (SCORE_ITEM_START+7*2)

SCORE_START equ (SCORE_ITEM_END+1*2)

START_ITEM_START equ (((80*15)+60)*2)
START_ITEM_END equ (START_ITEM_START+10*2)

QUIT_ITEM_START equ (((80*19)+60)*2)
QUIT_ITEM_END equ (QUIT_ITEM_START+10*2)

RETURN_ITEM_START equ (((80*11)+60)*2)
RETURN_ITEM_END equ (RETURN_ITEM_START+10*2)

PAUSE_ITEM_START equ (((80*7)+60)*2)
PAUSE_ITEM_END equ (PAUSE_ITEM_START+10*2)

OVER_ITEM_START equ (((80*7)+60)*2)
OVER_ITEM_END equ (PAUSE_ITEM_START+10*2)

EASY_ITEM_START equ (((80*13)+60)*2)
EASY_ITEM_END equ (EASY_ITEM_START+10*2)

MID_ITEM_START equ (((80*15)+60)*2)
MID_ITEM_END equ (MID_ITEM_START+10*2)

HARD_ITEM_START equ (((80*17)+60)*2)
HARD_ITEM_END equ (HARD_ITEM_START+10*2)

BACK_ITEM_START equ (((80*19)+60)*2)
BACK_ITEM_END equ (BACK_ITEM_START+10*2)

BUTTON_COLOR equ 0x1f00
PAUSE_COLOR equ 0x8c00

EASY_SPEED equ (MAX_RATE/10)
MID_SPEED equ (MAX_RATE/4)
HARD_SPEED equ MAX_RATE

segment code

MenuInit:
    call ScoreItemInit
    call MainItemInit
    ;call ContinueItemInit
    ;call PauseItemInit
    ret



ScoreItemInit:
    push ax
    mov ax,0
    mov word [score],ax
    push word score_item
    push word SCORE_ITEM_START
    call PrintStr
    call ShowScore
    pop ax
    pop ax
    pop ax
    ret

MainItemInit:
    push ax
    mov al,0
    mov byte [wait_select],al
    call HideLevelItem
    call StartItemInit
    call QuitItemInit
    pop ax
    ret

StartItemInit:
    push bp
    mov bp,sp

    push word start_item
    push word START_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor
    
    mov sp,bp
    pop bp
    ret

QuitItemInit:
    push bp
    mov bp,sp

    push word quit_item
    push word QUIT_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor
    
    mov sp,bp
    pop bp
    ret

ContinueItemInit:
    push bp
    mov bp,sp

    push word return_item
    push word RETURN_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor
    call ShowMouse
    mov sp,bp
    pop bp
    ret

PauseItemInit:
    push bp
    mov bp,sp

    push word pause_item
    push word PAUSE_ITEM_START
    push word PAUSE_COLOR
    call PrintStrColor
    
    mov sp,bp
    pop bp
    ret

HidePauseItem:
    push bp
    mov bp,sp

    push word (PAUSE_ITEM_END - PAUSE_ITEM_START)/2
    push word PAUSE_ITEM_START
    call PrintBlankStr
    
    push word (RETURN_ITEM_END - RETURN_ITEM_START)/2
    push word RETURN_ITEM_START
    call PrintBlankStr
    mov sp,bp
    pop bp
    ret

LevelItemInit:
    push bp
    mov bp,sp
    push ax

    mov al,1
    mov byte [wait_select],al

    push word easy_item
    push word EASY_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor

    push word mid_item
    push word MID_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor

    push word hard_item
    push word HARD_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor

    push word back_item
    push word BACK_ITEM_START
    push word BUTTON_COLOR
    call PrintStrColor

    pop ax
    mov sp,bp
    pop bp
    ret

HideLevelItem:
    push bp
    mov bp,sp

    push word (HARD_ITEM_END - HARD_ITEM_START)/2
    push word HARD_ITEM_START
    call PrintBlankStr
    
    push word (MID_ITEM_END - MID_ITEM_START)/2
    push word MID_ITEM_START
    call PrintBlankStr

    push word (EASY_ITEM_END - EASY_ITEM_START)/2
    push word EASY_ITEM_START
    call PrintBlankStr

    push word (BACK_ITEM_END - BACK_ITEM_START)/2
    push word BACK_ITEM_START
    call PrintBlankStr

    mov sp,bp
    pop bp
    ret

EasyMode:
    mov byte [init_v],EASY_SPEED
    call GameStart
    ret

MidMode:
    mov byte [init_v],MID_SPEED
    call GameStart
    ret
HardMode:
    mov byte [init_v],HARD_SPEED
    call GameStart
    ret
GameOverItemInit:
    push bp
    mov bp,sp

    push word over_item
    push word OVER_ITEM_START
    push word PAUSE_COLOR
    call PrintStrColor
    
    mov sp,bp
    pop bp
    ret

ShowScore:
    push dx
    push cx
    push bx
    push ax
    push si
    mov si,word score_str
    mov cx,5
    ShowScore.init:
        mov al,'0'
        mov byte [si],al
        inc si
    loop ShowScore.init
    dec si
    
    
    mov bx,word score
    mov ax,[bx]
    mov bx,10
    ShowScore.loop:
        cmp ax,0
        jz ShowScore.finish
        mov dx,0
        div bx
        add [si],dl
        dec si
    jmp ShowScore.loop
    ShowScore.finish:
    push word score_str
    push word SCORE_START
    call PrintStr
    pop ax
    pop ax

    pop si
    pop ax
    pop bx
    pop cx
    pop dx
    ret 
; void PrintStr(u8* str,u16 loc)
PrintStr:
    push bp
    mov bp,sp
    push word [bp+6]
    push word [bp+4]
    push word BLANK
    call PrintStrColor
    mov sp,bp
    pop bp
    ret

; void PrintStrColor(u8* str,u16 loc,u16 color)
PrintStrColor:
    push bp
    mov bp,sp

    call HideMouse

    push ax
    push bx
    mov ax,VIDEO_ADDRESS
    mov es,ax
    mov di,word [bp+6]
    mov bx, word [bp+8]
    mov ax, [bp+4]
    PrintStr.loop:
    mov al, byte [bx]
    cmp al,0
    jz  PrintStr.finish
    mov word [es:di],ax
    add di,2
    inc bx
    jmp PrintStr.loop

    PrintStr.finish:
    pop bx
    pop ax

    call ShowMouse

    mov sp,bp
    pop bp
    ret

PrintBlankStr:
    push bp
    mov bp,sp

    call HideMouse

    push ax
    push cx
    mov di,word [bp+4]
    mov cx,word [bp+6]
    mov ax,VIDEO_ADDRESS
    mov es,ax
    PrintBlankStr.loop:
        mov ax, BLANK
        mov word [es:di],ax
        add di,2
    loop PrintBlankStr.loop
    pop cx
    pop ax

    call ShowMouse

    mov sp,bp
    pop bp
    ret

segment data

score_item db   " Score:",0
return_item db  " Continue ",0
start_item db   " New Game ",0
quit_item db    "   Quit   ",0
pause_item db   " Pausing! ",0
over_item db    "Game Over!",0
easy_item db    "   Easy   ",0
mid_item db     "  Medium  ",0
hard_item db    "   Hard   ",0
back_item db    "   Back   ",0

score dw    0
score_str db    0,0,0,0,0,0
hide_str db "          ",0
wait_select db 0