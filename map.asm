; map.asm
; CSE3120 Contest 1
; Nicholas Bleeker

INCLUDE masmTD.inc

; lookGrass = ...
; lookPath = ...

.data
; mapGrid BYTE mapTiles DUP(*Enter grass tile*)
baseLook DWORD mapTiles DUP(0)
pathTiels BYTE maxPath*2 DUP(0)     ; (x,y)
pathLen DWORD 0

