UNIT_TIME equ 3

segment code
; 初始化计时器
TimerInit:
    push dx
    push cx
	mov ah,2ch
	int 21h
	mov [last_time], dl
    pop cx
    pop dx
	ret

; 检查是否刷新,以UNIT_TIME/100秒为单位
; 若al为0，则不用刷新
; 若al为1，则刷新
TimerCheck:
    push dx
    push cx
	mov ah,2ch
	int 21h
    pop cx
    mov dh,dl
	cmp dl, [last_time]
	jns TimerCheck.next
	add dl, 100
	TimerCheck.next:
	sub dl, [last_time]
	cmp dl, UNIT_TIME
	jns TimerCheck.check_success

	TimerCheck.check_failed:
    pop dx
	mov al,0
	ret
	TimerCheck.check_success:
	mov al,1
	mov [last_time], dh
    pop dx
	ret

segment data
    last_time db 0