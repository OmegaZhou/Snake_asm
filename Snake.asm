SNAKE_COLOR equ 0x3000
SNAKE_INIT_LEN equ 4
SNAKE_INIT_LOC equ (10*80+24)*2
SNAKE_NODE_SIZE equ 4
MEM_SIZE equ 7500
MAX_RATE equ 40
SPEED_UP equ 10
ENLONGATE_NUM equ 3

segment code
SnakeInit:
    push ax
    push cx
    push bx
    mov ax, VIDEO_ADDRESS
    mov es, ax
    mov ax, SNAKE_INIT_LOC
    mov di,ax
    call DeleteAllPtr
    call CreateSnakePtr
    mov [header_str],ax
    mov bx,ax
    mov cx, SNAKE_INIT_LOC

    mov word [bx], cx
    mov cl,UP_KEY
    mov byte [bx+2], cl
    mov cl, SNAKE_INIT_LEN
    mov byte [bx+3], cl
    mov cx, SNAKE_INIT_LEN
    SnakeInit.loop0:
        push cx
        push di
        mov cx,2

        SnakeInit.loop1:
            mov ax,SNAKE_COLOR
            mov word [es:di],ax
            add di,2
        loop SnakeInit.loop1

        pop di
        pop cx
        add di,160
    loop SnakeInit.loop0
    pop bx
    pop cx
    pop ax
    ret

; 通过取余方式判断方向
CalDirection:
    push dx
    push bx
    push cx
    mov ax,0
    mov al,byte [now_dir]
    cmp al,0
    jz CalDirection.finish
    mov ch,4
    mov cl,al

    mov bx,word [header_str]
    mov ah,0
    mov al,byte [bx+2]
    div ch
    add ah,1

    cmp ah,cl
    jz CalDirection.right

    mov ah,0
    mov al,byte [bx+2]
    add al,4
    sub al,2
    div ch
    add ah,1
    cmp ah,cl
    jz CalDirection.left

    mov ax,0
    jmp CalDirection.finish

    CalDirection.right:
    mov ax,RIGHT_KEY
    jmp CalDirection.finish

    CalDirection.left:
    mov ax,LEFT_KEY
    jmp CalDirection.finish

    CalDirection.finish:
    mov cl,0
    mov byte [now_dir],cl
    pop cx
    pop bx
    pop dx
    ret


CheckDirection:
    push ax
    push bx
    push si
    push dx

    call CalDirection
    cmp ax, 0
    jz CheckDirection.finish

    push ax
    ; 创建新节点
    call CreateSnakePtr
    mov bx,ax
    ; si:原节点
    mov ax,word [header_str]
    mov si,ax

    mov [header_str], bx

    mov ax,word [si]
    mov word [bx],ax
    ; newNode->dir=newNode->next->dir
    mov al,byte [si+2]
    mov byte [bx+2],al
    ; newNode->len=0
    mov al,0
    mov byte [bx+3],al
    

    pop ax

    cmp ax,LEFT_KEY
    jz CheckDirection.change_l

    cmp ax,RIGHT_KEY
    jz CheckDirection.change_r

    jmp CheckDirection.finish

    CheckDirection.change_l:
    call TurnLeft
    jmp CheckDirection.finish
    CheckDirection.change_r:
    call TurnRight
    jmp CheckDirection.finish

    CheckDirection.finish:
    pop dx
    pop si
    pop bx
    pop ax
    ret

Move:
    push ax
    push bx
    push cx
    call CheckDirection
    call Enlongate

    mov cx,[header_str]
    mov ax,cx
    mov bx,[queue_start]
    add bx,mem

    call SnakeEndMove
    mov cl, [bx+3]
    cmp cl, 0
    jnz Move.continue
    call DeleteSnakePtr

    Move.continue:

    call SnakeHeaderMove

    call CheckFood

    pop cx
    pop bx
    pop ax
    ret
CreateSnakePtr:
    push bx
    push cx
    push dx
    mov bx,word [queue_end]
    add bx, mem

    mov dx,0
    mov ax, SNAKE_NODE_SIZE
    add ax, word [queue_end]
    mov cx, MEM_SIZE
    div cx

    mov word [queue_end],dx
    mov ax,bx

    pop dx
    pop cx
    pop bx
    ret

DeleteSnakePtr:
    push ax
    push dx
    push cx
    mov dx,0
    mov ax,SNAKE_NODE_SIZE
    add ax, word [queue_start]
    mov cx,MEM_SIZE
    div cx
    mov word [queue_start],dx
    pop cx
    pop dx
    pop ax

    ret

DeleteAllPtr:
    push ax
    mov ax,0
    mov word [queue_end],ax
    mov word [queue_start],ax
    pop ax
    ret
SnakeHeaderMove:
    push bp
    mov bp,sp

    push ax
    push bx
    push cx

    mov bx,word [header_str]
    mov al, byte [bx+3]
    add al,1
    mov byte [bx+3],al

    mov al,byte [bx+2]

    cmp al,UP_KEY
    jz SnakeHeaderMove.up
    cmp al,DOWN_KEY
    jz SnakeHeaderMove.down
    cmp al,RIGHT_KEY
    jz SnakeHeaderMove.right
    cmp al,LEFT_KEY
    jz SnakeHeaderMove.left
    jmp SnakeHeaderMove.finish

    SnakeHeaderMove.up:
    mov ax,160
    mov cx,[bx]
    sub cx,ax
    mov ax,cx
    jmp SnakeHeaderMove.draw_square

    SnakeHeaderMove.down:
    mov ax,160
    add ax,[bx]
    jmp SnakeHeaderMove.draw_square

    SnakeHeaderMove.right:
    mov ax,4
    add ax,[bx]
    jmp SnakeHeaderMove.draw_square

    SnakeHeaderMove.left:
    mov ax,4
    mov cx,[bx]
    sub cx,ax
    mov ax,cx
    jmp SnakeHeaderMove.draw_square

    SnakeHeaderMove.draw_square:
    mov word [bx], ax

    push ax
    call CheckWall
    cmp ax,1
    jnz SnakeHeaderMove.no_hit
    call GameOver
    pop ax
    jmp SnakeHeaderMove.finish
    SnakeHeaderMove.no_hit:
    pop ax
    
    push ax
    push word SNAKE_COLOR
    call DrawSquare
    pop ax
    pop ax
    SnakeHeaderMove.finish:
    pop cx
    pop bx
    pop ax

    mov sp,bp
    pop bp
    ret

SnakeEndMove:
    push bp
    mov bp,sp

    push ax
    push bx
    push cx

    mov bx, [queue_start]
    add bx, mem
    ; 减去该段长度
    mov al, byte [bx+3]
    sub al, 1
    mov byte [bx+3],al

    mov al,byte [bx+2]
    cmp al,UP_KEY
    jz SnakeEndMove.up
    cmp al,DOWN_KEY
    jz SnakeEndMove.down
    cmp al,RIGHT_KEY
    jz SnakeEndMove.right
    cmp al,LEFT_KEY
    jz SnakeEndMove.left
    jmp SnakeEndMove.finish

    SnakeEndMove.up:
    mov al,160
    mul byte [bx+3]
    add ax,[bx]
    jmp SnakeEndMove.draw_blank

    SnakeEndMove.down:
    mov al,160
    mul byte [bx+3]
    mov cx,[bx]
    sub cx,ax
    mov ax,cx
    jmp SnakeEndMove.draw_blank

    SnakeEndMove.right:
    mov al,4
    mul byte [bx+3]
    mov cx,[bx]
    sub cx,ax
    mov ax,cx
    jmp SnakeEndMove.draw_blank

    SnakeEndMove.left:
    mov al,4
    mul byte [bx+3]
    add ax, [bx]
    jmp SnakeEndMove.draw_blank

    SnakeEndMove.draw_blank:
    push ax
    push word BLANK
    call DrawSquare
    pop ax
    pop ax
    SnakeEndMove.finish:
    pop cx
    pop bx
    pop ax

    mov sp,bp
    pop bp
    ret
TurnLeft:   
    push ax
    push bx
    push cx

    
    mov bx,word [header_str]
    mov al,byte [bx+2]
    sub al,1
    mov ah,0
    add ax,4
    sub ax,1
    mov cl,4
    div cl
    add ah,1
    mov byte [bx+2],ah
    pop cx
    pop bx
    pop ax
    ret

TurnRight:
    push ax
    push bx
    push cx
    mov bx,word [header_str]
    mov al,byte [bx+2]
    sub al,1
    mov ah,0
    add ax,1
    mov cl,4
    div cl
    add ah,1
    mov byte [bx+2],ah
    pop cx
    pop bx
    pop ax
    ret

CheckWall:
    push bx
    mov bx,word [header_str]
    mov di,word [bx]
    pop bx
    mov ax,VIDEO_ADDRESS
    mov es,ax
    mov ax,word [es:di]
    cmp ax,WALL_COLOR
    jz CheckWall.hit_wall
    cmp ax,SNAKE_COLOR
    jz CheckWall.hit_wall
    mov ax,0
    ret
    CheckWall.hit_wall:
    call GameOver
    mov ax,1
    ret
Enlongate:
    cmp word[food_num],ENLONGATE_NUM
    jb Enlongate.finish
    call SnakeHeaderMove
    mov word[food_num],0
    Enlongate.finish:
    ret

RealMove:
    push ax
    push dx
    push cx
    mov dx,0
    mov ax,word [score]
    mov cx,50
    div cx
    add ax,word [rate]
    add ax,word [init_v]
    mov word [rate],ax
    cmp ax, MAX_RATE
    jb RealMove.finish
    mov word[rate],0
    call Move
    RealMove.finish:
    pop cx
    pop dx
    pop ax
    ret


segment data
; Snake struct{
; loc dw
; dir db
; len db
;}
header_str dw 0
now_dir db 0
queue_start dw 0
queue_end dw 0

init_v dw 0
food_num dw 0
rate dw 0
mem: times MEM_SIZE db 0