; ui.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

CURSOR_COLOR_OK = (white SHL 4) OR black             ; When over empty grass
CURSOR_COLOR_BAD = (lightRed SHL 4) or black         ; When over the path/blocked tile
CURSOR_COLOR_SELL = (lightMagenta SHL 4) or black    ; When over a tower
HUD_ATTR = (black SHL 4) or lightGray

.data
hOut DWORD 0
cursorInfo CONSOLE_CURSOR_INFO <100, 0> ; size = 100, visible = 0
titleStr BYTE "MASM TD CSE3120", 0
hudTemp DWORD 1
blankLine BYTE SCREEN_W-1 DUP(' '), 0
sLives BYTE "HEALTH ", 0
sMoney BYTE "       MONEY $", 0
sControls BYTE "Arrows/WASD: move   ENTER/Space: build tower ($50)  x/Del: sell tower   Esc: quit", 0

outBuf BYTE 0,0,0   ; 2 chars + null terminator

cursorX DWORD MAP_W/2
cursorY DWORD MAP_H/2
screenCache DWORD MAP_TILES DUP(-1) ; last look of each tile
curColor DWORD -1                    ; last color of the console
expCol DWORD -1                     ; Where the console cursor is located
expRow DWORD -1
cursorColors BYTE CURSOR_COLOR_OK, CURSOR_COLOR_BAD, CURSOR_COLOR_SELL, CURSOR_COLOR_BAD
; In order of:        T_GRASS,            T_PATH,         T_TOWER,          T_BLOCK

csbi CONSOLE_SCREEN_BUFFER_INFO <>
lastCols DWORD 0
lastRows DWORD 0
tooSmall DWORD 0    ; 1 = warning
sSmall1 BYTE "Window too small!", 0
sSmall2 BYTE "Enlarge console window", 0
sSmall3 BYTE "to at least 121 x 36.", 0
sSmall4 BYTE "Press Esc to quit.", 0

overlay DWORD MAP_TILES DUP(0)

.code
InitConsole PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hOut, eax
    INVOKE SetConsoleTitle, ADDR titleStr
    INVOKE SetConsoleCursorInfo, hOut, ADDR cursorInfo  ; hides cursor blinking
    ret
InitConsole ENDP

DrawLook PROC USES eax ebx edx
; EAX = look, DL = col, DH = row. Writes one tile (2 char)
; Skips SetTextColor if the color is already set
; Skips Gotoxy if the console cursor is already at DL/DH (expCol/expRow)
; Records a new color and cursor position for the next call
    movzx ebx, al
    cmp ebx, curColor
    je colorOK
    mov curColor, ebx
    push eax
    mov eax, ebx
    call SetTextColor
    pop eax

colorOK:
    movzx ebx, dl
    cmp ebx, expCol
    jne move
    movzx ebx, dh
    cmp ebx, expRow
    je temp

move:
    call Gotoxy

temp:
    mov outBuf[0], ah
    shr eax, 16
    mov outBuf[1], al
    push edx
    mov edx, OFFSET outBuf
    call WriteString
    pop edx
    movzx ebx, dl
    add ebx, 2
    cmp ebx, SCREEN_W
    jb @F               ; Jumps to @@
    mov ebx, -1
@@: mov expCol, ebx
    movzx ebx, dh
    mov expRow, ebx

    ret
DrawLook ENDP

RenderFrame PROC USES eax ebx ecx edx esi edi
    mov edi, OFFSET overlay
    mov ecx, MAP_TILES
    xor eax, eax
    cld
    rep stosd
    call drawBalloons

    xor ebx, ebx                ; tile index 0, MAP_TILES-1
    xor ecx, ecx                ; y
RY: xor esi, esi                ; x
RX: mov eax, overlay[ebx*4]    
    test eax, eax
    jnz @f
    mov eax, baseLook[ebx*4]
@@: cmp esi, cursorX
    jne @F
    cmp ecx, cursorY
    jne @F
    call CursorLook
@@: cmp eax, screenCache[ebx*4]
    je L1
    mov screenCache[ebx*4], eax
    mov edx, esi
    shl edx, 1
    mov dh, cl
    call DrawLook
L1:                             ; reused code from older RenderFrame
    inc ebx
    inc esi
    cmp esi, MAP_W
    jb RX
    inc ecx
    cmp ecx, MAP_H
    jb RY
    ret
RenderFrame ENDP

CursorLook PROC USES ecx
; eax = look of the tile under the cursor, ebx = tile index
; Returns eax with the cursor highlight
    movzx ecx, mapGrid[ebx]
    and eax, 0FFFFFF00h         ; keeps the character textures
    or al, cursorColors[ecx]    ; new color based on tile index
    cmp ecx, T_GRASS
    jne quit
    and eax, 0FFh                ; draws empty box "[]" on grass
    or eax, ('[' SHL 8) OR (']' SHL 16)

quit:
    ret
CursorLook ENDP

InvalidateScreen PROC USES eax ecx edi
; clears the console and redraws the next frame
    mov eax, HUD_ATTR
    call SetTextColor
    call Clrscr
    mov edi, OFFSET screenCache
    mov ecx, MAP_TILES
    mov eax, -1     ; -1 doesnt equal a "real" look
    cld
    rep stosd       ; fills ecx dwords at [edi] with eax
    mov curColor, -1
    mov expCol, -1
    ret
InvalidateScreen ENDP

HandleInput PROC USES ebx edx   ; ReadKey overwrites ebx
; processes all pending key presses. Returns eax = 1 if the player quits the game
L1: call ReadKey
    jz noKey
    cmp dx, VK_ESCAPE
    je quit
    cmp dx, VK_LEFT
    je left
    cmp dx, VK_RIGHT
    je right
    cmp dx, VK_UP
    je up
    cmp dx, VK_DOWN
    je down
    cmp dx, 2Eh
    je sell
    test al, al
    jz L1           ; other non character key presses (shift, home, etc)
    cmp al, 0Dh
    je place
    cmp al, ' '
    je place
    or al, 20h      ; turns uppercase to lowercase
    cmp al, 'a'
    je left
    cmp al, 'd'
    je right
    cmp al, 'w'
    je up
    cmp al, 's'
    je down
    cmp al, 'x'
    je sell
    jmp L1
left: cmp cursorX, 0
    je L1
    dec cursorX
    jmp L1
right: cmp cursorX, MAP_W-1
    jae L1
    inc cursorX
    jmp L1
up: cmp cursorY, 0
    je L1
    dec cursorY
    jmp L1
down: cmp cursorY, MAP_H-1
    jae L1
    inc cursorY
    jmp L1
place: call placeTower
    jmp L1
sell: call sellTower
    jmp L1
noKey: xor eax, eax
    ret
quit: mov eax, 1
    ret
HandleInput ENDP

CheckConsoleSize PROC USES ebx ecx edx
; rturns eax = 1 if the window is big enough. 0 if too small
; Forces a full redraw whenever the size changes
    INVOKE GetConsoleScreenBufferInfo, hOut, ADDR csbi
    movzx eax, csbi.srWindow.Right
    movzx ebx, csbi.srWindow.Left
    sub eax, ebx
    inc eax                         ; eax = col
    movzx ecx, csbi.srWindow.Bottom
    movzx ebx, csbi.srWindow.Top
    sub ecx, ebx
    inc ecx                          ; ecx = row
    cmp eax, lastCols
    jne changed
    cmp ecx, lastRows
    je checkMin
changed:
    mov lastCols, eax
    mov lastRows, ecx
    call InvalidateScreen           ; preserves eax and ecx
    mov tooSmall, 0
checkMin:
    cmp eax, MIN_COLS
    jb small
    cmp ecx, MIN_ROWS
    jb small
    mov tooSmall, 0
    mov eax, 1
    ret
small:
    cmp tooSmall, 1
    je done                         ; dont redraw every tick
    mov tooSmall, 1
    mov eax, HUD_ATTR
    call SetTextColor
    mov dx, 0                       ; row 0, col 0
    call Gotoxy
    mov edx, OFFSET sSmall1
    call WriteString
    call Crlf
    mov edx, OFFSET sSmall2
    call WriteString
    call Crlf
    mov edx, OFFSET sSmall3
    call WriteString
    call Crlf
    mov edx, OFFSET sSmall4
    call WriteString
    mov curColor, -1
    mov expCol, -1
done:
    xor eax, eax
    ret
CheckConsoleSize ENDP

PollQuitKey PROC USES ebx edx
; overrides all pending keys while pressed. Returns eax = 1 if esc is pressed
L1:
    call ReadKey
    jz none
    cmp dx, VK_ESCAPE
    jne L1
    mov eax, 1
    ret
none:
    xor eax, eax
    ret
PollQuitKey ENDP
END