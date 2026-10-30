; map.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

lookGrass = ((lightGreen SHL 4) OR green) OR (' ' SHL 8) OR (' ' SHL 16) ; creates a 2 char length empty green tile
lookPath = ((LightGray SHL 4) OR gray) OR ('[' SHL 8) OR (']' SHL 16) ; creates a 2 char length gray tile with a [] texture

.data
mapGrid BYTE mapTiles DUP(tGrass)
baseLook DWORD mapTiles DUP(0)
pathTiels BYTE maxPath*2 DUP(0)     ; (x,y)
pathLen DWORD 0

; Pathway corners
coords BYTE 0,12, 29,12, 29,5, 19,5, 19,23, 9,23, 9,17, 37,17, 37,10, 45,10, 45,21, 26,21, 26,29 ; pairs of coords that the balloons follow
numCoords = ($ - waypoints)/2 ; Gives the number of coord pairs

.code

; builds mapGrid and baseLook with the path
InitMap PROC USES eax ebx ecx edx esi edi
    mov esi, OFFSET mapGrid     ; first byte of mapGrid
    mov edi, OFFSET baseLook    ; first DWROD of baseLook
    mov ecx, mapTiles           ; number of tiles to fill (loop counter)

L1:
