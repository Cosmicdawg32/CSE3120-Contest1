; masmTD.inc
; CSE3120 Contest 1
; Nicholas Bleeker
; This file shares constants, structures, data, and prototypes

INCLUDE Irvine32.inc

MAP_W = 60
MAP_H = 30

TICK_MS = 40        ; 1000/40 = 25 ticks/second
InitConsole PROTO   ; Implemented in ui.asm