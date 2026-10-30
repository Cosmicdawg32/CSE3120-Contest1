; map.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

LOOK_GRASS = ((lightGreen SHL 4) OR green) OR (' ' SHL 8) OR (' ' SHL 16)

.data
mapGrid BYTE MAP_TILES DUP(T_GRASS) ; What a tile is
baseLook DWORD MAP_TILES DUP(0)     ; How a tile looks

; bits 0-7 = color
; bits 8-15 = first character
; bits 16-23 = second character
flowerLooks DWORD ((lightGreen SHL 4) OR white) OR ('.' SHL 8) OR (' ' SHL 16)
            DWORD ((lightGreen SHL 4) OR yellow) OR (' ' SHL 8) OR ('*' SHL 16)
            DWORD ((lightGreen SHL 4) OR green) OR ('"' SHL 8) OR (' ' SHL 16)
            DWORD ((lightGreen SHL 4) OR white) OR (' ' SHL 8) OR ('*' SHL 16)
NUM_FLOWERS = ($ - flowerLooks)/4

.code
InitMap PROC USES eax ebx ecx edx esi edi
    mov esi, OFFSET mapGrid
    mov edi, OFFSET baseLook
    mov ecx, MAP_TILES

L1:
    mov BYTE PTR [esi], T_GRASS
    mov eax, 20
    call RandomRange
    cmp eax, NUM_FLOWERS
    jb L2
    mov eax, LOOK_GRASS
    jmp L3

L2:
    mov eax, flowerLooks[eax*4]

L3:
    mov [edi], eax
    inc esi
    add edi, 4
    dec ecx
    jnz L1
    ret
InitMap ENDP

END

