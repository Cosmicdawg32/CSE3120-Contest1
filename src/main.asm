; main.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

.data
frameStart DWORD 0
tickCount DWORD 0   ; temporary for testing

.code
main PROC
    call InitConsole
    call Clrscr

gameLoop:
    call GetMseconds    ; eax = milliseconds since midnight
    mov frameStart, eax

    call ReadKey        ; ZF = 1 if no key is waiting
    jz noKey            ; No key skips the check
    cmp dx, VK_ESCAPE   ; DX = key code of pressed key
    je quit             ; Esc exits the game

noKey:
    inc tickCount       ; temp to test the games update status
    mov dx, 0           ; DH = row 0, DL = col 0
    call Gotoxy
    mov eax, tickCount
    call WriteDec

waitTick:
    call GetMseconds
    sub eax, frameStart ; eax = ms of the frame
    cmp eax, TICK_MS    ; unsigned and catches midnight wrap
    jae gameLoop        ; if late, immediately starts the next frame
    mov ebx, TICK_MS
    sub ebx, eax
    mov eax, ebx
    call Delay
    jmp gameLoop

quit:
    mov eax, (black SHL 4) OR lightGray ; Returns terminal to normal colors
    call SetTextColor
    call Clrscr                         ; clears terminal
    exit                     

main ENDP
END main
