MOUSE_MASK equ 0x4
segment code
MAX_X equ 639
MIN_X equ ((BOX_WIDTH+1)*8)
MouseListen:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx

    mov cx,0
    mov bx,0
    mov ax,06h
    mov bx,0
    int 33h
    cmp bx,0
    jz MouseListen.finish

    push cx
    mov ax,dx
    mov dx,0
    mov cx,8
    div cx
    mov dx,ax

    pop cx
    push dx
    mov ax,cx
    mov dx,0
    mov cx,8
    div cx
    mov cx,ax

    pop dx
    push cx
    mov ax,dx
    mov cx,80
    mul cx
    pop cx
    add ax,cx
    mov cx,2
    mul cx

    ; 判断退出按钮
    cmp ax,QUIT_ITEM_START
    jb MouseListen.next0
    cmp ax,QUIT_ITEM_END
    jae MouseListen.next0
    cmp byte [wait_select],1
    jz MouseListen.next0
    call Quit

    ; 判断继续按钮
    MouseListen.next0:
    cmp ax,RETURN_ITEM_START
    jb MouseListen.next1
    cmp ax,RETURN_ITEM_END
    jae MouseListen.next1
    cmp byte [is_end],1
    jz MouseListen.next1
    call StopPause

    ; 判断开始按钮
    MouseListen.next1:
    cmp ax,START_ITEM_START
    jb MouseListen.next2
    cmp ax,START_ITEM_END
    jae MouseListen.next2
    cmp byte [wait_select],1
    jz MouseListen.next2
    call LevelItemInit

    ; 判断返回按钮
    MouseListen.next2:
    cmp ax,BACK_ITEM_START
    jb MouseListen.next3
    cmp ax,BACK_ITEM_END
    jae MouseListen.next3
    cmp byte [wait_select],0
    jz MouseListen.next3
    call MainItemInit

    ; 判断简单难度
    MouseListen.next3:
    cmp ax,EASY_ITEM_START
    jb MouseListen.next4
    cmp ax,EASY_ITEM_END
    jae MouseListen.next4
    cmp byte [wait_select],0
    jz MouseListen.next4
    call EasyMode

    MouseListen.next4:
    cmp ax,MID_ITEM_START
    jb MouseListen.next5
    cmp ax,MID_ITEM_END
    jae MouseListen.next5
    cmp byte [wait_select],0
    jz MouseListen.next5
    call MidMode

    MouseListen.next5:
    cmp ax,HARD_ITEM_START
    jb MouseListen.next6
    cmp ax,HARD_ITEM_END
    jae MouseListen.next6
    cmp byte [wait_select],0
    jz MouseListen.next6
    call HardMode

    MouseListen.next6:
    MouseListen.finish:
    pop dx
    pop cx
    pop bx
    pop ax

    mov sp,bp
    pop bp
    ret
MouseInit:
    push ax
    push cx
    push dx
    mov ax,00h
    int 33h
    mov ax,07h
    mov cx,MIN_X
    mov dx,MAX_X
    int 33h
    call ShowMouse
    pop ax
    pop cx
    pop dx
    ret

ShowMouse:
    push ax
    mov ax,01h
    int 33h
    pop ax
    ret

QuitMouse:
    mov ax,07h
    mov cx,0
    mov dx,MAX_X
    int 33h
    call HideMouse
    ret
HideMouse:
    push ax
    mov ax,02h
    int 33h
    pop ax
    ret
segment data
