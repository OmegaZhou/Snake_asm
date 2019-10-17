BOX_START_X equ 0
BOX_START_Y equ 0
BOX_WIDTH equ 50
BOX_HEIGH equ 25

section .text
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
is_start db 0
score dw 0
snake_ptr dw 0