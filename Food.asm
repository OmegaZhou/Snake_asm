FOOD_CHAR equ 0x0703
LAMDA equ 91
MOD equ 0xffff
FOOD_SCORE equ 10
segment code
    
CheckFood:
    push ax
    call CheckFoodExist
    cmp ax, 1
    jz CheckFood.finish
    call SetNewFood
    add byte [food_num],1
    mov ax,FOOD_SCORE
    add word [score],ax
    call ShowScore
    CheckFood.finish:
    pop ax
    ret

SetNewFood:
    push bp
    mov bp,sp

    push ax
    push dx
    push cx
    push bx

    mov cx,150
    SetNewFood.loop:
    push cx
    call Rand
    mov dx,0
    mov bx,BOX_HEIGH
    div bx
    mov ax,dx
    push ax

    mov cx,250
    SetNewFood.loop_y:
    call Rand
    mov dx,0
    mov bx,BOX_WIDTH-1
    div bx
    mov ax,dx
    push ax

    call GetLocValue
    mov word [food_loc],ax
    pop ax
    
    call CheckBlank
    cmp ax, 1
    jz SetNewFood.success
    loop SetNewFood.loop_y
    pop ax
    pop cx
    loop SetNewFood.loop

    jmp SetNewFood.fail

    SetNewFood.success:
    
    call SetFoodValue
    SetNewFood.fail:
    pop ax
    pop cx

    pop bx
    pop cx
    pop dx
    pop ax

    mov sp,bp
    pop bp
    ret


SetFoodValue:
    push ax
    mov ax, VIDEO_ADDRESS
    mov es,ax
    mov ax, word [food_loc]
    mov di, ax
    mov ax,FOOD_CHAR
    mov [es:di],ax
    pop ax
    ret

GetFoodValue:
    mov ax, VIDEO_ADDRESS
    mov es,ax
    mov ax, word [food_loc]
    mov di, ax
    mov ax, [es:di]
    ret

CheckBlank:
    call GetFoodValue
    cmp ax, BLANK
    jz CheckBlank.blank
    mov ax, 0
    ret
    CheckBlank.blank:
    mov ax,1
    ret

CheckFoodExist:
    call GetFoodValue
    cmp ax, FOOD_CHAR
    jz CheckFoodExist.exist
    mov ax, 0
    ret
    CheckFoodExist.exist:
    mov ax,1
    ret

SetSeed:
    push dx
    push cx
    push ax
	mov ah,2ch
	int 21h
    mov ax,dx
    mov dx,0
    mov cx, LAMDA
    div cx
	mov word [seed], dx
    pop ax
    pop cx
    pop dx
	ret


Rand:
    push dx
    push cx
    mov ax, word [seed]
    mov dx, LAMDA
    mul dx
    add ax,7
    mov cx, MOD
    div cx
    mov ax,dx
    mov word [seed], dx
    pop cx
    pop dx
    ret

segment data
food_loc dw 0
seed dw 0