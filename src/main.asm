; main.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

.data
frameStart DWORD 0
tickCount DWORD 0   ; temporary for testing

.code
main PROC
    call Randomize          ; random number for flower placement
    call InitConsole
    call InitMap            ; fills map with grass and flowers
    call BalloonInit
    call InvalidateScreen   ; clears screen and forces a first draw
gameLoop:
    call GetMseconds        ; eax = milliseconds since midnight
    mov frameStart, eax

    call CheckConsoleSize   ; eax = 1 if the window is the correct size
    test eax, eax
    jnz sizeOK
    call PollQuitKey        ; Game paused
    cmp eax, 1
    je quit
    jmp waitTick

sizeOK:
    call HandleInput        ; eax 1 if esc was pressed
    cmp eax, 1
    je quit
    ; future updates here
    call balloonTick
    call towerTick
    call RenderFrame

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
