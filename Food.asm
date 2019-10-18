FOOD_CHAR equ 0x0703
LAMDA equ 51
MOD equ 0xffff
section .text

CheckFood:
    call CheckFoodExist
    cmp ax,0
    jz CheckFood.not_exist
    CheckFood.not_exist:
    

SetNewFood:
    push ax
    push dx
    push cx
    push bx
    SetNewFood.loop:
    call Rand
    mov dx,0
    mov bx,BOX_HEIGH
    div bx
    mov ax,dx
    push ax

    mov cx,200
    SetNewFood.loop_y:
    call Rand
    mov dx,0
    mov bx,BOX_WIDTH
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
    jmp SetNewFood.loop

    SetNewFood.success:
    pop ax
    call SetFoodValue

    pop bx
    pop cx
    pop dx
    pop ax
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
    cmp ax, 0
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

section .data
food_loc dw 0
seed dw 0