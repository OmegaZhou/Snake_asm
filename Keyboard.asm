UP_KEY equ 1
DOWN_KEY equ 2
LEFT_KEY equ 3
RIGHT_KEY equ 4
PAUSE_KEY equ 5
ENTER_KEY equ 6

section .text
GetKey:
    push ax
    mov ah,0bh
    int 21h
    mov ah,0
    cmp al,0
    jz GetKey.null

    mov ah,08h
    int 21h

    cmp al,'w'
    jz GetKey.w_key
    cmp al, 'W'
    jz GetKey.w_key

    cmp al,'s'
    jz GetKey.s_key
    cmp al, 's'
    jz GetKey.s_key

    cmp al,'a'
    jz GetKey.a_key
    cmp al, 'a'
    jz GetKey.a_key

    cmp al,'d'
    jz GetKey.d_key
    cmp al, 'd'
    jz GetKey.d_key

    cmp al,0x1b
    jz GetKey.esc

    cmp al,0x03
    jz GetKey.end

    jmp GetKey.default

    GetKey.w_key:
    mov al, UP_KEY
    jmp GetKey.finish

    GetKey.s_key:
    mov al, DOWN_KEY
    jmp GetKey.finish

    GetKey.a_key:
    mov al, LEFT_KEY
    jmp GetKey.finish

    GetKey.d_key:
    mov al, RIGHT_KEY
    jmp GetKey.finish

    GetKey.esc:
    mov al, PAUSE_KEY
    jmp GetKey.finish

    GetKey.end:
    call Quit
    jmp GetKey.finish
    

    GetKey.default:
    mov al,0
    jmp GetKey.finish

    GetKey.finish:
    mov [now_key], al
    pop ax
    ret
    
    GetKey.null:
    mov al,0
    mov [now_key],al
    pop ax
    ret

section .data
now_key db 0