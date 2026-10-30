; map.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

LOOK_GRASS = ((lightGreen SHL 4) OR green) OR (' ' SHL 8) OR (' ' SHL 16)
LOOK_PATH = ((lightGray SHL 4) OR gray) OR ('[' SHL 8) OR (']' SHL 16)
LOOK_TREE1 = ((green SHL 4) OR lightGreen) OR ('&' SHL 8) OR ('%' SHL 16)
LOOK_TREE2 = ((green SHL 4) OR lightGreen) OR ('%' SHL 8) OR ('&' SHL 16)
LOOK_ROCK = ((gray SHL 4) OR lightGray) OR ('o' SHL 8) OR ('O' SHL 16)
DECO_TREE = 1
DECO_ROCK = 2

.data
mapGrid BYTE MAP_TILES DUP(T_GRASS) ; What a tile is
baseLook DWORD MAP_TILES DUP(0)     ; How a tile looks
pathTiles BYTE MAX_PATH*2 DUP(0)    ; (x,y)
pathLen DWORD 0

waypoints BYTE 0,12, 29,12, 29,5, 19,5, 19,23, 9,23, 9,17, 37,17, 37,10, 45,10, 45,21, 26,21, 26,29
NUM_WAYPOINTS = ($ - waypoints) / 2

; bits 0-7 = color
; bits 8-15 = first character
; bits 16-23 = second character
flowerLooks DWORD ((lightGreen SHL 4) OR white) OR ('.' SHL 8) OR (' ' SHL 16)
            DWORD ((lightGreen SHL 4) OR yellow) OR (' ' SHL 8) OR ('*' SHL 16)
            DWORD ((lightGreen SHL 4) OR green) OR ('"' SHL 8) OR (' ' SHL 16)
            DWORD ((lightGreen SHL 4) OR white) OR (' ' SHL 8) OR ('*' SHL 16)
NUM_FLOWERS = ($ - flowerLooks)/4

; Decorations: x1, y1, x2, y2, id
decoRects   BYTE 0, 0, 5, 2, DECO_TREE
            BYTE 0, 3, 3, 4, DECO_TREE
            BYTE 38, 19, 38, 19, DECO_ROCK
NUM_DECO = ($ - decoRects)/5


.code
InitMap PROC USES eax ebx ecx edx esi edi
    mov esi, OFFSET mapGrid
    mov edi, OFFSET baseLook
    mov ecx, MAP_TILES

; G = grass, D = deco
G1:
    mov BYTE PTR [esi], T_GRASS
    mov eax, 20
    call RandomRange
    cmp eax, NUM_FLOWERS
    jb G2
    mov eax, LOOK_GRASS
    jmp G3

G2:
    mov eax, flowerLooks[eax*4]

G3:
    mov [edi], eax
    inc esi
    add edi, 4
    dec ecx
    jnz G1

    mov esi, OFFSET decoRects
    mov ecx, NUM_DECO
D1: 
    movzx ebx, BYTE PTR [esi+1]     ; y = y1

D2: 
    movzx eax, BYTE PTR [esi]       ; x = x1

D3: 
    imul edx, ebx, MAP_W
    add edx, eax                    ; edx = tile index (y*MAP_W + x)
    mov mapGrid[edx], T_BLOCK       ; cant build here
    cmp BYTE PTR [esi+4], DECO_TREE
    jne D4
    mov edi, eax                    ; alternates between tree looks
    add edi, ebx                    ; checkerboard pattern: (x+y) odd/even
    test edi, 1
    mov edi, LOOK_TREE1             
    jz D5                           ; jz reads test result
    mov edi, LOOK_TREE2
    jmp D5

D4: 
    mov edi, LOOK_ROCK

D5:     
    mov baseLook[edx*4], edi
    inc eax
    cmp al, BYTE PTR [esi+2]        ; x <= x2
    jbe D3
    inc ebx
    cmp bl, BYTE PTR [esi+3]        ; y <= y2
    jbe D2
    add esi, 5                      ; next rectangle
    dec ecx
    jnz D1

    call BuildPath                  ; Path called last to place over decorations

    ret
InitMap ENDP

BuildPath PROC USES eax ebx ecx esi
    mov pathLen, 0
    mov esi, OFFSET waypoints
    movzx eax, BYTE PTR [esi]   ; x = first corner
    movzx ebx, BYTE PTR [esi+1] ; y1
    call AddPathTile
    mov ecx, NUM_WAYPOINTS-1    ; number of segments

L1: 
    cmp al, BYTE PTR [esi +2]   ; compares x with the next corners x
    je L3
    jb L2
    dec eax                     ; steps left
    jmp L6

L2:
    inc eax                     ; steps right
    jmp L6

L3:
    cmp bl, BYTE PTR [esi+3]    ; x matches and becomes y
    je L7                       ; reaches corner
    jb L4
    dec ebx                     ; steps up
    jmp L6

L4:
    inc ebx                     ; steps down

L6:
    call AddPathTile
    jmp L1

L7:
    add esi, 2                  ; next segment starts at this corner
    dec ecx
    jnz L1

    ret
BuildPath ENDP

AddPathTile PROC USES edx edi
; eax = x, ebx = y. Marks path on the map
    mov edi, pathLen
    cmp edi, MAX_PATH
    jae quit                        ; quits when full
    mov pathTiles[edi*2], al
    mov pathTiles[edi*2+1], bl
    inc pathLen
    imul edx, ebx, MAP_W
    add edx, eax
    mov mapGrid[edx], T_PATH
    mov baseLook[edx*4], LOOK_PATH
quit:
    ret
AddPathTile ENDP
END

