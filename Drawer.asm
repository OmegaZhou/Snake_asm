SCREEN_SIZE equ 2000
SCREEN_WIDTH equ 80
SCREEN_HEIGH equ 25
VIDEO_ADDRESS equ 0xB800
BLANK equ 0x0720
segment code

; 清空屏幕并保存原屏幕信息
ScreenInit:
    push ax
    push cx
    mov ax, VIDEO_ADDRESS
    mov es, ax
    mov ax, 0
    mov di, ax
    mov cx, SCREEN_SIZE
    ScreenInit.save:
        mov ax, word [es:di]
        mov word [old_screen+di], ax
        add di,2
    loop ScreenInit.save
    call ClearScreen
    call HideCursor
    pop cx
    pop ax
    ret

ClearScreen:
    push ax
    push cx
    mov ax, VIDEO_ADDRESS
    mov es, ax
    mov ax, 0
    mov di, ax
    mov cx, SCREEN_SIZE
    mov ax,BLANK
    ClearScreen.clear:
        mov word [es:di],ax
        add di,2
    loop ClearScreen.clear
    pop cx
    pop ax
    ret

Quit:
    push ax
    push cx
    call DisplayCursor
    call QuitMouse
    mov ax, VIDEO_ADDRESS
    mov es, ax
    mov ax, 0
    mov di, ax
    mov cx, SCREEN_SIZE
    Quit.return:
        mov ax, word [old_screen+di]
        mov word [es:di], ax
        add di,2
    loop Quit.return
    call DeleteAllPtr
    pop cx
    pop ax
    mov ah,4ch
    int 21h
    ret

; 绘制一条线
; void DrawLine(u16 x,u16 y,u16 x_len ,u16 y_len, u16 charactor)
DrawLine:
    push bp
    mov bp,sp
    push ax
    push cx

    push word [bp+12]
    push word [bp+10]
    call GetDisplayLocation
    pop cx
    pop cx

    mov cx,word [bp+8]
    DrawLine.draw_y:
        push cx
        mov cx,word [bp+6]
        mov ax,word [bp+4]
        push di
        DrawLine.draw_x:
            mov word [es:di], ax
            add di,2
        loop DrawLine.draw_x
        pop di
        add di, SCREEN_WIDTH*2
        pop cx
    loop DrawLine.draw_y
    pop cx
    pop ax
    mov sp,bp
    pop bp
    ret

; void GetDisplayLocation(u16 x,u16 y)
GetDisplayLocation:
    push bp
    mov bp,sp

    push ax
    push cx

    mov ax, VIDEO_ADDRESS
    mov es, ax
    
    mov ax,word [bp+6]
    mov cl, SCREEN_WIDTH*2
    mul cl
    add ax,word [bp+4]
    add ax,word [bp+4]
    mov di, ax

    pop cx
    pop ax

    mov sp,bp
    pop bp
    ret
; u16 GetLocValue(u16 x,u16 y)
GetLocValue:
    push bp
    mov bp,sp
    
    push word [bp+6]
    push word [bp+4]
    call GetDisplayLocation

    mov ax,di
    mov sp,bp
    pop bp
    ret

WALL_COLOR equ 0x4000
WALL_HORIZONTAL_WIDTH equ 1
WALL_VERTICAL_WIDTH equ 2

; void DrawHorizontalWall(u16 x,u16 y,u16 len)
DrawHorizontalWall:
    push bp
    mov bp,sp

    push word [bp+8]
    push word [bp+6]
    push word WALL_HORIZONTAL_WIDTH
    push word [bp+4]
    push word WALL_COLOR
    call DrawLine

    mov sp,bp
    pop bp
    ret

; DrawVerticalWall(u16 x,u16 y,u16 len)
DrawVerticalWall:
    push bp
    mov bp,sp

    push word [bp+8]
    push word [bp+6]
    push word [bp+4]
    push word WALL_VERTICAL_WIDTH
    push word WALL_COLOR
    call DrawLine

    mov sp, bp
    pop bp
    ret

WHITE equ 1

DrawHorizontalWhiteLine:
    push bp
    mov bp,sp

    push word [bp+8]
    push word [bp+6]
    push word WALL_HORIZONTAL_WIDTH
    push word [bp+4]
    push word WALL_COLOR
    call DrawLine

    mov sp,bp
    pop bp
    ret

DrawVerticalWhiteLine:
    push bp
    mov bp,sp

    push word [bp+8]
    push word [bp+6]
    push word [bp+4]
    push word WALL_VERTICAL_WIDTH
    push word WALL_COLOR
    call DrawLine

    mov sp, bp
    pop bp
    ret

DrawSquare:
    push bp
    mov bp,sp

    push ax
    mov ax, VIDEO_ADDRESS
    mov es,ax

    mov ax,word [bp+6]
    mov di,ax

    mov ax,word [bp+4]

    mov word [es:di],ax
    add di,2
    mov word [es:di],ax

    pop ax
    mov sp, bp
    pop bp
    ret
HideCursor:
    push dx
    push bx
    push ax
	mov dx, 03d4h
    ; 保存原光标位置
    mov al, 0eh
	out dx, al
	inc dx
	in al,dx
    mov bh,al
	dec dx
	mov al, 0fh
	out dx, al
	inc dx
	in al,dx
    mov bl,al
    mov word [old_cursor],bx
    dec dx

    ; 隐藏光标
    mov bx, 25*80+1
    mov al, 0eh
	out dx, al
	inc dx
	mov al,bh
    out dx,al
	dec dx
	mov al, 0fh
	out dx, al
	inc dx
	mov al,bl
    out dx,al

    pop ax
    pop bx
    pop dx
    ret
DisplayCursor:
    push dx
    push bx
    push ax

    mov bx, word [old_cursor]
    mov al, 0eh
	out dx, al
	inc dx
	mov al,bh
    out dx,al
	dec dx
	mov al, 0fh
	out dx, al
	inc dx
	mov al,bl
    out dx,al

    pop ax
    pop bx
    pop dx
    ret
segment data
old_cursor dw 0
old_screen: times SCREEN_SIZE dw 0x0