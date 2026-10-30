; masmTD.inc
; CSE3120 Contest 1
; Nicholas Bleeker
; This file shares constants, structures, data, and prototypes

INCLUDE Irvine32.inc

MAP_W = 60
MAP_H = 30

TICK_MS = 40        ; 1000/40 = 25 ticks/second
InitConsole PROTO   ; ui.asm

MAP_TILES = MAP_W * MAP_H
SCREEN_W = 121              ; 60 tiles * 2 chars + 1 spare column for safety
SCREEN_H = 37
HUD_ROWS = MAP_H            ; first HUD row under the map
MIN_COLS = SCREEN_W
MIN_ROWS = HUD_ROWS + 6

T_GRASS = 0
T_PATH = 1
T_TOWER = 2
T_BLOCK = 3

EXTERNDEF mapGrid: BYTE, baseLook:DWORD
InitMap PROTO
RenderFrame PROTO