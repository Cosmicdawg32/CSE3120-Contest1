; masmTD.inc
; CSE3120 Contest 1
; Nicholas Bleeker
; This file shares constants, structures, data, and prototypes

INCLUDE Irvine32.inc

MAP_W = 60
MAP_H = 30

EXTERNDEF helloMsg:BYTE ; To be defined in map.asm and public
SayHello PROTO          ; To be defined in map.asm
