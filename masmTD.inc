; masmTD.inc
; CSE3120 Contest 1
; Nicholas Bleeker

INCUDE Irvine32.inc

; Map size
mapW = 60   ; map width in tiles (each tile = 2 chars)
mapH = 30   ; map height in tiles
mapTiles = mapW * mapH
screenW = 121   ; 120 + 1 so rows dont wrap
screenH = 37