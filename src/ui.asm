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

outBuf BYTE 0,0,0   ; 2 chars + null terminator

cursorX DWORD MAP_W/2
cursorY DWOORD MAP_H/2
screenCache DWORD MAP_TILES DUP(-1) ; last look of each tile
curColor DWORD -1                    ; last color of the console
expCol DWORD -1                     ; Where the console cursor is located
expRow DWORD -1
cursorColors BYTE CURSOR_COLOR_OK, CURSOR_COLOR_BAD, CURSOR_COLOR_SELL, CURSOR_COLOR_BAD
; In order of:        T_GRASS,            T_PATH,         T_TOWER,          T_BLOCK

.code
InitConsole PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hOut, eax
    INVOKE SetConsoleTitle, ADDR titleStr
    INVOKE SetConsoleCursorInfo, hOut, ADDR cursorInfo  ; hides cursor blinking
    ret
InitConsole ENDP

DrawLook PROC USES eax edx  ; temp for testing
    ; eax = look, dl = col, dh = row. Writes one 2 char tile
    call Gotoxy
    push eax
    movzx eax, al           ; color only
    call SetTextColor
    pop eax
    mov outBuf[0], ah       ; char 1
    shr eax, 16
    mov outBuf[1], al       ; cahr 2
    mov edx, OFFSET outBuf
    call WriteString
    ret
DrawLook ENDP

RenderFrame PROC USES eax ebx ecx edx esi   ; temp for testing, redraws everything
    xor ebx, ebx                ; tile index 0, MAP_TILES-1
    xor ecx, ecx                ; y
RY: xor esi, esi                ; x
RX: mov eax, baseLook[ebx*4]
    mov edx, esi
    shl edx, 1                  ; DL = col = x*2
    mov dh, cl                  ; DH = row = y
    call DrawLook
    inc ebx
    inc esi
    cmp esi, MAP_W
    jb RX
    inc ecx
    cmp ecx, MAP_H
    jb RY
    ret
RenderFrame ENDP
END