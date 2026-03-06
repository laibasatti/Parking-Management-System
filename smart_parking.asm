                                                                                              .model small
.stack 100h

.data
msg1 db 13,10,"SMART PARKING SYSTEM",13,10,"$"
msg2 db 13,10,"Enter Total Slots (1-99): $"
menu db 13,10,"1. Park Car",13,10,"2. Remove Car",13,10,"3. Exit",13,10,"Enter choice: $"
full db 13,10,"Parking Full!$"
all_booked db 13,10,"All parking slots are now booked!$"
empty db 13,10,"Parking Empty!$"
parked db 13,10,"Car Parked Successfully.$"
removed db 13,10,"Car Removed Successfully.$"
avail db 13,10,"Available Slots: $"

total_slots dw 0
occupied dw 0

.code

; ---------------- PRINT NUMBER ----------------
print_num proc
    mov bx,10
    xor cx,cx
repeat:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne repeat
print:
    pop dx
    add dl,30h
    mov ah,02h
    int 21h
    loop print
    ret
print_num endp

; ---------------- INPUT NUMBER ----------------
get_number proc
    xor bx,bx
next_digit:
    mov ah,01h
    int 21h
    cmp al,13
    je done
    sub al,30h
    mov ah,0
    mov cx,ax
    mov ax,bx
    mov dx,0
    mov si,10
    mul si
    add ax,cx
    mov bx,ax
    jmp next_digit
done:
    mov ax,bx
    ret
get_number endp

; ---------------- SHOW AVAILABLE ----------------
show_available proc
    lea dx,avail
    mov ah,09h
    int 21h
    mov ax,total_slots
    sub ax,occupied
    call print_num
    ret
show_available endp

; ================= MAIN =================
main proc
    mov ax,@data
    mov ds,ax

    lea dx,msg1
    mov ah,09h
    int 21h

    lea dx,msg2
    mov ah,09h
    int 21h

    call get_number
    mov total_slots,ax

menu_start:
    call show_available

    lea dx,menu
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,30h

    cmp al,1
    je park
    cmp al,2
    je remove
    cmp al,3
    je exit
    jmp menu_start

park:
    mov ax,occupied
    cmp ax,total_slots
    jae parking_full
    inc occupied

    mov ax,occupied
    cmp ax,total_slots
    jne not_all
    lea dx,all_booked
    mov ah,09h
    int 21h
not_all:

    lea dx,parked
    mov ah,09h
    int 21h
    jmp menu_start

parking_full:
    lea dx,full
    mov ah,09h
    int 21h
    jmp menu_start

remove:
    cmp occupied,0
    je parking_empty
    dec occupied
    lea dx,removed
    mov ah,09h
    int 21h
    jmp menu_start

parking_empty:
    lea dx,empty
    mov ah,09h
    int 21h
    jmp menu_start

exit:
    mov ah,4ch
    int 21h
main endp

end main
