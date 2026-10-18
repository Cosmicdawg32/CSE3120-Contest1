; BalloonOBJ.asm
; CSE3120 Contest 1
; Ioannis Limniatis

; Usage of STRUCT was utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/struct-masm?view=msvc-170

INCLUDE Irvine32.inc

maxBalloonCount = 100
balloonRed = 1
balloonBlue = 2
balloonGreen = 3

Balloon STRUCT
	active BYTE ?
	balloonType BYTE ?
	hp BYTE ?
	moveTick BYTE ?
	balloonPathing DWORD ?

Balloon ENDS

.data

.code

BalloonInit PROC
	ret

BalloonInit ENDP

END